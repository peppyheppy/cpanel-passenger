# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'cpanel-passenger'
  s.version = '0.0.1'
  s.author = "Paul Hepworth"
  s.date = %q{2009-05-13}
  s.description = %{Simple bin used for automating the configuration of an account for Rails.}
  s.email = "paul@peppyheppy.com"
  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true  
  s.homepage = "http://peppyheppy.com"
  s.rdoc_options << '--title' <<  'Come ON!'
  s.require_path = ['lib']
  s.summary = "Cpanel Passenger" 
  s.autorequire = 'cpanel-passenger'
end

