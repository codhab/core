require_dependency 'core/application_presenter'

module Core
  module Document
    class DataPrintEx < ApplicationPresenter


      def write_document(template)
        template = template.gsub('doc.nome', "#{self.name}").gsub('doc.cpf', "#{self.cpf.format_cpf}")
        template = self.nationality.present? ? template.gsub('doc.nacionalidade', "#{self.nationality}") : template.gsub('doc.nacionalidade', "BRASILEIRO(A)")
        template = self.employment.present? ? template.gsub('doc.profissao', "#{self.employment}") : template.gsub('doc.profissao', "")
        template = self.civil_state.present? ? template.gsub('doc.est_civil', "#{self.civil_state.name}") : template.gsub('doc.est_civil', "")
        template = self.rg.present? ? template.gsub('doc.rg', self.rg) : template.gsub('doc.rg', "")
        template = template.gsub('doc.expeditor', "#{self.rg_org}/#{self.rg_uf}") if self.rg_org.present? && self.rg_uf.present?
        template = self.document_number.present? ? template.gsub('doc.processo', "#{self.document_number}") : template.gsub('doc.processo', "")
        template = self.mother_name.present? ? template.gsub('doc.mae', "#{self.mother_name}") : template.gsub('doc.mae', "")

        if !self.mother_name.blank?
          template = self.father_name.present? ? template.gsub('doc.pai', "e de #{self.father_name}") : template.gsub('doc.pai', "")
        end

        if self.spouse_cpf.present?

          married  = ""

          if self.spouse_name.present?
            married += "#{self.spouse_name}, inscrito no CPF nº #{self.spouse_cpf.format_cpf} " rescue ""
          end

          married  += self.spouse_nationality.present? ? "#{self.spouse_nationality}, " :  nil
          married  += self.spouse_employment.present? ?  "#{self.spouse_employment}, " : nil
          married  += self.spouse_civil_state_id.present? ? "#{self.spouse_civil_state.name}, "   : nil
          married  += self.spouse_rg.present? ? "e portador(a) da CI nº #{self.spouse_rg.to_s} " : nil
          married  += (self.spouse_rg_org.present? && self.spouse_rg_uf.present?) ? "#{self.spouse_rg_org}/#{self.spouse_rg_uf}, " : nil
          married  += (self.wedding_regime.present? && self.wedding_date.present?) ? "casados em #{self.wedding_regime} em #{self.wedding_date}" : nil

          if self.spouse_mother_name.present?
            married += self.spouse_mother_name.present? ? ", filho(a) de #{self.spouse_mother_name}" : nil
          end

          if self.spouse_father_name.present?
            married += self.spouse_father_name.present? ? " e de #{self.spouse_father_name}" : nil
          end

          template = template.gsub('doc.casamento', "#{married}")
        else

          template = template.gsub('doc.casamento', "")
        end

        self.allotment.data_prints.where(complete_address: self.complete_address).where.not(id: self.id).each do |second|
          template = template.gsub('doc.second_nome', "#{second.name} ").gsub('doc.second_cpf', "#{second.cpf.format_cpf} ")
          template = second.nationality.present? ? template.gsub('doc.second_nacionalidade', "#{second.nationality} ") : template.gsub('doc.nacionalidade', "BRASILEIRO(A)")
          template = second.employment.present? ? template.gsub('doc.second_profissao', "#{second.employment} ") : template.gsub('doc.profissao', "")
          template = second.civil_state.present? ? template.gsub('doc.second_est_civil', "#{second.civil_state.name} ") : template.gsub('doc.est_civil', "")
          template = template.gsub('doc.second_expeditor', "#{second.rg}, #{second.rg_org}/#{second.rg_uf} ") if self.rg_org.present? && self.rg_uf.present?
          template = second.document_number.present? ? template.gsub('doc.processo', "#{second.document_number}") : template.gsub('doc.processo', "")

          template = template.gsub('doc.second_certificado_sefaz', second.certificate_sefaz) if second.certificate_sefaz.present?
          template = template.gsub('doc.second_data_certificado', second.date_certificate_sefaz) if second.date_certificate_sefaz.present?
          template = template.gsub('doc.second_validade_certificado', second.validate_certificate_sefaz) if second.validate_certificate_sefaz.present?

          if second.mother_name.present?
            template = second.mother_name.present? ? template.gsub('doc.second_mae', "#{second.mother_name}") : template.gsub('doc.second_mae', "")
          end

          if second.father_name.present?
            template = second.father_name.present? ? template.gsub('doc.second_pai', "#{second.father_name}, ") : template.gsub('doc.second_pai', "")
          end

          if second.spouse_cpf.present?

            married  = ""

            if second.spouse_name.present?
              married += "#{second.spouse_name}, inscrito no CPF nº #{second.spouse_cpf.format_cpf}, " rescue ""
            end

            married  += second.spouse_nationality.present? ? "#{second.spouse_nationality}, " :  nil
            married  += second.spouse_employment.present? ?  "#{second.spouse_employment}, " : nil
            married  += second.spouse_civil_state_id.present? ? "#{second.spouse_civil_state.name}, "   : nil
            married  += second.spouse_rg.present? ? "e portador(a) da CI nº #{second.spouse_rg.to_s} " : nil
            married  += (second.spouse_rg_org.present? && second.spouse_rg_uf.present?) ? "#{second.spouse_rg_org}/#{second.spouse_rg_uf}, " : nil
            married  += (second.wedding_regime.present? && second.wedding_date.present?) ? "casados em #{second.wedding_regime} em #{second.wedding_date} " : nil

            if second.spouse_mother_name.present?
              married += second.spouse_mother_name.present? ? ", filho(a) de #{second.spouse_mother_name}" : nil
            end

            if second.spouse_father_name.present?
              married += second.spouse_father_name.present? ? " e de #{second.spouse_father_name}" : nil
            end

            template = template.gsub('doc.second_casamento', "#{married}")
          else

            template = template.gsub('doc.second_casamento', "")
          end

        end

        if self.city.present?
          template =  template.gsub('doc.cidade', "#{self.city.name}")
          template = template.gsub('doc.estado', self.city.state.name)
        else
          template = template.gsub('doc.cidade', "")
          template = template.gsub('doc.estado', "")
        end

        template = template.gsub('doc.endereco', self.complete_address) if self.complete_address.present?
        template = template.gsub('doc.tipo_posse', self.ownership_type.name) if self.ownership_type.present?
        template = template.gsub('doc.data_ocupacao', self.ocupation.strftime('%d/%m/%Y')) if self.ocupation.present?
        template = template.gsub('doc.matricula', self.unit_code.to_s) if self.unit_code.present?
        template = template.gsub('doc.cartorio', self.office) if self.office.present?
        template = template.gsub('doc.iptu', self.registration_iptu) if self.registration_iptu.present?
        template = template.gsub('doc.ato_declaratorio', self.declaratory_act_number) if self.declaratory_act_number.present?
        template = template.gsub('doc.certificado_sefaz', self.certificate_sefaz) if self.certificate_sefaz.present?
        template = template.gsub('doc.data_certificado', self.date_certificate_sefaz) if self.date_certificate_sefaz.present?
        template = template.gsub('doc.validade_certificado', self.validate_certificate_sefaz) if self.validate_certificate_sefaz.present?
        template = template.gsub('doc.averbacao', self.endorsement) if self.endorsement.present?
        template = template.gsub('doc.area', self.area) if self.area.present?
        template = template.gsub('doc.data_ato', self.date_act_declaratory.strftime('%d/%m/%Y')) if self.date_act_declaratory.present?
        template = template.gsub('doc.data_doc', self.allotment.data_document.strftime('%d/%m/%Y')) if self.allotment.present? && self.allotment.data_document.present?

        if self.allotment.property_value.present?
          template = template.gsub('doc.valor_fiscal', self.allotment.property_value)
        elsif self.property_value.present?
          template = template.gsub('doc.valor_fiscal', self.property_value)
        else
          template = template.gsub('doc.valor_fiscal', "")
        end

        template = template.gsub('doc.data_hoje', "#{Date.current.strftime('%d/%m/%Y')}")

        return template

      end

      def write_document2(template)
        template = template.gsub('doc.nome', "#{self.name}").gsub('doc.cpf', "#{self.cpf.format_cpf}")
        template = self.nationality.present? ? template.gsub('doc.nacionalidade', "#{self.nationality}") : template.gsub('doc.nacionalidade', "BRASILEIRO(A)")
        template = self.employment.present? ? template.gsub('doc.profissao', "#{self.employment}") : template.gsub('doc.profissao', "")
        template = self.civil_state.present? ? template.gsub('doc.est_civil', "#{self.civil_state.name}") : template.gsub('doc.est_civil', "")
        template = self.rg.present? ? template.gsub('doc.rg', self.rg) : template.gsub('doc.rg', "")
        template = template.gsub('doc.expeditor', "#{self.rg_org}/#{self.rg_uf}") if self.rg_org.present? && self.rg_uf.present?
        template = self.document_number.present? ? template.gsub('doc.processo', "#{self.document_number}") : template.gsub('doc.processo', "")
        template = self.mother_name.present? ? template.gsub('doc.mae', "#{self.mother_name}") : template.gsub('doc.mae', "")

        if self.mother_name.present?
          template = self.father_name.present? ? template.gsub('doc.pai', "e de #{self.father_name}") : template.gsub('doc.pai', "")
        else
          template = self.father_name.present? ? template.gsub('doc.pai', "#{self.father_name}") : template.gsub('doc.pai', "")
        end


        self.allotment.data_prints.where(complete_address: self.complete_address).where.not(id: self.id).each do |second|
          template = template.gsub('doc.second_nome', "#{second.name}").gsub('doc.second_cpf', "#{second.cpf.format_cpf}")
          template = second.nationality.present? ? template.gsub('doc.second_nacionalidade', "#{second.nationality}") : template.gsub('doc.second_nacionalidade', "BRASILEIRO(A)")
          template = second.employment.present? ? template.gsub('doc.second_profissao', "#{second.employment}") : template.gsub('doc.second_profissao', "")
          template = second.civil_state.present? ? template.gsub('doc.second_est_civil', "#{second.civil_state.name}") : template.gsub('doc.second_est_civil', "")
          template = second.rg.present? ? template.gsub('doc.second_rg', second.rg) : template.gsub('doc.second_rg', "")
          template = template.gsub('doc.second_expeditor', "#{second.rg_org}/#{second.rg_uf}") if second.rg_org.present? && second.rg_uf.present?
          template = second.document_number.present? ? template.gsub('doc.second_processo', "#{second.document_number}") : template.gsub('doc.second_processo', "")
          template = second.mother_name.present? ? template.gsub('doc.second_mae', "#{second.mother_name}") : template.gsub('doc.second_mae', "")

          if second.mother_name.present?
            template = second.father_name.present? ? template.gsub('doc.second_pai', "e de #{second.father_name}") : template.gsub('doc.second_pai', "")
          else
            template = second.father_name.present? ? template.gsub('doc.second_pai', "#{second.father_name}") : template.gsub('doc.second_pai', "")
          end


          if second.spouse_cpf.present?
            template = template.gsub('doc.second_conjuge_nome', "#{second.spouse_name}, inscrito no CPF nº #{second.spouse_cpf.format_cpf} ")

            #template = template.gsub('doc.second_conj_cpf', ", inscrito no CPF nº #{self.spouse_cpf.format_cpf} ") if self.spouse_cpf.present?
            template = second.spouse_nationality.present? ? template.gsub('doc.second_nac_conjuge', "#{second.spouse_nationality}") : template.gsub('doc.second_nac_conjuge', "")
            template = second.spouse_employment.present? ? template.gsub('doc.second_prof_conju', "#{second.spouse_employment}") : template.gsub('doc.second_prof_conju', "")
            template = second.spouse_civil_state_id.present? ? template.gsub('doc.second_estciv_conj', "#{second.spouse_civil_state.name rescue "<span style='color: red'>Completar</span>".html_safe}") : template.gsub('doc.second_estciv_conj', "")
            template = template.gsub('doc.second_registro_geral', "e portador(a) da CI nº #{second.spouse_rg.to_s}") if second.spouse_rg.present?
            template = template.gsub('doc.second_reg_exp', "#{second.spouse_rg_org}/#{second.spouse_rg_uf}") if second.spouse_rg_org.present? && second.spouse_rg_uf.present?
            template = second.wedding_regime.present? && second.wedding_date.present? ? template.gsub('doc.second_regime_casamento', "casados em #{second.wedding_regime} em #{second.wedding_date}") : template.gsub('doc.second_regime_casamento',"")
            if second.married.present?
              template = template.gsub('doc.second_casado', "#{second.married}")
            else
              template = template.gsub('doc.second_casado', "e")
            end

            if second.spouse_mother_name.present?
              template = second.spouse_mother_name.present? ? template.gsub('doc.second_conjuge_mae', "#{second.spouse_mother_name}") : template.gsub('doc.second_conjuge_mae', "")
            end

            if second.spouse_mother_name.present?
              template = second.spouse_father_name.present? ? template.gsub('doc.second_conjuge_pai', "e de #{second.spouse_father_name}") : template.gsub('doc.second_conjuge_pai', "")
            else
              template = second.spouse_father_name.present? ? template.gsub('doc.second_conjuge_pai', "#{second.spouse_father_name}") : template.gsub('doc.conjuge_pai', "")
            end

          else
            template = template.gsub('doc.casado', "")
            template = template.gsub('doc.conjuge_nome', "").gsub('doc.conj_cpf', "").gsub('doc.nac_conjuge', "")
            template = template.gsub('doc.prof_conju', "").gsub('doc.conj_cpf', "").gsub('doc.estciv_conj', "")
            template = template.gsub('doc.registro_geral', "").gsub('doc.reg_exp', "").gsub('doc.reg_uf', "")
            template = template.gsub('doc.regime_casamento', "").gsub('doc.conj_cpf', "").gsub('doc.data_casamento', "")
          end
        end


      end

    end
  end
end
