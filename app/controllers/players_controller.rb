require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]
  
  def search_player_if_needed
    if params[:search]
      name = Player.sanitize_name(params[:search])
      @player = Player.find_player(name)
      if @player 
        name = @player.player_name.gsub(" ", "_")
        redirect_to "/players/#{name}"
      else
        redirect_to ranks_path, notice: "Player '#{name}' not found."
      end
      return
    end 
  end

  def create_player_if_needed
    if !params[:player_to_add_name].nil? and params[:player_to_add_name] != "" 
      if params[:player_to_add_name].length > 12
        redirect_to ranks_path, notice: 'Invalid player name.'
        return
      end

      name = Player.sanitize_name(params[:player_to_add_name])
      params[:player_to_add_name] = nil
      session[:player_to_add_name] = nil

      result = Player.create_new(name)

      if result.nil?
        redirect_to ranks_path, notice: "Player hiscores not found."
        return
      elsif result == "exists"
        redirect_to "/players/#{name.gsub(" ", "_")}", notice: "The player you wish to add already exists."
        return
      elsif result == "p2p"
        redirect_to ranks_path, notice: "The player you wish to add is not a free to play account."
        return
      elsif result == "cutoff"
        redirect_to ranks_path, notice: "The player you wish to add does not meet the EHP requirement."
        return
      end

      redirect_to result, notice: "Player added successfully."
    end
  end
  
  def tracking
    search_player_if_needed
    create_player_if_needed

    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions_] || {}
    @skill = params[:skill] || session[:skill] || {}
    unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    @time = params[:time] || session[:time] || "week"
    case @time
    when "day"
      @time_display = Time.now.gmtime.strftime("%b %d, %Y")
    when "week"
      @time_display = Time.now.gmtime.beginning_of_week.strftime("%b %d, %Y")
    when "month"
      @time_display = Time.now.gmtime.strftime("%b %Y")
    when "year"
      @time_display = Time.now.gmtime.year
    end  
      
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end
    
    if @skill == "combat"
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    
    if @sort_by == "lvl"
      @sort_by = "ehp"
      params[:sort_by] = "ehp"
      session[:sort_by] = "ehp"
    end
    
    if params[:player1] and params[:player2]
      compare
    end
    
    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    
    if @sort_by == {}
      @sort_by = "ehp"
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions_] != session[:restrictions_] || params[:time] != session[:time]
      session[:filters_] = @filters
      session[:restrictions_] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
      session[:time] = @time
    end
    
    case @sort_by
    when "ehp"
      @player_ehp_header = 'hilite'
      ordering = "#{@skill}_ehp - #{@skill}_ehp_#{@time}_start DESC, #{@skill}_xp - #{@skill}_xp_#{@time}_start DESC, #{@skill}_ehp DESC"
    when "xp"
      @player_xp_header = 'hilite'
      ordering = "#{@skill}_xp - #{@skill}_xp_#{@time}_start DESC, #{@skill}_ehp - #{@skill}_ehp_#{@time}_start DESC, #{@skill}_xp DESC"
    end
    
    @players = Player.limit(@show_limit.to_i).where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").where(player_acc_type: @filters.keys).where("overall_ehp_day_start > 0").order(ordering)
    
    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10)
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1)
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4")
    end
    
    @players = @players.where("overall_ehp > 1").paginate(:page => params[:page], :per_page => @show_limit.to_i)
    @players = @players.where("potential_p2p <= 0")
  end

  def records
    search_player_if_needed
    create_player_if_needed

    Time.zone = "Pacific Time (US & Canada)"
    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions_] || {}
    @skill = params[:skill] || session[:skill] || {}
    unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    @time = params[:time] || session[:time] || "week"
    case @time
    when "day"
      @time_display = Time.zone.now.strftime("%b %d, %Y")
    when "week"
      @time_display = Time.zone.now.beginning_of_week.strftime("%b %d, %Y")
    when "month"
      @time_display = Time.zone.now.strftime("%b %Y")
    when "year"
      @time_display = Time.zone.now.year
    end  
      
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end
    
    if @skill == "combat"
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    
    if @sort_by == "lvl"
      @sort_by = "ehp"
      params[:sort_by] = "ehp"
      session[:sort_by] = "ehp"
    end
        
    if params[:player1] and params[:player2]
      compare
    end
    
    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
        
    if @sort_by == {}
      @sort_by = "ehp"
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions_] != session[:restrictions_] || params[:time] != session[:time]
      session[:filters_] = @filters
      session[:restrictions_] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
      session[:time] = @time
    end
    
    case @sort_by
    when "ehp"
      @player_ehp_header = 'hilite'
      ordering = "#{@skill}_ehp_#{@time}_max DESC, #{@skill}_xp_#{@time}_max DESC, #{@skill}_ehp DESC"
    when "xp"
      @player_xp_header = 'hilite'
      ordering = "#{@skill}_xp_#{@time}_max DESC, #{@skill}_ehp_#{@time}_max DESC, #{@skill}_xp DESC"
    end
    
    @players = Player.limit(@show_limit.to_i).where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").where(player_acc_type: @filters.keys).where("overall_ehp_day_max > 0").order(ordering)
    
    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10)
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1)
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4")
    end
    
    @players = @players.where("overall_ehp > 1 and potential_p2p <= 0").paginate(:page => params[:page], :per_page => @show_limit.to_i)
  end

  def ranks
    search_player_if_needed
    create_player_if_needed

    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions_] || {}
    @skill = params[:skill] || session[:skill] || {}
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end
        
    if params[:player1] and params[:player2]
      compare
    end
    
    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
        
    if @sort_by == {}
      @sort_by = "ehp"
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions_] != session[:restrictions_]
      session[:filters_] = @filters
      session[:restrictions_] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
    end
    
    if @skill.include?("ttm")
      case @skill
      when "ttm_lvl"
        ordering = "ttm_lvl ASC, overall_ehp DESC"
      when "ttm_xp"
        ordering = "ttm_xp ASC, overall_ehp DESC"    
      end
    elsif @skill.include?("clues")
      case @skill
      when "clues_all"
        ordering = "clues_all DESC"
      when "clues_beginner"
        ordering = "clues_beginner DESC"    
      end
    elsif @skill.include?("no_combats")
      case @sort_by
      when "ehp"
        ordering = "overall_ehp - attack_ehp - strength_ehp - defence_ehp - ranged_ehp - magic_ehp - prayer_ehp DESC, overall_lvl - hitpoints_lvl - attack_lvl - strength_lvl - defence_lvl - ranged_lvl - magic_lvl - prayer_lvl DESC, overall_xp - hitpoints_xp - attack_xp - strength_xp - defence_xp - ranged_xp - magic_xp - prayer_xp DESC"
      when "lvl"
        ordering = "overall_lvl - hitpoints_lvl - attack_lvl - strength_lvl - defence_lvl - ranged_lvl - magic_lvl - prayer_lvl DESC, overall_ehp - attack_ehp - strength_ehp - defence_ehp - ranged_ehp - magic_ehp - prayer_ehp DESC, overall_xp - hitpoints_xp - attack_xp - strength_xp - defence_xp - ranged_xp - magic_xp - prayer_xp DESC" 
      when "xp"
        ordering = "overall_xp - hitpoints_xp - attack_xp - strength_xp - defence_xp - ranged_xp - magic_xp - prayer_xp DESC, overall_ehp - attack_ehp - strength_ehp - defence_ehp - ranged_ehp - magic_ehp - prayer_ehp DESC, overall_lvl - hitpoints_lvl - attack_lvl - strength_lvl - defence_lvl - ranged_lvl - magic_lvl - prayer_lvl DESC"
      end
    else
      case @sort_by
      when "ehp"
        @player_ehp_header = 'hilite'
        ordering = "#{@skill}_ehp DESC, #{@skill}_lvl DESC, #{@skill}_xp DESC, #{@skill}_rank ASC"
      when "lvl"
        @player_lvl_header = 'hilite'
        if @skill == "combat"
          ordering = "#{@skill}_lvl DESC, overall_ehp DESC"
        else
          ordering = "#{@skill}_lvl DESC, #{@skill}_xp DESC, #{@skill}_rank ASC"
        end
      when "xp"
        @player_xp_header = 'hilite'
        ordering = "#{@skill}_xp DESC, #{@skill}_rank ASC"
      end
    end
      

    @players = Player.limit(@show_limit.to_i).where(player_acc_type: @filters.keys).order(ordering)
    
    if @skill.include?("ttm")
      @players = @players.where("ttm_lvl != 0 or ttm_xp != 0 or overall_ehp > 1000")
    end

    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10)
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1)
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4")
    end
    if @skill == "combat"
      @players = @players.where("combat_lvl IS NOT NULL")
    end
    @players = @players.where("potential_p2p <= 0")
    
    @players = @players.paginate(:page => params[:page], :per_page => @show_limit.to_i)
  end
  
  # GET /players/1
  # GET /players/1.json
  def show
    @display = params[:display] || session[:display] || "stats"
    @time = params[:time] || session[:time] || "week"
    
    if params[:display] != session[:display] || params[:time] != session[:time]
      session[:display] = @display
      session[:time] = @time
    end

    id = params[:search] || params[:id]
    @player = Player.find_player(id)

    if not @player
      redirect_to ranks_path, notice: "Player '#{id}' not found."
      return
    end

    if @player.potential_p2p > 0
      redirect_to ranks_path, notice: "Player '#{@player.player_name}' is not free to play."
      return
    end

    @player
  end
  
  def compare
    @player1 = Player.find_player(params[:player1])
    @player2 = Player.find_player(params[:player2])

    player_not_found = nil
    if not @player1
      player_not_found = params[:player1]
    elsif not @player2
      player_not_found = params[:player2]
    end

    if player_not_found
      redirect_to ranks_path, notice: "Player '#{player_not_found}' not found."
    end
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
  def update
    @player.update_player
    redirect_to player_path(@player.player_name)
  end
  
  def update_player
    @player.update_player
    @player
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    show
  end
  
  def player_params
    params.require(:player).permit(
      :player_name,
      :player_acc_type,
      :overall_xp, 
      :overall_lvl, 
      :overall_ehp, 
      :overall_rank, 
      :attack_xp, 
      :attack_lvl, 
      :attack_ehp, 
      :attack_rank, 
      :strength_xp, 
      :strength_lvl, 
      :strength_ehp,
      :strength_rank,  
      :defence_xp, 
      :defence_lvl, 
      :defence_ehp, 
      :defence_rank,  
      :hitpoints_xp, 
      :hitpoints_lvl, 
      :hitpoints_ehp, 
      :hitpoints_rank, 
      :ranged_xp, 
      :ranged_lvl, 
      :ranged_ehp, 
      :ranged_rank, 
      :prayer_xp, 
      :prayer_lvl, 
      :prayer_ehp,
      :prayer_rank, 
      :magic_xp, 
      :magic_lvl, 
      :magic_ehp, 
      :magic_rank, 
      :cooking_xp, 
      :cooking_lvl, 
      :cooking_ehp, 
      :cooking_rank, 
      :woodcutting_xp, 
      :woodcutting_lvl, 
      :woodcutting_ehp, 
      :woodcutting_rank, 
      :fishing_xp, 
      :fishing_lvl, 
      :fishing_ehp, 
      :fishing_rank, 
      :firemaking_xp, 
      :firemaking_lvl, 
      :firemaking_ehp, 
      :firemaking_rank, 
      :crafting_xp, 
      :crafting_lvl, 
      :crafting_ehp, 
      :crafting_rank, 
      :smithing_xp, 
      :smithing_lvl, 
      :smithing_ehp, 
      :smithing_rank, 
      :mining_xp, 
      :mining_lvl, 
      :mining_ehp, 
      :mining_rank, 
      :runecraft_xp, 
      :runecraft_lvl, 
      :runecraft_ehp,
      :runecraft_rank,
      :potential_p2p,
      :combat_lvl,
      
      :attack_xp_day_start,
      :attack_xp_day_max,
      :attack_ehp_day_start,
      :attack_ehp_day_max,
      :attack_xp_week_start,
      :attack_xp_week_max,
      :attack_ehp_week_start,
      :attack_ehp_week_max,
      :attack_xp_month_start,
      :attack_xp_month_max,
      :attack_ehp_month_start,
      :attack_ehp_month_max,
      :attack_xp_year_start,
      :attack_xp_year_max,
      :attack_ehp_year_start,
      :attack_ehp_year_max,
      :strength_xp_day_start,
      :strength_xp_day_max,
      :strength_ehp_day_start,
      :strength_ehp_day_max,
      :strength_xp_week_start,
      :strength_xp_week_max,
      :strength_ehp_week_start,
      :strength_ehp_week_max,
      :strength_xp_month_start,
      :strength_xp_month_max,
      :strength_ehp_month_start,
      :strength_ehp_month_max,
      :strength_xp_year_start,
      :strength_xp_year_max,
      :strength_ehp_year_start,
      :strength_ehp_year_max,
      :defence_xp_day_start,
      :defence_xp_day_max,
      :defence_ehp_day_start,
      :defence_ehp_day_max,
      :defence_xp_week_start,
      :defence_xp_week_max,
      :defence_ehp_week_start,
      :defence_ehp_week_max,
      :defence_xp_month_start,
      :defence_xp_month_max,
      :defence_ehp_month_start,
      :defence_ehp_month_max,
      :defence_xp_year_start,
      :defence_xp_year_max,
      :defence_ehp_year_start,
      :defence_ehp_year_max,
      :hitpoints_xp_day_start,
      :hitpoints_xp_day_max,
      :hitpoints_ehp_day_start,
      :hitpoints_ehp_day_max,
      :hitpoints_xp_week_start,
      :hitpoints_xp_week_max,
      :hitpoints_ehp_week_start,
      :hitpoints_ehp_week_max,
      :hitpoints_xp_month_start,
      :hitpoints_xp_month_max,
      :hitpoints_ehp_month_start,
      :hitpoints_ehp_month_max,
      :hitpoints_xp_year_start,
      :hitpoints_xp_year_max,
      :hitpoints_ehp_year_start,
      :hitpoints_ehp_year_max,
      :ranged_xp_day_start,
      :ranged_xp_day_max,
      :ranged_ehp_day_start,
      :ranged_ehp_day_max,
      :ranged_xp_week_start,
      :ranged_xp_week_max,
      :ranged_ehp_week_start,
      :ranged_ehp_week_max,
      :ranged_xp_month_start,
      :ranged_xp_month_max,
      :ranged_ehp_month_start,
      :ranged_ehp_month_max,
      :ranged_xp_year_start,
      :ranged_xp_year_max,
      :ranged_ehp_year_start,
      :ranged_ehp_year_max,
      :prayer_xp_day_start,
      :prayer_xp_day_max,
      :prayer_ehp_day_start,
      :prayer_ehp_day_max,
      :prayer_xp_week_start,
      :prayer_xp_week_max,
      :prayer_ehp_week_start,
      :prayer_ehp_week_max,
      :prayer_xp_month_start,
      :prayer_xp_month_max,
      :prayer_ehp_month_start,
      :prayer_ehp_month_max,
      :prayer_xp_year_start,
      :prayer_xp_year_max,
      :prayer_ehp_year_start,
      :prayer_ehp_year_max,
      :magic_xp_day_start,
      :magic_xp_day_max,
      :magic_ehp_day_start,
      :magic_ehp_day_max,
      :magic_xp_week_start,
      :magic_xp_week_max,
      :magic_ehp_week_start,
      :magic_ehp_week_max,
      :magic_xp_month_start,
      :magic_xp_month_max,
      :magic_ehp_month_start,
      :magic_ehp_month_max,
      :magic_xp_year_start,
      :magic_xp_year_max,
      :magic_ehp_year_start,
      :magic_ehp_year_max,
      :cooking_xp_day_start,
      :cooking_xp_day_max,
      :cooking_ehp_day_start,
      :cooking_ehp_day_max,
      :cooking_xp_week_start,
      :cooking_xp_week_max,
      :cooking_ehp_week_start,
      :cooking_ehp_week_max,
      :cooking_xp_month_start,
      :cooking_xp_month_max,
      :cooking_ehp_month_start,
      :cooking_ehp_month_max,
      :cooking_xp_year_start,
      :cooking_xp_year_max,
      :cooking_ehp_year_start,
      :cooking_ehp_year_max,
      :woodcutting_xp_day_start,
      :woodcutting_xp_day_max,
      :woodcutting_ehp_day_start,
      :woodcutting_ehp_day_max,
      :woodcutting_xp_week_start,
      :woodcutting_xp_week_max,
      :woodcutting_ehp_week_start,
      :woodcutting_ehp_week_max,
      :woodcutting_xp_month_start,
      :woodcutting_xp_month_max,
      :woodcutting_ehp_month_start,
      :woodcutting_ehp_month_max,
      :woodcutting_xp_year_start,
      :woodcutting_xp_year_max,
      :woodcutting_ehp_year_start,
      :woodcutting_ehp_year_max,
      :fishing_xp_day_start,
      :fishing_xp_day_max,
      :fishing_ehp_day_start,
      :fishing_ehp_day_max,
      :fishing_xp_week_start,
      :fishing_xp_week_max,
      :fishing_ehp_week_start,
      :fishing_ehp_week_max,
      :fishing_xp_month_start,
      :fishing_xp_month_max,
      :fishing_ehp_month_start,
      :fishing_ehp_month_max,
      :fishing_xp_year_start,
      :fishing_xp_year_max,
      :fishing_ehp_year_start,
      :fishing_ehp_year_max,
      :firemaking_xp_day_start,
      :firemaking_xp_day_max,
      :firemaking_ehp_day_start,
      :firemaking_ehp_day_max,
      :firemaking_xp_week_start,
      :firemaking_xp_week_max,
      :firemaking_ehp_week_start,
      :firemaking_ehp_week_max,
      :firemaking_xp_month_start,
      :firemaking_xp_month_max,
      :firemaking_ehp_month_start,
      :firemaking_ehp_month_max,
      :firemaking_xp_year_start,
      :firemaking_xp_year_max,
      :firemaking_ehp_year_start,
      :firemaking_ehp_year_max,
      :crafting_xp_day_start,
      :crafting_xp_day_max,
      :crafting_ehp_day_start,
      :crafting_ehp_day_max,
      :crafting_xp_week_start,
      :crafting_xp_week_max,
      :crafting_ehp_week_start,
      :crafting_ehp_week_max,
      :crafting_xp_month_start,
      :crafting_xp_month_max,
      :crafting_ehp_month_start,
      :crafting_ehp_month_max,
      :crafting_xp_year_start,
      :crafting_xp_year_max,
      :crafting_ehp_year_start,
      :crafting_ehp_year_max,
      :smithing_xp_day_start,
      :smithing_xp_day_max,
      :smithing_ehp_day_start,
      :smithing_ehp_day_max,
      :smithing_xp_week_start,
      :smithing_xp_week_max,
      :smithing_ehp_week_start,
      :smithing_ehp_week_max,
      :smithing_xp_month_start,
      :smithing_xp_month_max,
      :smithing_ehp_month_start,
      :smithing_ehp_month_max,
      :smithing_xp_year_start,
      :smithing_xp_year_max,
      :smithing_ehp_year_start,
      :smithing_ehp_year_max,
      :mining_xp_day_start,
      :mining_xp_day_max,
      :mining_ehp_day_start,
      :mining_ehp_day_max,
      :mining_xp_week_start,
      :mining_xp_week_max,
      :mining_ehp_week_start,
      :mining_ehp_week_max,
      :mining_xp_month_start,
      :mining_xp_month_max,
      :mining_ehp_month_start,
      :mining_ehp_month_max,
      :mining_xp_year_start,
      :mining_xp_year_max,
      :mining_ehp_year_start,
      :mining_ehp_year_max,
      :runecraft_xp_day_start,
      :runecraft_xp_day_max,
      :runecraft_ehp_day_start,
      :runecraft_ehp_day_max,
      :runecraft_xp_week_start,
      :runecraft_xp_week_max,
      :runecraft_ehp_week_start,
      :runecraft_ehp_week_max,
      :runecraft_xp_month_start,
      :runecraft_xp_month_max,
      :runecraft_ehp_month_start,
      :runecraft_ehp_month_max,
      :runecraft_xp_year_start,
      :runecraft_xp_year_max,
      :runecraft_ehp_year_start,
      :runecraft_ehp_year_max,
      :overall_xp_day_start,
      :overall_xp_day_max,
      :overall_ehp_day_start,
      :overall_ehp_day_max,
      :overall_xp_week_start,
      :overall_xp_week_max,
      :overall_ehp_week_start,
      :overall_ehp_week_max,
      :overall_xp_month_start,
      :overall_xp_month_max,
      :overall_ehp_month_start,
      :overall_ehp_month_max,
      :overall_xp_year_start,
      :overall_xp_year_max,
      :overall_ehp_year_start,
      :overall_ehp_year_max
      )
  end
end
