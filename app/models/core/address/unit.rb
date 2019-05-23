require_dependency 'core/application_record'

module Core
  module Address
    class Unit < ApplicationRecord # :nodoc:
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
      belongs_to :enterprise_typology, class_name: "Core::Project::EnterpriseTypology", foreign_key: 'enterprise_typology_id'

      has_many :registry_units,   class_name: ::Core::Address::RegistryUnit
      has_many :cadastre_address, class_name: ::Core::Candidate::CadastreAddress
      has_many :cadastres,        class_name: ::Core::Candidate::Cadastre, through: :cadastre_address
      has_many :ammvs,            class_name: ::Core::Candidate::Ammv
      has_many :activities,    class_name: 'Core::Address::Activity'
      has_many :unit_images,   class_name: 'Core::Healty::UnitImage'
      has_many :unit_vois,     class_name: 'Core::Healty::Voi'
      has_many :unit_sealings, class_name: 'Core::Healty::SealingAddress'
      has_many :unit_labels,   class_name: 'Core::Healty::UnitLabel'

      scope :by_city,   -> (value)   { where(city_id: value) }
      scope :by_block,  -> (block)   { where(block: block)   }
      scope :by_group,  -> (group)   { where(group: group)   }
      scope :by_unit,   -> (unit)    { where(unit: unit)     }
      scope :by_donate, -> (donate)  { where(donate: donate) }
      scope :by_complete_address, -> (donate)  { where(donate: donate) }
      scope :by_id, -> (id)  { where(id: id) }

      scope :by_filter_city,   -> (value)   { where(city_id: value) }
      scope :by_filter_block,  -> (block)   { where(block: block).uniq(:group)   }
      scope :by_filter_group,  -> (group)   { where(group: group)   }
      scope :by_filter_unit,   -> (unit)    { where(unit: unit)     }

      scope :by_own, ->(own) {
        where(type_use_unit_id: 13) if own
      }

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

      scope :by_voi, ->(id) {
        joins(:unit_vois) if id
      }

      validates :city, :block, :unit, :complete_address, :situation_unit, presence: true
      validates :complete_address, uniqueness: { scope: [:city_id] }, presence: true, on: :create

      after_save :create_office

      def current_cadastre_address
        cadastre_address.order('created_at ASC').last rescue nil
      end

      def current_candidate
        address = self.cadastre_address.order('created_at asc').last rescue nil

        return false if address.nil?
        return false unless %w(reserva distribuído sobrestado).include?(address.situation_id)

        cadastre = address.cadastre rescue nil
      end

      def unit_block?
        unit_book? || self.situation_unit_id == 3 && current_cadastre_address.present? && current_cadastre_address.distribuído?
      end

      def unit_occupied?
        [5,9,10,12].include? self.situation_unit_id
      end

      def unit_book?
        self.situation_unit_id == 6 && current_cadastre_address.present? && current_cadastre_address.reserva?
      end

      def unit_link?
        situation_unit_id > 1
      end

      def unit_empty?
        situation_unit_id == 1
      end

      def unit_selling?
        situation_unit_id == 3
      end

      def unit_void?
        situation_unit_id == 1 && (current_cadastre_address.nil? || current_cadastre_address.distrato?)
      end

      private

      def create_office
        @office = Core::Address::NotaryOffice.new(
          unit_id: self.id
        )
        @office.save
      end
    end
  end
end
