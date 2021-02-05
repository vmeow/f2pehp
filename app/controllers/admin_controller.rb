require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'
require 'logger'

class AdminController < ApplicationController
    before_action :http_basic_auth

    def http_basic_auth
        if ENV['HTTP_AUTH_USER'] && ENV['HTTP_AUTH_PASS']
            self.class.http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASS']
        else
            self.class.http_basic_authenticate_with :name => "admin", :password => "admin"
        end
    end

    def index
        
    end

    def add_supporter
        @name = params[:player_supporter]
        x = Player.find_player @name
        if x
            x.update_player
            redirect_to admin_path, notice: "Player #{@name} has been added."
        else
            redirect_to admin_path, notice: "Could not find player #{@name}."
        end
    end

    def fix_spaces
        @name = params[:name_spaces]
        x = Player.find_player @name
        if x
            @name_spaces = x.player_name.force_encoding('ascii')
            @fixed_spaces = @name_spaces.gsub! '\xC2\xA0', ' '
            if (@fixed_spaces)
                x.update_attributes(:player_name=>@fixed_spaces)
                redirect_to admin_path, notice: "Player #{@fixed_spaces} has had whitespaces fixed."
            else
                redirect_to admin_path, notice: "Player #{@name_spaces} had no whitespace issues."
            end
        else
            redirect_to admin_path, notice: "Could not find player #{@name}."
        end
    end

    def change_name
        @name1 = params[:name1]
        @name2 = params[:name2]
        x = Player.find_player @name1
        if x
            x.update_attributes(:player_name=>@name2)
            redirect_to admin_path, notice: "Name has been updated to #{@name2}."
        else
            redirect_to admin_path, notice: "Could not find player #{@name}."
        end
    end

    def update_clan
        player = Player.find_player(params[:player_name])
        clan_id = Clan.where(name: params[:clan_name]).first.id
        if player
            player.update_attributes(:clan_id=>clan_id)
            redirect_to admin_path, notice: "#{player.player_name}'s clan has been updated to #{params[:clan_name]}."
        else
            redirect_to admin_path, notice: "Could not find player #{@name}."
        end
    end

    def update_many_clans
        updated_players = []
        failed_players = []

        player_names = params[:player_names].split(",")
        if player_names.size > 100
            redirect_to(admin_path, notice: "Too many players. Please try again with fewer than 100 players.")
            return
        end

        player_names.each do |player_name|
            player = Player.find_player(player_name)
            clan_id = Clan.where(name: params[:clan_name]).first.id
            if player
                player.update_attributes(:clan_id=>clan_id)
                updated_players += [player.player_name]
            else
                failed_players += [player_name]
            end
        end

        notice_msg =  "The following players have their clan updated to #{params[:clan_name]}: #{updated_players}"
        notice_msg += "\nPlayers failed to be found: #{failed_players}"

        redirect_to admin_path, notice: notice_msg
    end
end
