module Core
  module Attendance
    class NotificationService

      attr_accessor :cadastre, :notification

      AUTH_TOKEN = 'MmEyZTMxMDgtZWEyOC00MTkzLWE1YTUtOWUwMDUxZGUxYzVi'
      APP_ID     = 'f8691fb0-e0c9-4d6a-b927-c795b65727c5'


      def initialize(ticket: nil, cadastre: nil)
        @ticket   = ticket
        @cadastre = cadastre
      end

      def create(category_id: 1, message: "", title: nil, target_model: nil, mobile: false, target: nil, push: true)

        notification = Core::Attendance::Notification.new({
          cadastre_id: @cadastre.id,
          title: title,
          category_id: category_id,
          message: message,
          target_model: target_model,
          mobile: mobile,
          target_id: target
        })

        notification.save

        if push

          send_push(heading: notification.title,
                    message: notification.message,
                    user_ids: notification.cadastre.mobile_user_token)
        end

      end


      private

      def send_push(message: nil, user_ids: nil, heading: nil)

        return false if user_ids.nil? || message.nil?

        if user_ids.is_a?(Array)
          array = user_ids
        else
          array = []
          array << user_ids
        end

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
        end
      end

    end
  end
end
