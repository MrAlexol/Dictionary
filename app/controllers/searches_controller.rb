class SearchesController < ApplicationController
  def show
    @search = Search.find(params[:id])
  end

  def new
    @search = Search.new
    # @parts_of_speech = ['Noun', 'Verb', 'Adjective', 'Adverb', 'Number', 'Pronoun', 'Conjunction', 'Interjection', 'Prefix', 'Postfix', 'Exclamation']
  end

  def create
    @search = Search.create(search_params)
    redirect_to @search
  end

private

  def search_params
    params.require(:search).permit(:phrase, :groups, :part_of_speech)
  end
end
