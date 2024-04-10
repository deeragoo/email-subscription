require_relative 'email_sender'
require_relative 'quote_generator'

require 'sinatra'
require 'haml'
require 'sqlite3'
require "sinatra/activerecord"
register Sinatra::ActiveRecordExtension
TO_EMAIL = ENV['TO_EMAIL']

set :haml, format: :html5, escape_html: true
set :database, {adapter: "sqlite3", database: "devlopment_subscriptions.sqlite3"}

class User < ActiveRecord::Base
  validates_presence_of :email
  validates_presence_of :password
end

class Subscriber < ActiveRecord::Base
  attribute :email
  validates_presence_of :email
  has_and_belongs_to_many :subscription
end

class Subscription < ActiveRecord::Base
  attribute :name
  has_many :subscribers
end

get '/' do
  qg = QuoteGenerator.new
  @quote = JSON.parse(qg.get_quote).first['quote']
  @author = JSON.parse(qg.get_quote).first['author']
  content = haml :layout, layout: false, locals: { quote: @quote, author: @author }
  # EmailSender.new.send_email(TO_EMAIL, content)
end

get '/subscribe' do
  haml :subscribe, layout: false
end

post '/subscribe' do
  
  if params[:email] && !params[:email].empty?
    email = params[:email]
  
    begin
      subscription = Subscription.where(name: 'daily_quote').first
      p subscription
      
      subscription = Subscription.new(name: 'daily_quote') unless subscription
      
      subscriber = Subscriber.new(email: email)

      p subscriber
      
      subscriber.save

      subscription.subscribers << subscriber

      subscription.save

      
      # Save the email to the SQLite3 database
  
      p "#{email} has subscribed successfully"
  
      # Redirect to the thank you page
      redirect '/thank_you'
    rescue SQLite3::Exception => e
      # If an exception occurs during database operation, return an error response
      status 500
      { error: "Failed to insert email into the database: #{e.message}" }.to_json
    end
  else
    # If email parameter is missing or empty, return an error response
    status 400
    { error: 'Email parameter is missing or empty' }.to_json
  end
end

get '/thank_you' do
  'Thank you for Subscribing'
end
