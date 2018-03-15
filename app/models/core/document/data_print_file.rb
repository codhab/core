module Core
  module Document
    class DataPrintFile
      include ActiveModel::Model

      attr_accessor :file_path, :allotment_id

      validates :file_path,  presence: true
      validates :file_path, file_size: { less_than_or_equal_to: 10.megabytes.to_i }
      validates :file_path, file_content_type: { allow: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'], message: 'Somente arquivos .xlsx' }

      def import_files!(user)
        return false unless self.valid?
        @allotment = Core::Document::Allotment.find(self.allotment_id)

        spreadsheet = Roo::Excelx.new(self.file_path.path, nil, :ignore)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          print_hash = Hash[[header, spreadsheet.row(i)].transpose]
          if print_hash.present?

            ## Main Cpf
            if print_hash["cpf"].to_s.length == 14
              cpf = print_hash["cpf"].gsub('-','').gsub('.','').to_s
            else
              cpf = print_hash["cpf"].to_s
            end

            if cpf.length <= 12
              cpf = '%011d' % cpf.to_i
            end
            if cpf.length > 11
              cpf = cpf.to_i
            end

            if print_hash["cpf_conjuge"].present?
              if print_hash["cpf_conjuge"].to_s.length == 14
                spouse_cpf = print_hash["cpf_conjuge"].gsub('-','').gsub('.','').to_s
              else
                spouse_cpf = print_hash["cpf_conjuge"].to_s
              end

              if spouse_cpf.length <= 12
                spouse_cpf = '%011d' % spouse_cpf.to_i
              end
              if spouse_cpf.length > 11
                spouse_cpf = spouse_cpf.to_i
              end
            end


            print_new = Core::Document::DataPrint.new

            print_new.allotment_id               = @allotment.id
            print_new.name                       = print_hash["nome"]
            print_new.cpf                        = cpf
            print_new.civil_state_id             = print_hash["est_civil"]
            print_new.nationality                = print_hash["nacionalidade"]
            print_new.employment                 = print_hash["profissao"]
            rg = print_hash["rg"]
            print_new.rg                         = rg.class == Float ? print_hash["rg"].to_i : print_hash["rg"]
            print_new.rg_org                     = print_hash["rg_org"]
            print_new.rg_uf                      = print_hash["rg_uf"]
            print_new.document_number            = print_hash["processo"]
            print_new.wedding_regime             = print_hash["regime_casamento"]
            print_new.wedding_date               = print_hash["data_casamento"]
            print_new.father_name                = print_hash["pai"]
            print_new.mother_name                = print_hash["mae"]
            print_new.spouse_name                = print_hash["nome_conjuge"]
            print_new.spouse_cpf                 = spouse_cpf
            print_new.spouse_nationality         = print_hash["nacionalidade_conjuge"]
            print_new.spouse_employment          = print_hash["profissao_conjuge"]
            print_new.spouse_civil_state_id      = print_hash["est_civil_conjuge"]
            spouse_rg = print_hash["rg_conjuge"]
            print_new.spouse_rg                  = spouse_rg.class == Float ? print_hash["rg_conjuge"].to_i : print_hash["rg_conjuge"]
            print_new.spouse_rg_org              = print_hash["rg_org_conjuge"]
            print_new.spouse_rg_uf               = print_hash["rg_uf_conjuge"]
            print_new.spouse_mother_name         = print_hash["conjuge_mae"]
            print_new.spouse_father_name         = print_hash["conjuge_pai"]
            print_new.city_id                    = print_hash["cidade"]
            print_new.ownership_type_id          = print_hash["tipo_posse"]
            print_new.complete_address           = print_hash["endereco"]
            print_new.ocupation                  = print_hash["data_ocupacao"]
            code_unit = print_hash["matricula"]
            print_new.unit_code                  = code_unit.class == Float ? print_hash["matricula"].to_i : print_hash["matricula"]
            print_new.office                     = print_hash["cartorio"]
            iptu = print_hash["iptu"]
            print_new.registration_iptu          = iptu.class == Float ? print_hash["iptu"].to_i : print_hash["iptu"]
            print_new.declaratory_act_number     = print_hash["ato_declaratorio"]
            print_new.certificate_sefaz          = print_hash["certificado_sefaz"]
            print_new.date_certificate_sefaz     = print_hash["data_certificado"]
            print_new.validate_certificate_sefaz = print_hash["validade_certificado"]
            print_new.endorsement                = print_hash["averbacao"]
            print_new.date_act_declaratory       = print_hash["data_ato"]
            print_new.address_data_base          = print_hash["endereco_base"]
            print_new.area                       = print_hash["area"]
            print_new.property_value             = print_hash["valor_fiscal"]
            print_new.married                    = print_hash["casado"]
            print_new.staff_id                   = user
            print_new.status                     = true

            begin
              print_new.save!
              @service = Core::Document::DataPrintService.new(print_new)
              @service.update_cadastre!(user)
            rescue Exception => e
              errors.add(:file_path, "Ocorreu um erro ao processar, cpf: #{print_new.cpf}, #{e.message}")
            end
          end
        end
      end

    end
  end
end
