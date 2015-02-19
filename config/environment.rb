# Load the Rails application.
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ActionMailer::Base.delivery_method = :smtp

Time::DATE_FORMATS[:ru_datetime] = "%d.%m.%Y в %k:%M:%S"

# Initialize the Rails application.
Rails.application.initialize!