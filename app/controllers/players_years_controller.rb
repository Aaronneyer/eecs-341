class PlayersYearsController < ApplicationController
  before_action :set_players_year, only: [:show, :edit, :update, :destroy]

  # GET /players_years
  # GET /players_years.json
  def index
    @players_years = PlayersYear.all
  end

  # GET /players_years/1
  # GET /players_years/1.json
  def show
  end

  # GET /players_years/new
  def new
    @players_year = PlayersYear.new
  end

  # GET /players_years/1/edit
  def edit
  end

  # POST /players_years
  # POST /players_years.json
  def create
    @players_year = PlayersYear.new(players_year_params)

    respond_to do |format|
      if @players_year.save
        format.html { redirect_to @players_year, notice: 'Players year was successfully created.' }
        format.json { render action: 'show', status: :created, location: @players_year }
      else
        format.html { render action: 'new' }
        format.json { render json: @players_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players_years/1
  # PATCH/PUT /players_years/1.json
  def update
    respond_to do |format|
      if @players_year.update(players_year_params)
        format.html { redirect_to @players_year, notice: 'Players year was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @players_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players_years/1
  # DELETE /players_years/1.json
  def destroy
    @players_year.destroy
    respond_to do |format|
      format.html { redirect_to players_years_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_players_year
      @players_year = PlayersYear.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def players_year_params
      params.require(:players_year).permit(:player_id, :year, :passing_stats_id, :rushing_stats_id, :receiving_stats_id, :return_stats_id, :kicking_stats_id, :punting_stats_id, :defense_stats_id)
    end
end
