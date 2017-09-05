require_dependency 'core/application_record'

module Core
  module SocialWork
    class Company < ApplicationRecord
      self.table_name = 'generic.social_work_companies'

      belongs_to :station, required: false, class_name: Core::TechnicalAssistance::Station, foreign_key: :station_id

      has_many :company_users
      has_many :project_executes, class_name: Core::SocialWork::ProjectExecute
      has_many :executor_companies

      validates :name, :email, :cnpj, :company_type, :station, presence: true
      validates :cnpj, cnpj: true

      enum company_type: ['Empresa de Projetos','Empresa Executora']

      scope :by_name,    -> (name)    {where('name ilike ?', "%#{name}%")}
      scope :by_cnpj,    -> (cnpj)    {where(cnpj: cnpj.gsub('.','').gsub('/','').gsub('-',''))}
      scope :by_fantasy, -> (fantasy) {where('fantasy_name ilike ?', "%#{fantasy}%")}
      scope :by_type,    -> (type)    {where(company_type: type)}
    end
  end
end
