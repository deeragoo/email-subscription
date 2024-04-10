require 'mail'
require_relative 'quote_generator'

FROM_EMAIL = ENV['FROM_EMAIL']
SMTP_SERVER = ENV['SMTP_SERVER']
DOMAIN = ENV['DOMAIN']
USER_NAME = ENV['USER_NAME']
PASSWORD = ENV['PASSWORD']
PORT = ENV['PORT']
class EmailSender

  def send_email(recipient, content)
    Mail.defaults do
      delivery_method :smtp, address: SMTP_SERVER, port: PORT, domain: DOMAIN, user_name: USER_NAME, password: PASSWORD,
      authentication: :plain,
      enable_starttls_auto: true,
      content_type: 'text/html'
    end

    mail = Mail.new do
      from(USER_NAME)
      to(recipient)
      subject('Ragoo Tech Newsletter')
      content_type 'text/html'
      body(content)
    end

    mail.deliver!
    p "Email sent to #{recipient}"
  end
end