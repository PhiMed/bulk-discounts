require 'rails_helper'

describe Holiday do
  it 'exists' do
    holiday = Holiday.new({:name => "Thanksgiving", :date => "2021-11-25"})
    expect(holiday).to be_an_instance_of(Holiday)
  end

  it 'attributes' do
    holiday = Holiday.new({:name => "Thanksgiving", :date => "2021-11-25"})
    expect(holiday.name).to eq("Thanksgiving")
    expect(holiday.date.to_s).to eq("2021-11-25")
  end
end
