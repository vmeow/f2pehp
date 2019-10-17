require 'open-uri'

class CML
  class << self
    CML_BASE_URL = 'https://crystalmathlabs.com/tracker/api.php'

    def records_api_url(player_name)
      URI.join(
        CML_BASE_URL,
        "?type=recordsofplayer&player=#{player_name}"
      )
    end

    def datapoints_api_url(player_name, time)
      URI.join(
        CML_BASE_URL,
        "?type=datapoints&player=#{player_name}&time=#{time}"
      )
    end

    def fetch_records(player_name)
      uri = records_api_url(player_name)
      records = fetch(uri)
      parse_records(records)
    end

    def parse_records(records)
      return unless records
      extracted_records = {}

      skills = F2POSRSRanks::Application.config.skills
      player_skills = Player.skills

      records.split("\n").each.with_index do |record, idx|
        skill = skills[idx]

        if player_skills.include?(skill)
          skill_records = record.split(',')
          extracted_records.merge!(
            "#{skill}_xp_day_max" => skill_records[0],
            "#{skill}_xp_week_max" => skill_records[2],
            "#{skill}_xp_month_max" => skill_records[4]
          )
        end
      end

      extracted_records
    end

    def fetch_exp(player_name, time_back)
      now = DateTime.now

      timedelta =
        case time_back
        when 'year'
          (now - DateTime.new(now.year, 1, 1)).to_i
        when 'month'
          time_diff = (now - DateTime.new(now.year, now.month, 1)).to_i
        else
          raise ArgumentError, "time_back must be either 'year' or 'month'"
        end

      uri = datapoints_api_url(player_name, "#{timedelta}d")
      records = fetch(uri)
      parse_exp(records)
    end

    def parse_exp(records)
      return unless records
      records = records.split(',')
      { 'overall_xp'     => xps[0],
        'attack_xp'      => xps[1],
        'defence_xp'     => xps[2],
        'strength_xp'    => xps[3],
        'hitpoints_xp'   => xps[4],
        'ranged_xp'      => xps[5],
        'prayer_xp'      => xps[6],
        'magic_xp'       => xps[7],
        'cooking_xp'     => xps[8],
        'woodcutting_xp' => xps[9],
        'fishing_xp'     => xps[11],
        'firemaking_xp'  => xps[12],
        'crafting_xp'    => xps[13],
        'smithing_xp'    => xps[14],
        'mining_xp'      => xps[15],
        'runecraft_xp'   => xps[21] }
    end

    private

    def fetch(uri, max_attempts = 3)
      raise TypeError, 'uri not an URI object' unless URI == uri

      openuri_params = {
        # Timeout durations for HTTP connection.
        # 5 seconds should be max for opening and reading a connection.
        open_timeout: 5,
        read_timeout: 5
      }

      attempt = 0

      begin
        attempt += 1
        return uri.read(openuri_params)
      rescue OpenURI::HTTPError => e
        # 404, no content.
      rescue SocketError, Net::ReadTimeout => e
        Rails.logger.warn "CML cannot be reached: #{e}"
        sleep 2
        retry if attempt < max_attempts
      end
    end
  end
end
