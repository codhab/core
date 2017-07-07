require_dependency 'core/entity/project_raffle'

module Core
  module Entity
    class ProjectUnitForm < Core::Entity::ProjectUnit

      validates :name, presence: true
      
    end
  end
end
