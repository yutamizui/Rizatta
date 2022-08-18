require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class ActiveHash::Base
  extend ActiveModel::Translation
end

module Yotech
  class Application < Rails::Application
    config.i18n.default_locale = :ja
    config.i18n.fallbacks = [I18n.default_locale]
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    config.active_record.time_zone_aware_types = [:datetime]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end

