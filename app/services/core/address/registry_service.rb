module Core
  module Address
    class RegistryService

      def initialize(unit, staff)
        @unit  = unit
        @staff = staff
      end

      def create_registry!(situation)
        @registry = @unit.registry_units.new(
          situation: situation,
          status: true
        )
        @registry.save
        create_log!
      end

      private

      def create_log!
        @activity = @unit.activity.new(
          observation: 'Atualização de situação de registro por empressão de documento',
          staff_id: @staff.id,
          activity_status_id: 3
        )
        @activity.save
      end
    end
  end
end
