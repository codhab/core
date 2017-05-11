require_dependency 'core/manager/project_category'

module Core
  module Manager
    class ProjectCategoryForm < ::Core::Manager::ProjectCategory

      validates :name, presence: true
      
    end
  end
end