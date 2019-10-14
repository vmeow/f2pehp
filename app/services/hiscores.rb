require 'open-uri'

class Hiscores
  class << self
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

    def player_exists?(player_name)
      # A player does not exist if the player does not have 'Reg' hiscores.
      fetch_stats('Reg', player_name)
      true
    rescue
      false
    end

    def fetch_stats(account_type, player_name, parse: false, parse_fields: [])
      uri = api_url(account_type, player_name)

      openuri_params = {
        # Timeout durations for HTTP connection.
        # 5 seconds should be max for opening and reading a connection.
        open_timeout: 5,
        read_timeout: 5
      }

      max_attempts = 3
      attempt = 0

      begin
        res = uri.read
        data = res.split("\n")

        return data unless parse

        parse_fields = [parse_fields] unless Array === parse_fields
        return parse_stats(data, parse_fields)
      rescue OpenURI::HTTPError => e
        raise RuntimeError, "player #{player_name} is not a(n) #{account_type}"
      rescue SocketError, Net::ReadTimeout => e
        Rails.logger.warn "Runescape Hiscores cannot be reached: #{e}"
        sleep 2
        retry if attempt < max_attempts
      end
    end

    def hcim_dead?(player_name)
      uri = hcim_table_url(player_name)
      page = Nokogiri::HTML(open(uri))
      page.xpath('//*[@id="contentHiscores"]/table/tbody/tr[contains(@class, "--dead")]/td/a/span')
          .first
          .present?
    end

    # Checks if given `account_type` for `player_name` is still valid.
    def verify_account_type(account_type, player_name)
      unless account_type.in? Player.account_types
        raise ArgumentError, 'account type not recognized'
      end

      if account_type == 'Reg'
        # Confirm that player still exists in hiscores.
        return false unless player_exists?(player_name)
        return 'Reg'
      end

      # Retrieve a `modes` list of hierarchy to check total exps in order.
      # For UIM: [UIM, IM, Reg]
      # For HCIM: [HCIM, IM, Reg]
      # For IM: [IM, Reg]
      ancestors = Player.account_type_ancestors[account_type.to_sym]
      modes = [account_type] + ancestors

      overall_xp_each_mode = modes.map do |mode|
        stats = fetch_stats(mode, player_name, parse: true, parse_fields: 'overall')
        stats['overall_xp']
      end

      # Find the mode with the highest amount of total exp.
      _, most_exp_idx = overall_xp_each_mode
        .map.with_index.sort_by { |xp, idx| [-xp, idx] }
        .first

      modes[most_exp_idx]
    end

    def determine_account_type(player_name)
      return false unless player_exists?(player_name)

      %w[UIM HCIM IM].each do |type|
        begin
          return verify_account_type(type, player_name)
        rescue  # Non-existent hiscores lookup for a mode raises exception.
          # Proceed to attempt to retrieve hiscores for next mode.
          next
        end
      end

      return 'Reg'
    end
  end
end
