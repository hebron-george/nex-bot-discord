# frozen_string_literal: true

# This simple bot responds to every "Ping!" message with a "Pong!"

require 'discordrb'
require 'dotenv/load'
require './quotes_service'

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], client_id: ENV['BOT_CLIENT_ID'], prefix: '!'

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
# puts "This bot's invite URL is #{bot.invite_url}."
# puts 'Click on it to invite it to your server.'

bot.command :ping do |event|
  "Pong! Back at ya #{event.message.author.username}"
end

bot.command :quote do |event, search_string|
  result = QuotesService.find_quote(search_string)
  message = result.dig('data', 'quote')
  return "> #{message}"
end

bot.command :addquote do |event, *quote|
  data = {
    message:         quote.join(' '),
    quote_submitter: event.message.author.username,
    channel:         event.message.channel.name,
  }
  result = QuotesService.add_quote(data)
  message = result['message']
  return message
end

at_exit { bot.stop }
bot.run