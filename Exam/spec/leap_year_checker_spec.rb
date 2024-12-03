# frozen_string_literal: true

require_relative '../leap_year_checker'

describe '#leap_year?' do
  it 'повертає true для року, який ділиться на 400' do
    expect(leap_year?(2000)).to eq(true)
  end

  it 'повертає false для року, який ділиться на 100, але не на 400' do
    expect(leap_year?(1900)).to eq(false)
  end

  it 'повертає true для року 2004, який ділиться на 4, але не на 100' do
    expect(leap_year?(2004)).to eq(true)
  end

  it 'повертає true для року, який ділиться на 4, але не на 100' do
    expect(leap_year?(2024)).to eq(true)
  end

  it 'повертає false для року, який не ділиться на 4' do
    expect(leap_year?(2023)).to eq(false)
  end
end
