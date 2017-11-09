require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialContract < ApplicationRecord
      self.table_name = 'generic.social_contracts'

      belongs_to :company, required: false, class_name: ::Core::SocialWork::Company
      belongs_to :station, required: false, class_name: Core::TechnicalAssistance::Station, foreign_key: :station_id
      belongs_to :staff,                    class_name: ::Core::Person::Staff

      has_many :social_payments, class_name: ::Core::SocialWork::SocialPayment,      foreign_key: :contract_id, :dependent => :destroy
      has_many :executions,      class_name: ::Core::SocialWork::SocialExecution,    foreign_key: :contract_id, :dependent => :destroy
      has_many :goals,           class_name: ::Core::SocialWork::SocialContractGoal, foreign_key: :contract_id, :dependent => :destroy

      scope :by_conpany, -> (company) { where(company: company) }
      scope :by_station, -> (station) { where(station: station) }
      scope :by_number,  -> (number)  {where('number ilike ?', "%#{number}%")}

      validates :number, :value, :station_id, :company_id, presence: true

    end
  end
end
