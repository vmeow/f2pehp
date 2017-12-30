require 'net/http'
require 'uri'
require "open-uri"
require 'nokogiri'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players
  # GET /players.json
  def index
    sort_by = params[:sort_by] || session[:sort_by] || {}
    search_term = params[:search] || session[:search] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @skills = params[:skills_] || session[:skills_] || {}
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
    end

    #x = Player.first
    #x.update_attribute(:potential_p2p, @filters)
    
    if sort_by == {}
      sort_by = "overall_ehp"
    end
    
    if search_term == {}
      search_term = ""
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skills_] != session[:skills_] # || params[:search] != session[:search]
      session[:filters_] = @filters
      session[:skills_] = @skills
      session[:sort_by] = sort_by
      #session[:search] = search_term
      #redirect_to(players_path(sort_by: sort_by, filters_: @filters, skills_: @skills)) && return
      #redirect_to(players_path(sort_by: sort_by, search: search_term, filters_: @filters)) && return
    end

    ordering = sort_by
    case sort_by
    when "overall_ehp"
      @player_ehp_header = 'hilite'
    when "overall_lvl"
      @player_lvl_header = 'hilite'
    when "overall_xp"
      @player_xp_header = 'hilite'
    when "attack_ehp"
      @player_attack_header = 'hilite'
    when "strength_ehp"
      @player_strength_header = 'hilite'
    when "defence_ehp"
      @player_defence_header = 'hilite'
    when "hitpoints_ehp"
      @player_hitpoints_header = 'hilite'
    when "ranged_ehp"
      @player_ranged_header = 'hilite'
    when "prayer_ehp"
      @player_prayer_header = 'hilite'
    when "magic_ehp"
      @player_magic_header = 'hilite'
    when "cooking_ehp"
      @player_cooking_header = 'hilite'
    when "woodcutting_ehp"
      @player_woodcutting_header = 'hilite'
    when "fishing_ehp"
      @player_fishing_header = 'hilite'
    when "firemaking_ehp"
      @player_firemaking_header = 'hilite'
    when "crafting_ehp"
      @player_crafting_header = 'hilite'
    when "smithing_ehp"
      @player_smithing_header = 'hilite'
    when "mining_ehp"
      @player_mining_header = 'hilite'
    when "runecraft_ehp"
      @player_runecraft_header = 'hilite'
    when "potential_p2p"
      @player_p2p_header = 'hilite'
    end
    #if !search_term.nil? or search_term != ""
    #  @players = Player.where('player_name like ?', "%#{search_term}%").order(ordering)
    #else
    #  @players = Player.all.order(ordering)
    #end
    @players = Player.where(player_acc_type: @filters.keys).order(ordering)
    @players = @players.reverse
  end
  
  def clear
    @filters = {}
    params[:search] = {}
    params[:sort_by] = {}
    params[:filters_] = {}
    session[:filters_] = {}
    session[:sort_by] = {}
    session[:search] = {}
    reset_session
    session.clear
    @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
    redirect_to(players_path(filters_: @filters, sort_by: "overall_ehp"))
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
    flash[:notice] = 'Player was successfully created.'
    redirect_to players_path
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update_player
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
    
    begin
      name = player.player_name.gsub(" ", "_")
      puts name
      uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{name}")
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
              if (tier_idx + 1) < skill_tiers.length and skill_xp >=  skill_tiers[tier_idx + 1]
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
        elsif skill == "overall"
          @player.update_attribute(:"#{skill}_lvl", skill_lvl)
          @player.update_attribute(:"#{skill}_xp", skill_xp)
        end
      end
      @player.update_attribute(:overall_ehp, total_ehp.round(2))
      if @player.potential_p2p.to_f <= 0
        @player.update_attribute(:potential_p2p, "0")
      else
        @player.update_attribute(:overall_ehp, "0")
        @player.update_attribute(:overall_lvl, "0")
        @player.update_attribute(:overall_xp, "0")
      end
    rescue Exception => e  
      puts e.message 
      @player.update_attribute(:potential_p2p, "NAME CHANGE")
      @player.update_attribute(:overall_ehp, "0")
      @player.update_attribute(:overall_lvl, "0")
      @player.update_attribute(:overall_xp, "0")
    end
    #redirect_to @player, notice: 'Player was successfully updated.'
    redirect_to players_url, notice: 'Player was successfully updated.'
  end
  
  def refresh_players
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
      name = player.player_name.gsub(" ", "_")
      puts name
      begin
        uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{name}")
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
                if (tier_idx + 1) < skill_tiers.length and skill_xp >=   skill_tiers[tier_idx + 1]
                  skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
                else
                skill_ehp += (skill_xp.to_f - skill_tier)/skill_xphr
                end
              end
            end
            player.update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
            total_ehp += skill_ehp.round(2)
          elsif skill == "p2p" and skill_xp != 0
            player.update_attribute(:potential_p2p, player.potential_p2p.to_f + skill_xp.to_f)
          elsif skill == "overall"
            player.update_attribute(:"#{skill}_lvl", skill_lvl)
            player.update_attribute(:"#{skill}_xp", skill_xp)
          end
        end
        player.update_attribute(:overall_ehp, total_ehp.round(2))
        if player.potential_p2p.to_f <= 0
          player.update_attribute(:potential_p2p, "0")
        else
          player.update_attribute(:overall_ehp, "0")
          player.update_attribute(:overall_lvl, "0")
          player.update_attribute(:overall_xp, "0")
        end
      rescue Exception => e  
        puts e.message 
        player.update_attribute(:potential_p2p, "NAME CHANGE")
        player.update_attribute(:overall_ehp, "0")
        player.update_attribute(:overall_lvl, "0")
        player.update_attribute(:overall_xp, "0")
        next
      end
      
      
    end
    redirect_to players_path, notice: 'All players were successfully updated.'
  end
  
  def export_players
    File.open("players.txt", "w+") do |f|
      Player.all.each do |player|
        str = "              { 'player_name': '#{player.player_name}', 'player_acc_type': '#{player.player_acc_type}', 'potential_p2p': '#{player.potential_p2p}'"
        F2POSRSRanks::Application.config.f2p_skills.each do |skill|
          lvl = "#{skill}_lvl"
          xp = "#{skill}_xp"
          ehp = "#{skill}_ehp"
          if not player["#{lvl}"].nil?
            str += ", #{skill}_lvl: #{player[lvl]}"
          end
          if not player["#{xp}"].nil?
            str += ", #{skill}_xp: #{player[xp]}"
          end
          if not player["#{ehp}"].nil?
            str += ", #{skill}_ehp: #{player[ehp]}"
          end
        end
        str += "},\n"
        f.write(str)
      end
    end
  end
  
  def find_new
    hc_start = "59"
    hc_uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/a=13/overall.ws?table=0&page=#{hc_start}")
    
    #uim_start = "21"
    #uim_uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_ultimate/a=13/overall.ws?table=0&page=#{uim_start}")
    
    #iron_start = "773"
    #iron_uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_ironman/a=13/overall.ws?table=0&page=#{iron_start}")
    
    #reg_start = "8976"
    #reg_uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/a=13/overall.ws?table=0&page=#{reg_start}")

    ehp_reg = F2POSRSRanks::Application.config.ehp_reg
    ehp_iron = F2POSRSRanks::Application.config.ehp_iron
    ehp_uim = F2POSRSRanks::Application.config.ehp_uim
    
    xp_table = F2POSRSRanks::Application.config.xp_table
    lvl_tiers = F2POSRSRanks::Application.config.lvl_tiers
    lvl_xps = F2POSRSRanks::Application.config.lvl_xps
    
    contents = hc_uri.read

    open(url) do |f|
      page_string = f.read
    end
    flash[:notice] = open("http://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/a=13/overall.ws?table=0&page=#{hc_start}").read.truncate(1250)
    redirect_to players_path#, notice: 'New players were found.'
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
      :strength_xp, 
      :strength_lvl, 
      :strength_ehp, 
      :defence_xp, 
      :defence_lvl, 
      :defence_ehp, 
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
