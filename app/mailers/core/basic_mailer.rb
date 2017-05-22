require_dependency 'core/application_mailer'

module Core
  class BasicMailer < ApplicationMailer 
    default from: 'nao-responda@codhab.df.gov.br'
    
    def simple_sender(email, subject, message)
      @message = message 
      @subject = subject
      mail(to: email, subject: subject)
    end
 
  end
end
