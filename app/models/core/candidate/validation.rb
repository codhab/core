module CoreCandidate
  class Validation < ApplicationRecord

    self.table_name = 'extranet.candidate_validations'

    belongs_to :program
    belongs_to :occurrence_situation

    enum validation_type: ['query', 'service']
    enum target_return_type: ['retorno_query', 'retorno_service']
    enum occurrence_type: ['informação', 'pendência', 'pendência_impeditiva']


    def fields
      self.target_return_field.split(';') rescue nil
    end


  end
end
