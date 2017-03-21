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

    end
  end
end
