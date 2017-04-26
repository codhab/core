require_dependency 'core/application_record'

module Core
  module Candidate
    class List < ApplicationRecord
      self.table_name = 'extranet.candidate_lists'

      extend FriendlyId
      friendly_id :title, use: :slugged

      scope :portal, ->   { where(list_type: 1, publish: true)}
      scope :extranet, -> { where(list_type: 0, publish: true)}

      scope :habitation,      -> { where(program_id: [1,2])}
      scope :regularization,  -> { where(program_id: [3])}

      enum list_type: ['extranet', 'portal']

      def program
        Core::Candidate::Program.where(id: program_id)
      end

      def self.view_targets
        %w[Core::View::GeneralPontuation Core::Candidate::Cadastre]
      end
    end
  end
end
