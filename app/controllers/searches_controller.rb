class SearchesController < ApplicationController
  def new
    @search = Search.new
    respond_to do |format|
      format.html
      format.js
    end
  end

private

  def search_params
    params.require(:search).permit(:phrase, :groups, :part_of_speech)
  end
end
