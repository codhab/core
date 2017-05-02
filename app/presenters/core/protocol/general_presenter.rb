require_dependency 'core/application_presenter'

module Core
  module Protocol
    class GeneralPresenter < ApplicationPresenter # :nodoc:

      def due_document(allotment)
        @allotment = Core::Protocol::Allotment.find(allotment)
        @count = 0
        @allotment.conducts.each do |conduct|
          @count += 1 if conduct.assessment.responded != true
        end
        return @count == 0 ? false : true
      end

      def due_date(replay_date)
        days = replay_date - Date.today
        if days.to_i > 10
          @color = 'green'
        elsif days.to_i < 10 && days.to_i >= 5
          @color = 'yellow'
        elsif days.to_i < 5 && days.to_i > 0
          @color = 'red'
        elsif days.to_i <= 0
          @color = 'black'
        else
          @color = 'gray'
        end
        [@color, days]
      end
    end
  end
end
