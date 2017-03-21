module Core
  module Project
    class Enterprise < ActiveRecord::Base
      belongs_to :typology, -> { order(:id) }
      belongs_to :company,  -> { order(:id) }, class_name: "Project::Company"

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
