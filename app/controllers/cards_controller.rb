class CardsController < ApplicationController
  include CardsHelper
  before_action :set_card, only: %i[show destroy check]
  before_action :authenticate_user!

  # GET /cards or /cards.json
  def index
    @cards = Card.where(user_id: current_user)
  end

  # GET /cards/1 or /cards/1.json
  def show
    @card.definition.chop! if @card.definition[-1] == '.'
  end

  # POST /cards/1/check.json
  def check
    respond_to do |format|
      format.json { render json: { result: make_respond(card_params[:word], @card.word).as_json }.as_json }
    end
  end

  # POST /cards or /cards.json
  def create
    @card = Card.new(card_params)
    @card.user_id = current_user.id
    @card.save
    # respond_to do |format|
    #   if @card.save
    #     format.html { redirect_to @card, notice: "Card was successfully created." }
    #     format.json { render :show, status: :created, location: @card }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @card.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: "Card was successfully destroyed." }
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
      params.require(:card).permit(:word)
    end
end
