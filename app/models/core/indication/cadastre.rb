require_dependency 'core/application_record'

module Core
  module Indication
    class Cadastre < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.indication_subjects'
    end
  end
end
