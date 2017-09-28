require_dependency 'core/application_record'

module Core
  module Entity
    class Cadastre < ApplicationRecord
      self.table_name = 'extranet.entity_cadastres'

      belongs_to :city, class_name: ::Core::Address::City

      has_many :situations, class_name: ::Core::Entity::Situation
      has_many :inspections
      has_many :candidates
      has_many :situation_status, through: :situations

      has_many :documents
      has_many :document_categories, through: :documents
      has_many :members
      has_many :candidates
      has_many :candidate, through: :candidates

      has_many :enterprises, class_name: ::Core::Project::Enterprise,
        foreign_key: :entity_id 
        
      has_many :realties
      has_many :activities
      has_many :assessments,
               class_name: ::Core::Protocol::Assessment,
               foreign_key: :cnpj,
               primary_key: :cnpj

      has_many :interests, class_name: ::Core::Entity::Interest, foreign_key: :entity_id


      has_many :chats, class_name: ::Core::Entity::Chat, foreign_key: :entity_id
      has_many :assessments, class_name: ::Core::Protocol::Assessment, foreign_key: :cnpj, primary_key: :cnpj

      has_many :allotment_entities, class_name: ::Core::Entity::AllotmentEntity, foreign_key: :entity_id

      scope :with_president, -> {
        joins('LEFT JOIN entity_members
               ON entity_members.cadastre_id = entity_cadastres.id
               AND entity_members.member_job_id = 2')
      }



      scope :situation, -> (status) {
        Core::Entity::Cadastre.joins(:situations)
        .where('entity_situations.situation_status_id = (SELECT MAX(entity_situations.situation_status_id)
                FROM entity_situations WHERE entity_situations.cadastre_id = entity_cadastres.id)')
        #.where('entity_situations.situation_status_id = ?', status)
      }

      scope :senders, -> {
        where(id: Core::Entity::Document.all.map(&:cadastre_id))
      }

      scope :active_documents, -> {
        Core::Entity::Document.where(document_category_id: Core::Entity::DocumentCategory.actives.map(&:id))
      }

      scope :complete, -> {
        count = active_documents.select('cadastre_id')
                                .group('cadastre_id')
                                .having('count(cadastre_id) >= 11')

        where(id: count)
      }

      scope :by_name, ->(value) {where("name ILIKE '%#{value}%'")}

      scope :by_situation, ->(value) {
        joins(:situations)
        .where("(extranet.entity_situations.id IN (SELECT MAX(entity_situations.id) as max
                FROM extranet.entity_situations GROUP BY extranet.entity_situations.cadastre_id))")
        .where('extranet.entity_situations.situation_status_id = ?', value)

      }

      scope :by_cnpj,  -> (cnpj) {where(cnpj: cnpj.gsub('-','').gsub('/','').gsub('.',''))}
      scope :by_name_entity,  -> (name_entity) {where(name: name_entity)}
      scope :by_fantasy_name,  -> (fantasy_name) {where("fantasy_name ILIKE '%#{fantasy_name}%'")}

      def current_situation
        self.situations.order(:id).last.situation_status.name rescue self.situations.order(:id).last.situation_status_id
      end

      def president_name
        obj = self.members.where(member_job_id: 2).first
        obj.name.mb_chars.upcase rescue nil
      end

    end
  end
end
