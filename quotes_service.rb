require 'faraday'
require 'json'

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
    JSON.parse(client.post('find-quote') { |req| req.params = {keyword: keyword} }.body)
  end

  def self.client
    url     = ENV['QUOTES_BACKEND_API']
    headers = {'Content-Type' => 'application/json'}
    Faraday.new(url: url, headers: headers)
  end
end
