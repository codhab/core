require_dependency 'core/application_record'

module Core
  module Project
    class Enterprise < ApplicationRecord
      self.table_name = 'extranet.project_enterprises'

      belongs_to :typology
      belongs_to :company,   class_name: ::Core::Project::Company

      has_many :steps
      has_many :enterprise_typologies
      has_many :allotments, through: :steps

      #enum situation:  ['editais', 'licitações', 'em construção', 'concluído'] Verificar

      scope :actives, -> { where(status: true).order(:name)}

      scope :by_name, -> (name) { where(name: name) }
      scope :by_edital, -> (edital) { where(edict_number: edital) }
      scope :by_process, -> (process) { where(process_number: process) }
      scope :by_status, -> (status) { where(status: status) }



    end
  end
end
