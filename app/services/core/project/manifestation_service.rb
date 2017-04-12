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

        @indication.save
        
      end

      def cancel_indicate!

        @indication = @cadastre.enterprise_cadastres
                               .where(enterprise_id: @project.id,
                                      inactive: false,
                                      indication_situation_id: [1,2]).last
        
        return false if !@indication.present?

        @indication.update(indication_situation_id: 3, inactive_date: Date.current, inactive: true)
      end

    end
  end
end