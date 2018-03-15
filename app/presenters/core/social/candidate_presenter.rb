require_dependency 'core/application_presenter'

module Core
  module Social
    class CandidatePresenter < ApplicationPresenter # :nodoc:
      def situation_label(situation)
        situation = self.candidate_situations.last
        case situation.situation_id
        when 1
          h.content_tag(:div, class: 'ui label') do
            situation.situation.name
          end
        when 2
          h.content_tag(:div, class: "ui label blue") do
            situation.situation.name
          end
        when 3
          h.content_tag(:div, class: "ui label green") do
            'teste'
          end
        when 4
          h.content_tag(:div, class: "ui label brown") do
            situation.situation.name
          end
        when 5
          h.content_tag(:div, class: "ui label purple") do
            situation.situation.name
          end
        when 6
          h.content_tag(:div, class: "ui label red") do
            situation.situation.name
          end
        when 7
          h.content_tag(:div, class: "ui label yellow") do
            situation.situation.name
          end
        end
      end
    end
  end
end
