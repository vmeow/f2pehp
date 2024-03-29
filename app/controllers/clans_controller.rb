require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'

class ClansController < ApplicationController
  before_action :set_clan, only: %i[show edit update destroy]

  def admin
    @clan = params[:id]
  end

  def add_player_to_clan
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    player = Player.find_player(params[:player_name])

    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
    elsif player and clan.players.pluck(:player_id).include?(player.id)
      redirect_to clan_admin_path, notice: "#{player.player_name} is already in #{clan_name.gsub("_", " ")}."
    elsif player
      clan.add_player(player)
      redirect_to clan_admin_path, notice: "#{player.player_name} added to #{clan_name.gsub("_", " ")}."
    else
      redirect_to clan_admin_path, notice: "Could not find player #{params[:player_name]}."
    end
  end

  def add_many_players_to_clan
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    updated_players = []
    failed_players = []
    redundant_players = []

    player_names = params[:player_names].split(",")
    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
      return
    elsif player_names.size > 100
      redirect_to(clan_admin_path, notice: "Too many players. Please try again with fewer than 100 players.")
      return
    end

    player_names.each do |player_name|
      player = Player.find_player(player_name)
      if player and clan.players.pluck(:player_id).include?(player.id)
        redundant_players += [player.player_name]
      elsif player
        clan.add_player(player)
        updated_players += [player.player_name]
      else
        failed_players += [player_name]
      end
    end

    notice_msg =  "Players added to #{clan_name.gsub("_", " ")}: #{updated_players}"
    notice_msg += "\nPlayers not found: #{failed_players}"
    notice_msg += "\nPlayers already in #{clan_name.gsub("_", " ")}: #{redundant_players}"

    redirect_to clan_admin_path, notice: notice_msg
  end

  def remove_player_from_clan
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    player = Player.find_player(params[:player_name])

    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
    elsif player and clan.players.pluck(:player_id).include?(player.id)
      clan.remove_player(player)
      redirect_to clan_admin_path, notice: "#{player.player_name} removed from #{clan_name.gsub("_", " ")}."
    else
      redirect_to clan_admin_path, notice: "Player #{params[:player_name]} not found, or not in #{clan_name.gsub("_", " ")}."
    end
  end

  def remove_many_players_from_clan
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    updated_players = []
    failed_players = []

    player_names = params[:player_names].split(",")
    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
      return
    elsif player_names.size > 100
      redirect_to(clan_admin_path, notice: "Too many players. Please try again with fewer than 100 players.")
      return
    end

    player_names.each do |player_name|
      player = Player.find_player(player_name)
      if player and clan.players.pluck(:player_id).include?(player.id)
        clan.remove_player(player)
        updated_players += [player.player_name]
      else
        failed_players += [player_name]
      end
    end

    notice_msg =  "Players been removed from #{clan_name.gsub("_", " ")}: #{updated_players}"
    notice_msg += "\nPlayers not found, or are not in the clan: #{failed_players}"

    redirect_to clan_admin_path, notice: notice_msg
  end

  def set_default_description
    @default_description = 'F2P.wiki is an open source Old School RuneScape hiscores for Free-to-play players. It also includes EHP tracking, information about meta changes, and various F2P Old School RuneScape tools.'
  end
  before_action :set_default_description

  def index
    @clans = Clan.all
  end

  def show
    id = params[:search] || params[:id]
    @clan = Clan.find_clan(id)

    if not @clan
      redirect_to clans_path, notice: "Clan '#{id}' not found."
      return
    end

    @display = params[:display] || session[:display] || "stats"
    @time = params[:time] || session[:time] || "week"

    if params[:display] != session[:display] || params[:time] != session[:time]
      session[:display] = @display
      session[:time] = @time
    end

    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @skill = params[:skill] || session[:skill] || {}
    @filter_inactive = params[:filter_inactive] || session[:filter_inactive] || "false"
    @clear_filters = params[:clear_filters]

    if @clear_filters
      @sort_by = {}
      @skill = {}
      @filter_inactive = "false"
    end

    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end

    @display = params[:display] || session[:display] || "stats"
    @time = params[:time] || session[:time] || "week"

    if params[:display] != session[:display] || params[:time] != session[:time] || params[:filter_inactive] != session[:filter_inactive]
      session[:display] = @display
      session[:time] = @time
      session[:filter_inactive] = @filter_inactive
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

    if params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill]
      session[:skill] = @skill
      session[:sort_by] = @sort_by
    end

    # Sort some skills by xp not ehp as ehp is mostly 0
    @skills_by_xp = ['magic', 'mining']
    if @sort_by == {} && @skills_by_xp.include?(@skill)
      @sort_by = "xp"
    elsif @sort_by == {}
      @sort_by = "ehp"
    end

    if @display == "stats"
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
          # ordering = "clues_all DESC, players.id ASC"
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
    elsif @display == "gains"
      unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
        @skill = "overall"
        params[:skill] = "overall"
        session[:skill] = "overall"
      end

      case @sort_by
      when "ehp", "lvl"
        @sort_by = "ehp"
        @player_ehp_header = 'hilite'
        ordering = "#{@skill}_ehp - COALESCE(#{@skill}_ehp_#{@time}_start, 100000) DESC, #{@skill}_xp - COALESCE(#{@skill}_xp_#{@time}_start, 1000000000) DESC, #{@skill}_ehp DESC, #{@skill}_xp DESC, players.id ASC"
      when "xp"
        @player_xp_header = 'hilite'
        ordering = "#{@skill}_xp - COALESCE(#{@skill}_xp_#{@time}_start, 1000000000) DESC, #{@skill}_ehp - COALESCE(#{@skill}_ehp_#{@time}_start, 100000) DESC, #{@skill}_xp DESC"
      end
    elsif @display == "records"
      unless F2POSRSRanks::Application.config.f2p_skills.include?(@skill)
        @skill = "overall"
        params[:skill] = "overall"
        session[:skill] = "overall"
      end

      case @sort_by
      when "ehp", "lvl"
        @sort_by = "ehp"
        @player_ehp_header = 'hilite'
        ordering = "COALESCE(#{@skill}_ehp_#{@time}_max, -100000) DESC, COALESCE(#{@skill}_xp_#{@time}_max, -1000000000) DESC, #{@skill}_ehp DESC, #{@skill}_xp DESC, players.id ASC"
      when "xp"
        @player_xp_header = 'hilite'
        ordering = "COALESCE(#{@skill}_xp_#{@time}_max, -1000000000) DESC, COALESCE(#{@skill}_ehp_#{@time}_max, -100000) DESC, #{@skill}_xp DESC"
      end
    end

    if @sort_by == "player_name"
      ordering = "player_name ASC"
    end

    @players = @clan.players.where("potential_p2p <= 0")

    if @filter_inactive == "true"
      @players = @players.where("(overall_xp - overall_xp_month_start) > 0")
    end

    if @skill.include?("ttm")
      @players = @players.where("ttm_lvl != 0 or ttm_xp != 0 or overall_ehp > 1000")
    end
    if @skill == "combat"
      @players = @players.where("combat_lvl IS NOT NULL")
    end
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
    else
      @players = @players.order(Arel.sql(ordering))
    end

    @clan
  end

  def update_clan_description
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
    elsif params[:clan_description].size > 1000
      redirect_to clan_admin_path, notice: "Description is too long. Please limit to 1000 characters."
    else
      clan.update(:description => ActiveRecord::Base.sanitize_sql(params[:clan_description]))
      redirect_to clan_admin_path, notice: "Clan description updated successfully."
    end
  end

  def update_clan_link1
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
    elsif params[:link1].empty? or params[:link1_name].empty?
      redirect_to clan_admin_path, notice: "Link URL and label must not be empty."
    elsif !params[:link1].include?("http")
      redirect_to clan_admin_path, notice: "Sorry, the link URL must start with 'http' or 'https'."
    elsif params[:link1].size > 500 or params[:link1_name].size > 500
      redirect_to clan_admin_path, notice: "Link URL or label are invalid (too long). Please limit to 500 characters."
    else
      clan.update(:link1 => ActiveRecord::Base.sanitize_sql(params[:link1]), :link1_name => ActiveRecord::Base.sanitize_sql(params[:link1_name]))
      redirect_to clan_admin_path, notice: "Clan link updated successfully."
    end
  end

  def update_clan_link2
    clan_name = params[:id]
    clan = Clan.find_clan(clan_name)
    clan_id = clan.id

    if clan.pass != Digest::MD5.hexdigest(params[:pass])
      redirect_to(clan_admin_path, notice: "Incorrect password. Please try again.")
    elsif params[:link2].empty? or params[:link2_name].empty?
      redirect_to clan_admin_path, notice: "Link URL and label must not be empty."
    elsif !params[:link2].include?("http")
      redirect_to clan_admin_path, notice: "Sorry, the link URL must start with 'http' or 'https'."
    elsif params[:link2].size > 500 or params[:link2_name].size > 500
      redirect_to clan_admin_path, notice: "Link URL or label are invalid (too long). Please limit to 500 characters."
    else
      clan.update(:link2 => ActiveRecord::Base.sanitize_sql(params[:link2]), :link2_name => ActiveRecord::Base.sanitize_sql(params[:link2_name]))
      redirect_to clan_admin_path, notice: "Clan link updated successfully."
    end
  end

  def create
  end

  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clan
      show
    end

    def clan_params
      params.require(:clan).permit(:name)
    end
end
