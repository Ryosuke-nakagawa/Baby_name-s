class FotuneTelling
  require 'open-uri'
  
  def initialize(first_name:,last_name:)
    @first_name = first_name
    @last_name = last_name
  end

  def search_url
    "https://enamae.net/m/#{search_param}#result"
  end

  def rate
    html = URI.open(search_url).read
    doc = Nokogiri::HTML.parse(html)
    daikiti = doc.css(".daikiti").count
    kiti =doc.css(".kiti").count
    kikkyou= doc.css(".kikkyou").count
    kyou= doc.css(".kyou").count
    tokusyu= doc.css(".tokusyu").count
    return ( daikiti * 5 + kiti * 4 + kikkyou * 3 + tokusyu * 3 + kyou * 2 ) / 6
  end

  def image_save(image_name)
    #ファイルのurlを作成
    file = "public/fotune_telling_images/#{image_name}"
    image_url = "https://enamae.net/result2/#{search_param}.jpg"

    #画像URLにアクセスし、画像ファイルをrailsアプリに保存
    File.open(file, 'wb') do |img|
      img.write(URI.open(image_url).read)
    end
    #こっからs3
    s3resource = Aws::S3::Resource.new(
      region: ENV["AWS_REGION"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      )
      #空のS3オブジェクトを作成
    obj = s3resource.bucket(ENV["AWS_BUCKET"]).object("/fotune_telling_images/#{image_name}")
    
      #S3オブジェクトに画像ファイルをアップロード
    obj.upload_file("public/fotune_telling_images/#{image_name}")
    
      #railsアプリに保存した画像ファイルはもう必要ないので削除
    File.delete("public/fotune_telling_images/#{image_name}")
    
  end

  def search_param
    full_name = "#{@last_name}__#{@first_name}"
    URI.encode_www_form_component(full_name)
  end

end