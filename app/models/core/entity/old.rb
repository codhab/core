require_dependency 'core/application_record'

module Core
  module Entity
    class Old < ApplicationRecord
      self.table_name = 'extranet.entity_olds'

      has_many :old_candidates

      scope :by_name,  -> (name_entity) {where("name ILIKE '%#{name_entity}%'")}
      scope :by_fantasy_name,  -> (code) {where("fantasy_name ILIKE '%#{code}%'")}
      scope :cnpj,  -> (cnpj) {where(cnpj: cnpj)}
      scope :status,  -> (status) {where(old: status)}
      scope :by_cnpj,  -> (cnpj) {where(cnpj: cnpj.unformat_cnpj)}
      scope :by_situation, -> (situation) { where(old: situation) }


      has_many :assessments, class_name: "::Protocol::Assessment", foreign_key: 'cnpj', primary_key: 'cnpj'
      belongs_to :new_city, class_name: "Address::City", foreign_key: :city_id
    end
  end
end
