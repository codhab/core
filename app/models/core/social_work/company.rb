require_dependency 'core/application_record'

module Core
  module SocialWork
    class Company < ApplicationRecord
      self.table_name = 'generic.social_work_companies'
      has_many :company_users
      has_many :project_executes, class_name: Core::SocialWork::ProjectExecute
      has_many :executor_companies

      validates :name, :email, :cnpj, :company_type, presence: true
      validates :cnpj, cnpj: true
      enum company_type: ['Empresa de Projetos','Empresa Executora']
    end
  end
end
