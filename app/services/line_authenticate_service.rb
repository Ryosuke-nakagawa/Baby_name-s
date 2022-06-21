class LineAuthenticateService
  attr_reader :line_id, :name, :avatar

  def initialize(id_token)
    @id_token = id_token
  end

  def call
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),
                              { 'id_token' => @id_token, 'client_id' => channel_id })
    @line_id = JSON.parse(res.body)['sub']
    @name = JSON.parse(res.body)['name']
    @avatar = JSON.parse(res.body)['picture']
  end

  def search_user
    User.find_by(line_id: @line_id)
  end
end
