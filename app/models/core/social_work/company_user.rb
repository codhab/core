require_dependency 'core/application_record'

module Core
  module SocialWork
    class CompanyUser < ApplicationRecord
      self.table_name = 'generic.social_work_company_users'

      attr_accessor :password_confirmation

      belongs_to :company
      enum user_type: ['comum','supervisor']

      validates :name, :username, :password, presence: true, on: :create
      validates :username, uniqueness: true, on: :create
      validates :password, presence: true, length: {within: 8..28}
      validates :password_confirmation, presence: true, length: { within: 8..28}

      validate  :equal_passwords, on: :update

      private

      def equal_passwords
        if self.password != self.password_confirmation
          errors.add(:password, "Senhas não conferem")
        end
      end
    end
  end
end
