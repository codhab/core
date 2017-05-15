module Core
  module Manager
    class NotificationService

      attr_accessor(
        :staff,
        :project,
        :task,
        :problem,
        :attachment,
        :service
      )

      def self.write_activity(project_id: nil, task_id: nil, title: nil, content: nil, responsible_id: nil)
        activity = Core::Manager::Activity.new.tap do |o|
          o.project_id      = project_id
          o.task_id         = task_id
          o.title           = title 
          o.content         = content 
          o.responsible_id  = responsible_id
        end

        activity.save
      end

      def write_and_send_notification(subject, text, reference_id, reference_model)

        @notification = Core::Person::Notification.new.tap do |notification|
          n.staff_id = @staff.id,
          n.content  = text 
          n.title    = subject
          n.reference_context  = "manager"
          n.reference_id       = reference_id
          n.reference_model    = reference_model
        end

        @notification.save

        email   = @staff.email
        message = text.html_safe

        send_mail(@staff.email, subject, text.html_safe)
        send_push(subject, text, @staff.mobile_user_token)

      end

      private

      def send_mail(email, subject, message)
        begin
          Core::BasicMailer.simple_sender(email, subject, message).deliver_now!
          return true
        rescue Exception => e 
          puts e
          return false
        end
      end

      def send_push(heading, message, mobile_user_token)
        
        array = []
        array << mobile_user_token

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

    end
  end
end