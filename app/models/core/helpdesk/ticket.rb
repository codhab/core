require_dependency 'core/application_record'

module Core
  module Helpdesk
    class Ticket < ApplicationRecord
      self.table_name = 'extranet.helpdesk_tickets'

    end
  end
end
