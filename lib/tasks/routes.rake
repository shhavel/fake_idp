# frozen_string_literal: true

desc 'List defined routes'
task :routes do
  FakeIdp::Application.routes.each do |method, routes|
    routes.each do |route,|
      puts "#{method.rjust(7, ' ')} #{route}"
    end
  end
end
