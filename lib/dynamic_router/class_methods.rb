module DynamicRouter
  module ClassMethods
    def has_dynamic_route(url, target, options = {})
      method = options[:method] || :get
      klass = self
      
      if ActiveRecord::Base.connection.table_exists? klass.table_name
        Rails.application.routes.draw do
          klass.find_each do |model|
            defaults = DynamicRouter::ClassMethods.parse_defaults(options[:defaults], model)
            
            self.send(method, url.call(model).to_s, :to => target.to_s, :defaults => defaults)
          end
        end
      end
      
      add_after_save_callback(klass, method, url, target, options[:defaults])
    end
    
    def add_after_save_callback(klass, method, url, target, defaults)
      klass.cattr_accessor :_method
      klass.cattr_accessor :_url
      klass.cattr_accessor :_target
      klass.cattr_accessor :_defaults
      
      klass._method = method
      klass._url = url
      klass._target = target
      klass._defaults = defaults
      
      klass.class_eval do
        after_save :create_route
        
        def create_route
          klass = self
          
          Rails.application.routes.draw do
            defaults = DynamicRouter::ClassMethods.parse_defaults(klass._defaults, klass)
            
            self.send(klass._method, klass._url.call(klass).to_s, :to => klass._target.to_s, :defaults => defaults)
          end
        end
      end
    end
    
    module_function
      def parse_defaults(_defaults, klass)
        unless _defaults.blank?
          defaults = {}
          
          _defaults.each do |key, value|
            defaults[key.to_sym] = value.call(klass)
          end  
        end
        
        defaults
      end
  end
end