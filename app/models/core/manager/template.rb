require_dependency 'core/application_record'

module Core
  module Manager
    class Template < ApplicationRecord
      self.table_name = 'extranet.manager_templates'
      
      has_many :tasks, class_name: Core::Manager::TemplateTask, foreign_key: :template_id
      belongs_to :sector, class_name: Core::Person::Sector
             
    end
  end
end