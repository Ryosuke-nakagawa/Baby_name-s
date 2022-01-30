class LineAuthenticateService
  def initialize(id_token)
    @id_token = id_token
  end

  def search_line_id
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),
                              { 'id_token' => @id_token, 'client_id' => channel_id })
    JSON.parse(res.body)['sub']
  end
end
