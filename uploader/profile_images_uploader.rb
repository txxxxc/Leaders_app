require 'carrierwave'
class ProfileImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  # アップロード可能な拡張子のリスト

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [128, 128]

  version :thumb_middle do
    process resize_to_fill: [64,64]
  end

  version :thumb_small do
    process resize_to_fill: [32,32]
  end

  def default_url
    "/images/fallback/default.svg"
  end

end