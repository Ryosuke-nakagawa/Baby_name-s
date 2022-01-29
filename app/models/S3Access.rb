class S3Access
  require 'open-uri'

  def get_presigned_image_url(image_name)
    s3 = Aws::S3::Resource.new
    signer = Aws::S3::Presigner.new(client: s3.client)
    signer.presigned_url(:get_object, bucket: ENV['AWS_BUCKET'],
                                      key: "/fotune_telling_images/#{image_name}", expires_in: 60)
  end

  def image_save(image_name,save_file)
    s3resource = Aws::S3::Resource.new
    # 空のS3オブジェクトを作成
    obj = s3resource.bucket(ENV['AWS_BUCKET']).object("/fotune_telling_images/#{image_name}")
    # S3オブジェクトに画像ファイルをアップロード
    obj.upload_file(save_file)
  end
end
