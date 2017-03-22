require_dependency 'core/application_record'

module Core
  module Regularization
    class EnabledTransfer < ApplicationRecord
      belongs_to :cadastre, required: false, class_name: ::Core::Candidate::Cadastre

    end
  end
end
