module ActionMessenger

  class Message

    attr_accessor :body, :delivery_handler, :delivery_class, :delivery_settings

    def initialize(attrs = { })
      @body = attrs[:body]
    end

    def deliver
      delivery_handler.deliver(self)
    end

    def delivery_method(klass, settings)
      delivery_class = klass
      delivery_settings = settings
    end

  end

end
