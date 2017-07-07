require_dependency 'core/application_record'

module Core
  module Entity
    class ProjectRaffleEntity < ApplicationRecord
      self.table_name = 'extranet.entity_project_raffle_entities'
    end
  end
end