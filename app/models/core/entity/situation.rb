module Entity
  class Situation < ActiveRecord::Base
    belongs_to :staff, class: '::Person::Staff'
    belongs_to :cadastre
    belongs_to :situation_status

    validates :situation_status, :observation, presence: true
    validate  :unique_status

    private

    def unique_status
      if self.cadastre.current_situation_id == self.situation_status_id
        errors.add(:situation_status_id, "Entidade já se encontra nesta situação.")
      end
    end
  end
end
