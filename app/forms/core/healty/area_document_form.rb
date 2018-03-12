module Core
  module Healty
    class AreaDocumentForm < Core::Healty::SealingDocument # :nodoc:
      def self.model_name
        ActiveModel::Name.new(self, nil, 'AreaDocumentForm')
      end
    end
  end
end
