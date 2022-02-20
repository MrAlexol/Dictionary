# frozen_string_literal: true

# Cards controller. It interacts with users
class CardsController < ApplicationController
  include CardsHelper
  before_action :set_card, only: %i[show destroy check]
  before_action :authenticate_user!

  # GET /cards or /cards.json
  def index
    @cards = Card.where(user_id: current_user).order(created_at: :desc)
  end

  # GET /cards/1 or /cards/1.json
  def show
    @card.definition.chop! if @card.definition[-1] == '.'
  end

  # POST /cards/1/check.json
  def check
    @response = make_response(card_params[:word], @card.word)
    @user_action = params[:button]
  end

  # POST /cards or /cards.json
  def create
    @card = Card.new(card_params)
    @card.user_id = current_user.id
    @card.save
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: I18n.t('cards.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = Card.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def card_params
    params.require(:card).permit(:word, :definition)
  end
end
