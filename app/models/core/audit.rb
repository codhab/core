module Core
  class Audit < ApplicationRecord
    self.table_name = 'extranet.audits'
  end
end