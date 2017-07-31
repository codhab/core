require_dependency 'core/candidate/ownership_activity'

module Core
  module Attendance
    class OwnershipForm < Core::Candidate::OwnershipActivity 
      
      attr_accessor(
        :original_cpf, 
        :target_cpf, 
        :observation, 
        :original_cadastre, 
        :target_cadastre,
        :target_cadastre_mirror,
        :current_user
      )

      validates :original_cpf, :target_cpf, cpf: true, presence: true
      validate  :original_cpf_validate
      validate  :target_cpf_validate

      def create_ownership!
        # => Migrando informações do originário para o novo titular

        # Coletando informações

        current_situation  = @original_cadastre.cadastre_situations.order(created_at: :desc).last rescue nil
        current_procedural = @original_cadastre.cadastre_procedurals.order(created_at: :desc).last rescue nil
        current_created_at = @original_cadastre.created_at 
        current_dependents = @original_cadastre.dependents
        current_program_id = @original_cadastre.program_id

        # Migrando informações

        migrate_situation = @target_cadastre.cadastre_situations.new(current_situation.attributes)
        migrate_situation.id = nil
        migrate_situation.save

        migrate_procedural = @target_cadastre.cadastre_procedurals.new(current_procedural.attributes)
        migrate_procedural.id = nil
        migrate_procedural.save

        @target_cadastre.created_at = current_created_at
        @target_cadastre.program_id = current_program_id

        @target_cadastre.save

        # Migrando dependentes

        @target_cadastre.dependents.destroy_all 

        current_dependents.each do |dependent|
          if dependent.cpf != @target_cadastre.cpf
            dependent.attributes.each do |key, value|

              new_dependent = @target_cadastre.dependents.new

              unless %w(id created_at updated_at).include? key
                new_dependent[key] = value if new_dependent.attributes.has_key?(key)    
              end

              new_dependent.save
            end
          end
        end

        # Criando cadastro espelho

        clone_target_cadastre_to_new_mirror!

        # Repontuando

        
        score_service = Core::Candidate::ScoreService.new({
          cadastre_mirror_id: @target_cadastre_mirror.id
        }).scoring_cadastre!

        @target_cadastre.pontuations.new({
          cadastre_mirror_id: @target_cadastre_mirror.id,
          bsb: score_service[:timebsb_score],
          dependent: score_service[:dependent_score],
          timelist: score_service[:timelist_score],
          special_condition: score_service[:special_dependent_score],
          income: score_service[:income_score],
          total: score_service[:total],
          program_id: @target_cadastre_mirror.program_id,
        }).save!

        # Migrando processos

        assessments = Core::Protocol::Assessment.where(cpf: @original_cadastre.cpf)
        assessments.update_all(cpf: @target_cadastre.cpf)

        # => Trocando situação do cadastro originário 

        new_situation = @original_cadastre.cadastre_situations.new({
          situation_status_id: 66, # Titularidade trocada
          observation: "Situação migrada por troca de titularidade, vide atividades"
        })

        new_situation.save

        # => Migrando indicações

        indications = @original_cadastre.enterprise_cadastres
        indications.update_all(cadastre_id: @target_cadastre.id)

        # => Migrando vínculo com endereços

        addresses = @original_cadastre.cadastre_address
        addresses.update_all(cadastre_id: @target_cadastre.id)

        # => Adicionando atividades

        new_original_activity = @original_cadastre.cadastre_activities.new({
          staff_id: current_user.id,
          activity_status_id: 33,
          type_activity: 'crítico',
          observation: "Troca de titularidade entre o CPF original #{@original_cadastre.cpf} e o novo titular CPF #{@target_cadastre.cpf}"
        })

        new_original_activity.save

        new_target_activity = @target_cadastre.cadastre_activities.new({
          staff_id: current_user.id,
          activity_status_id: 33,
          type_activity: 'crítico',
          observation: "Troca de titularidade entre o CPF original #{@original_cadastre.cpf} e o novo titular CPF #{@target_cadastre.cpf}"
        })

        new_target_activity.save
      end

      private

      def original_cpf_validate
        @original_cadastre = Core::Candidate::Cadastre.find_by(cpf: self.original_cpf) rescue nil
        
        if @original_cadastre.nil?
          errors.add(:original_cpf, "CPF não encontrado")
        else
          self.original_cadastre_id   = @original_cadastre.id
        end

      end

      def target_cpf_validate

        @target_cadastre = Core::Candidate::Cadastre.find_by(cpf: self.target_cpf) rescue nil
        
        if @target_cadastre.nil?
          errors.add(:target_cpf, "CPF não encontrado")
        else
          self.target_cadastre_id   = @target_cadastre.id
        end
      end

      def clone_target_cadastre_to_new_mirror!
        
        # => Clonando cadastro
        
        @target_cadastre_mirror = @target_cadastre.cadastre_mirrors.new

        @target_cadastre.attributes.each do |key, value|
          unless %w(id created_at updated_at).include? key
            @target_cadastre_mirror[key] = value if @target_cadastre_mirror.attributes.has_key?(key)
          end
        end

        @target_cadastre_mirror.save

        # => Clonando dependentes

        @target_cadastre.dependents.each do |dependent|

          @new_dependent = @target_cadastre_mirror.dependent_mirrors.new

          dependent.attributes.each do |key, value|
            unless %w(id created_at cadastre_id updated_at).include? key
             @new_dependent[key] = value if @new_dependent.attributes.has_key?(key)
            end
          end

          @new_dependent.save

        end
      end

    end
  end
end