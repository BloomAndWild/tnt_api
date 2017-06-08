def get_next_day(date, day_of_week)
  date + ((day_of_week - date.wday) % 7)
end
