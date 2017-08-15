require_dependency 'core/application_record'

module Core
  module SocialWork
    class Company < ApplicationRecord
      self.table_name = 'generic.social_work_companies'
      has_many :company_users

      validates :name, :email, presence: true
      validates :cnpj, cnpj: true
      enum company_type: ['Empresa de Projetos','Empresa Executora']
    end
  end
end
