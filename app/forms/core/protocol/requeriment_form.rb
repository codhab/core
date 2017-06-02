require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class RequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true
      default_scope { where(prefex: 777, subject_id: [1746,1747]) }

      scope :by_type, -> (type) {
        if type.to_i == 1
          where(subject_id: 1746)
        end

        if type.to_i == 2
          where(subject_id: 1747)
        end
      }


      belongs_to :general, class_name: ::Core::View::GeneralPontuation, foreign_key: :cpf, primary_key: :cpf

      scope :by_candidate_situation, -> (situation_status_id) {
        joins(:general)
        .where('extranet.general_pontuations.situation_status_id =  ?', situation_status_id)
      }


      def self.situations
        situations = {}
        
        all.each do |situation|
          situations[situation.cadastre.presenter.current_situation_name] = situation.cadastre.presenter.current_situation_id rescue nil
        end


        situations.inject([]) { |result,h| result << h unless result.include?(h); result }
      end


    end
  end
end
