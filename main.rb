require_relative 'email_sender'
require_relative 'quote_generator'

require 'sinatra'
require 'haml'
require 'sqlite3'
require "sinatra/activerecord"
require 'sidekiq'
require 'redis'
require 'sidekiq-cron'
REDIS_URL = ENV['REDIS_URL']

redis_url = REDIS_URL
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.on(:startup) do
    schedule_file = 'config/sidekiq_schedule.yml'
    file = YAML.load_file(schedule_file)
    Sidekiq::Cron::Job.load_from_hash!(file, source: "schedule")
  end
end
register Sinatra::ActiveRecordExtension
TO_EMAIL = ENV['TO_EMAIL']

set :haml, format: :html5, escape_html: true
set :database, {adapter: "sqlite3", database: "devlopment_subscriptions.sqlite3"}

class EmailSenderWorker
  include Sidekiq::Worker

  def perform
    name = 'daddy dee'
    puts "Hello, #{name}!"
  end

  #def perform
  #  subscribers = Subscriber.where(confirmed: true)
   # qg = QuoteGenerator.new
  #  quote = JSON.parse(qg.get_quote).first['quote']
 #   author = JSON.parse(qg.get_quote).first['author']

 #   subscribers.each do |subscriber|
    #  content = haml :layout, layout: false, locals: { quote: quote, author: author }
      #EmailSender.new.send_email(subscriber.email, content)
   # end
end

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

  subscribers = Subscriber.where(confirmed: true)

  content = haml :layout, layout: false, locals: { quote: @quote, author: @author }

  subscribers = Subscriber.where(confirmed: true)
  #subscribers.each do |subscriber|
    #EmailSender.new.send_email(subscriber.email, content)
  #end
  content
end

get '/subscribe' do
  haml :subscribe, layout: false
end

post '/subscribe' do
  if params[:email] && !params[:email].empty?
    email = params[:email]

    begin
      subscription = Subscription.where(name: 'daily_quote').first
      subscription ||= Subscription.create(name: 'daily_quote')

      subscriber = Subscriber.new(email: email)

      if subscriber.save
        subscription.subscribers << subscriber
        subscription.save

        # Send confirmation email
        confirmation_link = "#{request.base_url}/confirm_subscription/#{subscriber.id}"
        confirmation_content = "Thank you for subscribing! Please click <a href='#{confirmation_link}'>here</a> to confirm your subscription."
        EmailSender.new.send_email(subscriber.email, confirmation_content)

        "A confirmation email has been sent to #{subscriber.email}."
      else
        status 500
        { error: "Failed to save subscriber: #{subscriber.errors.full_messages.join(', ')}" }.to_json
      end
    rescue => e
      status 500
      { error: "Failed to subscribe: #{e.message}" }.to_json
    end
  else
    status 400
    { error: 'Email parameter is missing or empty' }.to_json
  end
end

get '/confirm_subscription/:id' do |id|
  subscriber = Subscriber.find_by(id: id)
  if subscriber
    subscriber.update(confirmed: true)
    'Thank you for confirming your subscription!'
  else
    'Subscriber not found.'
  end
end

get '/thank_you' do
  'Thank you for Subscribing'
end

post '/enqueue_email' do
  "enqueue started for #{name}"
end