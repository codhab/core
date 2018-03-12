module Core
  module Healty
    class VoiReportReason < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_report_reasons'

      default_scope { where(status: true) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiReportReason')
      end
    end
  end
end
