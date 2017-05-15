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

      def self.positions_to_chart
        @collection = []
        Core::Candidate::Program.all.each_with_index do |program, index|
          @positions = self.where(program_id: program.id)
          if @positions.present?
            @base_hash = {
              name: program.name,
              data: @positions.merge_hash
            }
            @collection << @base_hash
          end
        end
        @collection
      end

      def self.merge_hash
        item = {}
        self.all.each do |p|
          item[":#{p.created_at.strftime("%Y-%m-%d")}"] = p.position
        end
        item
      end
    end
  end
end
