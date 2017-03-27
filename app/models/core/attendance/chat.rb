require_dependency 'core/application_record'

module Core
  module Attendance
    class Chat < ApplicationRecord
      self.table_name = 'extranet.attendance_chats'

        validates :chat_category_id, presence: true

        belongs_to :chat_category, required: false, class_name: ::Core::Attendance::ChatCategory
        belongs_to :cadastre,      required: false, class_name: ::Core::Candidate::Cadastre
        belongs_to :staff,         required: false, class_name: ::Core::Person::Staff,           foreign_key: :close_staff_id

        has_many :chat_comments

        accepts_nested_attributes_for :chat_comments

        scope :by_name, -> (name) { joins(:cadastre).where('candidate_cadastres.name ilike ?', "%#{name}%")}
        scope :by_cpf, -> (cpf) { joins(:cadastre).where('candidate_cadastres.cpf = ?', cpf.gsub('-','').gsub('.',''))}
        scope :by_status, -> (status) { where(closed: status)}
        scope :by_date_start, -> (date_start) { where("created_at::date >= ?", Date.parse(date_start))}
        scope :by_date_end, -> (date_end) { where("created_at::date <= ?", Date.parse(date_end))}

    end
  end
end
