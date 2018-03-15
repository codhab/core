module Core
  module Healty
    class ImageUploader < CarrierWave::Uploader::Base # :nodoc:
      storage :file

      def store_dir
        'extranet/uploads/jorge/'
      end

      def extension_white_list
        %w[jpg jpeg gif png]
      end

      def filename
        if original_filename
          @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
          "#{@name}.#{file.extension}"
        end
      end
    end
  end
end
