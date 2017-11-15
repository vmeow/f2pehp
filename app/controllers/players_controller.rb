require 'net/http'
require 'uri'
require "open-uri"

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players
  # GET /players.json
  def index
    #@players = Player.all
    sort_by = params[:sort_by] || session[:sort_by] || {}
    search_term = params[:search] || session[:search] || {}
    @filters = params[:filter_acc] || session[:filter_acc] || {}
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      #@filters = ["Reg", "IM", "UIM", "HCIM"]
    end
    
    if sort_by == {}
      sort_by = "overall_ehp"
    end
    
    if search_term == {}
      search_term = ""
    end
    
    #if params[:sort_by] != session[:sort_by] || params[:search] != session[:search]
    #  session[:sort_by] = sort_by
    #  session[:search] = search_term
    #  session[:filter_acc] = @filters
    #  redirect_to(players_path(sort_by: sort_by, search: search_term)) && return
    #end

    ordering = sort_by

    #if !search_term.nil? or search_term != ""
    #  @players = Player.where('player_name like ?', "%#{search_term}%").order(ordering)
    #else
    #  @players = Player.all.order(ordering)
    #end
    @players = Player.all.order(ordering)
    @players = @players.reverse
  end
  
  def clear
    @filters = {}
    params[:search] = {}
    params[:sort_by] = {}
    session[:sort_by] = {}
    session[:search] = {}
    reset_session
    session.clear
    index
    #redirect_to(players_path) && return
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
    @player.update_attribute(:potential_p2p, "0")
    case @player.player_acc_type
    when "Reg"
      ehp = F2POSRSRanks::Application.config.ehp_reg
    when "HCIM", "IM"
      ehp = F2POSRSRanks::Application.config.ehp_iron
    when "UIM"
      ehp = F2POSRSRanks::Application.config.ehp_uim
    end
    
    uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{@player.player_name}")
    all_stats = uri.read.split(" ")
    total_ehp = 0.0
    F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
      skill_lvl = all_stats[skill_idx].split(",")[1].to_f
      skill_xp = all_stats[skill_idx].split(",")[2].to_f
      if skill != "p2p" and skill != "overall" and skill != "lms"
        @player.update_attribute(:"#{skill}_lvl", skill_lvl)
        @player.update_attribute(:"#{skill}_xp", skill_xp)
        
        skill_ehp = 0.0
        skill_tiers = ehp["#{skill}_tiers"]
        skill_xphrs = ehp["#{skill}_xphrs"]
        last_skill_tier = 0.0
        skill_tiers.each.with_index do |skill_tier, tier_idx|
          skill_tier = skill_tier.to_f
          skill_xphr = skill_xphrs[tier_idx].to_f
          if skill_xphr != 0 and skill_tier < skill_xp
            if (tier_idx + 1) < skill_tiers.length and skill_xp >= skill_tiers[tier_idx + 1]
              skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
            else
              skill_ehp += (skill_xp.to_f - skill_tier)/skill_xphr
            end
          end
        end
        @player.update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
        total_ehp += skill_ehp.round(2)
      elsif skill == "p2p" and skill_xp != 0
        @player.update_attribute(:potential_p2p, skill_xp)
      end
    end
    @player.update_attribute(:overall_ehp, total_ehp.round(2))
    #redirect_to @player, notice: 'Player was successfully updated.'
     redirect_to players_url, notice: 'Player was successfully updated.'
  end
  
  def update_all
    Player.all.each do |player|
      player.update_attribute(:potential_p2p, "0")
      case player.player_acc_type
      when "Reg"
        ehp = F2POSRSRanks::Application.config.ehp_reg
      when "HCIM", "IM"
        ehp = F2POSRSRanks::Application.config.ehp_iron
      when "UIM"
        ehp = F2POSRSRanks::Application.config.ehp_uim
      end
    
      uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{player.player_name}")
      all_stats = uri.read.split(" ")
      total_ehp = 0.0
      F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
        skill_lvl = all_stats[skill_idx].split(",")[1].to_f
        skill_xp = all_stats[skill_idx].split(",")[2].to_f
        if skill != "p2p" and skill != "overall" and skill != "lms"
          player.update_attribute(:"#{skill}_lvl", skill_lvl)
          player.update_attribute(:"#{skill}_xp", skill_xp)
        
          skill_ehp = 0.0
          skill_tiers = ehp["#{skill}_tiers"]
          skill_xphrs = ehp["#{skill}_xphrs"]
          last_skill_tier = 0.0
          skill_tiers.each.with_index do |skill_tier, tier_idx|
            skill_tier = skill_tier.to_f
            skill_xphr = skill_xphrs[tier_idx].to_f
            if skill_xphr != 0 and skill_tier < skill_xp
              if (tier_idx + 1) < skill_tiers.length and skill_xp >= skill_tiers[tier_idx + 1]
                skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
              else
                skill_ehp += (skill_xp.to_f - skill_tier)/skill_xphr
              end
            end
          end
          player.update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
          total_ehp += skill_ehp.round(2)
        elsif skill == "p2p" and skill_xp != 0
          player.update_attribute(:potential_p2p, player.potential_p2p + skill_xp)
        end
      end
      player.update_attribute(:overall_ehp, total_ehp.round(2))
    end
    redirect_to players_url, notice: 'All players were successfully updated.'
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
      :runecraft_ehp,
      :potential_p2p)
  end
end
