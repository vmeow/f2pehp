module Base
  def fetch(uri, max_attempts = 3)
    raise TypeError, 'uri not an URI object' unless URI === uri

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
      Rails.logger.warn "[#{attempt}/#{max_attempts}] #{uri} could not be reached: #{e}"
      sleep 2
      retry if attempt < max_attempts
      raise e
    end
  end
end
