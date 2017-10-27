require_dependency 'core/application_presenter'

module Core
  module Document
    class DataPrintPresenter < ApplicationPresenter

      def write_document(template)
        template = template.gsub('doc.nome', "#{self.name},").gsub('doc.cpf', "#{self.cpf.format_cpf},")
        template = self.nationality.present? ? template.gsub('doc.nacionalidade', "#{self.nationality},") : template.gsub('doc.nacionalidade', "BRASILEIRO(A)")
        template = self.employment.present? ? template.gsub('doc.profissao', "#{self.employment},") : template.gsub('doc.profissao', "")
        template = self.civil_state.present? ? template.gsub('doc.est_civil', "#{self.civil_state.name},") : template.gsub('doc.est_civil', "")
        template = self.rg.present? ? template.gsub('doc.rg', self.rg) : template.gsub('doc.rg', "")
        template = template.gsub('doc.expeditor', "#{self.rg_org}/#{self.rg_uf}") if self.rg_org.present? && self.rg_uf.present?
        template = self.document_number.present? ? template.gsub('doc.processo', "#{self.document_number},") : template.gsub('doc.processo', "")
        if self.spouse_cpf.present?
          template = template.gsub('doc.conjuge_nome', "#{self.spouse_name}, inscrito no CPF nº #{self.spouse_cpf.format_cpf}, ")
          #template = template.gsub('doc.conj_cpf', ", inscrito no CPF nº #{self.spouse_cpf.format_cpf} ") if self.spouse_cpf.present?
          template = self.spouse_nationality.present? ? template.gsub('doc.nac_conjuge', "#{self.spouse_nationality},") : template.gsub('doc.nac_conjuge', "")
          template = self.spouse_employment.present? ? template.gsub('doc.prof_conju', "#{self.spouse_employment},") : template.gsub('doc.prof_conju', "")
          template = self.spouse_civil_state_id.present? ? template.gsub('doc.estciv_conj', "#{self.spouse_civil_state.name rescue "<span style='color: red'>Completar</span>".html_safe},") : template.gsub('doc.estciv_conj', "")
          template = template.gsub('doc.registro_geral', "e portador da CI nº #{self.spouse_rg} ") if self.spouse_rg.present?
          template = template.gsub('doc.reg_exp', "#{self.spouse_rg_org}/#{self.spouse_rg_uf}") if self.spouse_rg_org.present? && self.spouse_rg_uf.present?
          template = self.wedding_regime.present? && self.wedding_date.present? ? template.gsub('doc.regime_casamento', "casados em #{self.wedding_regime} em #{self.wedding_date},") : template.gsub('doc.regime_casamento',"")
          if self.married.present?
            template = template.gsub('doc.casado', "#{self.married}")
          else
            template = template.gsub('doc.casado', "e")
          end
        else
          template = template.gsub('doc.casado', "")
          template = template.gsub('doc.conjuge_nome', "").gsub('doc.conj_cpf', "").gsub('doc.nac_conjuge', "")
          template = template.gsub('doc.prof_conju', "").gsub('doc.conj_cpf', "").gsub('doc.estciv_conj', "")
          template = template.gsub('doc.registro_geral', "").gsub('doc.reg_exp', "").gsub('doc.reg_uf', "")
          template = template.gsub('doc.regime_casamento', "").gsub('doc.conj_cpf', "").gsub('doc.data_casamento', "")
        end
        if self.city.present?
          template =  template.gsub('doc.cidade', "#{self.city.name},")
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
        return template
      end

    end
  end
end
