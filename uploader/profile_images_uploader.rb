class ProfileImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  # アップロード可能な拡張子のリスト
  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  process resize_to_fit: [128, 128]

  version :thumb_middle do
    process resize_to_fill: [64,64]
  end

  version :thumb_small do
    process resize_to_fill: [32,32]
  end
end