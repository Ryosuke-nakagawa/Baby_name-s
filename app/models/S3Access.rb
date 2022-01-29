class S3Access
  require 'open-uri'

  def get_presigned_image_url(image_name)
    s3 = Aws::S3::Resource.new
    signer = Aws::S3::Presigner.new(client: s3.client)
    signer.presigned_url(:get_object, bucket: ENV['AWS_BUCKET'],
                                      key: "/fotune_telling_images/#{image_name}", expires_in: 60)
  end
end
