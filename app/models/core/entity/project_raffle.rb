module Core
  module Entity
    class ProjectRaffle < ActiveRecord::Base
      self.table_name = 'extranet.entity_project_raffles'

      belongs_to :project, class_name: Core::Entity::Project
      enum situation: ['aberto', 'sorteado', 'cancelado']
      
    end
  end
end