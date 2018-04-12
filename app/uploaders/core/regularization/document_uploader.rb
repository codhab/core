module Core
  module Regularization
    class DocumentUploader < CarrierWave::Uploader::Base # :nodoc:
      storage :file

      def store_dir
        'extranet/uploads/regularization/mobile'
      end

      def extension_white_list
        %w[pdf docx doc jpg jpeg png gif]
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