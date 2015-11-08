class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(char)
    raise ArgumentError, 'Not letter' if !char || !char.match(/[a-zA-Z]/)
    return false if ('A'..'Z').include?(char) || guesses.include?(char) || wrong_guesses.include?(char)
    char = char.downcase
    if word.include?(char)
      self.guesses += char
    else
      self.wrong_guesses += char
    end
  end

  def word_with_guesses
    result = word
    word.chars do |char|
      result.gsub!(char, '-') unless guesses.include?(char)
    end
    result
  end

  def check_win_or_lose
    return :lose if wrong_guesses.length >= 7
    uniq_char = word[0]
    word.chars do |char|
      uniq_char << char unless uniq_char.include?(char)
    end
    return :win if uniq_char.length == guesses.length
    :play
  end
  
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
