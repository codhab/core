module CoreCandidate
  class Verification < ApplicationRecord

    self.table_name = 'extranet.candidate_verifications'

    belongs_to :program

    scope :morar_bem, -> {where(code: 'morar_bem', publish: true).order(:name)}

    enum verification_type: ['sql', 'serviço']


    def mirror_verificate(mirror)
      if self.sql?
        # => verificação por SQL
        Candidate::Verification.find_by_sql("#{self.sql}").present?
      else
        service_string = self.service.split('|')

        # => falta validação de array [{:}]
        model     = service_string[0]
        function  = service_string[1]
        attribute = service_string[2]


        # => construção de função do modelo
        meth = "#{model}".constantize.method("#{function}")
        meth.call mirror.send("#{attribute}")
      end
    end
  end
end
