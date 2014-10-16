Dummy::Application.routes.draw do
  DynamicRouter.has_dynamic_route_for(Example, Proc.new {|example| "/#{example.first_path}/#{example.second_path}"}, "dummy#dummy_method")
end
