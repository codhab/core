module Core
  module Protocol
    class AssessmentService

      def initialize(assessment)
        @assessment = assessment
      end

      def set_number!(user, sector)
        document_type = Core::Protocol::DocumentType.find(@assessment.document_type_id)
        if @assessment.external_petition == true || document_type.prefex == 777
          @assessment.prefex = 777  #prefixo de documento externo
        elsif @assessment.document_type.prefex == 392
          @assessment.prefex = 392
        else
          sector_find = Core::Person::Sector.find(sector)
          @assessment.prefex = (!document_type.prefex.nil?) ? document_type.prefex  : sector_find.sector.prefex
          documents = Core::Protocol::Assessment.where("sector_id = ? and document_type_id = ? and year = ? and prefex <> '777' ",@assessment.sector_id,
                                       @assessment.document_type_id,
                                       Time.now.year).order('id ASC').last
        end
         @assessment.staff_id    =  user
         @assessment.sector_id   =  sector
         @assessment.year        =  Time.now.year
         document = documents.present? ? documents : Core::Protocol::Assessment.where(document_type_id:  @assessment.document_type_id,
                                      year: Time.now.year, prefex: @assessment.prefex).order('id asc').last
         @assessment.number = (document.present?) ? document.number + 1 : 1         

         format_document_number!

      end

      def format_document_number!
          number = "#{@assessment.prefex}#{'%06d' % @assessment.number}#{@assessment.year}"
          number =~ /(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{4})/
          number = "#{$1}-#{$2}.#{$3}/#{$4}"

          @assessment.document_number = number
      end
    end
  end
end