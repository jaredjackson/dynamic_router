require "dynamic_router/version"

module DynamicRouter
  class Router
    def self.has_dynamic_route_for(klass, url, target, options = {})
      route_method = options[:method] || :get
      
      if ActiveRecord::Base.connection.table_exists? klass.table_name
        Rails.application.routes.draw do
          klass.find_each do |model|
            unless options[:defaults].blank?
              defaults = {}
              
              options[:defaults].each do |key, value|
                defaults[key.to_sym] = value.call(model)
              end  
            end
            
            _url = url.call(model).to_s
            _target = target.to_s
            
            unless _url.blank? || _url.gsub(/\//, "").blank?
              #puts "Routing #{route_method.to_s.upcase} #{_url}, to #{target}, defaults : #{defaults}"
              send(route_method, _url, :to => _target, :defaults => defaults)
            end
          end   
        end
      end
      
      klass.class_eval do
        after_save :create_route
        
        def create_route
          Rails.application.routes_reloader.reload!
        end
      end
    end
  end    
end