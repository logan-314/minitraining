Recaptcha.configure do |config|
  # On essaie de lire les credentials, si ça plante ou si c'est vide, on met nil au lieu de crasher
  begin
    config.site_key = Rails.application.credentials.dig(:recaptcha, :site_key) || ENV['RECAPTCHA_SITE_KEY']
    config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key) || ENV['RECAPTCHA_SECRET_KEY']
  rescue StandardError
    config.site_key = ENV['RECAPTCHA_SITE_KEY']
    config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  end
end
