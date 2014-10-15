# DynamicRouter

[![Build Status](https://travis-ci.org/coyosoftware/dynamic_router.svg?branch=master)](https://travis-ci.org/coyosoftware/dynamic_router) [![Gem Version](https://badge.fury.io/rb/dynamic_router.png)](http://badge.fury.io/rb/dynamic_router) [![Coverage Status](https://coveralls.io/repos/coyosoftware/dynamic_router/badge.png)](https://coveralls.io/r/coyosoftware/dynamic_router)

Add dynamic routes based on model attributes

## Installation

Add this line to your application's Gemfile:

    gem 'dynamic_router'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamic_router

## Usage

Suppose you want to create a friendly URL for a resource based on fields of an example model:

	class Example < ActiveRecord::Base
		# This model has a field called 'url'
	end
	
To create a route to a resource using the field 'url' as URL, first extend the DynamicRouter class:

	class Example < ActiveRecord::Base
		extend DynamicRouter
		
		# This model has a field called 'url'
	end
	
And after add the 'has_dynamic_route' method as following:

	class Example < ActiveRecord::Base
		extend DynamicRouter
		
		# This model has a field called 'url'
		
		has_dynamic_route Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method"
	end
	
With this notation, when you create models like:

	Example.create!(:url => "abc")
	Example.create!(:url => "123")
	
The dynamic router will create the routes "/abc" and "/123" mapping to DummyController#dummy_method

You can pass the desired HTTP method also:
	
	class Example < ActiveRecord::Base
		# This model has a field called 'url'
		
		has_dynamic_route Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method", :method => :post
	end
	
And can specify default values to be passed, like:

	class Example < ActiveRecord::Base
		# This model has two fields called 'url' and 'default_field'
		
		has_dynamic_route Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method", :defaults => {:some_value => Proc.new {|example| example.default_field}}
	end
	
The dynamic router will map ALL records of the model on the startup and will create an after_save hook to create new routes as the models are created. 

## Contributing

1. Fork it ( https://github.com/coyosoftware/dynamic_router/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
