module Core
  module Attendance
    class RecadastreService 
      
      attr_accessor :cadastre, :ticket, :context, :ticket_context, :cadastre_mirror

      def initialize(cadastre: nil, ticket: nil, context: nil)
        @cadastre       = cadastre
        @ticket         = ticket
        @context        = context
        @ticket_context = ticket_context
      end

      def ticket
        return @ticket if !@ticket.nil?
        return @cadastre.tickets.find_by(status: true) rescue false
      end

      def create
        
        @ticket = @cadastre.tickets.new.tap do |ticket|
          ticket.ticket_type_id     = 1
          ticket.ticket_status_id   = 1
          ticket.status             = true
        end 

        clone_and_create_mirror!

        @ticket.cadastre_mirror_id = @cadastre_mirror.id
        @ticket.save
      end

      def close_recadastre
        if @ticket.ticket_context_actions.where(status: 2).present?
          @ticket.update(ticket_status_id: 2)
        else
          @ticket.update(ticket_status_id: 6)
        end
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