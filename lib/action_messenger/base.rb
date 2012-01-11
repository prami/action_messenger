module ActionMessenger

  class Base < AbstractController::Base
    include DeliveryMethods
    abstract!

    include AbstractController::Logger
    include AbstractController::Rendering
    include AbstractController::Layouts
    include AbstractController::Helpers
    include AbstractController::Translation
    include AbstractController::AssetPaths

    private_class_method :new
    attr_writer :raise_delivery_errors

    class_attribute :default_params
    self.default_params = {
      :delivery_method => :custom
    }.freeze

    class << self

      def messenger_name
        @messenger_name ||= name.underscore
      end
      attr_writer :messenger_name
      alias :controller_path :messenger_name

      def respond_to?(method, include_private = false)
        super || action_methods.include?(method.to_s)
      end

      def method_missing(method, *args)
        return super unless respond_to?(method)
        new(method, *args).message
      end

      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end

    end

    def mailer_name
      self.class.mailer_name
    end

    attr_internal :content

    def initialize(method_name=nil, *args)
      super()
      @_content = Message.new()
      process(method_name, *args) if method_name
    end

    def process(*args)
      lookup_context.skip_default_locale!
      super
    end

    def mailer_name
      self.class.mailer_name
    end

    def message
      template_path = self.class.messenger_name
      template_name = action_name

      template = lookup_context.find(template_name, Array.wrap(template_path))
      wrap_delivery_behavior!(default_params[:delivery_method])

      @_content.body = render(:template => template)
      @_content
    end

    def each_template(paths, name, &block)
      templates = lookup_context.find_all(name, Array.wrap(paths))
      templates.uniq_by { |t| t.formats }.each(&block)
    end

    ActiveSupport.run_load_hooks(:action_messenger, self)
  end

end
