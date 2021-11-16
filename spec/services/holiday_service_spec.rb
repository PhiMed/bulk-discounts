require 'rails_helper'

describe HolidayService do
  it 'exists' do
    holiday_service = HolidayService.new
    expect(holiday_service).to be_an_instance_of(HolidayService)
  end

  it 'next_three_holidays' do
    holiday_service = HolidayService.new
    expect(holiday_service.next_three_holidays.first.name).to eq("Thanksgiving Day")
    expect(holiday_service.next_three_holidays.second.name).to eq("Christmas Day")
    expect(holiday_service.next_three_holidays.third.name).to eq("New Year's Day")
  end
end
