Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, "169299983097581", "06f3ceb0a59c331cf358a83c15aaf289", {:scope => "publish_stream,email,offline_access"} if RAILS_ENV == 'production'
  provider :facebook, "193602280655674", "e65e2462f38785adac7abea723e2c4af", {:scope => "publish_stream,email,offline_access"} if RAILS_ENV == 'development'
end