module Core
  module Attendance
    class RecadastreService 
      
      attr_accessor(
                    :cadastre, 
                    :ticket, 
                    :context, 
                    :ticket_context,
                    :cadastre_mirror,
                    :dependent_mirror_id,
                    :dependent_mirror
                  )

      def initialize(cadastre: nil, ticket: nil, context: nil, dependent_mirror_id: nil)
        @cadastre            = cadastre
        @ticket              = ticket
        @context             = context
        @ticket_context      = ticket_context
        @dependent_mirror_id = dependent_mirror_id.to_i
        @dependent_mirror    = Core::Candidate::DependentMirror.find(@dependent_mirror_id) rescue nil
      end

      def ticket
        return @ticket if !@ticket.nil?
        return @cadastre.tickets.where(ticket_type_id: 1).find_by(status: true) rescue false
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
          @ticket.update(ticket_status_id: 6, status: false)
        end
      end

      def set_required_documents(required_all = false)

        case @context.ticket_context_id
        when 1
          if @ticket.cadastre.rg != @ticket.cadastre_mirror.rg
            @context.rg_uploads.new(disable_destroy: true)
          end
        when 2
          
          if required_all
            if @dependent_mirror.is_major?
              @context.cpf_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id}) 
              @context.rg_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end
            
            @context.born_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            
            if @dependent_mirror.icome.to_i > 0
              @context.income_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end
            
            if @dependent_mirror.special_condition_id == 2
              @context.special_condition_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id}) 
            end

          else
            
            current_dependent = @ticket.cadastre.dependents.find_by(name: @dependent_mirror.name)
            
            if current_dependent.cpf != @dependent_mirror.cpf
              @context.cpf_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end

            if current_dependent.rg != @dependent_mirror.rg
              @context.rg_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end

            if current_dependent.born != @dependent_mirror.born
              @context.certificate_born_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end

            if current_dependent.income.to_f != @dependent_mirror.income.to_f 
              @context.income_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end

            if (current_dependent.special_condition_id != @dependent_mirror.special_condition_id) &&
              @dependent_mirror.special_condition_id == 2

              @context.special_condition_uploads.new({disable_destroy: true, dependent_mirror_id: @dependent_mirror.id})
            end
          end

        when 3
          if @ticket.cadastre.main_income != @ticket.cadastre_mirror.main_income
            @context.income_uploads.new(disable_destroy: true)
          end
          
          @ticket.cadastre_mirror.dependent_mirrors.order(:name).each do |dependent|
            current_dependent = @ticket.cadastre.dependents.find_by(name: dependent.name) rescue nil
            
            if !current_dependent.nil? && dependent.income.to_f != current_dependent.income.to_f
              @context.income_uploads.new(disable_destroy: true)
            end 
          end
        end
      end

      def document_required_any?
        %w(rg special_condition).each do |item|
          return true if @context.send("#{item}_uploads").any? 
        end

        return false
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