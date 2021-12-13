require 'http'

class WordsController < ApplicationController
  before_action :set_word, only: %i[show edit update destroy]

  # GET /words or /words.json
  def index
    @word = Word.search(word_search_params[:phrase])[0]
  rescue ActionController::ParameterMissing
    puts 'no params'
  ensure
    if @word
      respond_to do |format|
        format.html { redirect_to @word }
        format.json { redirect_to @word, format: :json } # render :show, status: :created, location: @word
      end
    else
      @words = Word.all
    end
  end

  # GET /words/1 or /words/1.json
  def show
    @word_api = HTTP.get("https://api.dictionaryapi.dev/api/v2/entries/en/#{@word.phrase}").body
    respond_to do |format|
      format.json do
        render json: { own: @word.to_json, api: @word_api }.as_json
      end
      format.html
    end
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words or /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: "Word was successfully created." }
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
        format.html { redirect_to @word, notice: "Word was successfully updated." }
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
      format.html { redirect_to words_url, notice: "Word was successfully destroyed." }
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

    def word_search_params
      params.require(:search).permit(:phrase, :part_of_speech)
    end
end
