module Core
  module Candidate
    class OwnershipActivity < ActiveRecord::Base
      self.table_name = 'extranet.candidate_ownership_activities'
      
      belongs_to :original_cadastre, class_name: Core::Candidate::Cadastre
      belongs_to :target_cadastre, 
                  class_name: Core::Candidate::Cadastre,
                  primary_key: :id,
                  foreign_key: :target_cadastre_id

      belongs_to :staff, 
                  class_name: Core::Person::Staff,
                  primary_key: :id,
                  foreign_key: :staff_id
    end
  end
end