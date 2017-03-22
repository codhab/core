require_dependency 'core/application_record'

module Core
  module Project
    class Company < ActiveRecord::Base
      belongs_to :city,  required: false,   class_name: ::Core::Address::City

      has_many :enterprise, class_name: "Project::Enterprise"

      has_many :user_companies

    end
  end
end
