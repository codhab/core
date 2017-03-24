require_dependency 'core/protocol/digital_document'

module Core
  module Protocol
    class DigitalDocumentForm < Core::Protocol::DigitalDocument

      validates :description_subject, presence: true

      mount_uploader :doc_path, Core::Protocol::DocumentDigitalUploader
    end
  end
end
