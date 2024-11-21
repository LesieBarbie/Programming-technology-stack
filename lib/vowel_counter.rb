module VowelCounter
  class Counter
    ENGLISH_VOWELS = %w[a e i o u].freeze
    UKRAINIAN_VOWELS = %w[а е є и і ї о у ю я].freeze
    ALL_VOWELS = (ENGLISH_VOWELS + UKRAINIAN_VOWELS).freeze

    def self.count_vowels(string)
      return 0 unless string.is_a?(String)

      # Розбиваємо рядок на слова за пробілами
      words = string.split

      words.sum do |word|
        word.chars.each_with_index.count do |char, index|
          is_vowel = ALL_VOWELS.include?(char.downcase)

          # Логіка для "y"
          if char.downcase == 'y'
            # "Y" не рахується голосною на початку слова перед голосною
            is_vowel = if index.zero? && word[index + 1] =~ /[aeiouаеиіоуюяє]/i
                         false
                       else
                         true # Голосна в інших випадках
                       end
          end

          is_vowel
        end
      end
    end
  end
end
