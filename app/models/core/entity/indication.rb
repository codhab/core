module Core
  module Entity
    class Indication
      include ActiveModel::Model

      attr_accessor :cpf, :enterprise_id, :cadastre_id, :cpf_create

      validates :cpf, cpf: true, presence: true
      validate  :cpf_exist?

      def persist_indication
        enterprise = Core::Project::Enterprise.find(self.enterprise_id)
        indication = enterprise.candidates.new
        indication.inactive = false
        indication.indication_type_id = 1
        indication.indication_situation_id = 1
        indication.cadastre_id = @cadastre.id
        indication.save
      end

      private

      def cpf_exist?


        @enterprise = Core::Project::Enterprise.find(self.enterprise_id)

        if !(@enterprise.units.to_i > @enterprise.candidates.where('inactive is false').count)
          errors.add(:cpf, "Você já indicou a quantidade máxima para este empreendimento")
        end

        @cadastre = Core::Candidate::Cadastre.find_by(cpf: self.cpf) rescue nil

        if @cadastre.nil?
          errors.add(:cpf, 'CPF não encontrado na base de dados da CODHAB')
          self.cpf_create = true
        else

          candidate_enterprise = Core::Candidate::EnterpriseCadastre.where(cadastre_id: @cadastre.id)
                                                                    .where('inactive is false')

          if candidate_enterprise.present?
            errors.add(:cpf, 'CPF já possui indicação ativa')
          else
            
            #if @enterprise.candidates.where(cadastre_id: @cadastre.id).present?
            #  errors.add(:cpf, 'CPF já possui indicação para este empreendimento')
            #end

            if @cadastre.cadastre_situations.order(id: :asc).last.situation_status_id == 7 
              errors.add(:cpf, ', não é possível indicar um CPF já contemplado')
            end

          end
        end
      end
    end
  end
end
