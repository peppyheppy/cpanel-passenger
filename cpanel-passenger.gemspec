spec = Gem::Specification.new do |s|
  s.name = 'cpanel-passenger'
  s.version = '0.1'
  s.summary = "Cpanel Passenger"
  s.description = %{Simple bin used for automating the configuration of an account for Rails.}
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'cpanel-passenger'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'Come ON!'
  s.author = "Paul Hepworth"
  s.email = "paul@peppyheppy.com"
  s.homepage = "http://peppyheppy.com"
end

