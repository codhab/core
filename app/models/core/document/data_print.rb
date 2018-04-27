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

      def self.to_csv(options = {})
        desired_columns = %w[Nome CPF Cidade Nacionalidade]
        CSV.generate(options) do |csv|
          csv << desired_columns
          all.each do |data_print|
            csv << [data_print.name, data_print.cpf, data_print.city.present? ? data_print.city.name : nil,
                    data_print.nationality]
          end
        end
      end
    end
  end
end
