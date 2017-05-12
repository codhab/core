require_dependency 'core/application_record'

module Core
  module Manager
    class Project < ApplicationRecord
      self.table_name = 'extranet.manager_projects'

      belongs_to :project_category

      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id
      belongs_to :manager,     class_name: ::Core::Person::Staff, foreign_key: :manager_id
      belongs_to :requester,   class_name: ::Core::Person::Staff, foreign_key: :requester_id

      belongs_to :responsible_sector, class_name: ::Core::Person::Sector, foreign_key: :responsible_sector_id
      belongs_to :requester_sector,   class_name: ::Core::Person::Sector, foreign_key: :requester_sector_id

      has_many   :tasks
      has_many   :problems,    through: :tasks
      has_many   :comments,    through: :tasks
      has_many   :attachments, through: :tasks
      has_many   :activities
      
      enum situation: ['em_construção', 'em_produção', 'concluído', 'cancelado']

    end
  end
end