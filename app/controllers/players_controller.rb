require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players
  # GET /players.json
  def plaintextcomp
    competitions
  end
  
  def test
    competitions
  end
  
  def competitions
    @comp_filters = params[:comp_filters_] || session[:comp_filters_] || {}
    @comp_show_limit = params[:comp_show_limit] || session[:comp_show_limit] || 100
    
    if @comp_filters == {}
      @comp_filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:comp_filters_] = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      session[:comp_filters_] = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
    end
    
    if params[:comp_filters_] != session[:comp_filters_] || params[:comp_show_limit] != session[:comp_show_limit] 
      session[:comp_filters_] = @comp_filters
      session[:comp_show_limit] = @comp_show_limit
    end
    
    enddatetime = Time.new(2018, 7, 1)
    hours = ((enddatetime - Time.now) / 3600).to_i
    mins = ((((enddatetime - Time.now) / 3600) - hours) * 60).round
  
    if hours > 168 or (hours == 168 and mins > 0)
      ordering = "overall_ehp DESC" 
    elsif hours < 0 or (hours == 0 and mins < 0)
      ordering = "woodcutting_ehp_end - woodcutting_ehp_start + fishing_ehp_end - fishing_ehp_start + mining_ehp_end - mining_ehp_start + firemaking_ehp_end - firemaking_ehp_start + cooking_ehp_end - cooking_ehp_start DESC, overall_ehp DESC" 
    else
      ordering = "woodcutting_ehp - woodcutting_ehp_start + fishing_ehp - fishing_ehp_start + mining_ehp - mining_ehp_start + firemaking_ehp - firemaking_ehp_start + cooking_ehp - cooking_ehp_start DESC, overall_ehp DESC" 
    end

    @comp_players = Player.limit(@comp_show_limit.to_i).where(player_acc_type: @comp_filters.keys).order(ordering)
    @comp_players = @comp_players.where("woodcutting_ehp_end - woodcutting_ehp_start + fishing_ehp_end - fishing_ehp_start + mining_ehp_end - mining_ehp_start + firemaking_ehp_end - firemaking_ehp_start + cooking_ehp_end - cooking_ehp_start > 1").paginate(:page => params[:page], :per_page => @comp_show_limit.to_i)
  
  end
  
  def tracking
    ranks
  end
  
  def ranks
    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @restrictions = params[:restrictions_] || {}
    @skill = params[:skill] || session[:skill] || {}
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end
    
    if params[:search]
      @player = Player.find_player(params[:search])
      if @player 
        name = @player.player_name.gsub(" ", "_")
        redirect_to "/players/#{name}"
      else
        redirect_to ranks_path, notice: 'Player not found.'
      end
      return
    end 
    
    if params[:player1] and params[:player2]
      compare
    end
    
    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    
    if !params[:player_to_add_name].nil? and params[:player_to_add_name] != "" 
      name = Player.clean_trailing_leading_spaces(params[:player_to_add_name])
      params[:player_to_add_name] = nil
      session[:player_to_add_name] = nil
      
      found = Player.find_player(name)
      if found
        redirect_to "/players/#{found.player_name.gsub(" ", "_")}", notice: 'The player you wish to add already exists.'
        return
      elsif F2POSRSRanks::Application.config.downcase_fakes.include?(name.downcase)
        redirect_to ranks_path, notice: 'The player you wish to add is not a free to play account.'
        return
      end
      
      acc_type = determine_acc_type(name)
      if acc_type.nil?
        redirect_to ranks_path, notice: "Player hiscores not found."
        return 
      end
      Player.create!({ player_name: name, 'player_acc_type': acc_type})
      player = Player.find_player(name)
      
      result = player.update_player
      
      if result == "p2p"
        redirect_to ranks_path, notice: "The player you wish to add is not a free to play account."
        return
      elsif result == "cutoff"
        redirect_to ranks_path, notice: "The player you wish to add does not meet the EHP requirement."
        return
      end
      
      #player.update_attribute(:overall_ehp_start, player['overall_ehp'].to_f)
      player.update_attribute(:mining_ehp_start, player['mining_ehp'].to_f)
      player.update_attribute(:fishing_ehp_start, player['fishing_ehp'].to_f)
      player.update_attribute(:woodcutting_ehp_start, player['woodcutting_ehp'].to_f)
      player.update_attribute(:firemaking_ehp_start, player['firemaking_ehp'].to_f)
      player.update_attribute(:cooking_ehp_start, player['cooking_ehp'].to_f)
      
      redirect_to player, notice: 'Player added successfully.'
    end
    
    if @sort_by == {}
      @sort_by = "ehp"
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] || params[:restrictions] != session[:restrictions] 
      session[:filters_] = @filters
      session[:restrictions_] = @restrictions
      session[:skill] = @skill
      session[:sort_by] = @sort_by
      session[:show_limit] = @show_limit
    end
    
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
    
    
    @players = Player.limit(@show_limit.to_i).where(player_acc_type: @filters.keys).order(ordering)
    
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
    
    @players = @players.where("overall_ehp > 1").paginate(:page => params[:page], :per_page => @show_limit.to_i)
  end
  
  # GET /players/1
  # GET /players/1.json
  def show
    id = params[:search] || params[:id]
    @player = Player.find_player(id)
  end
  
  def compare
    @player1 = Player.find_player(params[:player1])
    @player2 = Player.find_player(params[:player2])
    if @player1 == false or @player2 == false
      redirect_to ranks_path, notice: "Players not found."
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
  
  def get_stats(name, acc_type)
    if name == "Bargan"
      all_stats = "-1,1410,143408971 -1,99,13078967 -1,99,13068172 -1,99,13069431 -1,99,14171944 -1,85,3338143 -1,82,2458698 -1,99,13065371 -1,99,14018193 -1,91,6111148 -1,-1,0 -1,92,6557350 -1,99,14021572 -1,99,13074360 -1,99,13182234 -1,81,2195415 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,80,1997973 -1,-1,0 -1,-1,0 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1".split(" ")
    else
      begin
        case acc_type
        when "Reg"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{name}")
        when "HCIM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{name}")
        when "UIM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ultimate/index_lite.ws?player=#{name}")
        when "IM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{name}")
        end
        all_stats = uri.read.split(" ")
      rescue Exception => e  
        puts e.message
        return false
      end
    end
    return all_stats
  end
  

  def acc_type_xp(name, acc_type)
    stats = get_stats(name, acc_type)
    return 0 if not stats
    return stats[0].split(",")[2].to_f
  end
  
  def determine_acc_type(name)
    uim_xp = acc_type_xp(name, "UIM")
    hcim_xp = acc_type_xp(name, "HCIM")
    im_xp = acc_type_xp(name, "IM")
    reg_xp = acc_type_xp(name, "Reg")
    if uim_xp > 0 and uim_xp >= reg_xp and uim_xp >= im_xp
      return "UIM"
    elsif hcim_xp > 0 and hcim_xp >= reg_xp and hcim_xp >= im_xp
      return "HCIM"
    elsif im_xp > 0 and im_xp >= reg_xp
      return "IM"
    elsif reg_xp > 0 
      return "Reg"
    else
      raise("Account type cannot be determined.")
    end
  end
  
  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    @player.update_player
    @player
  end
  
  def update_player
    @player.update_player
    @player
  end
  
  def ehp_start
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          #player.update_attribute(:overall_ehp_start, player['overall_ehp'].to_f)
          player.update_attribute(:mining_ehp_start, player['mining_ehp'].to_f)
          player.update_attribute(:fishing_ehp_start, player['fishing_ehp'].to_f)
          player.update_attribute(:woodcutting_ehp_start, player['woodcutting_ehp'].to_f)
          player.update_attribute(:firemaking_ehp_start, player['firemaking_ehp'].to_f)
          player.update_attribute(:cooking_ehp_start, player['cooking_ehp'].to_f)
        rescue
          next
        end
      end
    end
  end
  
  def ehp_end
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          #player.update_attribute(:overall_ehp_end, player['overall_ehp'].to_f)
          player.update_attribute(:mining_ehp_end, player['mining_ehp'].to_f)
          player.update_attribute(:fishing_ehp_end, player['fishing_ehp'].to_f)
          player.update_attribute(:woodcutting_ehp_end, player['woodcutting_ehp'].to_f)
          player.update_attribute(:firemaking_ehp_end, player['firemaking_ehp'].to_f)
          player.update_attribute(:cooking_ehp_end, player['cooking_ehp'].to_f)
        rescue
          next
        end
      end
    end
  end
  
  def ehp_reset
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_attribute(:overall_ehp_start, 0.0)
        rescue
          next
        end
      end
    end
  end
  
  def refresh_players
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        if F2POSRSRanks::Application.config.downcase_fakes.include?(player.player_name.downcase)
          Player.where(player_name: player.player_name).destroy_all
          next
        end
        name = player.player_name.gsub(" ", "_")
        puts name
        begin
          all_stats = get_stats(name, player.player_acc_type)
          if all_stats == false
            Player.where(player_name: @player.player_name).destroy_all
            next
          end
          ehp = get_ehp_type(player)
          calc_ehp(player, all_stats, ehp)
          calc_combat(player)
          remove_cutoff(player)
        rescue
          next
        end
      end
    end
    redirect_to ranks_path, notice: 'All players were successfully updated.'
  end
  
  def refresh_250
    Player.where("overall_ehp > 200").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        if F2POSRSRanks::Application.config.downcase_fakes.include?(player.player_name.downcase)
          Player.where(player_name: player.player_name).destroy_all
          next
        end
        name = player.player_name.gsub(" ", "_")
        puts name
        begin
          all_stats = get_stats(name, player.player_acc_type)
          if all_stats == false
            next
          end
          ehp = get_ehp_type(player)
          calc_ehp(player, all_stats, ehp)
          calc_combat(player)
          remove_cutoff(player)
        rescue
          next
        end
      end
    end
    redirect_to ranks_path, notice: 'All players were successfully updated.'
  end
  
  # not working; URI.parse broken
  def find_new
    hc_start = "59"
    hc_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/a=13/overall.ws?table=0&page=#{hc_start}")
    
    #uim_start = "21"
    #uim_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ultimate/a=13/overall.ws?table=0&page=#{uim_start}")
    
    #iron_start = "773"
    #iron_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/a=13/overall.ws?table=0&page=#{iron_start}")
    
    #reg_start = "8976"
    #reg_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool/a=13/overall.ws?table=0&page=#{reg_start}")

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
    flash[:notice] = open("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/a=13/overall.ws?table=0&page=#{hc_start}").read.truncate(1250)
    redirect_to players_path
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
      :overall_ehp_start,
      :overall_ehp_end,
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
      :cooking_ehp_start, 
      :cooking_ehp_end, 
      :woodcutting_xp, 
      :woodcutting_lvl, 
      :woodcutting_ehp, 
      :woodcutting_rank, 
      :woodcutting_ehp_start, 
      :woodcutting_ehp_end, 
      :fishing_xp, 
      :fishing_lvl, 
      :fishing_ehp, 
      :fishing_rank, 
      :fishing_ehp_start, 
      :fishing_ehp_end, 
      :firemaking_xp, 
      :firemaking_lvl, 
      :firemaking_ehp, 
      :firemaking_rank, 
      :firemaking_ehp_start, 
      :firemaking_ehp_end, 
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
      :mining_ehp_start, 
      :mining_ehp_end, 
      :runecraft_xp, 
      :runecraft_lvl, 
      :runecraft_ehp,
      :runecraft_rank,
      :potential_p2p,
      :combat_lvl
      )
  end
end
