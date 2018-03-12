module Core
  module Healty
    class Voi < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_vois'

      belongs_to :unit,          required: false, class_name: 'Core::Address::Unit', foreign_key: :unit_id
      belongs_to :city,          required: false, class_name: 'Core::Address::City'
      belongs_to :voi_type,      required: false, class_name: 'Core::Healty::VoiType'
      belongs_to :origin_type,   required: false, class_name: 'Core::Healty::VoiOriginType'
      belongs_to :report_reason, required: false, class_name: 'Core::Healty::VoiReportReason'

      has_many :voi_situations, class_name: 'Core::Healty::VoiSituation'
      has_many :voi_documents,  class_name: 'Core::Healty::VoiDocument'
      has_many :voi_activities, class_name: 'Core::Healty::VoiActivity'

      scope :by_name,     ->(name)    { where(name: name) }
      scope :by_cpf,      ->(cpf)     { where(cpf: cpf) }
      scope :by_voi_type, ->(type)    { where(voi_type_id: type) }
      scope :by_origin,   ->(origin)  { where(origin_type_id: origin) }
      scope :by_city,     ->(city)    { where(city_id: city) }
      scope :by_address,  ->(address) { where("address ilike '%#{address}%'") }

      def current_situation
        voi_situations.order(created_at: :asc).last
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, 'Voi')
      end
    end
  end
end
