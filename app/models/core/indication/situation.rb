require_dependency 'core/application_record'

module Core
  module Indication
    class Situation < ApplicationRecord
      self.table_name = 'extranet.indication_situations'

    end
  end
end
