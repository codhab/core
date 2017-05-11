require_dependency 'core/application_record'

module Core
  module Manager
    class TemplateTask < ApplicationRecord
      self.table_name = 'extranet.manager_template_tasks'

      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id
      belongs_to :sector, class_name: ::Core::Person::Sector, foreign_key: :sector_id


      enum priority: ['baixa', 'normal', 'alta', 'urgênte']
      
    end
  end
end