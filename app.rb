# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require './quotes_service'

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], client_id: ENV['BOT_CLIENT_ID'], prefix: '!'

bot.command :ping do |event|
  "Pong! Back at ya #{event.message.author.username}"
end

bot.command :quote do |_event, search_string|
  QuotesService.find_quote(search_string)
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