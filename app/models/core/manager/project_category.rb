require_dependency 'core/application_record'

module Core
  module Manager
    class ProjectCategory < ApplicationRecord
      self.table_name = 'extranet.manager_project_categories'

      has_many :projects

      scope :actives, -> { where(status: true )}
      
    end
  end
end