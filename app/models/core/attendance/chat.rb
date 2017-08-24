require_dependency 'core/application_record'

module Core
  module Attendance
    class Chat < ApplicationRecord
      self.table_name = 'extranet.attendance_chats'

        belongs_to :chat_category,                  class_name: ::Core::Attendance::ChatCategory
        belongs_to :cadastre,      required: false, class_name: ::Core::Candidate::Cadastre
        belongs_to :staff,         required: false, class_name: ::Core::Person::Staff,           foreign_key: :close_staff_id
        belongs_to :general,       required: false, class_name: ::Core::View::GeneralPontuation, foreign_key: :cadastre_id

        has_many :chat_comments,   class_name: ::Core::Attendance::ChatComment

        accepts_nested_attributes_for :chat_comments

        scope :by_name, -> (name) { joins(:cadastre).where('candidate_cadastres.name ilike ?', "%#{name}%")}
        scope :by_cpf, -> (cpf) { joins(:cadastre).where('candidate_cadastres.cpf = ?', cpf.gsub('-','').gsub('.',''))}
        scope :by_status, -> (status) { where(closed: status)}
        scope :by_date_start, -> (date_start) { where("created_at::date >= ?", Date.parse(date_start))}
        scope :by_date_end, -> (date_end) { where("created_at::date <= ?", Date.parse(date_end))}

        scope :by_situation, -> (situation) {
          joins(:cadastre).where(situation_status_id: situation)
         }


        scope :by_type, -> (type) {
          if type.to_i == 1
            joins(:cadastre).where('candidate_cadastres.program_id in (1,2,4,5,7,8)')
          end

          if type.to_i == 2
            joins(:cadastre).where('candidate_cadastres.program_id in (3,6)')
          end
        }

        validates :chat_category, presence: true



    end
  end
end
