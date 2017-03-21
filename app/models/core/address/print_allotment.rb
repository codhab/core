module Core
  module Address
    class PrintAllotment < ApplicationRecord
      self.table_name = 'extranet.address_print_allotments'

      belongs_to :staff,      required: false, class_name: ::Core::Person::Staff
      belongs_to :print_type, required: false, class_name: ::Core::Address::PrintType, foreign_key: :print_type_id
      belongs_to :unit,       required: false, class_name: ::Core::Address::Unit


      has_many :print_unit_cadastres, dependent: :destroy

    end
  end
end
