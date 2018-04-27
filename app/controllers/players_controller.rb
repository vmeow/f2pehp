require 'net/http'
require 'uri'
require "open-uri"
require 'nokogiri'

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players
  # GET /players.json
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
          
    @comp_players = Player.limit(@comp_show_limit.to_i).where(player_acc_type: @comp_filters.keys).order("overall_ehp - overall_ehp_start DESC")
    @comp_players = @comp_players.where("overall_ehp > 75").paginate(:page => params[:page], :per_page => @comp_show_limit.to_i)
  
  end
  
  def tracking
    ranks
  end
  
  def ranks
    @sort_by = params[:sort_by] || session[:sort_by] || {}
    @filters = params[:filters_] || session[:filters_] || {}
    @skill = params[:skill] || session[:skill] || {}
    @show_limit = params[:show_limit] || session[:show_limit] || 100
    
    if @filters == {}
      @filters = {"Reg": 1, "IM": 1, "UIM": 1, "HCIM": 1}
      params[:filters_] = @filters
      session[:filters_] = @filters
    end
    
    if params[:search]
      params[:id] = params[:search]
      show
      if @player
        redirect_to @player
      else
        redirect_to ranks_path, notice: "Player not found."
      end
      return
    end 
    
    if params[:player1] and params[:player2]
      compare
      if @player1 and @player2
        redirect_to compare_path
      else
        redirect_to ranks_path, notice: "Players not found."
      end
      return
    end
    
    if @skill == {}
      @skill = "overall"
      params[:skill] = "overall"
      session[:skill] = "overall"
    end
    
    if !params[:player_to_add_name].nil? and !params[:player_to_add_acc].nil?
      name1 = params[:player_to_add_name].downcase
      while name1[-1] == " " or name1[-1] == "_"
        name1 = name1[0...-1]
      end
      name2 = name1.gsub(" ", "_")
      name3 = name1.gsub("_", " ")
      found1 = Player.where('lower(player_name) = ?', name1).first
      found2 = Player.where('lower(player_name) = ?', name2).first
      found3 = Player.where('lower(player_name) = ?', name3).first
      if found1
        redirect_to found1, notice: 'The player you wish to add already exists.'
        return
      elsif found2
        redirect_to found2, notice: 'The player you wish to add already exists.'
        return
      elsif found3
        redirect_to found3, notice: 'The player you wish to add already exists.'
        return
      end
      
      if F2POSRSRanks::Application.config.downcase_fakes.include?(params[:player_to_add_name].downcase)
        redirect_to ranks_path, notice: 'The player you wish to add is not a free to play account.'
        return
      end
      
      Player.create!({ player_name: params[:player_to_add_name], 'player_acc_type': params[:player_to_add_acc]})
      player = Player.where(player_name: params[:player_to_add_name]).first
      name = params[:player_to_add_name].gsub(" ", "_")
      puts name
      params[:player_to_add_name] = nil
      params[:player_to_add_acc] = nil
      session[:player_to_add_name] = nil
      session[:player_to_add_acc] = nil
      
      all_stats = get_stats(name, player.player_acc_type)
      if all_stats == false
        redirect_to ranks_path, notice: 'Invalid player name.'
        return
      end 
      ehp = get_ehp_type(player)
      calc_ehp(player, all_stats, ehp)
      if !Player.where('lower(player_name) = ?', name.downcase).first and !Player.where('lower(player_name) = ?', name1.downcase).first and !Player.where('lower(player_name) = ?', name2.downcase).first and !Player.where('lower(player_name) = ?', name3.downcase).first
        redirect_to ranks_path, notice: "The player you wish to add is not a free to play account."
        return
      end

      if remove_cutoff(player)
        redirect_to ranks_path, notice: 'The player you wish to add does not yet meet the 75 EHP requirement.'
      else
        redirect_to player, notice: 'Player added successfully.'
      end
    end
    
    if !params[:delete_player].nil?
      Player.where(player_name: params[:delete_player]).destroy_all
      params[:delete_player] = nil
      session[:delete_player] = nil
    end
    
    if @sort_by == {}
      @sort_by = "ehp"
    end
    
    if params[:filters_] != session[:filters_] || params[:sort_by] != session[:sort_by] || params[:skill] != session[:skill] || params[:show_limit] != session[:show_limit] 
      session[:filters_] = @filters
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
      ordering = "#{@skill}_lvl DESC, #{@skill}_xp DESC, #{@skill}_rank ASC"
    when "xp"
      @player_xp_header = 'hilite'
      ordering = "#{@skill}_xp DESC, #{@skill}_rank ASC"
    end
      
    @players = Player.limit(@show_limit.to_i).where(player_acc_type: @filters.keys).order(ordering)
    @players = @players.where("overall_ehp > 75").paginate(:page => params[:page], :per_page => @show_limit.to_i)
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
    @player = Player.where('lower(player_name) = ?', params[:id].downcase).first
    if @player.nil?
      name = params[:id].gsub("_", " ")
      @player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player.nil?
      name = params[:id].gsub(" ", "_")
      @player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player.nil?
      begin
        @player = Player.find(params[:id])
      rescue
        return
      end
    end
  end
  
  def compare
    @player1 = Player.where('lower(player_name) = ?', params[:player1].downcase).first
    if @player1.nil?
      name = params[:player1].gsub("_", " ")
      @player1 = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player1.nil?
      name = params[:player1].gsub(" ", "_")
      @player1 = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player1.nil?
      begin
        @player1 = Player.find(params[:id])
      rescue
        return
      end
    end
    
    @player2 = Player.where('lower(player_name) = ?', params[:player2].downcase).first
    if @player2.nil?
      name = params[:player2].gsub("_", " ")
      @player2 = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player2.nil?
      name = params[:player2].gsub(" ", "_")
      @player2 = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if @player2.nil?
      begin
        @player2 = Player.find(params[:id])
      rescue
        return
      end
    end
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

  def get_stats(name, acc_type)
    if name == "Bargan"
      all_stats = "-1,1410,143408971 -1,99,13078967 -1,99,13068172 -1,99,13069431 -1,99,14171944 -1,85,3338143 -1,82,2458698 -1,99,13065371 -1,99,14018193 -1,91,6111148 -1,-1,0 -1,92,6557350 -1,99,14021572 -1,99,13074360 -1,99,13182234 -1,81,2195415 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,80,1997973 -1,-1,0 -1,-1,0 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1".split(" ")
    else
      begin
        case acc_type
        when "Reg"
          uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{name}")
        when "HCIM"
          uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{name}")
        when "UIM"
          uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_ultimate/index_lite.ws?player=#{name}")
        when "IM"
          uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{name}")
        end
        all_stats = uri.read.split(" ")
      rescue Exception => e  
        puts e.message 
        Player.where(player_name: name).destroy_all
        return false
      end
    end
    return all_stats
  end
  
  def check_hc_death(player, overall_xp)
    if player.player_acc_type == "HCIM"
      begin
        hc_uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{player.player_name}")
        hc_stats = hc_uri.read.split(" ")
        hc_xp = hc_stats[0].split(",")[2].to_f
        if hc_xp < overall_xp
          player.update_attribute(:player_acc_type, "IM")
        end
      rescue Exception => e   
        puts e.message 
      end
    end
  end
  
  def calc_ehp(player, all_stats, ehp)
    player.update_attribute(:potential_p2p, "0")
    total_ehp = 0.0
    F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
      skill_lvl = all_stats[skill_idx].split(",")[1].to_f
      skill_xp = all_stats[skill_idx].split(",")[2].to_f
      skill_rank = all_stats[skill_idx].split(",")[0].to_f
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame"
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
        if skill_xp == "-1"
          player.update_attribute(:"#{skill}_xp", 0)
        else
          player.update_attribute(:"#{skill}_xp", skill_xp)
        end
        player.update_attribute(:"#{skill}_lvl", skill_lvl)
        player.update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
        player.update_attribute(:"#{skill}_rank", skill_rank)
        total_ehp += skill_ehp.round(2)
      elsif skill == "p2p" and skill_xp > 0 
        player.update_attribute(:potential_p2p, skill_xp)
        Player.where(player_name: player.player_name).destroy_all
      elsif skill == "p2p_minigame" and skill_lvl > 0
        player.update_attribute(:potential_p2p, skill_lvl)
        Player.where(player_name: player.player_name).destroy_all
      elsif skill == "overall"
        check_hc_death(player, skill_xp)
        player.update_attribute(:"#{skill}_lvl", skill_lvl)
        player.update_attribute(:"#{skill}_xp", skill_xp)
        player.update_attribute(:"#{skill}_rank", skill_rank)
      end
    end
    player.update_attribute(:overall_ehp, total_ehp.round(2))
    if player.potential_p2p.to_f <= 0
      player.update_attribute(:potential_p2p, "0")
    else
      Player.where(player_name: player.player_name).destroy_all
    end
  end

  def get_ehp_type(player)
    case player.player_acc_type
    when "Reg"
      ehp = F2POSRSRanks::Application.config.ehp_reg
    when "HCIM", "IM"
      ehp = F2POSRSRanks::Application.config.ehp_iron
    when "UIM"
      ehp = F2POSRSRanks::Application.config.ehp_uim
    end
  end
  
  def remove_cutoff(player)
    if player.overall_ehp < 75
      Player.where(player_name: player.player_name).destroy_all
      #redirect_to ranks_path, notice: 'The player you wish to add does not yet meet the 75 EHP requirement.'
      return true
    end
  end
  
  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update_player
    @player = Player.find params[:id]
    if F2POSRSRanks::Application.config.downcase_fakes.include?(@player.player_name.downcase)
      Player.where(player_name: @player.player_name).destroy_all
      redirect_to ranks_path, notice: 'Fake F2P player was successfully removed.'
    end
    name = @player.player_name.gsub(" ", "_")
    puts name
    all_stats = get_stats(name, @player.player_acc_type)
    ehp = get_ehp_type(@player)
    calc_ehp(@player, all_stats, ehp)
    remove_cutoff(@player)
    
    respond_to do |format|
      format.html { redirect_to @player, notice: 'Player was successfully updated.'}
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end
  
  def ehp_start
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_attribute(:overall_ehp_start, :overall_ehp)
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
          player.update_attribute(:overall_ehp_end, :overall_ehp)
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
            next
          end
          ehp = get_ehp_type(player)
          calc_ehp(player, all_stats, ehp)
          remove_cutoff(player)
        rescue
          next
        end
      end
    end
    redirect_to ranks_path, notice: 'All players were successfully updated.'
  end
  
  def export_players
    skill_list = F2POSRSRanks::Application.config.f2p_skills
    skill_list << "overall"
    File.open("players.txt", "w+") do |f|
      
      Player.all.each do |player|
        str = "              { 'player_name': '#{player.player_name}', 'player_acc_type': '#{player.player_acc_type}', 'potential_p2p': '#{player.potential_p2p}'"
        skill_list.each do |skill|
          lvl = "#{skill}_lvl"
          xp = "#{skill}_xp"
          ehp = "#{skill}_ehp"
          if (not player["#{lvl}"].nil?) and player['potential_p2p'] == '0'
            str += ", #{skill}_lvl: #{player[lvl]}"
          else
            str += ", #{skill}_lvl: 0"
          end
          if (not player["#{xp}"].nil?) and player['potential_p2p'] == '0'
            str += ", #{skill}_xp: #{player[xp]}"
          else
            str += ", #{skill}_xp: 0"
          end
          if (not player["#{ehp}"].nil?) and player['potential_p2p'] == '0'
            str += ", #{skill}_ehp: #{player[ehp]}"
          else
            str += ", #{skill}_ehp: 0"
          end
        end
        str += "},\n"
        f.write(str)
      end
    end
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
          remove_cutoff(player)
        rescue
          next
        end
      end
    end
    redirect_to ranks_path, notice: 'All players were successfully updated.'
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
      :potential_p2p
      )
  end
end
