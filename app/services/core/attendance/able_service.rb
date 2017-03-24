module Core
  module Attendance
    class AbleService 
      
      attr_accessor :cadastre, :ticket, :context, :ticket_context, :cadastre_mirror, :context_id

      def initialize(cadastre: nil, ticket: nil, context: nil, context_id: nil)
        @cadastre       = cadastre
        @ticket         = ticket
        @context        = context
        @ticket_context = ticket_context
        @context_id     = context_id
      end

      def able_situation_by_context context_id 
        @context_id = context_id.to_i
        @ticket     = @cadastre.tickets.where(ticket_type_id: 2).find_by(status: true) rescue false
        @context    = @ticket.ticket_context_actions.where(ticket_context_id: @context_id).first rescue false

        return @context
      end

      def ticket
        @cadastre.ticket_context_actions.where(ticket_context_id: 2)
      end

      def context
        return false    if @ticket.nil?
        return @context if !@context.nil?
        return @ticket.ticket_context_actions.where(ticket_context_id: @context_id).first rescue nil
      end

      def ticket_by_context_present?
        @ticket.present?
      end

      def create_ticket
        
        @ticket = @cadastre.tickets.new.tap do |ticket|
          ticket.ticket_type_id     = 2
          ticket.ticket_status_id   = 1
          ticket.ticket_context_id  = @context_id
          ticket.status             = true
        end 

        clone_and_create_mirror!

        @ticket.cadastre_mirror_id = @cadastre_mirror.id
        @ticket.save

        @context = @ticket.ticket_context_actions.new({
          ticket_context_id: @context_id,
          status: 0
        })

        @context.save
      end

      def close
        @ticket.update(ticket_status_id: 1)
        @context.update(status: 2)
      end

      def set_required_documents
        if @ticket.cadastre.rg != @ticket.cadastre_mirror.rg
          @context.rg_uploads.new(disable_destroy: true)
        end
      end

      def document_required_any?
        %w(rg special_condition).each do |item|
          return true if @context.send("#{item}_uploads").any? 
        end
      end

      private


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