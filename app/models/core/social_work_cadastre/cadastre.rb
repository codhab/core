module Core
  module SocialWorkCadastre
    class Cadastre < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastres'
      belongs_to :city, class_name: '::Address::City', foreign_key: 'city_id'
      has_many :cadastre_members, class_name: '::SocialWorkCadastre::CadastreMember'
      has_many :cadastre_titulars, class_name: '::SocialWorkCadastre::CadastreTitular'
      has_many :upload_documents, class_name: '::SocialWorkCadastre::UploadDocument'
      has_many :responsibles, class_name: 'SocialWorkCadastre::Responsible'
      has_many :locations, class_name: 'SocialWorkCadastre::CadastreLocation'
      has_many :steps, class_name: 'SocialWorkCadastre::CadastreStep'

      validates :social_reason, :cep, :address, :telephone, :crea, :city_id, presence: true
      validates :email, email: true, presence: true
      validates :password, presence: true, length: {minimum: 6, maximum: 20}
      validates :district, :uf, presence: true
      validates :cnpj, cnpj: true, presence: true, uniqueness: true

      enum situation: ['Aguardando', 'Habilitado', 'Não Habilitado', 'Pendente', 'Em Analise']

      def destroy_step(cadastre)
        @step =  Core::SocialWorkCadastre::CadastreStep.where(cadastre_id: cadastre.id, step: 1).last
        if @step.present?
          @step.destroy
        end
      end

    end
  end
end
