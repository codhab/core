module Core
  module Document
    class DataPrintService

      def initialize(data_print)
        @data_print = data_print
      end

      def create!(cpf,user, allotment)
        cpf = cpf.gsub('.','').gsub('-','')
        @cadastre = Core::Candidate::Cadastre.find_by(cpf: cpf)
        @cadastre = Core::Candidate::CadastrePresenter.new(@cadastre)

        if @cadastre.present?
          @data_print = Core::Document::DataPrint.new(
            name: @cadastre.name,
            cpf: cpf,
            nationality: @cadastre.nationality,
            employment: @cadastre.employment,
            civil_state_id: @cadastre.civil_state_id,
            rg: @cadastre.rg,
            rg_org: @cadastre.rg_org,
            rg_uf: @cadastre.rg_uf,
            document_number: @cadastre.current_procedural.present? && @cadastre.current_procedural.assessment.present? ? @cadastre.current_procedural.assessment.document_number : nil,
            wedding_regime: @cadastre.wedding_regime,
            wedding_date: @cadastre.wedding_date,
            spouse_name: @cadastre.spouse.present? ? @cadastre.spouse.name : nil,
            spouse_cpf: @cadastre.spouse.present? ? @cadastre.spouse.cpf : nil,
            spouse_nationality: @cadastre.spouse.present? ? @cadastre.spouse.nationality : nil,
            spouse_employment: @cadastre.spouse.present? ? @cadastre.spouse.employment : nil,
            spouse_civil_state_id: @cadastre.spouse.present? ? @cadastre.spouse.civil_state_id : nil,
            spouse_rg: @cadastre.spouse.present? ? @cadastre.spouse.rg : nil,
            spouse_rg_org: @cadastre.spouse.present? ? @cadastre.spouse.rg_org : nil,
            spouse_rg_uf: @cadastre.spouse.present? ? @cadastre.spouse.rg_uf_id : nil,
            city_id: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.city_id : nil,
            complete_address: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.complete_address : nil,
            area: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.area : nil,
            address_data_base: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.complete_address : nil,
            ownership_type_id: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.ownership_type_id : nil,
            complete_address: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.complete_address : nil,
            ocupation: @cadastre.current_address.present? ? @cadastre.current_address.created_at.strftime('%d/%m/%Y') : nil,
            registration_iptu: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.registration_iptu : nil,
            unit_code: @cadastre.current_address.present? && @cadastre.current_address.unit.present? && @cadastre.current_address.unit.notary_office.present? ? @cadastre.current_address.unit.notary_office.unit_code : nil,
            office: @cadastre.current_address.present? && @cadastre.current_address.unit.present? && @cadastre.current_address.unit.notary_office.present? ? @cadastre.current_address.unit.notary_office.office : nil,
            declaratory_act_number: @cadastre.current_address.present? && @cadastre.current_address.unit.present? && @cadastre.current_address.unit.notary_office.present? ? @cadastre.current_address.unit.notary_office.declaratory_act_number : nil,
            certificate_sefaz: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.certificate_sefaz : nil,
            date_certificate_sefaz: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.date_certificate_sefaz : nil,
            validate_certificate_sefaz: @cadastre.current_address.present? && @cadastre.current_address.unit.present? ? @cadastre.current_address.unit.validate_certificate_sefaz : nil,
            date_act_declaratory: @cadastre.current_address.present? && @cadastre.current_address.unit.present? && @cadastre.current_address.unit.notary_office.present? ? @cadastre.current_address.unit.notary_office.date_act_declaratory : nil,
            endorsement: @cadastre.current_address.present? && @cadastre.current_address.unit.present? && @cadastre.current_address.unit.notary_office.present? ? @cadastre.current_address.unit.notary_office.endorsement : nil,
            staff_id: user,
            status: true,
            allotment_id: allotment
          )
          return nil unless @data_print.save

        else
          @data_print = Core::Document::DataPrint.new(
            cpf: cpf,
            staff_id: user,
            status: true,
            allotment_id: allotment
          )
          return nil unless @data_print.save
        end
      end

      def update_cadastre!(user)
        @cadastre = Core::Candidate::Cadastre.find_by(cpf: @data_print.cpf)

        if @cadastre.present?
          @data_print.attributes.each do |key, value|
            if %w(name cpf nationality employment civil_state_id rg rg_org rg_uf wedding_regime wedding_date).include? key
              @cadastre[key] = value.to_s if @data_print.attributes.has_key?(key)
              @cadastre.program_id = 3
            end
          end
          @cadastre.save

          if @data_print.spouse_cpf.present?
            @spouse = @cadastre.dependents.where(kinship_id: 6).first
            if @spouse.present?
              @spouse.destroy
            end
            create_dep!(@cadastre)
          end

          @address = Core::Address::Unit.find_by(complete_address: @data_print.address_data_base)
          if @address.present?
            @address.ownership_type_id          = @data_print.ownership_type_id
            @address.registration_iptu          = @data_print.registration_iptu
            @address.certificate_sefaz          = @data_print.certificate_sefaz
            @address.date_certificate_sefaz     = @data_print.date_certificate_sefaz
            @address.validate_certificate_sefaz = @data_print.validate_certificate_sefaz
            @address.area                       = @data_print.area
            @address.save
            @office = @address.notary_office
            if @office.present?
              @office.unit_code = @data_print.unit_code
              @office.office = @data_print.office
              @office.endorsement = @data_print.endorsement
              @office.date_act_declaratory = @data_print.date_act_declaratory
              @office.declaratory_act_number = @data_print.declaratory_act_number
              @office.save
            end
          end
        else
          @cadastre = Core::Candidate::Cadastre.new
          @data_print.attributes.each do |key, value|
            if %w(name cpf nationality employment civil_state_id rg rg_org rg_uf wedding_regime wedding_date).include? key
              @cadastre[key] = value.to_s if @data_print.attributes.has_key?(key)
            end
          end
          @cadastre.creator_id = user
          @cadastre.program_id = 3
          @cadastre.save
          create_dep!(@cadastre)
        end
      end

      def create_dep!(cadastre)

        @dependent = cadastre.dependents.new(
          name: @data_print.spouse_name,
          cpf: @data_print.spouse_cpf,
          nationality: @data_print.spouse_nationality,
          employment: @data_print.spouse_employment,
          civil_state_id: @data_print.spouse_civil_state_id,
          rg: @data_print.spouse_rg,
          rg_org: @data_print.spouse_rg_org,
          rg_uf_id: @data_print.spouse_rg_uf,
          kinship_id: 6
        )
        @dependent.save

      end
    end
  end
end
