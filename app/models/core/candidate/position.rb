require_dependency 'core/application_record'

module Core
  module Candidate
    class Position < ApplicationRecord
      self.table_name = 'extranet.candidate_positions'

      belongs_to :cadastre,    required: false,  class_name: ::Core::Candidate::Cadastre
      belongs_to :pontuation,  required: false,  class_name: ::Core::Candidate::Pontuation
      belongs_to :program,     required: false,  class_name: ::Core::Candidate::Program

      scope :rii, -> { where(program_id: 1)}
      scope :rie, -> { where(program_id: 2)}
      scope :old, -> { where(program_id: 7)}
      scope :vulnerable, -> { where(program_id: 4)}
      scope :special, ->    { where(program_id: 5)}
    end
  end
end
