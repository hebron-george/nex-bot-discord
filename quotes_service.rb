require 'faraday'
require 'json'
require 'tzinfo'
require 'date'

module QuotesService
  def self.add_quote(data)
    raise ArgumentError.new('Missing quote submitter!') if data[:quote_submitter].to_s == ''
    raise ArgumentError.new('Missing quote message!')   if data[:message].to_s == ''

    quote_params = {
      message:         data[:message],
      quote_submitter: data[:quote_submitter],
      channel:         data[:channel],
    }

    resp = client.post('add-quote') { |req| req.params = {quote: quote_params} }
    return JSON.parse(resp.body)
  end

  def self.find_quote(keyword)
    response = client.post('find-quote') { |req| req.params = {keyword: keyword} }
    Presenter.new(response).formatted_quote
  end

  def self.client
    url     = ENV['QUOTES_BACKEND_API']
    headers = {'Content-Type' => 'application/json'}
    Faraday.new(url: url, headers: headers)
  end
end

class Presenter
  attr_reader :message
  def initialize(quote_response)
    @message = quote_response.success? ? JSON.parse(quote_response.body).dig('data') : empty_quote
  end

  def formatted_quote
    "> #{message['message']}\n"\
      "Added By: `#{message['author']}` | Saved At: `#{saved_at}` | Channel: `#{message['channel']}`"
  end

  private

  def empty_quote
    {
      'author'   => 'N/A',
      'saved_at' => 'N/A',
      'channel'  => 'N/A',
      'message'  => 'No quotes found.',
    }
  end

  def saved_at
    tz = TZInfo::Timezone.get('America/New_York')
    s = message['saved_at']
    date_time_format = '%b %d, %Y %I:%M %p %Z'
    s == 'N/A' ? 'N/A' : tz.to_local(DateTime.parse(s)).strftime(date_time_format)
  end
end
