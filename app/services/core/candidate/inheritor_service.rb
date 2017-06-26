module Address
  class PrintingDescriptiveService

    def initialize(cadastre, inheritor, staff)
      @cadastre  = cadastre
      @staff     = staff
      @inheritor = inheritor
    end

    def inheritor_destroy(observation)
      @activity = @cadastre.cadastre_activities.new(
          staff_id: @staff.id,
          activity_status_id: 28,
          type_activity: 2,
          observation: observation
        )
        @activity.save

      @removed = Core::Candidate::Inheritor.new(
        cadastre_id: @cadastre.id,
        cadastre_cpf: @cadastre.cpf,
        name: @inheritor.name,
        cpf: @inheritor.cpf,
        rg: @inheritor.rg,
        born: @inheritor.born,
        civil_state_id: @inheritor.civil_state_id,
        gender: @inheritor.gender,
        single_name: @inheritor.single_name,
        percentage: @inheritor.percentage,
        observation: observation
      )
      @removed.save
    end

  end
end
