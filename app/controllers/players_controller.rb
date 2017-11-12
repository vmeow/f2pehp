require 'net/http'
require 'uri'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players
  # GET /players.json
  def index
    sort_by = params[:sort_by] || session[:sort_by]
    search_term = params[:search] || session[:search]
    @filters = params[:filter_acc] || session[:filter_acc] || {}
    if @filters == {}
      @filters = ["filter_reg", "filter_im", "filter_uim", "filter_hcim"]
    end

    if params[:sort_by] != session[:sort_by] || params[:search] != session[:search]
      session[:sort_by] = sort_by
      session[:search] = search_term
      session[:filter_acc] = @filters
      redirect_to(players_path(sort_by: sort_by, search: search_term)) && return
    end

    ordering = sort_by

    if !search_term.nil?
      @players = Player.where('player_name like ?', "%#{search_term}%").order(ordering)
    else
      @players = Player.where(filter_acc: @filters).order(ordering)
    end
    @players = @players.reverse
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find params[:id]
  end

  # GET /players/new
  def new
    @player = Player.new
  end
  
  # GET /changelog
  def changelog
    @player = Player.new
  end

  # GET /players/1/update
  def update
    @player = Player.find params[:id]

    page_content = Net::HTTP.get(URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=" + @player.player_name.to_s))
    puts page_content

    redirect_to players_path, notice: 'Player was successfully updated.'
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.create!(player_params)
    # @item.update_attributes(case_id: tempCaseId)
    flash[:notice] = 'Player was successfully created.'
    redirect_to players_path
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
   @player = Player.find params[:id]

    page_content = Net::HTTP.get(URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=" + @player.player_name.to_s))
    puts page_content

    redirect_to @player, notice: 'Player was successfully updated.'
    #respond_to do |format|
    #  if @player.update(player_params)
    #    format.html {redirect_to players_path, notice: 'Player was successfully updated.'}
    #    format.json {render :show, status: :ok, location: @player}
    #  else
    #    format.html {render :show}
    #    format.json {render json: @player.errors, status: :unprocessable_entity}
    #  end
    #end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html {redirect_to players_url, notice: 'Player was successfully deleted.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(
      :player_name,
      :player_acc_type,
      :overall_xp, 
      :overall_lvl, 
      :overall_ehp, 
      :attack_xp, 
      :attack_lvl, 
      :attack_ehp, 
      :defence_xp, 
      :defence_lvl, 
      :defence_ehp, 
      :strength_xp, 
      :strength_lvl, 
      :strength_ehp, 
      :hitpoints_xp, 
      :hitpoints_lvl, 
      :hitpoints_ehp, 
      :ranged_xp, 
      :ranged_lvl, 
      :ranged_ehp, 
      :prayer_xp, 
      :prayer_lvl, 
      :prayer_ehp, 
      :magic_xp, 
      :magic_lvl, 
      :magic_ehp, 
      :cooking_xp, 
      :cooking_lvl, 
      :cooking_ehp, 
      :woodcutting_xp, 
      :woodcutting_lvl, 
      :woodcutting_ehp, 
      :fishing_xp, 
      :fishing_lvl, 
      :fishing_ehp, 
      :firemaking_xp, 
      :firemaking_lvl, 
      :firemaking_ehp, 
      :crafting_xp, 
      :crafting_lvl, 
      :crafting_ehp, 
      :smithing_xp, 
      :smithing_lvl, 
      :smithing_ehp, 
      :mining_xp, 
      :mining_lvl, 
      :mining_ehp, 
      :runecraft_xp, 
      :runecraft_lvl, 
      :runecraft_ehp)
  end
end
