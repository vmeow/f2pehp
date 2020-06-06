require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'
require 'logger'

class AdminController < ApplicationController
    http_basic_authenticate_with :name => "admin", :password => "admin" 

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
end
