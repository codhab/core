module Core
  module Manager
    class TemplateForm < ::Core::Manager::Template

      validates :name, :description, presence: true
    end
  end
end