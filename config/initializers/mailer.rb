# SMTP configuration
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            ENV['ALEFTNG_MAIL_USERNAME'],
    password:             ENV['ALEFTNG_MAIL_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true }
