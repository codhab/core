module Core
  module Entity
    class ProjectUnit < ActiveRecord::Base
      self.table_name = 'extranet.entity_project_units'

      belongs_to :unit, class_name: Core::Address::Unit
      belongs_to :project, class_name: Core::Entity::Project
      
      
    end
  end
end