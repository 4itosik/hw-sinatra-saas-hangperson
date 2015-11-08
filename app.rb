require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'
require 'pry'

class HangpersonApp < Sinatra::Base
  
  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    session[:word] = word
    session[:guesses] = ''
    session[:wrong_guesses] = ''

    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###

    @game.word = session[:word] if @game.word == ''
    @game.guesses = session[:guesses]
    @game.wrong_guesses = session[:wrong_guesses]
    begin
      result = @game.guess(letter)
      if result == false
        flash[:message] = "You have already used that letter."
      else
        flash[:message] = ""
        session[:guesses] = @game.guesses
        session[:wrong_guesses] = @game.wrong_guesses
      end
    rescue
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    @game.word = session[:word] if @game.word == ''
    @game.guesses = session[:guesses]
    @game.wrong_guesses = session[:wrong_guesses]

    redirect "/#{@game.check_win_or_lose.to_s}" if @game.word && @game.check_win_or_lose != :play
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    erb :lose # You may change/remove this line
  end
  
  
  def word_with_guesses(word, guesses)
    result = word
    word.chars do |char|
      result.gsub!(char, '-') unless guesses.include?(char)
    end
    result
  end
end
