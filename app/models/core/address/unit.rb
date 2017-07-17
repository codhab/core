require_dependency 'core/application_record'

module Core
  module Address
    class Unit < ApplicationRecord
      self.table_name = 'extranet.address_units'

      has_one :notary_office

      belongs_to :situation_unit,     required: false, class_name: ::Core::Address::SituationUnit
      belongs_to :ownership_type,     required: false,
                                      class_name: ::Core::Address::OwnershipType,
                                      foreign_key: :ownership_type_id
      belongs_to :project_enterprise, required: false,
                                      class_name: ::Core::Project::Enterprise,
                                      foreign_key: :project_enterprise_id
      belongs_to :city,               required: false
      belongs_to :type_use_unit,      required: false

      has_many :registry_units,   class_name: ::Core::Address::RegistryUnit
      has_many :cadastre_address, class_name: ::Core::Candidate::CadastreAddress
      has_many :cadastres,        class_name: ::Core::Candidate::Cadastre, through: :cadastre_address
      has_many :ammvs,            class_name: ::Core::Candidate::Ammv
      has_many :activities

      scope :by_city,   -> (value)   { where(city_id: value) }
      scope :by_block,  -> (block)   { where(block: block)   }
      scope :by_group,  -> (group)   { where(group: group)   }
      scope :by_unit,   -> (unit)    { where(unit: unit)     }
      scope :by_donate, -> (donate)  { where(donate: donate) }

      scope :by_enterprise, -> (value)   {
        enterprise = Project::Enterprise.find(value) rescue nil
        where(enterprise_typology_id: enterprise.enterprise_typologies.ids)
       }

      scope :by_registry, -> (situation) {
        where(id: Address::RegistryUnit.select(:unit_id)
                                       .where(created_at: Address::RegistryUnit.select("MAX(created_at)")
                                       .group(:unit_id), situation: situation))
       }

      scope :by_address,     -> (address) {
        where("complete_address ILIKE ?", "%#{address}%")
      }

      scope :by_situation,   -> (status)  {
        where(situation_unit_id: status)
      }

      scope :regularization, -> {
        where("urb not in ('ETAPA 4C','MORARBEM','H4')")
      }

      scope :by_cpf, -> (cpf) {
        joins(cadastre_address: :cadastre)
        .where("candidate_cadastres.cpf = ?", cpf.unformat_cpf)
        .distinct
      }

      scope :by_assessment, -> (assessment) {
        assessment  = Protocol::Assessment.find_by_document_number(assessment) rescue nil
        cadastre_id = Candidate::CadastreProcedural.where(assessment_id: assessment.id).last.cadastre_id rescue nil
        joins(:cadastre_address).where("candidate_cadastre_addresses.cadastre_id = ?", cadastre_id).distinct
      }

      scope :by_candidate_name, -> (name) {
        joins(cadastre_address: :cadastre)
        .where("candidate_cadastres.name ILIKE ?","#{name}%")
        .distinct
      }



    end
  end
end
