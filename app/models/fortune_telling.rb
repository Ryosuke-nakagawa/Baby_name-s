class FortuneTelling
  require 'open-uri'

  def initialize(first_name:, last_name:)
    @first_name = first_name
    @last_name = last_name
  end

  def search_url
    "https://enamae.net/m/#{search_param}#result"
  end

  def rates
    html = URI.open(search_url).read
    doc = Nokogiri::HTML.parse(html)

    res = doc.css('.res')
    result = {}
    result[:heaven] = change_result_to_numerical(res[0].text)
    result[:person] = change_result_to_numerical(res[1].text)
    result[:land] = change_result_to_numerical(res[2].text)
    result[:outside] = change_result_to_numerical(res[3].text)
    result[:all] = change_result_to_numerical(res[4].text)
    result[:talent] = change_result_to_numerical(res[5].text)

    daikiti = doc.css('.daikiti').count
    kiti = doc.css('.kiti').count
    kikkyou = doc.css('.kikkyou').count
    kyou = doc.css('.kyou').count
    tokusyu = doc.css('.tokusyu').count
    result[:rate] = (daikiti * 5 + kiti * 4 + kikkyou * 3 + tokusyu * 3 + kyou * 1) / 6

    return result
  end

  def search_param
    full_name = "#{@last_name}__#{@first_name}"
    URI.encode_www_form_component(full_name)
  end

  def change_result_to_numerical(result)
    case result
    when '大吉'
      return 50
    when '吉'
      return 40
    when '特殊格'
      return 30
    when '吉凶混合'
      return 20
    when '凶'
      return 10
    end
  end
end
