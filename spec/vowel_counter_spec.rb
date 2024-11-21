require "spec_helper"

RSpec.describe VowelCounter::Counter do
  it "counts vowels in English words with Y logic" do
    expect(VowelCounter::Counter.count_vowels("sky")).to eq(1) # 'y' — голосна
    expect(VowelCounter::Counter.count_vowels("yes")).to eq(1) # 'y' — приголосна
    expect(VowelCounter::Counter.count_vowels("rhythm")).to eq(1) # 'y' — голосна
    expect(VowelCounter::Counter.count_vowels("crypt")).to eq(1) # 'y' — голосна
    expect(VowelCounter::Counter.count_vowels("symphony")).to eq(3)
    expect(VowelCounter::Counter.count_vowels("My yellow umbrella is not wet yet")).to eq(10)
  end

  it "counts vowels in Ukrainian words" do
    expect(VowelCounter::Counter.count_vowels("привіт")).to eq(2)
    expect(VowelCounter::Counter.count_vowels("яблуко")).to eq(3)
    expect(VowelCounter::Counter.count_vowels("мрія")).to eq(2)
    expect(VowelCounter::Counter.count_vowels("Скільки голосних звуків в українській мові?")).to eq(13)
  end
end
