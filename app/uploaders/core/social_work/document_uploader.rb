module Core
  module SocialWork
    class DocumentUploader < CarrierWave::Uploader::Base
      storage :file

      def store_dir
        'uploads/social_work/documents'
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
