require_dependency 'core/application_policy'

module Core
  module Project
    class CadastrePolicy < ApplicationPolicy

      def allow_to_manifestation? 
        cadastre_policy = Core::Candidate::CadastrePresenter.new(self)
        cadastre_policy = Core::Candidate::CadastrePolicy.new(cadastre_policy)

        cadastre_policy.current_situation_id == 4 &&
        cadastre_policy.main_income.to_f >= 3600.0 && 
        cadastre_policy.main_income.to_f <= 12244.0 &&
        !cadastre_policy.active_indication_present?        
      end

    end
  end
end