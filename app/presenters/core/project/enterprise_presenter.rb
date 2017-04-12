require_dependency 'core/application_presenter'

module Core
  module Project
    class EnterprisePresenter < ApplicationPresenter
      
      def detail_name
        "#{self.typology.name} - #{self.typology.home_type}" rescue nil
      end

    end
  end
end