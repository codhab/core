module Address
  class DescriptiveDocument
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :descriptive, :office, :cadastre, :staff, :unit

    # => tipos de fichas que podem ser emitidas
    # coloquei esses atributos para segurar os erros
    attr_accessor :suspended, :exempt, :not_exempt, :type_document

    attr_accessor :text, :description

    # => validações

    # => verifica se é possível emitir a ficha descritiva feliz.
    # essa possibilidade é uma refatoração baseada em DRY 
    # se TRUE, verifica-se qual das fichas vai ser emitida. As vezes não cai em nenhuma
    # a regra de negócio é antiga e desatualizada. responsável => DIREG

    validate :cadastre_addresses_present?
    validate :allow_for_printing? 

    after_validation 

    def initialize(unit, staff)
      @unit   = unit
      @staff  = staff

      mount_document!
      mount_text_for_printing!
    end

        # => escrevendo log de emissão

    def write_log!
      # TODO
      @log = ::Candidate::CadastreActivity.new({
        cadastre_id: @cadastre.id,
        staff_id: @staff.id,
        activity_status_id: 18, #impressão de certidão positiva
        observation: @description,
        type_activity: 2
      })

      @log.save
    end


    private

    def mount_document!
      if type_suspended?
        @type_document = 1 
      elsif type_exempt?
        @type_document = 2
      elsif type_not_exempt?
        @type_document = 3
      else
        errors.add(:descriptive, "Não foi possível emitir a ficha, nenhuma das regras conseguiu ser aplicada a este CPF")
      end
    end

    def mount_text_for_printing!
      if @type_document == 1
        @text = "Observação: Beneficiário originário - O Distrito Federal, por seu representante legal, DECLARA Suspensa
          a Exigibilidade do Imposto sobre a Transmissão Causa Mortis ou Doação de Quaisquer Bens e Direitos  -
          ITCD, fundamentada na Lei 4.997/2012 de 19 de dezembro de 2012, Conforme   ato   declaratório  n º #{@unit.notary_office.declaratory_act_number}
          - GEESP/COTRI/SUREC/SEEF, de #{@unit.notary_office.date_act_declaratory.strftime('%d/%m/%Y')}"
        
        @description = "Tipo de Ficha - Suspenso ITBI"
      end 

      if @type_document == 2
          @text = "Observação: Beneficiário originário, isento de Imposto sobre Transmissão causa  mortis  e  doação  de
            quaisquer bens ou direitos  - ITCD, na forma da Lei Complementar nº 353/2001,   regulamentada  pelo
            Decreto nº 21.972/2001, conforme Ato Declaratório DITRI/SUREC/SEF #{@unit.notary_office.declaratory_act_number} publicado
            #{@unit.notary_office.date_act_declaratory.strftime('%d/%m/%Y')}."
          @description = "Tipo de Ficha - Isento"
      end

      if @type_document == 3

        if @unit.current_cadastre_address.dominial_chain > "0"
          @text = "Observação: Beneficiário não originário,  sem isenção de Imposto sobre Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
          - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001, Conforme   ato   declaratório  n º #{@unit.notary_office.rejection_number}
          - GEESP/COTRI/SUREC/SEEF, de #{@unit.notary_office.date_act_rejection.strftime('%d/%m/%Y')}." 
        end 

        if @unit.current_cadastre_address.dominial_chain == "0"
          @text = "Observação: Beneficiário originário,  sem isenção  de Imposto sobre  Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
          - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001, Conforme   ato   declaratório  n º #{@unit.notary_office.rejection_number}
          - GEESP/COTRI/SUREC/SEEF, de #{@unit.notary_office.date_act_rejection.strftime('%d/%m/%Y')}."
        end 

        if @unit.no_exemption
          @text = "Beneficiário originário, SEM ISENÇÃO - beneficiário desistiu da Isenção do Imposto sobre a Transmissão Causa Mortis e Doação de Quaisquer Bens ou Direito
          - ITCD na forma da Lei Complementar nº 229 de 05 de julho de 1999, regulamentada pelo Decreto nº 21.972 de 07 de março de 2001." 
          @description = "Tipo de Ficha - Não isento"
        end

      end    
    end

    def cadastre_addresses_present?
      # => é necessário que o imóvel tenha registros de vínculo com candidatos da base
      if !@unit.current_cadastre_address.present?
        errors.add(:descriptive, "Endereço não possuí vínculo com nenhum candidato")
      else
        @cadastre = @unit.current_cadastre_address.cadastre
      end
    end

    # => verifica se a ficha pode ser emitida para o CPF vínculado a unidade
    def allow_for_printing?
      @office = @unit.notary_office

      # => verfica a situação da escrituração do imóvel
      # vínculo feito em address_registry_units junto a um :enum interno
      # => a situação de escrituração atual do imóvel não pode está como *não*
      # deve estar como :em_fase de escrituração ou :sim, no caso escriturada 
      if @unit.current_registry_id != "não"
        errors.add(:descriptive, "Imóvel não esta em fase ou já escriturado. Atualize os dados de escrituração") 
      end

      # => O código de matrícula do imóvel precisa estar presente
      # tabela :address_notary_offices, esse vínculo é feito por um :has_one
      if !@office.unit_code.present?
        errors.add(:descriptive, "Matrícula da unidade não pode está vazio.")
      end

      # => O imovel não pode ter o campo requerimento, dado com Exigência com dados
      # não sei pq mas nesse contexto não existe validção para data de exigência.
      if @office.requeriment.present?
        errors.add(:descriptive, "Imóvel possuí exigência. Verifique em registros do imóvel")
      end

      # => O imovel não pode estar marcado como doado
      # campo :donate na tabela :address_units
      if !@unit.donate
        errors.add(:descriptive, "Imóvel não está marcado como doado.")
      end

      # => O imóvel não pode estar com a situação de *imóvel distribuido*, :id => 3
      # tabela :address_situation_units
      if !@unit.situation_unit_id == 3
        errors.add(:descriptive, "Imóvel não pode estar em situação de *Distribuído")
      end

    end

    # => tipos de fichas a serem emitidas
    # o retorno dos erros dos metódos abaixo são atribuidos aos atributos
    # :suspended, :exempt, :not_exempt
    def type_suspended?

      return false if self.errors[:descriptive].present? 

      @office = @unit.notary_office

      # => Nº e data do ato declaratorio não estar ser vazias
      # esse metódo eu fiz junção de dois outros que estavam no código antigo. No cry.
      if !@office.declaratory_act_number.present? || !@office.date_act_declaratory.present?
        errors.add(:suspended, "Nº e data do ato declaratorio não estar ser vazias")
      end

      # => Data do ato declaratório precisa estar entre 18/12/2012 e 01/01/2014
      if !@office.date_act_declaratory.between?(Date.parse('2012-12-18'), Date.parse('2014-01-01'))
        errors.add(:suspended, "Data do ato declaratório precisa estar entre 18/12/2012 e 01/01/2014")
      end
      
      # => O tipo de uso do imóvel não pode estar entre os abaixo:
      # 1 :  "residencial"
      # 2 :  "becos"
      # 3 :  "resid. financiado"
      # 6 :  "Habitação e Comércio"
      # 8 :  "Hab.Comercio/Financ."
      # 10:  "Habitação/Comércio*"
      # 11:  "misto"
      # 12:  "habitação/comércio"
      # 507: "PROMORADIA"
      # 510: "Multiro"
      if ![1,2,3,6,8,10,11,12,507,510].include? @unit.type_use_unit_id
        errors.add(:suspended, "O imóvel não esta em um tipo de uso permitido para emissão da ficha descritiva. Verifique.")
      end

      return true if !self.errors[:suspended].present?
    end

    def type_exempt?

      return false if self.errors[:descriptive].present? 
      
      @office = @unit.notary_office

      # => Nº e data do ato declaratorio não estar ser vazias
      # esse metódo eu fiz junção de dois outros que estavam no código antigo. No cry.
      # e sim tem duplicação de código com a outra ficha acima
      if !@office.declaratory_act_number.present? || !@office.date_act_declaratory.present?
        errors.add(:exempt, "Nº e data do ato declaratorio não estar ser vazias")
      end


      # => Data do ato declaratório não pode estar entre 19/12/2012 e 31/12/2014
      if @office.date_act_declaratory.between?(Date.parse('2012-12-19'), Date.parse('2013-12-31'))
        errors.add(:exempt, "Data do ato declaratório não pode estar entre 19/12/2012 e 31/01/2013")
      end

      # => O tipo de uso do imóvel não pode estar entre os abaixo:
      # 1 :  "residencial"
      # 2 :  "becos"
      # 3 :  "resid. financiado"
      # 6 :  "Habitação e Comércio"
      # 8 :  "Hab.Comercio/Financ."
      # 10:  "Habitação/Comércio*"
      # 11:  "misto"
      # 12:  "habitação/comércio"
      # 507: "PROMORADIA"
      # 510: "Multiro"

      # duplicado no metódo de cima. to-do
      if ![1,2,3,6,8,10,11,12,507,510].include? @unit.type_use_unit_id
        errors.add(:exempt, "O imóvel não esta em um tipo de uso permitido para emissão da ficha descritiva. Verifique.")
      end

      # => A data pcu que aqui esta vínculada ao :created_at não pode ser maior ou igual que 01/01/2008 e menor igual 01/01/2011
      # logo não pode estar entre 01/01/2008 e 01/01/2011
      if @unit.current_cadastre_address.created_at.between?(Date.parse('2008-01-01'), Date.parse('2011-01-01'))
        errors.add(:exempt, "Data da procuração não pode estar entre 01/01/2008 e 01/01/2011")
      end

      return true if !self.errors[:exempt].present?
    end

    def type_not_exempt?

      return false if self.errors[:descriptive].present? 
      
      @office = @unit.notary_office

      if !@office.rejection_number.present?
        errors.add(:not_exempt, "Nº de indeferimento não está preenchido")
      end

      # => Tipos de regularização vinculados na :candidate_cadastre_address

      #1: vila planalto-lei 5135-doação
      #2: vila planalto-lei 5135-venda
      #3: vila planalto-lei 5135-licita
      #4: reg 34213-inv.lt 250m2-gdf venda
      #6: reg. 34210-invasão(gdf licita)
      #7: reg. 34210-compra(gdf licita)
      #8: regularização decisão judicial
      #9: regularização por rd
      #10: reg. 34210-compra (gdf vende)
      #11: reg. 34210-invasão (gdf doa)
      #12: reg. 34210-compra (gdf doa)
      #13: reg. 34210-invasão (gdf vende)
      #14: reg. 34210-originario (gdf doa)
      #15: regularização por compra
      #16: regularização por invasão
      #17: regularização por permuta

      if !@unit.current_cadastre_address.regularization_type_id.present?
        errors.add(:not_exempt, "Tipo de regularização não está preenchido ou não tem um valor válido para emissão.")
      end

      # => tipo de regularização não pode estar entre os abaixo:

      #8: regularização decisão judicial
      #9: regularização por rd
      #10: reg. 34210-compra (gdf vende)
      #11: reg. 34210-invasão (gdf doa)
      #12: reg. 34210-compra (gdf doa)
      #13: reg. 34210-invasão (gdf vende)
      #14: reg. 34210-originario (gdf doa)
      #15: regularização por compra
      #16: regularização por invasão
      #17: regularização por permuta

      # ou

      #O morador atual ser o originario e o numero do ato de indeferimento está preenchido
      
      if !@unit.current_cadastre_address.regularization_type_id >= 8
        errors.add(:not_exempt, "O tipo de regularização vínculado ao cadastro do morador não é válido para emissão")
      end

      if @unit.current_cadastre_address.dominial_chain == 0 && @office.rejection_number.present?
        errors.add(:not_exempt, "O morador atual é o originário e o imóvel possuí ato de indeferimento. Isso impede a emissão.")
      end


      # => O tipo de uso do imóvel não pode estar entre os abaixo:
      # 1 :  "residencial"
      # 2 :  "becos"
      # 3 :  "resid. financiado"
      # 6 :  "Habitação e Comércio"
      # 8 :  "Hab.Comercio/Financ."
      # 10:  "Habitação/Comércio*"
      # 11:  "misto"
      # 12:  "habitação/comércio"
      # 507: "PROMORADIA"
      # 510: "Multiro"

      if [1,2,3,4,8,10,11,507,510].include? @unit.type_use_unit_id
        errors.add(:not_exempt, "O imóvel não esta em um tipo de uso permitido para emissão da ficha descritiva. Verifique.")
      end
      
      return true if !self.errors[:not_exempt].present?
    end



  end
end
