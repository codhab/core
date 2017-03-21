module Project
  module View
    class FirmCadastre < ActiveRecord::Base
      self.table_name = 'extranet.firm_cadastres'

      scope :by_cpf, -> (cpf) {where(cpf: cpf)}
      scope :by_status, -> (status) {where(enterprise_cadastre_status_id: status)}
      scope :by_name, -> (name_candidate) {where("name LIKE ? ", "#{name_candidate}%")}
      scope :by_enterprise, -> (name_candidate) {where("name LIKE ? ", "#{name_candidate}%")}

      scope :by_list, -> (list) {where(program_id: list)}

      belongs_to :cadastre, class_name: "Candidate::Cadastre", foreign_key: "cadastre_id"
      belongs_to :enterprise, class_name: "Project::Enterprise", foreign_key: "enterprise_id"
      belongs_to :enterprise_cadastre_situation, class_name: "Candidate::EnterpriseCadastreSituation", foreign_key: "enterprise_cadastre_status_id"

      def self.by_new(by_new)
         if by_new
           where(enterprise_cadastre_status_id: nil)
         else
           where("enterprise_cadastre_status_id is not null")
         end
       end


    end
  end
end
