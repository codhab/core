module Core
  module Atttendance
    class AbleService 
      
      attr_accessor :ticket, :context, :ticket_context

      def create_by_context context_id
                
        @context = @ticket.ticket_contexts.able.new.tap do 
          context_id: context_id
        end

      end

      def cancel_by_candidate       
      end

      def close_by_candidate
      end

      def cancel_by_attendant
      end

      def close_by_attendant
      end

      def document_required
      end

    end
  end
end