module Core
  module Attendance    
    class TicketAction < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_actions'
      
      belongs_to :situation, class_name: Core::Attendance::TicketActionSituation, foreign_key: :situation_id      
      belongs_to :context,   class_name: Core::Attendance::TicketActionContext,   foreign_key: :context_id      
     
      has_many :uploads,
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :born_documents, -> {where(category_id: 1)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id


      has_many :certificate_born_documents,-> {where(category_id: 8)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :rg_documents,-> {where(category_id: 2)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :cpf_documents,-> {where(category_id: 3)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :residence_documents,-> {where(category_id: 4)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :arrival_df_documents,-> {where(category_id: 5)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :registry_documents, -> {where(category_id: 6)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :payment_documents, -> {where(category_id: 7)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      has_many :income_documents, -> {where(category_id: 9)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id


      has_many :special_condition_documents, -> {where(category_id: 10)},
               class_name: Core::Attendance::TicketUpload,
               foreign_key: :action_id

      accepts_nested_attributes_for :born_documents,              allow_destroy: true
      accepts_nested_attributes_for :certificate_born_documents,  allow_destroy: true
      accepts_nested_attributes_for :rg_documents,                allow_destroy: true
      accepts_nested_attributes_for :cpf_documents,               allow_destroy: true
      accepts_nested_attributes_for :residence_documents,         allow_destroy: true
      accepts_nested_attributes_for :arrival_df_documents,        allow_destroy: true
      accepts_nested_attributes_for :registry_documents,          allow_destroy: true
      accepts_nested_attributes_for :payment_documents,           allow_destroy: true
      accepts_nested_attributes_for :income_documents,            allow_destroy: true
      accepts_nested_attributes_for :special_condition_documents, allow_destroy: true
    end
  end
end
