require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @alphabet = ('a'..'z').to_a
    @choosen_letters = []
    10.times do
      @ind = rand(@alphabet.length)
      @choosen_letters << @alphabet[@ind]
    end
  end

  def score
    @word = params[:word]
    @choosen_letters = params[:choosen_letters]
    api_check = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    word_check = []
    @word.chars.each { |letter| word_check << @choosen_letters.split(", ").include?(letter) }
    word_check = !word_check.include?(false)
    # raise
    if word_check && api_check["found"]
      session[:score].positive? ? session[:score] += @word.length : session[:score] = @word.length
      @message = "Congratulations! #{@word.upcase} is a valid english word!"
    elsif word_check
      @message = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    else
      @message = "Sorry but #{@word.upcase} can't be built out of #{@choosen_letters.upcase}"
    end
    @score = session[:score]
  end
end
