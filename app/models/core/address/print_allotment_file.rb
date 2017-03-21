
module Address
  class PrintAllotmentFile
    include ActiveModel::Model

    attr_accessor :file_path, :print_allotment_id

    validates :file_path,  presence: true
    validates :file_path, file_size: { less_than_or_equal_to: 10.megabytes.to_i }
    validates :file_path, file_content_type: { allow: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'], message: 'Somente arquivos .xlsx' }

    def import_files!

      return false unless self.valid?

      @allotment = Address::PrintAllotment.find(self.print_allotment_id)

      spreadsheet = Roo::Excelx.new(self.file_path.path, nil, :ignore)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        print_hash = Hash[[header, spreadsheet.row(i)].transpose]

        if print_hash.present? && !print_hash.any? {|k,v| v.nil? }

          if print_hash["CPF"].to_s.length == 14
            cpf = print_hash["CPF"].gsub('-','').gsub('.','').to_s
          else
            cpf = print_hash["CPF"].to_s
          end

          if cpf.length <= 12
            cpf = '%011d' % cpf.to_i
          end
          if cpf.length > 11
            cpf = cpf.to_i
          end


          @candidate = ::Candidate::Cadastre.find_by_cpf(cpf)
          @unit = Address::Unit.find_by_complete_address(print_hash["ENDERECO"]) if print_hash["ENDERECO"].present?
          @unit_candidate = @unit.current_cadastre_address if @unit.present?


          descriptive = 0
          if @candidate.present?
            units = @candidate.cadastre_address.select(:unit_id).distinct if @candidate.cadastre_address.present?
            if units.present?
              units.each do |addr|
                @unit_find = ::Address::Unit.find(addr.unit_id)
                @unit_candidate_find = @unit_find.current_cadastre_address if @unit_find.present?
              end
            end



            if @allotment.print_type.id == 1 && @unit.present?
              descriptive = 1 if @unit.notary_office.declaratory_act_number.present?
              if @unit.current_cadastre_address.present?
                descriptive = 2 if @unit.notary_office.rejection_number.present? && @unit.current_cadastre_address.dominial_chain > "0"
                descriptive = 3 if @unit.notary_office.rejection_number.present? && @unit.current_cadastre_address.dominial_chain == "0"
              end
            end

          if @unit_candidate.present?
             if %w(reserva distribuído).include?(@unit_candidate.situation_id.to_s) && @unit_candidate.cadastre_id == @candidate.id
                 @unit_ok =  @unit_candidate
             end
          end
         end

          print_new = Address::PrintUnitCadastre.new

          print_new.cadastre_id              = @candidate.present? ? @candidate.id : nil
          print_new.cpf                      = cpf
          print_new.print_allotment_id       = self.print_allotment_id
          print_new.status                   = true
          print_new.unit_id                  = @unit.present? ? @unit.id : nil
          print_new.current_unit_id          = @unit_candidate_find.present? ? @unit_candidate_find.unit_id : nil
          print_new.descriptive_type         = descriptive
          
          begin
            print_new.save!
          rescue Exception => e
            errors.add(:file_path, "Ocorreu um erro ao processar, cpf: #{print_new.cpf}, #{e.message}")
          end
          @unit_ok = nil
        end
      end
    end

  end
end
