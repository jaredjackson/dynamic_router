# DynamicRouter

[![Build Status](https://travis-ci.org/coyosoftware/dynamic_router.svg?branch=master)](https://travis-ci.org/coyosoftware/dynamic_router) [![Gem Version](https://badge.fury.io/rb/dynamic_router.png)](http://badge.fury.io/rb/dynamic_router) [![Test Coverage](https://codeclimate.com/github/coyosoftware/dynamic_router/badges/coverage.svg)](https://codeclimate.com/github/coyosoftware/dynamic_router) [![Code Climate](https://codeclimate.com/github/coyosoftware/dynamic_router/badges/gpa.svg)](https://codeclimate.com/github/coyosoftware/dynamic_router)

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
```ruby
class Example < ActiveRecord::Base
	# This model has a field called 'url'
end
```	
To create a route to a resource using the field 'url' as URL, add the following line to your routes.rb:
```ruby
DynamicRouter::Router.has_dynamic_route_for Example, Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method"
```
	
After this when you create models like:
```ruby
Example.create!(:url => "abc")
Example.create!(:url => "123")
```	
The dynamic router will create the routes "/abc" and "/123" mapping to DummyController#dummy_method

You can pass the desired HTTP method also:
```ruby	
DynamicRouter::Router.has_dynamic_route_for Example, Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method", :method => :post
```	
And can specify default values to be passed, like:
```ruby
DynamicRouter::Router.has_dynamic_route_for Example, Proc.new {|example| "/#{example.url}"}, "dummy#dummy_method", :defaults => {:some_value => Proc.new {|example| example.default_field}}
```	
The dynamic router will map ALL records of the model on the startup and will create an after_save hook to create new routes as the models are created.

**Notes for Unicorn**
If you use Unicorn as server (or some other server that spawn multiple workers), you might experience an 'intermittent' 404 page for the dynamic routes when they are updated after saving a model.
This occurs because only the worker that served the update request will update its routes. 
To avoid this you can reload the routes before every request or implement some kind of messaging system (using redis or similar) to tell your workers to reload the routes.


## Credits
Thanks to Michael Lang (http://codeconnoisseur.org/) for the code that inspired this gem.

## Contributing

1. Fork it ( https://github.com/coyosoftware/dynamic_router/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
