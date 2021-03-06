module Core
  module Protocol
    class AssessmentService

      def initialize(assessment)
        @assessment = assessment
      end

      def app_requeriment!(candidate = nil, entity = nil)

        @assessment.document_type_id = 26 #external requeriment

        if entity.nil?
          @assessment.recipient        = candidate.name
          if ([1,2,4,5,7,9,10].include? candidate.program_id)
            sector = 27
            @assessment.subject_id = 1746 #request
          else
            sector = 30
            @assessment.subject_id = 1747 #request
          end
        else
          @assessment.recipient  = entity.name
          @assessment.cnpj       = entity.cnpj
          sector = 27
          @assessment.subject_id = 1756 #request
        end

        @assessment.finalized        = false

        number = set_number!(nil,sector)

        @assessment.document_number = number

        if @assessment.save

          if !candidate.nil?
            @service = Core::Attendance::RequerimentService.new(@assessment, candidate)
            @service.new_requeriment!
          end

          set_conduct!(@assessment, nil, sector)

          return true
        else
          return false
        end

      end

      def requeriment_citzen_app!
        @assessment.document_type_id = 26
        @assessment.finalized        = false
        sector = 30
        @assessment.subject_id = 1747 #request
        number = set_number!(nil,sector)
        @assessment.document_number = number

        if @assessment.save
          @service = Core::NotificationService.new
          message = "Um novo requerimento nº #{@assessment.document_number} foi aberto. Agora faz-se necessário aguardar o retorno do atendimento da CODHAB."
          begin
           @service.send_email!(message, "Abertura Requerimento CODHAB", @assessment.email)
          rescue            
          end
          set_conduct!(@assessment, nil, sector)
          return true
        else
          return false
        end
      end

      def create_document!
        number = set_number!(@assessment.staff_id, @assessment.sector_id)
        @assessment.document_number = number
        if @assessment.save
          set_conduct!(@assessment, @assessment.staff_id, @assessment.sector_id)
          return true
        else
          return false
        end
      end

      def set_number!(user, sector)
        document_type = Core::Protocol::DocumentType.find(@assessment.document_type_id)
        if @assessment.external_petition == true || document_type.prefex == 777
          @assessment.prefex = 777  #prefixo de documento externo
        elsif @assessment.document_type.prefex == 392
          @assessment.prefex = 392
        else
          sector_find = Core::Person::Sector.find(sector)
          @assessment.prefex = (!document_type.prefex.nil?) ? document_type.prefex  : sector_find.prefex
          documents = Core::Protocol::Assessment.where("sector_id = ? and document_type_id = ? and year = ? and prefex <> '777' ",@assessment.sector_id,
                                       @assessment.document_type_id,
                                       Time.now.year).order('number ASC').last
        end
        @assessment.staff_id    =  user
        @assessment.sector_id   =  sector
        @assessment.year        =  Time.now.year
        document = documents.present? ? documents : Core::Protocol::Assessment.where(document_type_id:  @assessment.document_type_id,
                                    year: Time.now.year, prefex: @assessment.prefex).order('number asc').last
        @assessment.number = (document.present?) ? document.number + 1 : 1
        format_document_number!
      end

      def format_document_number!
        number = "#{@assessment.prefex}#{'%06d' % @assessment.number}#{@assessment.year}"
        number =~ /(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{4})/
        number = "#{$1}-#{$2}.#{$3}/#{$4}"
        @assessment.document_number = number
      end

      def set_conduct!(assessment, user, sector)
        @conduct = Core::Protocol::Conduct.new
        @conduct.conduct_type = 0
        @conduct.assessment_id = assessment.id
        @conduct.staff_id = user
        @conduct.sector_id = sector
        @conduct.save
      end



    end
  end
end
