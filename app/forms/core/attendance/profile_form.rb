module Core
  module Attendance
    class ProfileForm < Core::Candidate::Cadastre 
  
      attr_accessor :password_confirmation

      validates :avatar, file_size: { less_than_or_equal_to: 50.megabytes },
                         file_content_type: { allow: ['image/jpeg', 'image/png', 'image/jpg'] },
                         allow_blank: true 
      
      validates :password, :password_confirmation, length: { minimum: 6, maximum: 28}, allow_blank: true
      validate  :password_equal?

      private

      def password_equal?
        if self.password != self.password_confirmation
          errors.add(:password, "Senhas não conferem")
          errors.add(:password_confirmation, "Senhas não conferem")
        end
      end

    end
  end
end