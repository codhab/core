require_dependency 'core/application_record'

module Core
  module Brb
    class Remittance < ApplicationRecord
      self.table_name = 'extranet.brb_remittances'

    end
  end
end
