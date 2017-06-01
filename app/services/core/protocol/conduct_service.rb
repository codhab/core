module Core
  module Protocol
    class ConductService # :nodoc:
      include ActiveModel::Validations

      def initialize(conduct)
        @conduct = conduct
      end

      def allow_conduct!(assessment, sector)
        @conduct_result = Protocol::Conduct.where(assessment_id: assessment.id)
                                           .order(:created_at).last
        return nil unless @conduct_result.present?
        if sector == 3
          if %w[doc_create doc_cancel doc_return doc_receive doc_to_send]
                 .include?(@conduct_result.conduct_type) &&
                 (sector == @conduct_result.sector_id || @conduct_result.sector_id == 2)
          return @conduct_result
          end
        else
          if %w[doc_create doc_cancel doc_return doc_receive doc_to_send]
                 .include?(@conduct_result.conduct_type) &&
                 sector == @conduct_result.sector_id
          return @conduct_result
          end
        end
        nil
      end

      def doc_to_responded(assessment, sector)
        @conduct = Core::Protocol::Conduct.joins(:allotment).where('assessment_id = ? and protocol_allotments.sector_id = ? and conduct_type = 1 and protocol_conducts.replay_date is not null',assessment, sector)
        return @conduct.present? ? true : false
      end

      def set_data!(user, sector, assessment,allotment, replay_date, responded)
        @conduct = Core::Protocol::Conduct.new(
          sector_id: sector,
          assessment_id: assessment,
          staff_id: user.id,
          conduct_type: 5,
          allotment_id: allotment,
          replay_date: replay_date,
          responded: responded
        )
      end

      def create_conducts!(assessment_ids, type, user, sector)
        @assessment = Protocol::Assessment.find(assessment_ids)
        @assessment.each do |a|
          responded = doc_to_responded(a, sector)
          responded_date = Date.today if responded == true
          @conduct = Protocol::Conduct.new
          allotment = Protocol::Conduct.where(assessment_id: a.id)
                                       .order('created_at DESC').first
          @conduct.allotment_id = allotment.allotment_id
          @conduct.conduct_type = type
          @conduct.assessment_id = a.id
          @conduct.sector_id = sector
          @conduct.staff_id = user
          @conduct.responded = responded
          @conduct.responded_date = responded_date
          @conduct.save
        end
      end

      def send_allotment!(allotment, sector, user)
        @allotment_conduct = Core::Protocol::Conduct.where(allotment_id: allotment, conduct_type: 5)
        @allotment_conduct.each do |lote|
          @conduct = Core::Protocol::Conduct.new(
            allotment_id: allotment,
            conduct_type: 1,
            assessment_id: lote.assessment_id,
            sector_id: sector,
            staff_id: user,
            replay_date: lote.replay_date,
            responded: false
          )
          @conduct.save
        end
      end

      def unit_conduct!(staff, sector)
        @assessment = Core::Protocol::Assessment.find(@conduct.assessment_id)
        if allow_conduct!(@assessment, sector).present?
          @allotment = create_allotment!(@conduct.description, sector, staff)
          @conduct.allotment_id = @allotment.id
          @conduct.conduct_type = 1
          @conduct.responded = false
          @conduct.save
          return true
        else
          @conduct.errors.add(:description, 'Documento não está no seu setor ou não pode ser tramitado.')
          errors.add(:description, 'Documento não está no seu setor ou não pode ser tramitado.')
          return false
        end
      end

      def create_allotment!(description, sector, staff)
        @new_alloment = Core::Protocol::Allotment.new(
          description: description,
          amount_docs: 1,
          status: true,
          sector_id: sector,
          staff_id: staff
        )
        @new_alloment.save
        return @new_alloment.present? ? @new_alloment : nil
      end



    end
  end
end
