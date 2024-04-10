require 'bundler'
require 'bundler/setup'
require "active_record"
require 'require_all'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3',database: 'db/development.sqlite')
require_relative '../main'