require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'

class ClansController < ApplicationController
  before_action :set_clan, only: %i[show edit update destroy]

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
    @player = Clan.create!(clan_params)
    flash[:notice] = 'Clan was successfully created.'
    redirect_to clans_path
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
