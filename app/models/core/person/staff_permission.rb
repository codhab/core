module Person
  class StaffPermission < ActiveRecord::Base
    belongs_to :system, class_name: "Main::System"
    belongs_to :action_permission, class_name: "Main::ActionPermission"
    belongs_to :nav, class_name: "Main::Nav"
    belongs_to :staff

    validates_uniqueness_of :staff, :scope => :system_permission
  end
end
