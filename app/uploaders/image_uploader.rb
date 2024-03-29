class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  # def public_id
  #   return "my_folder/" + Random.rand(1..1000).to_s
  # end 

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # def store_dir
  #   ""
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #

  version :thumbnail do
    process resize_to_fill: [300, 300, :center]
  end

  version :standard do
    process resize_to_fill: [1080, 1080, :center]
  end

  version :vertical do
    process resize_to_fill: [1080, 1350, :center]
  end

  version :horizontal do
    process resize_to_fill: [1080, 566, :center]
  end

  version :reels do
    process resize_to_fill: [540, 960, :center]
  end

  # Create different versions of your uploaded files:
  
  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
