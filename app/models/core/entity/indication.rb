module Core
  module Entity
    class Indication
      include ActiveModel::Model 

      attr_accessor :cpf, :indication_id, :cadastre_id, :cpf_create

      validates :cpf, cpf: true, presence: true
      validate  :cpf_exist?

      def persist_indication
        indication = Core::Entity::IndicationUnit.find(self.indication_id)
        indication.update(cadastre_id: self.cadastre_id, situation: 1)

        indication.indication_logs.create({
          cadastre_id: self.cadastre_id,
          description: "Candidato selecionado."
        })
      end

      private

      def cpf_exist?
        @cadastre = Core::Candidate::Cadastre.find_by(cpf: self.cpf) rescue nil
        
        if @cadastre.nil?
          errors.add(:cpf, 'CPF não encontrado na base de dados da CODHAB') 
          self.cpf_create = true
        else

          indication = Core::Entity::IndicationUnit.find(self.indication_id)
          indication_candidate = indication.allotment.indication_units.where(cadastre_id: @cadastre.id).present?

          if indication_candidate
            errors.add(:cpf, "CPF já se encontra indicado")
          else
            self.cadastre_id = @cadastre.id
          end
        end


      end

    end
  end
end