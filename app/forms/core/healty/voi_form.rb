module Core
  module Healty
    class VoiForm < Core::Healty::Voi # :nodoc:
      validates :name, :cpf, :city_id, :address, presence: true
      validates :origin_type_id, :voi_type_id, presence: true
      validates :report_reason_id, presence: true
      validates :cpf, cpf: true

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiForm')
      end
    end
  end
end
