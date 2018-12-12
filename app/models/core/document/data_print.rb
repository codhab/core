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
      validates :wedding_regime,:wedding_date,:spouse_name,:spouse_cpf,:spouse_civil_state_id,:spouse_employment,
                :spouse_rg,:spouse_rg_org,:spouse_rg_uf,:spouse_nationality, presence: true, if: 'self.civil_state_id == 2', on: :update
      validates :name,:cpf,:civil_state_id,:rg,:rg_org,:rg_uf, :nationality,:employment,:address_data_base,:area,:city_id,:complete_address,
                :registration_iptu,:ocupation,:office,:unit_code,:declaratory_act_number,:endorsement, presence: true , on: :update

      def self.to_csv(options = {})
        desired_columns = %w[Nome CPF Cidade RG Expeditor RG_UF Estado_civil Nacionalidade Ocupação Processo Regime_casamento Data_regime Nome_pai Nome_mae
                             Conjuge Cpf_conjuge Ocupação_conjuge Rg_conjuge Expeditor_conjuge Uf_rg_conjuge Estado_civil_conj Naciolalidade_conjuge
                             Nome_pai_conjuge Nome_mae_conjuge casado Endereco_base area endereco_completo iptu data_ocupacao cartorio
                             matricula ato_declaratorio certificado_sefaz data_certificado validade valor ]
        (CSV.generate(options) do |csv|
          csv << desired_columns
          all.each do |data_print|
            csv << [data_print.name, data_print.cpf.format_cpf, data_print.city.present? ? data_print.city.name : nil,
                    data_print.rg, data_print.rg_org, data_print.rg_uf, data_print.civil_state_id,
                    data_print.nationality, data_print.employment, data_print.document_number, data_print.wedding_regime,
                    data_print.wedding_date, data_print.father_name, data_print.mother_name, data_print.spouse_name,
                    data_print.spouse_cpf, data_print.spouse_employment, data_print.spouse_rg, data_print.spouse_rg_org,
                    data_print.spouse_rg_uf, data_print.spouse_civil_state_id, data_print.spouse_nationality, data_print.spouse_father_name,
                    data_print.spouse_mother_name, data_print.married, data_print.address_data_base, data_print.area,
                    data_print.complete_address, data_print.registration_iptu, data_print.ocupation, data_print.office,
                    data_print.unit_code, data_print.declaratory_act_number, data_print.certificate_sefaz,
                    data_print.date_certificate_sefaz, data_print.validate_certificate_sefaz, data_print.endorsement,
                    data_print.property_value ]
          end
        end).encode('ISO8859-1', undef: :replace, replace: '')
      end
    end
  end
end
