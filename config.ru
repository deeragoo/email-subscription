require 'dotenv/load'
require 'sinatra'
require 'haml'
require_relative 'config/environment.rb'

require './main'

run Sinatra::Application