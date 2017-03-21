module CoreCandidate
  class CadastreOccurrence < ApplicationRecord

    self.table_name = 'extranet.candidate_cadastre_occurrences'

    belongs_to :occurrence_situation
    belongs_to :validation
    belongs_to :cadastre


    scope :solved, ->     { where(solved: true) }
    scope :not_solved, -> { where(solved: false) }

    def view_occurrence
      if self.validation.retorno_query?
        sql    = "#{self.validation.target_return_query} id = #{self.target_model_id}"
        result = ActiveRecord::Base.connection.query(sql)
        result
      else

      end
    end

  end
end
