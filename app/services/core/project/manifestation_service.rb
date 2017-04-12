module Core
  module Project
    class ManifestationService
      
      # Indication Situations
      # 1 => indicação realizada
      # 2 => manifestação realizada
      # 3 => manifestação cancelada
      # 4 => indicação inativada
      

      # Indications Types
      # 1 => indicação sistêmica      
      # 2 => manifestação de interesse


      attr_accessor :cadastre, :project, :indication

      def initialize(cadastre: nil, project: nil)
        @cadastre = cadastre
        @project  = project
      end

      def indicate!
        return false if @cadastre.enterprise_cadastres.where(inactive: false).present?

        units       = @project.units
        indications = Core::Candidate::EnterpriseCadastre.where(enterprise_id: @project.id, inactive: false).count
        
        situation   = (indications.to_i < units.to_i) ? 1 : 2

        @indication = Core::Candidate::EnterpriseCadastre.new.tap do |enterprise|
          enterprise.cadastre_id              =  @cadastre.id
          enterprise.enterprise_id            =  @project.id
          enterprise.inactive                 =  false
          enterprise.indication_situation_id  =  situation
          enterprise.indication_type_id       =  2
          enterprise.manifestation_date       =  Date.current
        end

        if @indication.save
          message = "A manifestação para o empreendimento #{@project.name}, referente ao Programa Portas Abertas, foi realizada com sucesso. Aguarde o contato da CODHAB para mais informações."
          title   = "Manifestação para empreendimento - Realizada"
          
          service = Core::NotificationService.new
          service.create({
                          cadastre_id: @cadastre.id,
                          category_id: 5,
                          title: title,
                          content: message.html_safe,
                          push: true,
                          email: true
                        })        
        end

      end

      def cancel_indicate!

        @indication = @cadastre.enterprise_cadastres
                               .where(enterprise_id: @project.id,
                                      inactive: false,
                                      indication_situation_id: [1,2]).last
        
        return false if !@indication.present?

        if @indication.update(indication_situation_id: 3, inactive_date: Date.current, inactive: true)
          message = "A manifestação para o empreendimento #{@project.name}, referente ao Programa Portas Abertas, foi cancelada com sucesso."
          title   = "Manifestação para empreendimento - Cancelada"
          
          service = Core::NotificationService.new
          service.create({
                          cadastre_id: @cadastre.id,
                          category_id: 5,
                          title: title,
                          content: message.html_safe,
                          push: true,
                          email: true
                        })      
        end
      end

    end
  end
end