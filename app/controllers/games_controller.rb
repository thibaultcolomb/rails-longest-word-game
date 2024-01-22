require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      new_letter = ('a'..'z').to_a.sample
      @letters << new_letter
    end
    @letters_joined = @letters.join
  end

  def start
  session[:score] = 0
  end

  def score
    if params[:word].downcase.chars.all? { |char| params[:word].downcase.chars.count(char) <= params[:letters].count(char) }
      url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
      word_serialized = URI.open(url).read
      word_parsed = JSON.parse(word_serialized)
      if word_parsed["found"] == true
        @result = "Congratulation! #{params[:word].upcase} is a valid english word"
        session[:score] += params[:word].length
      else
        @result = "Sorry but #{params[:word].upcase} does not seem to be an english word"
      end
    else
      @result = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].upcase.chars.join(', ')} "
    end
  end
end
