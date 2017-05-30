require_dependency 'core/application_policy'

module Core
  module Entity
    class CadastrePolicy < ApplicationPolicy

      def allow_accredited?
        entity = ::Core::Entity::CadastrePresenter.new(self)
        entity.current_situation_id == 567
      end
   
    end
  end
end