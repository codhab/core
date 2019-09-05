require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class Cadastre < ApplicationRecord # :nodoc:
      self.table_name = 'portal.social_work_cadastre_cadastres' 
      attr_accessor :remember_token, :activation_token, :reset_token, :token, :password_confirmation

      belongs_to :city, class_name: ::Core::Address::City, foreign_key: 'city_id'
      #belongs_to :uf, class_name: ::Core::Address::State, foreign_key: 'uf'
      has_many :cadastre_members, class_name: ::Core::SocialWorkCadastre::CadastreMember
      has_many :cadastre_titulars, class_name: ::Core::SocialWorkCadastre::CadastreTitular
      has_many :upload_documents, class_name: ::Core::SocialWorkCadastre::UploadDocument
      has_many :responsibles, class_name: ::Core::SocialWorkCadastre::Responsible
      has_many :locations, class_name: ::Core::SocialWorkCadastre::CadastreLocation
      has_many :steps, class_name: ::Core::SocialWorkCadastre::CadastreStep
      has_many :observations, class_name: ::Core::SocialWorkCadastre::Observation

      validates :social_reason, :cep, :address, :telephone, :crea, :city_id, presence: true
      validates :email, email: true, presence: true
      validates :password, presence: true, length: {minimum: 6, maximum: 20}
      validates :district, :uf, presence: true
      validates :cnpj, cnpj: true, presence: true, uniqueness: true

      scope :by_cnpj,           -> (cnpj)    {where(cnpj: cnpj.gsub('.','').gsub('/','').gsub('-',''))}
      scope :by_social_reason,  ->(social_reason) {where('social_reason ilike ?', "%#{social_reason}%")}
      scope :by_sicaf,          ->(sicaf) { where(sicaf: sicaf) }
      scope :credential_2018,   -> { where(assignment: 2018).order('id desc') }
      scope :credential_2019,   -> { where(assignment: 2019).order('id desc') }

      enum situation: ['Aguardando', 'Habilitado', 'Não Habilitado', 'Pendente', 'Em Analise']

      before_save   :downcase_email
      before_create :create_activation_digest

      def destroy_step(cadastre)
        @step = Core::SocialWorkCadastre::CadastreStep.where(cadastre_id: cadastre.id, step: 1).last
        if @step.present?
          @step.destroy
        end
      end

      # Sets the password reset attributes.
      def create_reset_digest
        self.reset_token = new_token
        update_attribute(:reset_digest,  digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
        update_attribute(:activation_digest, reset_token)
      end

      # Sends password reset email.
      def send_password_reset_email
        Core::SocialWorkCadastre::CadastreMailer.password_reset(self).deliver_now
      end

      def password_reset_expired?
        reset_sent_at < 2.hours.ago
      end

      private

      def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? ::BCrypt::Engine::MIN_COST : ::BCrypt::Engine.cost
        ::BCrypt::Password.create(string, cost: cost)
      end

      def new_token
        ::SecureRandom.urlsafe_base64
      end

      # Converts email to all lower-case.
      def downcase_email
        self.email = email.downcase
      end

      # Creates and assigns the activation token and digest.
      def create_activation_digest
        self.activation_token  = new_token
        self.activation_digest = digest(activation_token)
      end
    end
  end
end
