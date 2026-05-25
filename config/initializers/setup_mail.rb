# Settings to send with gmail
#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => "gmail.com",
#  :user_name            => Rails.application.credentials.dig(:email_user_name), # without @gmail.com
#  :password             => Rails.application.credentials.dig(:email_mathraining_key),
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

# Settings to send with noreply@mathraining.be
begin
  # Prefer credentials but fallback to ENV; tolerate decryption errors
  user_name = Rails.application.credentials.dig(:email_user_name) rescue nil
  password = Rails.application.credentials.dig(:email_password) rescue nil

  ActionMailer::Base.smtp_settings = {
    address:        ENV.fetch('SMTP_ADDRESS', 'pro3.mail.ovh.net'),
    port:           ENV.fetch('SMTP_PORT', 587).to_i,
    domain:         ENV.fetch('SMTP_DOMAIN', 'mathraining.be'),
    user_name:      user_name.presence || ENV['SMTP_USERNAME'] || ENV['EMAIL_USER_NAME'] || '',
    password:       password.presence || ENV['SMTP_PASSWORD'] || ENV['EMAIL_PASSWORD'] || '',
    authentication: :login,
    enable_starttls_auto: true
  }
rescue ActiveSupport::MessageEncryptor::InvalidMessage, NameError => e
  # If credentials can't be decrypted, fallback to ENV and continue starting
  Rails.logger.warn "Attention: Les credentials SMTP n'ont pas pu être déchiffrés (#{e.message})"
  ActionMailer::Base.smtp_settings = {
    address:        ENV.fetch('SMTP_ADDRESS', 'pro3.mail.ovh.net'),
    port:           ENV.fetch('SMTP_PORT', 587).to_i,
    domain:         ENV.fetch('SMTP_DOMAIN', 'mathraining.be'),
    user_name:      ENV['SMTP_USERNAME'] || ENV['EMAIL_USER_NAME'] || '',
    password:       ENV['SMTP_PASSWORD'] || ENV['EMAIL_PASSWORD'] || '',
    authentication: :login,
    enable_starttls_auto: true
  }
end
