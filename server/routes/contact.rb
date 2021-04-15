class MainApp
  namespace '/api/contact' do
    post '' do
      payload = request.body.read.parse_json
      logger.info '--------------Received message--------------'
      logger.info "Name: #{payload[:name]}"
      logger.info "Address: #{payload[:email]}"
      logger.info "Content: \n#{payload[:content]}"
      logger.info '--------------------------------------------'
    end
  end
end
