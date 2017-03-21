module Protocol
  class Subject < ActiveRecord::Base
    audited

    has_many :assessment
  end
end
