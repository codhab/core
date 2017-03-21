module Entity
  class Region < ActiveRecord::Base
    belongs_to :city, class_name: "::Address::City"
  end
end
