Gem::Specification.new do |s|
  s.name        = 'eternal'
  s.version     = '0.0.1'
  s.date        = '2018-04-04'
  s.summary     = %{Eternal parses events, dates, and everything involved in 
  schedules using chronic and chronic duration. These events are returned as 
  ice_cube objects which can be converted to ical or yaml, or simply used to
  calculate the next occurrence of the schedule specified.}
  s.description = "A parser for event timings and schedules"
  s.authors     = ["Krithik Rao"]
  s.email       = 'krdevmail@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://github.com/KritR/eternal'
  s.license     = 'MIT'

  s.add_dependency "chronic_duration", "~>0.10", ">= 0.10.8" 
  s.add_dependency "numerizer", "~>0.2", ">= 0.2.0" 
  s.add_dependency "chronic", "~>0.10", ">= 0.10.2" 
  s.add_dependency "ice_cube", "~>0.16", ">= 0.16.2"
  #s.add_dependency "textoken", "~> 1.1.2"

  s.add_development_dependency "rake", "~>12.3", ">= 12.3.1"
  s.add_development_dependency "simplecov", "~>0.14", ">= 0.14.1"
  s.add_development_dependency "coveralls", "~>0.8", ">= 0.8.21"
  s.add_development_dependency "minitest", "~>5.11", ">= 5.11.3"
end
