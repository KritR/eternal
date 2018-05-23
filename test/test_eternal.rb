require 'test_helper'
require 'ice_cube'

describe 'Eternal' do
  it 'can parse repeats occuring weekly' do
    schedule = IceCube::Schedule.new() do |s|
      s.add_recurrence_rule(IceCube::Rule.weekly.day(:sunday))
    end
    eternal_output = Eternal.parse('every sunday') 
    value(eternal_output).must_equal schedule
  end
end
