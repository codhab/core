module Protocol
  class DocumentType < ActiveRecord::Base
    audited

    has_many :assessment

    default_scope { order('name ASC') }
  end
end
