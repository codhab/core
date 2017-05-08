module Core
  module Protocol
    class AlertService # :nodoc:
      def due_documents_alert!
        @due_documents = Core::View::DueDocument.where('responded is not true')

        if @due_documents.present?
          @due_documents.each do |doc|
            if doc.days <= 2
              case doc.days
              when 2
                message = "Faltam 2 dias para o vencimento do prazo do documento: #{doc.document_number} - #{doc.document_type}. Este e-mail foi enviado ao responsável pelo documento."
              when 1
                message = "Falta 1 dia para o vencimento do prazo do documento: #{doc.document_number} - #{doc.document_type}. Este e-mail foi enviado ao responsável pelo documento, e seu gerente."
              when 0
                message = "O documento: #{doc.document_number} - #{doc.document_type} vence hoje. Este e-mail foi enviado ao responsável pelo documento, e seu gerente, seu diretor e à(o) responsável pela Secretaria Executiva."
              else
                message = "O documento: #{doc.document_number} - #{doc.document_type} está vencido à #{doc.days.abs} dias. Este e-mail foi enviado ao responsável pelo documento, e seu gerente, seu diretor e à(o) responsável pela Secretaria Executiva."
              end
              @sector = Core::Person::Sector.find(doc.sector_destiny_id)
              if @sector.present?
                @responsible = Core::Person::Staff.find(@sector.responsible_id)
                @staff = Core::Person::Staff.find(doc.staff_id) if doc.staff_id.present?
                @secex = Core::Person::Staff.where(sector_current_id: 3, status: true, job_id: 2).last
                @sector_manager = Core::Person::Sector.find(@responsible.sector_current_id) if @responsible.present?
                @manager = Core::Person::Staff.where(sector_current_id: @sector_manager.id, status: true, job_id: [3,4,5,6,7]).last
                @service = Core::NotificationService.new()
                subject = "Documento pendente"
                begin
                  # emails
                  @service.send_email!(message, subject, @staff.email) if @staff.present?
                  @service.send_email!(message, subject, @responsible.email) if @responsible.present?
                  @service.send_email!(message, subject, @secex.email)
                  @service.send_email!(message, subject, @manager.email) if @manager.present? && doc.days < 1
                  #pushs
                  #@teste = Core::Person::Staff.find(1490)
                #  @service.send_push!(@teste.id, message)

                rescue
                  return false
                end
              end
            end
          end
        end
      end
    end
  end
end
