# frozen_string_literal: true

require 'http'

# Words controller class
class WordsController < ApplicationController
  include WordsHelper
  before_action :set_word, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  # GET /words or /words.json
  def index
    respond_to do |format|
      if params[:search]
        search_word = word_search_params[:phrase]
        found = Word.search(search_word) || make_word_list(search_word)
        if found.is_a? Hash
          case found.length
          when 0
            format.json do
              render json: { error: true, message: 'Word not found' }.as_json
            end
          when 1 then format.json { redirect_to Word.search(found.keys[0]) }
          else format.json { render json: found.to_json }
          end
        else
          format.json { redirect_to found, format: :json }
        end
      else
        format.json { head :no_content, status: :success }
        format.html { head :no_content, status: :success }
      end
    end
  end

  # GET /words/1 or /words/1.json
  def show
    word_api = HTTP.get("#{Rails.application.config_for(:webapi)[:url]}/#{@word.phrase}").to_s
    raise StandardError if word_api[0] != '['

    prepared_respond = { own: @word.to_json, api: word_api }.as_json
  rescue StandardError
    prepared_respond = '{"error": true, "message": "API GET failed"}'
  ensure
    respond_to do |format|
      format.json do
        render json: prepared_respond
      end
      format.html { head :no_content, status: :success }
    end
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit; end

  # POST /words or /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1 or /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1 or /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def word_params
    params.require(:word).permit(:phrase, :groups)
  end

  # Only allow a list of trusted parameters for search.
  def word_search_params
    phrase = params[:search][:phrase]
    params[:search][:phrase] = phrase.length <= 1 ? phrase : phrase.downcase
    params.require(:search).permit(:phrase, :part_of_speech)
  end
end
