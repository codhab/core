require_dependency 'core/application_record'
module Core
  module Regularization
    class SolicitationDocument < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitation_documents'
      belongs_to :solicitation, required: false, class_name: 'Core::Regularization::Solicitation'
      belongs_to :request, required: false, class_name: 'Core::Regularization::SolicitationRequest'

      # validates :attachment, :name, presence: true

      mount_uploader :attachment, Core::Regularization::DocumentUploader

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SolicitationDocument')
      end
    end
  end
end
