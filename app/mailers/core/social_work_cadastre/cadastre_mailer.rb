module Core
  module SocialWorkCadastre
    class CadastreMailer < ApplicationMailer # :nodoc:
      default from: 'nao-responda@codhab.df.gov.br'
      
      def password_reset(user)
        @user = user
        mail to: user.email, subject: 'Alteração de senha (credenciamento 01-2018 CODHAB)'
      end
    end
  end
end
