require_dependency 'core/candidate/ownership_activity'

module Core
  module Attendance
    class OwnershipForm < Core::Candidate::OwnershipActivity

      attr_accessor(
        :original_cpf,
        :target_cpf,
        :original_cadastre,
        :target_cadastre,
        :target_cadastre_mirror,
        :current_user
      )

      validates :original_cpf, :target_cpf, cpf: true, presence: true
      validates :observation, presence: true
      validate  :original_cpf_validate
      validate  :target_cpf_validate
      validate  :current_user_validate

      def revert_ownership!
      end

      def create_ownership!

        # => Migrando cadastro
        original_id = @original_cadastre.id
        target_id   = @target_cadastre.id

        @original_cadastre.update(id: 0)
        @target_cadastre.update(id: original_id)
        @original_cadastre.update(id: target_id)

        @older_cadastre   = @original_cadastre
        @current_cadastre = @target_cadastre

        # => Trocando situação do cadastro originário

        new_situation = @older_cadastre.cadastre_situations.new({
          situation_status_id: 66, # Titularidade trocada
          observation: "Situação migrada por troca de titularidade, vide atividades"
        })

        new_situation.save

        # => Removendo `SE CONJUGE`

        dependent = @target_cadastre.dependents.find_by(cpf: @target_cadastre.cpf) rescue nil
        dependent.destroy if !dependent.nil?

        # => Atualizando dados base

        current_created_at = @older_cadastre.created_at
        current_program_id = @older_cadastre.program_id
        current_arrival_df = @older_cadastre.arrival_df

        @target_cadastre.update(created_at: current_created_at,
                                program_id: current_program_id,
                                arrival_df: current_arrival_df)

        clone_target_cadastre_to_new_mirror!

        # Repontuando

        if [1,2,4,5,7].include?(@target_cadastre.program_id)

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

        end

        # Migrando processos

        assessments = Core::Protocol::Assessment.where(cpf: @older_cadastre.cpf)
        assessments.update_all(cpf: @target_cadastre.cpf)

        # => Adicionando atividades

        new_original_activity = @older_cadastre.cadastre_activities.new({
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

      def current_user_validate
        self.staff_id = current_user.id
      end

      def original_cpf_validate
        @original_cadastre = Core::Candidate::Cadastre.find_by(cpf: self.original_cpf) rescue nil

        if @original_cadastre.nil?

          errors.add(:original_cpf, "CPF não encontrado")

        else

          self.original_cadastre_id   = @original_cadastre.id

          if !@original_cadastre.arrival_df.present?
            errors.add(:original_cpf, "Cadastro não possuí data de chegada ao DF, favor corrigir para prosseguir")
          end

        end


      end

      def target_cpf_validate

        @target_cadastre = Core::Candidate::Cadastre.find_by(cpf: self.target_cpf) rescue nil

        if @target_cadastre.nil?

          errors.add(:target_cpf, "CPF não encontrado")

        else

          self.target_cadastre_id   = @target_cadastre.id

          if !@target_cadastre.born.present?
            errors.add(:target_cpf, "Cadastro não possuí data de nascimento, favor corrigir para prosseguir")
          end

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
