require "action_messenger"
require "rails"
require "abstract_controller/railties/routes_helpers"

module ActionMessenger
  class Railtie < Rails::Railtie
    config.action_messenger = ActiveSupport::OrderedOptions.new

    initializer "action_messenger.logger" do
      ActiveSupport.on_load(:action_messenger) { self.logger ||= Rails.logger; }
    end

    initializer "action_messenger.set_configs" do |app|
      paths   = app.config.paths
      options = app.config.action_messenger

      options.assets_dir      ||= paths["public"].first
      options.javascripts_dir ||= paths["public/javascripts"].first
      options.stylesheets_dir ||= paths["public/stylesheets"].first

      # make sure readers methods get compiled
      options.asset_path      ||= app.config.asset_path
      options.asset_host      ||= app.config.asset_host

      ActiveSupport.on_load(:action_messenger) do
        include AbstractController::UrlFor
        extend ::AbstractController::Railties::RoutesHelpers.with(app.routes)
        include app.routes.mounted_helpers

        #register_interceptors(options.delete(:interceptors))
        #register_observers(options.delete(:observers))

        options.each { |k,v| send("#{k}=", v) }
      end
    end

    initializer "action_messenger.compile_config_methods" do
      ActiveSupport.on_load(:action_messenger) do
        config.compile_methods! if config.respond_to?(:compile_methods!)
      end
    end

    initializer "action_messenger.add_view_paths" do |app|
      paths   = app.config.paths
      views = paths["app/views"].existent
      unless views.empty?
        ActiveSupport.on_load(:action_messenger){ prepend_view_path(views) }
      end
    end
  end
end
