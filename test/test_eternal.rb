require 'test_helper'
require 'ice_cube'

describe 'Eternal Parsing' do
  it 'can parse repeats occuring weekly' do
    strings = {
      'every sunday' => IceCube::Rule.weekly.day(:sunday),
      'every monday' => IceCube::Rule.weekly.day(:monday),
      'every tuesday' => IceCube::Rule.weekly.day(:tuesday),
      'every wednesday' => IceCube::Rule.weekly.day(:wednesday),
      'every thursday' => IceCube::Rule.weekly.day(:thursday),
      'every friday' => IceCube::Rule.weekly.day(:friday),
      'every saturday' => IceCube::Rule.weekly.day(:saturday)
    }
    strings.each do |phrase, rule|
      schedule = IceCube::Schedule.new() do |s|
        s.add_recurrence_rule(rule)
      end
      eternal_output = Eternal.parse(phrase) 
      value(eternal_output).must_equal schedule
    end
  end
end
