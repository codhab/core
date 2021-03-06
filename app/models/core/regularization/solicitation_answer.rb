require_dependency 'core/application_record'
module Core
  module Regularization
    class SolicitationAnswer < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.regularization_solicitation_answers'
      belongs_to :solicitation, required: false, class_name: 'Core::Regularization::Solicitation'
      belongs_to :request, required: false, class_name: 'Core::Regularization::SolicitationRequest', foreign_key: :request_id
      has_many :solicitation_documents
      validates :answer, presence: true

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SolicitationAnswer')
      end
    end
  end
end
