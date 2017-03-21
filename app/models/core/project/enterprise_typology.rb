module Project
  class EnterpriseTypology < ActiveRecord::Base
    belongs_to :enterprise
    belongs_to :typology
  end
end
