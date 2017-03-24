require_dependency 'core/application_record'

module Core
  module Project
   class Step < ApplicationRecord
     self.table_name = 'extranet.project_steps'

     belongs_to :enterprise
     has_many :allotments, class_name: "Indication::Allotment"



    end
  end
end
