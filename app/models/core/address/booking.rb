module Core
  module Address
    class Booking
      include ActiveModel::Model
      extend CarrierWave::Mount

      attr_accessor :cpf, :observation, :cadastre, :file_path, :unit_id

      validates :cpf, cpf: true, presence: true
      validates :observation, presence: true

      validate  :cpf_valid?

      mount_uploader :file_path, Core::Address::FilePathUploader

      private

      def cpf_valid?
        @cadastre = ::Candidate::Cadastre.find_by_cpf(self.cpf) rescue nil
        @unit = ::Address::Unit.find(self.unit_id) rescue nil

        if @cadastre.nil?
          errors.add(:cpf, 'CPF não existe na base de dados')
          return false
        end

        if %w(1 2 4 5).include?(@cadastre.program_id.to_s)
          
          unless @cadastre.current_situation_id == 4 && %w(14 72).include?(@cadastre.current_procedural.procedural_status_id.to_s)
            errors.add(:cpf, 'Situação do CPF não é válida para esta operação')
          end
          if @unit.current_cadastre_address.present? && %w(reserva distribuído sobrestado).include?(@unit.current_cadastre_address.situation_id.to_s)
            if @unit.current_cadastre_address.cadastre_id == @cadastre.id
             errors.add(:cpf, 'CPF já possui vinculo com imóvel.')
            end
          end

          if @cadastre.cadastre_address.present?

            cadastre_unit = @unit = ::Address::Unit.find(@cadastre.cadastre_address.last.unit_id)
            if cadastre_unit.present? && %w(reserva distribuído sobrestado).include?(cadastre_unit.current_cadastre_address.situation_id.to_s)
               errors.add(:cpf, 'CPF já possui vinculo com imóvel.')
            end
          end


          if @cadastre.enterprise_cadastres.where('inactive is not true').present?
            if @cadastre.enterprise_cadastres.where('inactive is not true and enterprise_id != ?', @unit.project_enterprise_id).present?
              errors.add(:cpf, 'CPF não possui indicação para este empreendimento.')
            end
          else
            errors.add(:cpf, 'CPF não possui indicação para empreendimento.')
          end

        elsif %w(3 6).include?(@cadastre.program_id.to_s)
          unless %w(3 4).include?(@cadastre.current_situation_id.to_s) && %w(14 64 65 66 72).include?(@cadastre.current_procedural.procedural_status_id.to_s)
            errors.add(:cpf, 'Situação do CPF não é válida para esta operação')
          end
        end

      end

    end
  end
end
