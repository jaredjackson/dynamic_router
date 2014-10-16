require 'spec_helper'

RSpec.describe DynamicRouter do
  before(:each) do
    Example.destroy_all
    
    Example.create!(:first_path => "path_a", :second_path => "path_a_a", :default_field => "default_value")
    Example.create!(:first_path => "path_a", :second_path => "path_a_c", :default_field => "default_value")
  end
  
  it "should check the the existence of the table" do
    connection = ActiveRecord::Base.connection
    
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
    expect(connection).to receive(:table_exists?).with(Example.table_name)
    
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
    end
  end
  
  it "should create a get route with the supplied url" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
    end
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_a', :method => :get))
    expect(Rails.application.routes.recognize_path('/path_a/path_a_c', :method => :get))
  end
  
  it "should accept the method option" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :method => :post)
    end
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_a', :method => :post))
  end
  
  it "should accept the defaults option" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :defaults => {:default_value => Proc.new {|example| example.default_field}})
    end
    
    expect(Rails.application.routes.routes.named_routes["path_a_path_a_a"].defaults).to match a_hash_including(:default_value => "default_value")
  end
  
  it "should create the route after save the model" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method", :defaults => {:default_value => Proc.new {|example| example.default_field}})
    end
    
    Example.create!(:first_path => "path_a", :second_path => "path_a_b")
    
    expect(Rails.application.routes.recognize_path('/path_a/path_a_b', :method => :get))
  end
  
  it "should not create the route if the url is blank" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| ""}, "dummy#dummy_method")
    end
    
    expect(Rails.application.routes.routes.named_routes).to be_empty
  end
  
  it "should not create the route if the url eval to blank" do
    Rails.application.routes.draw do
      DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
    end
    
    Example.create!(:first_path => "")
    
    expect(Rails.application.routes.routes.named_routes.size).to eq(2)
  end
end