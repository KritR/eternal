require 'ice_cube'
require 'chronic'
require 'chronic_duration'
require 'patterns'
require 'time'

class Eternal
  def self.parse(str)
    str = str.dup
    cleanup!(str)
    tokens = tokenize(str)
    #delete_unknown!(tokens)
    recognize_keywords!(tokens)
    nested_tokens = nest_keywords(tokens)
    rrule = Evaluator.new(nested_tokens)
    rrule.evaluate
  end

  def self.cleanup!(str)
    str.gsub!(/\b(?:(last|spann?)(?:ing|s)?(?: for)?|for)(?: a| the)?(?: period| time| duration| span)?(?: of)?\b/i, 'duration')
    str.gsub!(/\b(start|end)(s|ing)?(\sin|\son)?\b/i, '\1')
    str.gsub!(/\b(end)(\sat)\b/i, 'endtime')
    str.gsub!(/\beach\b/i,'every')
    str.gsub!(/\b(start)(\sat)\b/i, 'at')
    str.gsub!(/\b(?:every\s)?(#{DAYS_REGEX})\b/i, 'every 1 week on \1')
    str.gsub!(/\b(?:on\s?)?(#{DAYS_REGEX})s\b/i, 'every 1 week on \1')
    str.gsub!(/\bevery (#{TIME_UNITS_REGEX})\b/i, 'every 1 \1')
    str.gsub!(/\bevery other\b/i, 'every 2')
    str.gsub!(/\b(#{REPEATERS_REGEX})\b/i) { 'every 1 ' + REPEATERS[$1]}
    str.gsub!(/\b(#{TIME_UNITS_REGEX})(?:s)\b/i, '\1')
    # I HAVE NO IDEA IF THIS WORKS | DEFINITELY A HACK
    str.gsub!(/\b(\w*)\sto\b/i) do |match|
      previous_word = $1
      if ($1 =~ /#{TIME_UNITS_REGEX}s?/i) == nil
        match = previous_word + ' ' + 'end' 
      else
        match = previous_word + ' ' + 'before'
      end
      match
    end
    str.gsub!(/\b(\w*)\sfrom\b/i) do |match|
      previous_word = $1
      if ($1 =~ /#{TIME_UNITS_REGEX}s?/i) == nil
        match = previous_word + ' ' + 'start' 
      else
        match = previous_word + ' ' + 'after'
      end
      match
    end
  end

  def self.tokenize(str)
    str.gsub!(/\s+/m, ' ')
    str.strip!
    str.split(" ")
  end

  def self.delete_unknown!(tokens)
    tokens.select! {|token| (token =~ REGEX_ALL) != nil}
  end

  def self.recognize_keywords!(tokens)
    tokens.map! do |token| 
      token = token.to_sym if (token =~ /\b#{KEYWORDS_REGEX}\b/) != nil
      token
    end
  end


  def self.nest_keywords(tokens)
    nested = [[]]
    tokens.each do |token|
      if (token.is_a? Symbol) 
        nested << []
      end
      nested.last << token
    end
    nested
  end
  
end

class Evaluator

  REPEAT_SPANS = {
    :year => :yearly,
    :week => :weekly,
    :day => :daily,
    :hour => :hourly,
    :minute => :minutely,
    :second => :secondly,
  }
  EVAL_ORDER = [:duration, :at_time, :every, :at_date, :on, :end_time, :end_date]
  def initialize(rule_list)
    @rule_list = rule_list
    @schedule = IceCube::Schedule.new
    @rules = []
    @options = []
  end

  def evaluate
    p @rule_list
    @rule_list.each do |rule|
      operation = rule.shift
      p operation
      case operation
      when :every
        amount = rule[0]
        duration = rule[1]
        @options << {every: {duration: REPEAT_SPANS[duration.to_sym], amount: amount}}
      when :at
        time = Chronic.parse(rule.reduce(:concat))
        @options << {at_time: time}
      when :on
        if rule.all? {|x| (x =~ /#{DAYS_REGEX}|and/i) != nil}
          rule.select! {|x| (x =~ /#{DAYS_REGEX}/i) != nil}
          rule.map!(&:to_sym)
          @options << {on: rule}
        else 
          days = Chronic.parse(rule.reduce(:concat))
          @options << {at_date: days}
        end
      when :start
        time = rule.reduce(:concat)
        if ChronicDuration.parse(time) < 24 * 60 * 60
          @options << {at_time: Chronic.parse(time, :guess => :begin)}
        else
          @options << {at_date: Chronic.parse(time, :guess => :begin)}
        end
      when :endtime
        time = rule.reduce(:concat)
        @options << {end_time: time}
      when :end
        time = rule.reduce(:concat)
        @options << {end_date: time}
      when :duration
        time = rule.reduce(:concat)
        @options << {duration: ChronicDuration.parse(time)}
      #when :until
      end
    end
    p @options
    option = @options.reduce(:merge)
    sorted = option.sort_by { |a|EVAL_ORDER.index(a) }
    sorted.each {|opt| operation = opt[0]; args = opt[1]; self.send(operation, args) }
    @rules.each {|rule| @schedule.add_recurrence_rule(rule) }
    @schedule
  end
  
  def every(opts)
    p opts
    @rules << IceCube::Rule.send(opts[:duration], opts[:amount])
  end

  def on(day)
    if(@rules.last)
      @rules.last.day(day)
    else 
      at_date(Chronic.parse(day.last.to_s))
    end
  end

  def at_time(time)
    new_time = time
    old_time = @schedule.start_time
    yr  = new_time.year
    mon = new_time.mon
    day = new_time.day
    hr  = new_time.hour
    min = new_time.min
    sec = new_time.sec
    @schedule.start_time = Time.new(yr, mon, day, hr, min, sec)
  end
  def at_date(time)
    new_time = time
    old_time = @schedule.start_time
    yr  = new_time.year
    mon = new_time.mon
    day = new_time.day
    hr  = old_time.hour
    min = old_time.min
    sec = old_time.sec
    @schedule.start_time = Time.new(yr, mon, day, hr, min, sec)
  end

  # needs to be deferred till existence of rule
  def until(string)
    @rules.last.until(Chronic.parse(string, :guess => :begin))
  end

  def in(span)
    @rules.last.month_of_year(span) if MONTHS.values.include? span
  end

  def end_time(string)
    now = @schedule.start_time || Time.now
    new_time = Chronic.parse(string, :now => :now, :guess => :begin)
    old_time = @schedule.start_time
    yr  = new_time.year
    mon = new_time.mon
    day = new_time.day
    hr  = new_time.hour
    min = new_time.min
    sec = new_time.sec
    @schedule.end_time = Time.new(yr, mon, day, hr, min, sec)
  end

  def end_date(string)
    now = @schedule.start_time || Time.now
    new_time = Chronic.parse(string, :now => :now, :guess => :begin)
    old_time = @schedule.start_time
    yr  = new_time.year
    mon = new_time.mon
    day = new_time.day
    hr  = old_time.hour
    min = old_time.min
    sec = old_time.sec
    @schedule.end_time = Time.new(yr, mon, day, hr, min, sec)
  end

  def duration(time)
    @schedule.duration = time
  end

  def except(time)
    
  end
end

