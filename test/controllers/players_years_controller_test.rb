require 'test_helper'

class PlayersYearsControllerTest < ActionController::TestCase
  setup do
    @players_year = players_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create players_year" do
    assert_difference('PlayersYear.count') do
      post :create, players_year: { defense_stats_id: @players_year.defense_stats_id, kicking_stats_id: @players_year.kicking_stats_id, passing_stats_id: @players_year.passing_stats_id, player_id: @players_year.player_id, punting_stats_id: @players_year.punting_stats_id, receiving_stats_id: @players_year.receiving_stats_id, return_stats_id: @players_year.return_stats_id, rushing_stats_id: @players_year.rushing_stats_id, year: @players_year.year }
    end

    assert_redirected_to players_year_path(assigns(:players_year))
  end

  test "should show players_year" do
    get :show, id: @players_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @players_year
    assert_response :success
  end

  test "should update players_year" do
    patch :update, id: @players_year, players_year: { defense_stats_id: @players_year.defense_stats_id, kicking_stats_id: @players_year.kicking_stats_id, passing_stats_id: @players_year.passing_stats_id, player_id: @players_year.player_id, punting_stats_id: @players_year.punting_stats_id, receiving_stats_id: @players_year.receiving_stats_id, return_stats_id: @players_year.return_stats_id, rushing_stats_id: @players_year.rushing_stats_id, year: @players_year.year }
    assert_redirected_to players_year_path(assigns(:players_year))
  end

  test "should destroy players_year" do
    assert_difference('PlayersYear.count', -1) do
      delete :destroy, id: @players_year
    end

    assert_redirected_to players_years_path
  end
end
