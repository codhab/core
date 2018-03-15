module Core
  module Healty
    class VoiSchedule < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_schedules'

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiSchedule')
      end
    end
  end
end
