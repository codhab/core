require_dependency 'core/application_record'

module Core
  module Regularization
    class Request < ApplicationRecord
      self.table_name = 'extranet.regularization_requests'

      enum situation: ['Aguardando atendimento', 'Em atendimento', 'Finalizado', 'Cancelado']

      mount_uploader :file, Core::Regularization::DocumentUploader

    end
  end
end