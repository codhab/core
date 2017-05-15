require_dependency 'core/application_record'

module Core
  module Brb
    class Category < ApplicationRecord
      self.table_name = 'extranet.brb_categories'

      has_many :invoices

      scope :active, -> { where(status: true).order(:name)}
      scope :by_id, -> (id) { where(id: id) }
    end
  end
end
