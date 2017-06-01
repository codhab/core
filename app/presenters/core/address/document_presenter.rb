require_dependency 'core/application_presenter'

module Core
  module Address
    class DocumentPresenter < ApplicationPresenter #:nodoc:

      def descriptive_observation(type, unit)
        case type
        when 1
          @text = "Observação: Beneficiário originário - O Distrito Federal, por seu representante legal, DECLARA Suspensa
                   a Exigibilidade do Imposto sobre a Transmissão Causa Mortis ou Doação de Quaisquer Bens e Direitos  -
                   ITCD, fundamentada na Lei 4.997/2012 de 19 de dezembro de 2012, Conforme   ato   declaratório  n º #{unit.notary_office.declaratory_act_number}
                   - GEESP/COTRI/SUREC/SEEF, de #{unit.notary_office.date_act_declaratory.strftime('%d/%m/%Y')}"
                   @description = "Tipo de Ficha - Suspenso ITBI"
        when 2
          @text = "Observação: Beneficiário originário, isento de Imposto sobre Transmissão causa  mortis  e  doação  de
                  quaisquer bens ou direitos  - ITCD, na forma da Lei Complementar nº 353/2001,   regulamentada  pelo
                  Decreto nº 21.972/2001, conforme Ato Declaratório DITRI/SUREC/SEF #{unit.notary_office.declaratory_act_number} publicado
                  #{unit.notary_office.date_act_declaratory.strftime('%d/%m/%Y')}."
                  @description = "Tipo de Ficha - Isento"
        when 3
          @text = "Observação: Beneficiário não originário,  sem isenção de Imposto sobre Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
                  - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001, Conforme   ato   declaratório  n º #{unit.notary_office.rejection_number}
                  - GEESP/COTRI/SUREC/SEEF, de #{unit.notary_office.date_act_rejection.strftime('%d/%m/%Y') if unit.notary_office.date_act_rejection.present? }." if unit.current_cadastre_address.dominial_chain > "0" && unit.notary_office.rejection_number.present?
          @text = "Observação: Beneficiário não originário,  sem isenção de Imposto sobre Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direto." if unit.current_cadastre_address.dominial_chain > "0"
          if unit.notary_office.date_act_rejection.present?
            @text = "Observação: Beneficiário originário,  sem isenção  de Imposto sobre  Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
                    - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001, Conforme   ato   declaratório  n º #{unit.notary_office.rejection_number}
                    - GEESP/COTRI/SUREC/SEEF, de #{unit.notary_office.date_act_rejection.strftime('%d/%m/%Y') if unit.notary_office.date_act_rejection.present?}." if unit.current_cadastre_address.dominial_chain == "0"
          else
            @text = "Observação: Beneficiário originário,  sem isenção  de Imposto sobre  Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
                    - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001."
          end
          @text = "Beneficiário originário, SEM ISENÇÃO - beneficiário desistiu da Isenção do Imposto sobre a Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
                  - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001." if unit.no_exemption
          @description = "Tipo de Ficha - Não isento"
        end
        [@text, @description]
      end
    end
  end
end
