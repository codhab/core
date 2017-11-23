module Core
  module Document
    class AuthenticateService # :nodoc:

      def authenticate_step
        @allotments = Core::Document::Allotment.where(print: true)
        second = Array.new
        first = Array.new
        main = Array.new
        if @allotments.present?
          @allotments.each do |allotment|
            second << allotment.id unless allotment.second_authenticate.present?
            first << allotment.id if allotment.second_authenticate.present? && !allotment.first_authenticate.present?
            main << allotment.id if allotment.second_authenticate.present? && allotment.first_authenticate.present? && !allotment.main_authenticate.present?
          end
          return [second, first, main]
        end
        nil
      end
    end
  end
end
