# frozen_string_literal: true

# Searches controller. Interacts with any user
class SearchesController < ApplicationController
  def new
    @search = Search.new
    @avail_parts_of_speech = [t('.all')]
  end

  def show
    # test with http://localhost:3000/searches/show?search%5Bphrase%5D=table&search%5Bpart_of_speech%5D=all
    @search = Search.new(params[:search] ? search_params : nil)
    unless @search.part_of_speech.nil?
      @avail_parts_of_speech = { t("searches.new.#{@search.part_of_speech}") => @search.part_of_speech }
    end
    @avail_parts_of_speech ||= { t('searches.new.all') => 'all' }

    render :new
  end

  private

  def search_params
    params.require(:search).permit(:phrase, :part_of_speech)
  end
end
