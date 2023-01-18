require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  def set_default_description
    @default_description = 'F2P.wiki is an open source Old School RuneScape hiscores for Free-to-play players. It also includes EHP tracking, information about meta changes, and various F2P Old School RuneScape tools.'
  end
  before_action :set_default_description

  def search_player_if_needed
    if params[:search]
      name = Player.sanitize_name(params[:search])
      @player = Player.find_player(name)
      if @player
        redirect_to "/players/#{@player.player_name.gsub(" ", "_").encode("ASCII", invalid: :replace, undef: :replace, replace: '_')}"
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

      case result
      when nil
        redirect_to ranks_path, notice: "Player hiscores not found."
      when 'exists'
        redirect_to "/players/#{name.gsub(" ", "_")}", notice: "The player you wish to add already exists."
      when 'p2p'
        redirect_to ranks_path, notice: "The player you wish to add is not a free to play account."
      when 'cutoff'
        redirect_to ranks_path, notice: "The player you wish to add does not meet the EHP requirement."
      when 'failed'
        redirect_to ranks_path, notice: 'Unable to fetch player hiscores.'
      else
        redirect_to result, notice: "Player added successfully."
      end
    end
  end

  def tracking
    search_player_if_needed
    create_player_if_needed

    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions] || {}
    @skill = params[:skill] || session[:skill] || {}
    unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    @time = params[:time] || session[:time] || "week"
    @clear_filters = params[:clear_filters]
    @clan_filters = params[:clans_] || session[:clans_] || {}

    if @clear_filters
      @sort_by = {}
      @filters = {}
      @restrictions = {}
      @skill = {}
      @show_limit = 100
      @clan_filters = {}
    end

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

    if @clan_filters == {}
      @clan_filters = Clan.all.map{ |c| {"#{c.name}": 1} }.reduce(:merge)
      @clan_filters["None"] = 1
      params[:clans_] = @clan_filters
      session[:clans_] = @clan_filters
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

    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions] != session[:restrictions] || params[:time] != session[:time] || params[:clans_] != session[:clans_]
      session[:filters_] = @filters
      session[:restrictions] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
      session[:time] = @time
      session[:clans_] = @clan_filters
    end

    case @sort_by
    when "ehp"
      @player_ehp_header = 'hilite'
      ordering = "#{@skill}_ehp - #{@skill}_ehp_#{@time}_start DESC, #{@skill}_xp - #{@skill}_xp_#{@time}_start DESC, #{@skill}_ehp DESC, #{@skill}_xp DESC, players.id ASC"
    when "xp"
      @player_xp_header = 'hilite'
      ordering = "#{@skill}_xp - #{@skill}_xp_#{@time}_start DESC, #{@skill}_ehp - #{@skill}_ehp_#{@time}_start DESC, #{@skill}_xp DESC"
    end

    @players = Player.limit(@show_limit.to_i).where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").where(player_acc_type: @filters.keys).where("overall_ehp_day_start > 0").order(Arel.sql(ordering))

    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10).where("combat_lvl >= 4")
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1).where("combat_lvl >= 4")
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4").where("overall_lvl <= 816")
    end

    clan_filter_clause = @clan_filters.keys
    clan_filter_clause += [nil] if @clan_filters["None"]


    # clan filter breaks page for some reason
    #@players = @players.left_joins(:clans).merge(Clan.where(name: clan_filter_clause)).distinct.where("potential_p2p <= 0").where("overall_ehp > 1").paginate(:page => params[:page], :per_page => @show_limit.to_i)
    @players = @players.where("potential_p2p <= 0").where("overall_ehp > 1").paginate(:page => params[:page], :per_page => @show_limit.to_i)
  end

  def records
    search_player_if_needed
    create_player_if_needed

    Time.zone = "Pacific Time (US & Canada)"
    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions] || {}
    @skill = params[:skill] || session[:skill] || {}
    unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    @time = params[:time] || session[:time] || "week"

    @clear_filters = params[:clear_filters]
    @clan_filters = params[:clans_] || session[:clans_] || {}

    if @clear_filters
      @sort_by = {}
      @filters = {}
      @restrictions = {}
      @skill = {}
      @show_limit = 100
      @clan_filters = {}
    end

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

    if @clan_filters == {}
      @clan_filters = Clan.all.map{ |c| {"#{c.name}": 1} }.reduce(:merge)
      @clan_filters["None"] = 1
      params[:clans_] = @clan_filters
      session[:clans_] = @clan_filters
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

    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions] != session[:restrictions] || params[:time] != session[:time] || params[:clans_] != session[:clans_]
      session[:filters_] = @filters
      session[:restrictions] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
      session[:time] = @time
      session[:clans_] = @clan_filters
    end

    case @sort_by
    when "ehp"
      @player_ehp_header = 'hilite'
      ordering = "#{@skill}_ehp_#{@time}_max DESC, #{@skill}_xp_#{@time}_max DESC, #{@skill}_ehp DESC, #{@skill}_xp DESC, players.id ASC"
    when "xp"
      @player_xp_header = 'hilite'
      ordering = "#{@skill}_xp_#{@time}_max DESC, #{@skill}_ehp_#{@time}_max DESC, #{@skill}_xp DESC"
    end

    clan_filter_clause = @clan_filters.keys
    clan_filter_clause += [nil] if @clan_filters["None"]

    @players = Player.limit(@show_limit.to_i).left_joins(:clans).merge(Clan.where(name: clan_filter_clause)).distinct.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").where(player_acc_type: @filters.keys).where("overall_ehp_day_max > 0").order(Arel.sql(ordering))

    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10).where("combat_lvl >= 4")
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1).where("combat_lvl >= 4")
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4").where("overall_lvl <= 816")
    end

    @players = @players.where("overall_ehp > 1 and potential_p2p <= 0").paginate(:page => params[:page], :per_page => @show_limit.to_i)
  end

  def ranks
    search_player_if_needed
    create_player_if_needed

    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions] || {}
    @skill = params[:skill] || session[:skill] || {}
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    @show_limit = [@show_limit.to_i, 500].min
    @clear_filters = params[:clear_filters]
    @filter_inactive = params[:filter_inactive] || session[:filter_inactive] || "false"
    @clan_filters = params[:clans_] || session[:clans_] || {}

    if @clear_filters
      @sort_by = {}
      @filters = {}
      @restrictions = {}
      @skill = {}
      @show_limit = 100
      @filter_inactive = "false"
      @clan_filters = {}
    end

    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end

    if @clan_filters == {}
      @clan_filters = Clan.all.map{ |c| {"#{c.name}": 1} }.reduce(:merge)
      if @clan_filters == nil
        @clan_filters = {}
      end
      @clan_filters["None"] = 1
      params[:clans_] = @clan_filters
      session[:clans_] = @clan_filters
    end

    if params[:player1] and params[:player2]
      compare
    end

    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end 

    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions] != session[:restrictions] || params[:filter_inactive] != session[:filter_inactive] || params[:clans_] != session[:clans_]
      session[:filters_] = @filters
      session[:restrictions] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
      session[:filter_inactive] = @filter_inactive
      session[:clans_] = @clan_filters
    end

    # Sort some skills by xp not ehp as ehp is mostly 0
    @skills_by_xp = ['magic', 'mining']
    if @sort_by == {} && @skills_by_xp.include?(@skill)
      @sort_by = "xp"
    elsif @sort_by == {}
      @sort_by = "ehp"
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
      # when "clues_all"
      #   ordering = "clues_all DESC, players.id ASC"
      when "clues_beginner"
        ordering = "clues_beginner DESC, players.id ASC"
      end
    elsif @skill.include?("no_combats")
      ordering = "overall_ehp DESC"
    elsif @skill.include?("count")
      ordering = "overall_ehp DESC"
    elsif @skill.include?("lowest_lvl")
      ordering = "overall_ehp DESC"
    elsif @skill.include?("lms")
      ordering = "lms_score DESC, lms_rank ASC"
    elsif @skill.include?("_kc")
      ordering = "#{@skill} DESC, #{@skill}_rank ASC"
    else
      case @sort_by
      when "ehp"
        @player_ehp_header = 'hilite'
        ordering = "#{@skill}_ehp DESC, #{@skill}_lvl DESC, #{@skill}_xp DESC, #{@skill}_rank ASC, players.id ASC"
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

    clan_filter_clause = @clan_filters.keys
    clan_filter_clause += [nil] if @clan_filters["None"]

    @players = Player.left_joins(:clans).merge(Clan.where(name: clan_filter_clause)).distinct.where(player_acc_type: @filters.keys).order(Arel.sql(ordering))

    if @skill.include?("ttm")
      @players = @players.where("ttm_lvl != 0 or ttm_xp != 0 or overall_ehp > 1000")
    end

    if @restrictions["10 hitpoints"]
      @players = @players.where(hitpoints_lvl: 10).where("combat_lvl >= 4")
    end
    if @restrictions["1 defence"]
      @players = @players.where(defence_lvl: 1).where("combat_lvl >= 4")
    end
    if @restrictions["3 combat"]
      @players = @players.where("combat_lvl < 4").where("overall_lvl <= 816")
    end
    if @skill == "combat"
      @players = @players.where("combat_lvl IS NOT NULL")
    end

    if @filter_inactive == "true"
      @players = @players.where("(overall_xp - overall_xp_month_start) > 0")
    end

    @players = @players.where("potential_p2p <= 0")

    if @skill.include?("99_count")
      @players = @players.sort_by {|player| [player.count_99, player.overall_ehp] }.reverse
    elsif @skill.include?("200m_count")
      @players = @players.sort_by {|player| [player.count_200m, player.overall_ehp] }.reverse
    elsif @skill.include?("lowest_lvl")
      @players = @players.sort_by {|player| [player.lowest_lvl, player.overall_ehp] }.reverse
    elsif @skill.include?("no_combats")
      case @sort_by
      when "ehp"
        @players = @players.sort_by {|player| [player.fishing_ehp + player.cooking_ehp + player.woodcutting_ehp + player.firemaking_ehp + player.mining_ehp + player.smithing_ehp + player.crafting_ehp + player.runecraft_ehp, player.overall_ehp] }.reverse
      when "lvl"
        @players = @players.sort_by {|player| [player.fishing_lvl + player.cooking_lvl + player.woodcutting_lvl + player.firemaking_lvl + player.mining_lvl + player.smithing_lvl + player.crafting_lvl + player.runecraft_lvl, player.fishing_ehp + player.cooking_ehp + player.woodcutting_ehp + player.firemaking_ehp + player.mining_ehp + player.smithing_ehp + player.crafting_ehp + player.runecraft_ehp, player.overall_ehp] }.reverse
      when "xp"
        @players = @players.sort_by {|player| [player.fishing_xp + player.cooking_xp + player.woodcutting_xp + player.firemaking_xp + player.mining_xp + player.smithing_xp + player.crafting_xp + player.runecraft_xp, player.fishing_ehp + player.cooking_ehp + player.woodcutting_ehp + player.firemaking_ehp + player.mining_ehp + player.smithing_ehp + player.crafting_ehp + player.runecraft_ehp, player.overall_ehp] }.reverse
      end
    end

    if @skill == "obor_kc"
      @players = @players.where("obor_kc > 0")
    elsif @skill == "bryo_kc"
      @players = @players.where("bryo_kc > 0")
    end

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
    # If updated less than a minute ago
    if (@player.updated_at > 1.minutes.ago)
      redirect_to player_path(@player.player_name),
        notice: "Updating too quickly. Please try again in a minute"
    elsif @player.update_player
      redirect_to player_path(@player.player_name)
    else
      redirect_to player_path(@player.player_name),
        notice: "Player #{@player.player_name} could not be updated. Please try again."
    end
  end

  def update_player
    @player.update_player
    @player
  end

  def check_acc_type
    name = Player.sanitize_name(params[:id])
    @player = Player.find_player(name)

    if @player.force_update_acc_type
      redirect_to player_path(@player.player_name)
    else
      redirect_to player_path(@player.player_name),
        notice: "Player #{@player.player_name} could not be updated. Please try again."
    end
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
