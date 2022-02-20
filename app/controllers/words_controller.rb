# frozen_string_literal: true

require 'http'

# Words controller class
class WordsController < ApplicationController
  include WordsHelper
  before_action :set_word, only: %i[show edit update destroy]

  # GET /words.json
  def index
    if params[:search]
      @found = find_word word_search_params[:phrase]
      redirect_to @found if @found.is_a? Word

      if @found.is_a?(Hash) && @found.length.zero?
        @error = true
        @message = 'Word not found'
      end
    else
      not_found_no_logs
    end
  end

  # GET /words/1.json
  def show
    @word_api = HTTP.get("#{Rails.application.config_for(:webapi)[:url]}/#{@word.phrase}").to_s
    raise StandardError if @word_api[0] != '['
  rescue StandardError
    @error = true
    @message = 'API GET failed'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:id])
  end

  # Only allow a list of trusted parameters for search.
  def word_search_params
    phrase = params[:search][:phrase]
    params[:search][:phrase] = phrase.length <= 1 ? phrase : phrase.downcase
    params.require(:search).permit(:phrase, :part_of_speech)
  end
end
