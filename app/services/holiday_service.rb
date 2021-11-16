class HolidayService

  def self.api_fetch
    this_year = Faraday.get("https://date.nager.at/api/v1/Get/US/#{Time.now.year}")
    next_year = Faraday.get("https://date.nager.at/api/v1/Get/US/#{Time.now.year + 1}")
    body_1 = JSON.parse(this_year.body, symbolize_names: true)
    body_2 = JSON.parse(next_year.body, symbolize_names: true)
    (body_1 << body_2).flatten!
  end

  def self.holidays
    api_fetch.map do |data|
      Holiday.new(data)
    end
  end

  def self.next_three_holidays
    upcoming_holidays = []
    holidays.each do |holiday|
      if holiday.date >= Date.today
        upcoming_holidays << holiday
      end
    end
    upcoming_holidays.shift(3)
  end
end
