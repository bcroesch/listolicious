Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, "169299983097581", "06f3ceb0a59c331cf358a83c15aaf289", {:scope => "publish_stream,email"}
end