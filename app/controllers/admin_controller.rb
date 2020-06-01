require 'net/https'
require 'uri'
require "open-uri"
require 'nokogiri'
require 'will_paginate/array'

class AdminController < ApplicationController
    http_basic_authenticate_with :name => "admin", :password => "admin" 

    def index
        
    end
end
