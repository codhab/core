module Core
  module Protocol
    class ConductService # :nodoc:
      def initialize(conduct)
        @conduct = conduct
      end

      def allow_conduct!(assessment, sector)
        @conduct_result = Protocol::Conduct.where(assessment_id: assessment.id)
                                           .order(:created_at).last
        return nil unless @conduct_result.present?
        if %w[doc_create doc_cancel doc_return doc_receive]
               .include?(@conduct_result.conduct_type) &&
               sector == @conduct_result.sector_id
        return @conduct_result
        end
        nil
      end

      def set_data!(user, sector, assessment,allotment)
        @conduct = Core::Protocol::Conduct.new(
          sector_id: sector,
          assessment_id: assessment,
          staff_id: user.id,
          conduct_type: 5,
          allotment_id: allotment
        )
      end

      def create_conducts!(assessment_ids, type, user, sector)
        @assessment = Protocol::Assessment.find(assessment_ids)
        @assessment.each do |a|
          @conduct = Protocol::Conduct.new
          allotment = Protocol::Conduct.where(assessment_id: a.id)
                                       .order('created_at DESC').first
          @conduct.allotment_id = allotment.allotment_id
          @conduct.conduct_type = type
          @conduct.assessment_id = a.id
          @conduct.sector_id = sector
          @conduct.staff_id = user
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
            staff_id: user
          )
          @conduct.save
        end
      end
    end
  end
end
