Gem::Specification.new do |s|
  s.name        = 'eternal'
  s.version     = '0.0.1'
  s.date        = '2018-04-04'
  s.summary     = "Hola!"
  s.description = "A parser for event timings and occurrences"
  s.authors     = ["Krithik Rao"]
  s.email       = 'krdevmail@gmail.com'
  s.files       = ["lib/eternal.rb"]
  s.homepage    =
  'http://rubygems.org/gems/eternal'
  s.license     = 'MIT'

  gem.add_dependency "chronic_duration", "~> 0.10.8" 
  gem.add_dependency "numerizer", "~> 0.3.0" 
  gem.add_dependency "chronic", "~> 0.10.2" 
	gem.add_dependency "ice_cube", "~> 0.16.2"
	gem.add_dependency "textoken", "~> 1.1.2"

  gem.add_development_dependency "rake", "~> 12.3.1"
  gem.add_development_dependency "rspec", "~> 3.7"
  gem.add_development_dependency "coveralls"
end
