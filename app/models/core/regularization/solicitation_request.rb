require_dependency 'core/application_record'
module Core
  module Regularization
    class SolicitationRequest < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitation_requests'
      belongs_to :solicitation, class_name: "Core::Regularization::Solicitation"
      belongs_to :staff, class_name: "Core::Person::Staff"
      has_many :solicitation_documents
      has_many :solicitation_answers, foreign_key: :request_id


      def self.model_name
        ActiveModel::Name.new(self, nil, 'SolicitationRequest')
      end
    end
  end
end
