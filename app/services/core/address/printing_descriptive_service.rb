module Address
  class PrintingDescriptiveService

    def initialize(cadastre, unit, staff)
      @cadastre = cadastre
      @staff    = staff
      @unit     = unit
    end

    def descriptive_type!

      if general?
        return 1 if suspended?
        return 2 if exempt?
        return 3 if not_exempt?
      end
      return 0
    end

    def general?
      office = @unit.notary_office


      return false unless @unit.current_registry_id == "não"
      return false unless office.unit_code.present?
      return false if office.requeriment.present?
      return false unless @unit.donate
      return false unless @unit.situation_unit_id == 3
      return true
    end

    def suspended?

      office = @unit.notary_office
      return false unless office.declaratory_act_number.present?
      return false unless office.date_act_declaratory.present?
      return false unless office.date_act_declaratory.between?(Date.parse('2012-12-18'), Date.parse('2014-01-01')) #diferente
      return false unless %w(1 2 3 6 8 10 11 12 510 507).include? @unit.type_use_unit_id.to_s #diferente
      return true
    end

    def exempt?

      office = @unit.notary_office
      return false unless office.declaratory_act_number.present?
      return false unless office.date_act_declaratory.present?
      return false unless (office.date_act_declaratory < Date.parse('2012-12-19') || office.date_act_declaratory > Date.parse('2013-12-31')) #diferente
      return false unless %w(1 2 3 6 8 10 11 12 510 507).include? @unit.type_use_unit_id.to_s #diferente
      return false unless (@unit.current_cadastre_address.created_at < Date.parse('2008-01-01') || @unit.current_cadastre_address.created_at < Date.parse('2011-01-01'))
      return true
    end

    def not_exempt?

      office = @unit.notary_office
      return false unless office.rejection_number.present?
      return false unless @unit.current_cadastre_address.regularization_type_id.present?

      return false unless @unit.current_cadastre_address.regularization_type_id >= 8 || (@unit.current_cadastre_address.dominial_chain == 0 && office.rejection_number.present?)
      return false unless %w(1 2 3 4 8 10 11 510 507).include? @unit.type_use_unit_id.to_s #diferente
      return true
    end

    def descriptive_log! type_document

      return false unless @cadastre.current_cadastre_address.present?

      Core::Candidate::CadastreActivity.new({
        cadastre_id: @cadastre.id,
        staff_id: @staff.present? ? @staff.id : nil,
        activity_status_id: 18, #impressão de certidão positiva
        observation: type_document,
        type_activity: 2
      }).save

    end

  end
end
