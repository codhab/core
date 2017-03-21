module Core
  module Schedule
    class DataReference < ActiveRecord::Base
      self.table_name = 'extranet.schedule_data_references'
    end
  end
end
