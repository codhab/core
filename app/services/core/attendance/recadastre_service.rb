module Core
  module Attendance
    class RecadastreService 
      
      attr_accessor :cadastre, :ticket, :context, :ticket_context, :cadastre_mirror

      def initialize(cadastre: nil, ticket: nil, context: nil, ticket_context: nil)
        @cadastre       = cadastre
        @ticket         = ticket
        @context        = context
        @ticket_context = ticket_context
      end

      def create
        @ticket = @cadastre.tickets.where(ticket_type_id: 1, status: true).first rescue nil
        
        if @ticket.nil?
         
          @ticket = @cadastre.tickets.new.tap do |ticket|
            ticket.ticket_type_id     = 1
            ticket.ticket_status_id   = 1
            ticket.status             = true
          end 

          clone_and_create_mirror!

          @ticket.cadastre_mirror_id = @cadastre_mirror.id
          @ticket.save

        end 

      end


      def confirm_by_context context_id 
        @context_action = current_action(context_id)

        return true if !@context_action.present?

        @context_action.update(status: 1) 
      end

      def create_context context_id
        
        return true if current_action(context_id)
         
        @action = @ticket.ticket_context_actions.new.tap do |action|
          action.ticket_context_id = context_id
          action.status = 0
        end

        @action.save

      end

     
      def cancel_by_candidate       
      end

      def close_by_candidate
        current_action(1).update(status: 1)
      end

      def cancel_by_attendant
      end

      def close_by_attendant
      end

      def document_required context_id
        case context_id.to_i
        when 1
          if @ticket.cadastre.rg != @ticket.cadastre_mirror.rg
            @ticket.rg_uploads.new
          end
        end

        return @ticket
      end


      private

      def current_action context_id
        @ticket.ticket_context_actions.where(ticket_context_id: context_id).last
      end

      def clone_and_create_mirror!
        return false if @cadastre.nil?

        @cadastre_mirror = @cadastre.cadastre_mirrors.new

        @cadastre.attributes.each do |key, value|
          unless %w(id created_at updated_at).include? key
            @cadastre_mirror[key] = value if @cadastre_mirror.attributes.has_key?(key)
          end
        end

        @cadastre_mirror.save
      
        @dependents = @cadastre.dependents

        @dependents.each do |dependent|
          @new_dependent = @cadastre_mirror.dependent_mirrors.new
          
          dependent.attributes.each do |key, value|
            unless %w(id created_at updated_at).include? key
              @new_dependent[key] = value if @new_dependent.attributes.has_key?(key)
            end
          end

          @new_dependent.save
      
        end
      end

    end
  end
end