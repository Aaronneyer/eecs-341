class PlayersYearsController < ApplicationController
  before_action :set_players_year, only: [:show]

  # GET /players_years
  # GET /players_years.json
  def index
    @players_years = PlayersYear.all
  end

  # GET /players_years/1
  # GET /players_years/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_players_year
      @players_year = PlayersYear.find(params[:id])
    end
end
