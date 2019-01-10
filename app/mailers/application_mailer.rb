class ApplicationMailer < ActionMailer::Base
  default from: ENV["USER_NAME"]
  layout "mailer"
end
