module Core
  module Document
    class Authenticate # :nodoc:
      include ActiveModel::Model

      attr_accessor :pin, :allotment_id, :user_id

      validates :pin, presence: true
      validate  :valid_pin?

      def valid_pin?
        @user = Core::Person::Staff.find(self.user_id)
        if @user.pin.present?
          if @user.pin != self.pin
            errors.add(:pin, "PIN não confere.")
            return false
          end
        else
          errors.add(:pin, "Não foi gerado PIN para este usuário.")
          return false
        end
        return true
      end
    end
  end
end
