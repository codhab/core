module Core
  module Candidate
    class CadastreMirror < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_mirrors'

      belongs_to :special_condition, required: false

      belongs_to :cadastre
      belongs_to :program       
      belongs_to :city,         required: false, class_name: ::Core::Address::City
      belongs_to :state,        required: false, class_name: ::Core::Address::State
      belongs_to :work_city,    required: false, class_name: ::Core::Address::City
      belongs_to :civil_state,  required: false
      belongs_to :city,         required: false, class_name: ::Core::Address::City
      belongs_to :work_city,    required: false, class_name: ::Core::Address::City
      belongs_to :work_state,   required: false, class_name: ::Core::Address::State
      
      belongs_to :special_condition_type, required: false
      belongs_to :cadastre_situation,     required: false
      belongs_to :cadastre_procedural,    required: false, foreign_key: :procedural_id

      has_many :dependent_mirrors, dependent: :destroy
      has_many :cadastre_procedurals
      
      has_one :pontuation

      enum situation: ['em_progresso','pendente', 'aprovado']
      enum gender: ['N/D', 'masculino', 'feminino']

    end
  end
end
