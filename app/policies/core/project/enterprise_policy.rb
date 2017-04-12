require_dependency 'core/application_policy'

module Core
  module Project
    class EnterprisePolicy < ApplicationPolicy

      def enterprise_active_indication?(cadastre)
        cadastre.enterprise_cadastres.where(inactive: false, enterprise_id: self.id).present?
      end

      def enterprise_allow_new_indications?
        true
      end

    end
  end
end