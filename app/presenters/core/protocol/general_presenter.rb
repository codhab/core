require_dependency 'core/application_presenter'

module Core
  module Protocol
    class GeneralPresenter < ApplicationPresenter # :nodoc:

      def any_due
        if self.responded == false
          self.conducts.where(conduct_type: 1).each do |c|
            if c.allotment.present? && c.replay_date.present?
              if due_document(c.allotment.id)
                returned =  due_date(c.replay_date)
                if returned.present?
                  html = <<-HTML
                    <div class="ui #{returned[0]} tag label">
                      #{c.sector.acron} #{returned[1]}
                    </div>
                    <br>
                    <br>
                  HTML
                  return html.html_safe
                end
              end
            end
          end
        end
      end

      def due_document(allotment)
        @allotment = Core::Protocol::Allotment.find(allotment)
        @count = 0
        @allotment.conducts.each do |conduct|
          @first_conduct = conduct.conduct_type == 'doc_sent' ? conduct.assessment_id : nil
          @responded = Core::Protocol::Conduct.where('assessment_id = ? and allotment_id > ? and sector_id = ? and conduct_type = ? and responded is true',
                                                     @first_conduct, @allotment.id, @allotment.sector_id, 4)
          @count += 1 if @responded.present?

        end
        return @count > 0 ? false : true
      end

      def due_date(replay_date)
        days = replay_date - Date.today
        if days.to_i >= 10
          @color = 'green'
          message = "Resta(m) #{days.to_i} dia(s)."
        elsif days.to_i < 10 && days.to_i >= 5
          @color = 'yellow'
          message = "Resta(m) #{days.to_i} dia(s)."
        elsif days.to_i < 5 && days.to_i > 0
          @color = 'red'
          message = "Resta(m) #{days.to_i} dia(s)."
        elsif days.to_i < 0
          @color = 'black'
          message = "#{days.to_i.abs} dia(s) atrasado(s)."
        elsif days.to_i == 0
          @color = 'grey'
          message = "Prazo de resposta termina hoje."
        else
          @color = 'brown'
        end
        [@color, message]
      end
    end
  end
end
