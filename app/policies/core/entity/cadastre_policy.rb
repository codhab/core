require_dependency 'core/application_policy'

module Core
  module Entity
    class CadastrePolicy < ApplicationPolicy

      def allow_questions?
        entity = ::Core::Entity::CadastrePresenter.new(self)
        entity.current_situation_id == 567
      end
   
    end
  end
end