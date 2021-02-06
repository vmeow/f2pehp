require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'

class ClansController < ApplicationController
  before_action :set_clan, only: %i[show edit update destroy]
  before_action :http_basic_auth, only: [:admin, :add_player_to_clan, :add_many_players_to_clan]

  def http_basic_auth
    if ENV['HTTP_AUTH_USER'] && ENV['HTTP_AUTH_PASS']
      self.class.http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASS']
    else
      self.class.http_basic_authenticate_with :name => "admin", :password => "admin"
    end
  end

  def admin
    @clan = params[:name]
  end

  def add_player_to_clan

    player = Player.find_player(params[:player_name])
    clan_name = params[:id]
    clan_id = Clan.find_clan(clan_name).id
    if player
        player.update_attributes(:clan_id=>clan_id)
        redirect_to clan_admin_path, notice: "#{player.player_name}'s clan has been updated to #{clan_name}."
    else
        redirect_to clan_admin_path, notice: "Could not find player #{@name}."
    end
  end

  def add_many_players_to_clan
    if ENV['HTTP_AUTH_USER'] && ENV['HTTP_AUTH_PASS']
      self.class.http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASS']
    else
      self.class.http_basic_authenticate_with :name => "admin", :password => "admin"
    end

    clan_name = params[:id]
    clan_id = Clan.find_clan(clan_name).id

    updated_players = []
    failed_players = []

    player_names = params[:player_names].split(",")
    if player_names.size > 100
        redirect_to(clan_admin_path, notice: "Too many players. Please try again with fewer than 100 players.")
        return
    end

    player_names.each do |player_name|
        player = Player.find_player(player_name)
        if player
            player.update_attributes(:clan_id=>clan_id)
            updated_players += [player.player_name]
        else
            failed_players += [player_name]
        end
    end

    notice_msg =  "The following players have their clan updated to #{clan_name}: #{updated_players}"
    notice_msg += "\nPlayers failed to be found: #{failed_players}"

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
    @clear_filters = params[:clear_filters]

    if @clear_filters
      @sort_by = {}
      @skill = {}
    end

    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
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
        ordering = "clues_all DESC, id ASC"
      when "clues_beginner"
        ordering = "clues_beginner DESC, id ASC"
      end
    elsif @skill.include?("no_combats")
      case @sort_by
      when "ehp"
        ordering = "fishing_ehp + cooking_ehp + woodcutting_ehp + firemaking_ehp + mining_ehp + smithing_ehp + crafting_ehp + runecraft_ehp DESC"
      when "lvl"
        ordering = "fishing_lvl + cooking_lvl + woodcutting_lvl + firemaking_lvl + mining_lvl + smithing_lvl + crafting_lvl + runecraft_lvl DESC, fishing_ehp + cooking_ehp + woodcutting_ehp + firemaking_ehp + mining_ehp + smithing_ehp + crafting_ehp + runecraft_ehp DESC, fishing_xp + cooking_xp + woodcutting_xp + firemaking_xp + mining_xp + smithing_xp + crafting_xp + runecraft_xp DESC"
      when "xp"
        ordering = "fishing_xp + cooking_xp + woodcutting_xp + firemaking_xp + mining_xp + smithing_xp + crafting_xp + runecraft_xp DESC, fishing_ehp + cooking_ehp + woodcutting_ehp + firemaking_ehp + mining_ehp + smithing_ehp + crafting_ehp + runecraft_ehp DESC, fishing_lvl + cooking_lvl + woodcutting_lvl + firemaking_lvl + mining_lvl + smithing_lvl + crafting_lvl + runecraft_lvl DESC"
      end
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
        ordering = "#{@skill}_ehp DESC, #{@skill}_lvl DESC, #{@skill}_xp DESC, #{@skill}_rank ASC, id ASC"
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

    @players = @clan.players
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
    else
      @players = @players.order(ordering)
    end

    @clan
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