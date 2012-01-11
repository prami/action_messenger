module ActionMessenger

  module DeliveryMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :delivery_methods, :delivery_method

      self.delivery_methods = {}.freeze
      self.delivery_method  = :custom
      add_delivery_method :custom, self.class
    end

    module ClassMethods
      def add_delivery_method(symbol, klass, default_options={})
        class_attribute(:"#{symbol}_settings") unless respond_to?(:"#{symbol}_settings")
        send(:"#{symbol}_settings=", default_options)
        self.delivery_methods = delivery_methods.merge(symbol.to_sym => klass).freeze
      end

      def wrap_delivery_behavior(message, method=nil)
        method ||= self.delivery_method
        message.delivery_handler = self

        case method
        when NilClass
          raise "Delivery method cannot be nil"
        when Symbol
          if klass = delivery_methods[method.to_sym]
            message.delivery_method(klass, send(:"#{method}_settings"))
          else
            raise "Invalid delivery method #{method.inspect}"
          end
        else
          message.delivery_method(method)
        end

        # message.perform_deliveries    = perform_deliveries
        # message.raise_delivery_errors = raise_delivery_errors
      end
    end

    def wrap_delivery_behavior!(*args)
      self.class.wrap_delivery_behavior(content, *args)
    end
  end
end
