# frozen_string_literal: true

# This simple bot responds to every "Ping!" message with a "Pong!"

require 'discordrb'
require 'dotenv/load'

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], client_id: ENV['BOT_CLIENT_ID'], prefix: '!'

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
# puts "This bot's invite URL is #{bot.invite_url}."
# puts 'Click on it to invite it to your server.'

bot.command :ping do |_event|
  "Pong! Back at ya #{event.message.authoer.username}"
end

bot.command :quote do |event, search_string|
  "Looking up a quote with the string: #{search_string}"
end

bot.command :addquote do |event, *quote|
  quote_submitter = event.message.author.username
  channel         = event.message.channel.name
  "Quote submitted by: #{quote_submitter} in #{channel}:  #{quote.join(' ')}"
end

at_exit { bot.stop }

bot.run