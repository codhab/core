require_dependency 'core/application_record'
module Core
  module Regularization
    class SolicitationDocument < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitation_documents'
    end
  end
end