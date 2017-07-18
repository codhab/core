require_dependency 'core/application_presenter'

module Core
  module Document
    class DataPrintPresenter < ApplicationPresenter

      def write_document(template)
        template = template.gsub('doc.nome', self.name).gsub('doc.cpf', self.cpf.format_cpf)
        template = template.gsub('doc.nacionalidade', self.nationality).gsub('doc.profissao', self.employment)
        template = template.gsub('doc.estado_civil', self.civil_state.name).gsub('doc.rg', self.rg)
        template = template.gsub('doc.expeditor', self.rg_org).gsub('doc.uf_rg', self.rg_uf)
        template = template.gsub('doc.processo', self.document_number)
        if self.spouse_cpf.present?
          template = template.gsub('doc.conjuge_nome', " e #{self.spouse_name} ")
          template = template.gsub('doc.conj_cpf', ", inscrito no CPF nº #{self.spouse_cpf} ").gsub('doc.nac_conjuge', self.spouse_nationality)
          template = template.gsub('doc.prof_conju', self.spouse_employment).gsub('doc.est_civil', self.spouse_civil_state.name) if self.spouse_civil_state.present?
          template = template.gsub('doc.registro_geral', ", e portador da CI nº #{self.spouse_rg} ").gsub('doc.reg_exp', self.spouse_rg_org)
          template = template.gsub('doc.reg_uf', self.spouse_rg_uf)
          template = template.gsub('doc.regime_casamento', self.wedding_regime) if self.wedding_regime?
          template = template.gsub('doc.data_casamento', self.wedding_date) if self.wedding_date?
        else
          template = template.gsub('doc.conjuge_nome,', "").gsub('doc.conj_cpf,', "").gsub('doc.nac_conjuge,', "")
          template = template.gsub('doc.prof_conju,', "").gsub('doc.conj_cpf,', "").gsub('doc.est_civil,', "")
          template = template.gsub('doc.registro_geral,', "").gsub('doc.reg_exp,', "").gsub('doc.reg_uf,', "")
          template = template.gsub('doc.regime_casamento,', "").gsub('doc.conj_cpf,', "").gsub('doc.data_casamento,', "")
        end
        template = template.gsub('doc.cidade', self.city.name) if self.city.present?
        template = template.gsub('doc.estado', self.city.state.name) if self.city.present?
        template = template.gsub('doc.endereco', self.complete_address).gsub('doc.tipo_posse', self.ownership_type.name) if self.ownership_type.present?
        template = template.gsub('doc.data_ocupacao', self.ocupation.strftime('%d/%m/%Y')).gsub('doc.matricula', self.unit_code) if self.ocupation.present?
        template = template.gsub('doc.cartorio', self.office).gsub('doc.iptu', self.registration_iptu)
        template = template.gsub('doc.ato_declaratorio', self.declaratory_act_number).gsub('doc.certificado_sefaz', self.certificate_sefaz)
        template = template.gsub('doc.data_certificado', self.date_certificate_sefaz).gsub('doc.validade_certificado', self.validate_certificate_sefaz)
        template = template.gsub('doc.averbacao', self.endorsement) if self.endorsement.present?
        template = template.gsub('doc.area', self.area)
        template = template.gsub('doc.data_ato', self.date_act_declaratory.strftime('%d/%m/%Y')) if self.date_act_declaratory.present?

        return template
      end

    end
  end
end
