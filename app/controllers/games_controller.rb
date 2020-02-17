require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid = []
    alphabet = ('A'..'Z').to_a
    10.times { grid << alphabet.sample }
    @letters = grid
  end

  def score
    result = {}
    @time = params[:time].to_i
    url = 'https://wagon-dictionary.herokuapp.com/'
    @check = JSON.parse(open(url + params[:word]).read)
    if @check["found"] == true
      if valid_word_checker(params[:word], params[:grid])
        result[:score] = (params[:word].size * 10) / @time
        result[:message] = "Well Done"
      else
        result[:score] = 0
        result[:message] = "not in the grid"
      end
    else
      result[:score] = 0
      result[:message] = "not an english word"
    end
    @result = result
    # @option = params[:word]
  end
end


def valid_word_checker(word, grid)
  result = true
  word = word.upcase.chars
  word.each do |letter|
    if grid.include?(letter)
      result = false if word.count(letter) > grid.count(letter)
    else
      result = false
    end
  end
  result
end
