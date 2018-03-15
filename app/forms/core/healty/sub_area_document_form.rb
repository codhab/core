module Core
  module Healty
    class SubAreaDocumentForm < Core::Healty::SealingDocument # :nodoc:
      def self.model_name
        ActiveModel::Name.new(self, nil, 'SubAreaDocumentForm')
      end
    end
  end
end
