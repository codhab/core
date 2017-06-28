require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class RequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true
      validates :cpf, cpf: true
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
      belongs_to :cadastre, class_name: ::Core::Candidate::Cadastre, foreign_key: :cpf, primary_key: :cpf

      scope :by_candidate_situation, -> (situation_status_id) {
        joins(:general)
        .where('extranet.general_pontuations.situation_status_id =  ?', situation_status_id)
      }

      scope :by_program, -> (program) {
        joins(:cadastre)
        .where('extranet.candidate_cadastres.program_id =  ?', program)
      }

      scope :without_bond, -> (bond){
        if bond == "true"
          joins('inner join extranet.candidate_cadastres  on candidate_cadastres.cpf = extranet.protocol_assessments.cpf ')
          .where('extranet.candidate_cadastres.program_id in (3,6)')
        else
          joins('left join extranet.candidate_cadastres  on candidate_cadastres.cpf = extranet.protocol_assessments.cpf ')
          .where('extranet.candidate_cadastres.id is null')
        end
      }


      def self.situations
        situations = {}

        all.each do |situation|
          if situation.cadastre.present?
            situations[situation.cadastre.presenter.current_situation_name] = situation.cadastre.presenter.current_situation_id rescue nil
          end
        end


        situations.inject([]) { |result,h| result << h unless result.include?(h); result }
      end


    end
  end
end
