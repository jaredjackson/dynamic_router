require 'spec_helper'

RSpec.describe DynamicRouter do
  before(:each) do
    class Example < ActiveRecord::Base
      extend DynamicRouter
    end
    
    Example.create!(:first_path => "path_a", :second_path => "path_a_a", :default_field => "default_value")
  end
  
  it "should check the the existence of the table" do
    connection = ActiveRecord::Base.connection
    
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
    expect(connection).to receive(:table_exists?).with(Example.table_name)
    
    Example.send(:has_dynamic_route, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
  end
  
  it "should create a get route with the supplied url" do
    Example.send(:has_dynamic_route, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_a', :method => :get))
  end
  
  it "should accept the method option" do
    Example.send(:has_dynamic_route, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :method => :post)
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_a', :method => :post))
  end
  
  it "should accept the defaults option" do
    Example.send(:has_dynamic_route, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :defaults => {:default_value => Proc.new {|example| example.default_field}})
    
    expect(Rails.application.routes.routes.named_routes["path_a_path_a_a"].defaults).to match a_hash_including(:default_value => "default_value")
  end
  
  it "should create the route after save the model" do
    Example.send(:has_dynamic_route, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :defaults => {:default_value => Proc.new {|example| example.default_field}})
    
    Example.create!(:first_path => "path_a", :second_path => "path_a_b")
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_b', :method => :get))
  end
end