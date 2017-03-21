module Core
  module Candidate
    class ActivityStatus < ApplicationRecord
      self.table_name = 'extranet.candidate_activity_statuses'
    end
  end
end
