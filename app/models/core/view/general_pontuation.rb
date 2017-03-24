module Core
  module View
    class GeneralPontuation < ApplicationRecord
      self.table_name = 'extranet.general_pontuations'

      belongs_to :cadastre,         class_name: ::Core::Candidate::Cadastre
      belongs_to :dependent,        class_name: ::Core::Candidate::Dependent
      belongs_to :situation_status, class_name: ::Core::Candidate::SituationStatus
    end
  end
end
