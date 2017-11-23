module Core
  module Document
    class NotificationService # :nodoc:
      AUTH_TOKEN = APP_ENV['onesignal']['auth_token']
      APP_ID     = APP_ENV['onesignal']['app_id']
      
      def send_push!(staff, content)
        @staff = Core::Person::Staff.find(staff)
        title = 'PIN'
        if @staff.mobile_user_token.present?
          params = { heading: title, message: content, user_ids: @staff.mobile_user_token }
          send_push_notification!(params)
        end
      end

      private

      def send_push_notification!(message: "", user_ids: nil, heading: "")
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
        rescue StandardError => e
          puts e
          return false
        end
      end
    end
  end
end
