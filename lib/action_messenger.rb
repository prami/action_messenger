require 'abstract_controller'
require 'action_view'

require 'active_support/core_ext/class'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/uniq_by'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'
require 'active_support/lazy_load_hooks'

module ActionMessenger
  extend ::ActiveSupport::Autoload

  #autoload :AdvAttrAccessor
  #autoload :Collector
  autoload :Base
  autoload :Message
  autoload :DeliveryMethods
  #autoload :MailHelper
  #autoload :OldApi
  #autoload :TestCase
  #autoload :TestHelper
end

require 'action_messenger/railtie'
