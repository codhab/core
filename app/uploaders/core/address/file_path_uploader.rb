module Core
  module Address
    class FilePathUploader < CarrierWave::Uploader::Base
      storage :file

      def store_dir
        'uploads/enterprise'
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
