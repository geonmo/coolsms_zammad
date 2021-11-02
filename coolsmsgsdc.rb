class Channel::Driver::Sms::Coolsmsgsdc
  NAME = 'sms/coolsmsgsdc'.freeze

  def send(options, attr, _notification = false) 
    puts "Starting send function."
    Rails.logger.info "Sending SMS to recipient #{attr[:recipient]}"

    return true if Setting.get('import_mode')

    Rails.logger.info "Backend sending Coolsms to #{attr[:recipient]}"
    begin
      if Setting.get('developer_mode') != true
        header = get_header(options, attr)
        uri = get_uri(options, attr)
        messages = {messages: [{ :to   => attr[:recipient],
                                 :from => options[:sender], 
                                 :text => attr[:message],
                              }]
                   }
              
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        req.add_field('Authorization', header)
        
        req.body = messages.to_json
        res = http.request(req)
        response = JSON.parse(res.body)
        statusCode = response["status"]
        if !statusCode == 'COMPLETE' && !statusCode = 'SENDING'
          message = "Received non-OK response from gateway URL '#{uri}'"
          Rails.logger.error "#{message}:"
          raise message
        end
      end

      true
    rescue => e
      message = "Error while performing request to gateway URL '#{uri}'"
      Rails.logger.error message
      Rails.logger.error e
      raise message
    end
  end

  def self.definition
    {
      name:         'coolsmsgsdc',
      adapter:      'sms/coolsmsgsdc',
      notification: [
        { name: 'options::gateway', display: 'Gateway', tag: 'input', type: 'text', limit: 200, null: false, placeholder: 'https://gate1.goyyamobile.com/sms/sendsms.asp', default: 'https://gate1.goyyamobile.com/sms/sendsms.asp' },
        { name: 'options::token', display: 'API Key', tag: 'input', type: 'text', limit: 200, null: false, placeholder: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' },
        { name: 'options::secret', display: 'API Secret', tag: 'input', type: 'text', limit: 200, null: false, placeholder: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' },
        { name: 'options::sender', display: 'Sender', tag: 'input', type: 'text', limit: 200, null: false, placeholder: '00491710000000' },
      ]
    }
  end

  private

  def get_header(options, attr)
    api_key = options[:token]
    api_secret = options[:secret]
    date = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
    salt = SecureRandom.hex
    signature = OpenSSL::HMAC.hexdigest('SHA256', api_secret, date + salt)
    return 'HMAC-SHA256 apiKey=' + api_key + ', date=' + date + ', salt=' + salt + ', signature=' + signature
  end

  def get_uri(options, attr)
    str = options[:gateway] + '/messages/v4/send-many'
    uri = URI(str)
    return uri
  end

end
