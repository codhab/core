require_dependency 'core/protocol/conduct'

module Core
  module Protocol
    class WorkflowForm < Core::Protocol::Workflow # :nodoc:

      attr_accessor :attachment_number, :attachment_type

      attr_accessor :attachment_number, :attachment_type

      before_validation :set_attachment

      validates :attachment_number, presence: true
      validates :attachment, presence: true

      private

      def set_attachment
        document = Core::Protocol::Assessment.where(document_number: self.attachment_number,
                                                    document_type: self.attachment_type).first rescue nil

        if document.nil?
          errors.add(:attachment_number, "Documento não existe")
        else
          self.attachment_id = document.id
        end

      end

    end
  end
end
