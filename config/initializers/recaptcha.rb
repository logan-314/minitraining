Recaptcha.configure do |config|
  # Prefer credentials but fallback to ENV; tolerate decryption errors
  begin
    site_key = Rails.application.credentials.dig(:recaptcha, :site_key)
    secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
    config.site_key   = site_key.presence || ENV['RECAPTCHA_SITE_KEY'] || ''
    config.secret_key = secret_key.presence || ENV['RECAPTCHA_SECRET_KEY'] || ''
  rescue StandardError
    config.site_key   = ENV['RECAPTCHA_SITE_KEY'] || ''
    config.secret_key = ENV['RECAPTCHA_SECRET_KEY'] || ''
  end
end
