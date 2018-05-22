DAYS = ['saturday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'sunday']
ABBREVIATED_DAYS = ['sat', 'mon', 'tu(e(s)?)?', 'wed', 'th(u(r(s)?)?)?', 'fri', 'sun']
ALL_DAYS = DAYS + ABBREVIATED_DAYS
MONTHS = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']
ABBREVIATED_MONTHS = MONTHS.map { |x| x[0..2] }
TIME_UNITS = ['second', 'hour', 'minute', 'week', 'month', 'year', 'decade', 'century'] 
ABBREVIATED_TIME_UNITS = ['sec', 'hr', 'min', 'wk', 'mo', 'yr', 'dec', 'cent']
ALL_TIME_UNITS = TIME_UNITS + ABBREVIATED_TIME_UNITS
SEASONS = ['summer','spring','autumn|fall', 'winter']
PREP_PHRASES = ['on','in','at', 'from', 'to', 'duration']
DETERMINERS = ['each','every']
REPEATERS = {'minutely' => 'minute', 'hourly' => 'hour' ,'daily' => 'day', 'weekly' => 'week', 'monthly' => 'month', 'yearly' => 'year'}
KEYWORDS = ['every', 'at', 'on', 'start', 'end', 'duration', 'until', 'endtime'] # 'except', 'and',]


# Combines array options into single regex
def regexify_strings(array)
  Regexp.union(array)
end

DAYS_REGEX = regexify_strings(DAYS)
ABBREVIATED_DAYS_REGEX = regexify_strings(ABBREVIATED_DAYS)
ALL_DAY_REGEX = regexify_strings(ALL_DAYS)
MONTHS_REGEX = regexify_strings(MONTHS)
ABBREVIATED_MONTHS_REGEX = regexify_strings(ABBREVIATED_MONTHS)
TIME_UNITS_REGEX = regexify_strings(TIME_UNITS)
ABBREVIATED_TIME_UNITS_REGEX = regexify_strings(ABBREVIATED_TIME_UNITS)
ALL_TIME_UNITS_REGEX = regexify_strings(ALL_TIME_UNITS)
ORDINAL_REGEX = /(\d+)(st|nd|rd|th)/i
SEASONS_REGEX = regexify_strings(SEASONS)
PREP_PHRASES_REGEX = regexify_strings(PREP_PHRASES)
DETERMINERS_REGEX = regexify_strings(DETERMINERS)
REPEATERS_REGEX = regexify_strings(REPEATERS.keys)
KEYWORDS_REGEX = regexify_strings(KEYWORDS)

