module Core
  module Entity
    class ProjectUnit < ActiveRecord::Base
      self.table_name = 'extranet.entity_project_units'

      belongs_to :unit, class_name: Core::Address::Unit
      belongs_to :project, class_name: Core::Entity::Project
      
      has_one :project_raffle_entity, class_name: Core::Entity::ProjectRaffleEntity, foreign_key: :project_unit_id 
 
    end
  end
end