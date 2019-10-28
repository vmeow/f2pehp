require 'open-uri'

class Hiscores
  extend Base

  REG_MODE = %w[Reg].freeze
  IRONMAN_MODES = %w[UIM HCIM IM].freeze
  ALL_MODES = %w[UIM HCIM IM Reg].freeze

  class << self
    def fetch_stats(player_name, account_type: nil)
      parse_fields = [parse_fields] unless Array === parse_fields

      modes =
        if account_type
          # Retrieve a `modes` list of hierarchy to check total exps in order.
          # For UIM:  [UIM, IM, Reg]
          # For HCIM: [HCIM, IM, Reg]
          # For IM:   [IM, Reg]
          # For Reg:  [Reg]
          case account_type
          when *REG_MODE
            REG_MODE
          when *IRONMAN_MODES
            ancestors = Player.account_type_ancestors[account_type.to_sym]
            [account_type] + ancestors
          else
            raise ArgumentError, 'account type not recognized'
          end
        else
          ALL_MODES
        end

      stats = []
      threads = []
      stats_mutex = Mutex.new
      uri_per_mode = modes.map { |mode| api_url(mode, player_name) }

      uri_per_mode.each_with_index do |uri, mode_idx|
        threads << Thread.new(uri, mode_idx, stats) do |uri, mode_idx, stats|
          # Raise exceptions in main thread so they can be caught.
          Thread.current.abort_on_exception = true
          res = fetch(uri)

          # No hiscores data for this mode, skip.
          next unless res

          data = res.split("\n")
          parsed_data = parse_stats(data, parse_fields)
          stats_mutex.synchronize { stats << [parsed_data, mode_idx] }
        end
      end

      threads.each(&:join)
      return if stats.empty?

      # Find the mode with the highest amount of total exp.
      actual_stats, mode_idx = stats.sort_by do |mode_stats_idx|
        mode_stats, idx = mode_stats_idx
        [-mode_stats['overall_xp'], idx]
      end.first

      [actual_stats, modes[mode_idx]]
    end

    def hcim_dead?(player_name)
      uri = hcim_table_url(player_name)

      begin
        content = fetch(uri)
      rescue SocketError, Net::ReadTimeout
        Rails.logger.warn "#{player_name}'s HCIM hiscores retrieval failed"
        return false
      end

      return false unless content

      page = Nokogiri::HTML(content)
      page.xpath('//*[@id="contentHiscores"]/table/tbody/tr[contains(@class, "--dead")]/td/a/span')
          .first
          .present?
    end

    private

    def api_url(account_type, player_name)
      unless account_type.in? Player.account_types
        raise ArgumentError, 'account type not recognized'
      end

      path_suffix = {
        HCIM: '_hardcore_ironman',
        UIM: '_ultimate',
        IM: '_ironman'
      }

      URI.join(
        'https://services.runescape.com',
        "m=hiscore_oldschool#{path_suffix[account_type.to_sym]}/index_lite.ws",
        "?player=#{player_name}"
      )
    end

    def hcim_table_url(player_name)
      URI.join(
        'https://secure.runescape.com/m=hiscore_oldschool_hardcore_ironman/overall.ws',
        "?user=#{player_name}"
      )
    end

    def parse_stats(data, restrict_fields = [])
      stats = { potential_p2p: 0 }

      fields = F2POSRSRanks::Application.config.skills.map.with_index

      # Select field names and indices that need to be parsed in compliance
      #  with optional whitelist from `restrict_fields`.
      if restrict_fields.any?
        fields = fields.select { |f, i| f.in? restrict_fields }
      end

      fields.each do |skill, skill_idx|
        rank, lvl, xp = data[skill_idx].split(',').map { |x| [x.to_i, 0].max }

        case skill
        when 'p2p'
          stats[:potential_p2p] += xp
        when 'p2p_minigame'
          stats[:potential_p2p] += lvl
        when 'lms'
          next
        when 'clues_all', 'clues_beginner'
          stats[skill] = lvl
          stats["#{skill}_rank"] = rank
        when 'hitpoints'
          stats["#{skill}_lvl"] = [lvl, 10].max
          stats["#{skill}_xp"] = [xp, 1154].max
        else
          stats["#{skill}_lvl"] = lvl
          stats["#{skill}_xp"] = xp
          stats["#{skill}_rank"] = rank
        end
      end

      stats
    end
  end
end
