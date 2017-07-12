require_dependency 'core/application_presenter'

module Core
  module Document
    class DataPrintPresenter < ApplicationPresenter

      def write_document(template)
        template = template.gsub('doc.nome', self.name).gsub('doc.cpf', self.cpf.format_cpf)
        template = template.gsub('doc.nacionalidade', self.nationality).gsub('doc.profissao', self.employment)
        template = template.gsub('doc.estado_civil', self.civil_state.name).gsub('doc.rg', self.rg)
        template = template.gsub('doc.rg_org', self.rg_org).gsub('doc.rg_uf', self.rg_uf)
        template = template.gsub('doc.processo', self.document_number).gsub('doc.regime_casamento', self.wedding_regime)
        template = template.gsub('doc.data_casamento', self.wedding_date).gsub('doc.nome_conjuge', self.spouse_name)
        template = template.gsub('doc.cpf_conjuge', self.spouse_cpf).gsub('doc.nacionalidade_conjuge', self.spouse_nationality)
        template = template.gsub('doc.profissao_conjuge', self.spouse_employment).gsub('doc.est_civil_conjuge', self.spouse_civil_state.name) if self.spouse_civil_state.present?
        template = template.gsub('doc.rg_conjuge', self.spouse_rg).gsub('doc.rg_org_conjuge', self.spouse_rg_org)
        template = template.gsub('doc.rg_uf_conjuge', self.complete_address).gsub('doc.cidade', self.city.name) if self.city.present?
        template = template.gsub('doc.endereco', self.complete_address).gsub('doc.tipo_posse', self.ownership_type.name) if self.ownership_type.present?
        template = template.gsub('doc.data_ocupacao', self.ocupation).gsub('doc.matricula', self.unit_code) if self.ocupation.present?
        template = template.gsub('doc.cartorio', self.office).gsub('doc.iptu', self.registration_iptu)
        template = template.gsub('doc.ato_declaratorio', self.declaratory_act_number).gsub('doc.certificado_sefaz', self.certificate_sefaz)
        template = template.gsub('doc.data_certificado', self.date_certificate_sefaz).gsub('doc.validade_certificado', self.validate_certificate_sefaz)
        template = template.gsub('doc.averbacao', self.endorsement).gsub('doc.data_ato', self.date_act_declaratory) if self.date_act_declaratory.present?

        return template
      end

    end
  end
end
