require_dependency 'core/application_record'

module Core
  module Project
    class UserCompany < ApplicationRecord
      self.table_name = 'extranet.project_user_companies'

      belongs_to :company
    end
  end
end
