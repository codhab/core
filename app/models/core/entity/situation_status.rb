module Entity
  class SituationStatus < ActiveRecord::Base

    validates :name, presence: true
  end
end
