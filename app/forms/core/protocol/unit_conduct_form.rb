require_dependency 'core/protocol/conduct'

module Core
  module Protocol
    class UnitConductForm < Core::Protocol::Conduct # :nodoc: 

      validates :description, :sector_id, presence: true

    end
  end
end
