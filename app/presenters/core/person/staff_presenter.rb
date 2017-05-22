require_dependency 'core/application_presenter'

module Core
  module Person
    class StaffPresenter < ApplicationPresenter

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
      
    end
  end
end
