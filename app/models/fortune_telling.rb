class FortuneTelling
  require 'open-uri'

  def initialize(first_name:, last_name:)
    @first_name = first_name
    @last_name = last_name
  end

  def search_url
    "https://enamae.net/m/#{search_param}#result"
  end

  def rate
    html = URI.open(search_url).read
    doc = Nokogiri::HTML.parse(html)
    daikiti = doc.css('.daikiti').count
    kiti = doc.css('.kiti').count
    kikkyou = doc.css('.kikkyou').count
    kyou = doc.css('.kyou').count
    tokusyu = doc.css('.tokusyu').count
    (daikiti * 5 + kiti * 4 + kikkyou * 3 + tokusyu * 3 + kyou * 1) / 6
  end

  def save_image_to_s3(image_name)
    file = "public/fortune_telling_images/#{image_name}"
    image_url = "https://enamae.net/result2/#{search_param}.jpg"

    # 画像URLにアクセスし、画像ファイルをrailsアプリに保存
    File.open(file, 'wb') do |img|
      img.write(URI.open(image_url).read)
    end

    s3_access = S3Access.new
    s3_access.image_save(image_name, file)
    # railsアプリに保存した画像ファイルはもう必要ないので削除
    File.delete("public/fortune_telling_images/#{image_name}")
  end

  def search_param
    full_name = "#{@last_name}__#{@first_name}"
    URI.encode_www_form_component(full_name)
  end
end