module Core
  module Healty
    class UnitVoiForm < Core::Healty::Voi # :nodoc:
      validates :origin_type_id, :voi_type_id, presence: true
      validates :report_reason_id, presence: true
      def self.model_name
        ActiveModel::Name.new(self, nil, 'UnitVoiForm')
      end
    end
  end
end
