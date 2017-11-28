require_dependency 'core/application_record'

module Core
  module Document
    class DataPrint < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.document_data_prints'

      belongs_to :allotment,          required: false, class_name: '::Core::Document::Allotment'
      belongs_to :city,               required: false, class_name: '::Core::Address::City'
      belongs_to :civil_state,        required: false, class_name: '::Core::Candidate::CivilState'
      belongs_to :spouse_civil_state, required: false, class_name: '::Core::Candidate::CivilState'
      belongs_to :ownership_type,     required: false, class_name: '::Core::Address::OwnershipType'

      validates :cpf, cpf: true
      validates :spouse_cpf, cpf: true, if: 'self.spouse_cpf.present?'



    end
  end
end
