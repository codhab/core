require_dependency 'core/attendance/notification'

module Core
  class NotificationService

    AUTH_TOKEN = APP_ENV['onesignal']['auth_token']
    APP_ID     = APP_ENV['onesignal']['app_id']
      
    attr_accessor :notification, :cadastre

    def self.create(cadastre_id: nil, category_id: 1, content: nil, title: nil, link: false, push: false, email: false)

      return false if cadastre_id.nil?

      @cadastre = Core::Candidate::Cadastre.find(cadastre_id) rescue nil

      return false if @cadastre.nil?

      @notification = Core::Attendance::Notification.new.tap do |notification|
        notification.cadastre_id              = @cadastre.id
        notification.title                    = title
        notification.content                  = content
        notification.notification_category_id = category_id
        notification.link                     = link
      end

      @notification.save 

      # => OneSignal API
      if push && @cadastre.mobile_user_token.present?
        
        params = {heading: title, message: content, user_ids: @cadastre.mobile_user_token}             
        send_push_notification!(params)
      
      end

      # => ActionMailer
      if email && @cadastre.email.present?
        
        params = {heading: title, message: content, emails: @cadastre.email}  
        send_email_notification!(params)
      
      end

      return true
      
    end

    def self.create_bulk(category_id: 1, content: nil, title: nil, cadastre_ids: [], push: false, email: false)

      cadastre_ids.each do |cadastre_id|
        create(category_id: category_id, content: content, title: title, push: false)
      end

      if push 

        mobile_user_ids = Core::Candidate::Cadastre.where(id: cadastre_ids).map(&:mobile_user_token)
        mobile_user_ids = mobile_user_ids.reject { |c| c.empty? }
      
        params = {heading: title, message: content, user_ids: mobile_user_ids}  

        send_push_notification!(params)

      end

      if email 
      
        user_emails = Core::Candidate::Cadastre.where(id: cadastre_ids).map(&:email)
        mobile_user_ids = mobile_user_ids.reject { |c| c.empty? }
        
        params = {heading: title, message: content, emails: user_emails}  

        send_email_notification!(params)

      end

      return true

    end

    private

    def send_push_notification!(message: nil, user_ids: nil, heading: nil)

      return false if user_ids.nil? || message.nil?

      array = []
      array = user_ids.is_a?(Array) ? user_ids : array << user_ids

      params = {
        headings:{ en: heading },
        contents:{ en: message },
        include_player_ids: array 
      }

      @client = OneSignal::Client.new(auth_token: AUTH_TOKEN, app_id: APP_ID)

      begin
        @client.notifications.create(params)
        return true
      rescue Exception => e 
        puts e
        return false
      end
    end

    def send_email_notification!(message: nil, subject: nil, emails: nil)
      
      return false if emails.nil? || message.nil?
      
      array = []
      array = emails.is_a?(Array) ? emails : array << emails

      emails.each do |email|
        #Sender e-mail to-do
        #ClassMailer.notification_mail(email: email, subject: subject, body: message).delivery_now!
      end
    end
    
  end
end