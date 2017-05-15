require_dependency 'core/application_presenter'

module Core
  module Candidate
    class CadastrePresenter < ApplicationPresenter

      def hello
        case Time.now.strftime("%H").to_i
        when 18..23
          @string = "Boa noite"
        when 0..6
          @string = "Boa noite"
        when 6..12
          @string = "Bom dia"
        when 12..18
          @string = "Boa tarde"
        end

        "#{@string}, #{self.humanize_first_name}"
      end

      def humanize_first_name
        self.name.split(' ')[0].humanize
      end

      def humanize_complete_name
        self.name.titleize
      end


      def special_condition_name
        self.special_condition.name rescue nil
      end

      def civil_state_name
        self.civil_state.name rescue nil
      end

      # => cadastre_situation

      def current_situation
        self.cadastre_situations.order('created_at ASC').last rescue nil
      end

      def current_situation_name
        current_situation.situation_status.name.mb_chars.upcase rescue nil
      end

      def current_situation_id
        current_situation.situation_status_id rescue nil
      end

      # => procedural

      def current_procedural
        self.cadastre_procedurals.order('created_at ASC').last rescue nil
      end

      def current_procedural_name
        current_procedural.procedural_status.name.mb_chars.upcase rescue nil
      end

      # => convocation

      def current_convocation
        self.cadastre_convocations.where(status: true).order('created_at ASC').last rescue nil
      end

      def current_convocation_name
        "#{current_convocation.convocation.id} - #{current_convocation.convocation.description}" rescue nil
      end

      def current_convocation_id
        current_convocation.convocation_id rescue nil
      end

      def current_cadastre_address
        self.cadastre_address.where(situation_id: [0,1,5]).order('created_at ASC').last rescue nil
      end


      # => pontuation

      def last_pontuation_total
        self.pontuations.order('created_at ASC').last.total rescue nil
      end

      def spouse
        self.dependents.where(kinship_id: 6).first rescue nil
      end

      def deadline_indication

      @inactives = self.enterprise_cadastres.where(inactive: true, indication_type_id: [1,4])

      if @inactives.present? && @inactives.first.inactive_date.present?

        @year    = @inactives.first.inactive_date + 4.years
        @dealine = @year.strftime("%d/%m/%Y")

        if @year > Date.today
          @month = ((Date.today.year - 1) * 12 + Date.today.month) - ((@year.year - 1) * 12 + @year.month)

          case @month.divmod(12)[0]
          when -4
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -3
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -2
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -1
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when 0
            @result = "Faltam poucos dias para exceder o prazo."
          else
           @result  = "Prazo excedido"
          end

        end

        {
         count:   @inactives.count,
         first:   @inactives.first.inactive_date.present? ? @inactives.first.inactive_date.strftime('%d/%m/%Y') : "Sem informação",
         end:     @year.strftime("%d/%m/%Y"),
         result:  @result
        }

      else
        nil
      end

    end

    end
  end
end
