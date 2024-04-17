require 'dotenv/load'
require 'sinatra'
require 'haml'
require_relative 'config/environment.rb'
require_relative 'config/initializers/sidekiq.rb'

require './main'

run Sinatra::Application