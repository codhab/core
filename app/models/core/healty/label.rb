module Core
  module Healty
    class Label < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_labels'

      def self.model_name
        ActiveModel::Name.new(self, nil, 'Label')
      end
    end
  end
end
