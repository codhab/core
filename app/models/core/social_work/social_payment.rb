require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialPayment < ApplicationRecord
      self.table_name = 'generic.social_work_social_payments'

      belongs_to :contract
      belongs_to :staff

      scope :by_code,  -> (code)  {where('code ilike ?', "%#{code}%")}
      scope :by_date,  -> (date) {where("created_at::date  = ? ", Date.parse(date))}

      validates :date,:code,:code_emission, :value, presence: true

    end
  end
end
