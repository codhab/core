require_dependency 'core/application_record'

module Core
  module Sefaz
    class SendStatus < ApplicationRecord
      self.table_name = 'extranet.sefaz_send_statuses'

    end
  end
end
