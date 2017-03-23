require_dependency 'core/application_record'

module Core
  module Candidate
    class Cadastre < ApplicationRecord

      self.table_name = 'extranet.candidate_cadastres'

      belongs_to :special_condition,      required: false,          class_name: ::Core::Candidate::SpecialCondition
      belongs_to :special_condition_type, required: false,          class_name: ::Core::Candidate::SpecialConditionType
      belongs_to :city,                   required: false,          class_name: ::Core::Address::City
      belongs_to :state,                  required: false,          class_name: ::Core::Address::State
      belongs_to :work_city,              required: false,          class_name: ::Core::Address::City
      belongs_to :civil_state,            required: false,          class_name: ::Core::Candidate::CivilState
      belongs_to :program,                required: false,          class_name: ::Core::Candidate::Program
      belongs_to :work_city,              required: false,          class_name: ::Core::Address::City


      # => Associations in attendance
      has_many :tickets,       class_name: ::Core::Attendance::Ticket
      has_many :notifications, class_name: ::Core::Attendance::Notification


      has_many :requeriments, primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Regularization::Requeriment
      has_many :schedules,    primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Schedule::AgendaSchedule
      has_many :assessments,  primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Protocol::Assessment
      has_many :exemptions,   primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Sefaz::Exemption

      has_many :occurrences,                                        class_name: ::Core::Candidate::CadastreOccurrence
      has_many :ammvs
      has_many :cadastre_observations
      has_many :cadastre_mirrors
      has_many :dependents
      has_many :dependent_creates
      has_many :cadastre_situations
      has_many :pontuations , ->  { order(:id)}
      has_many :positions
      has_many :cadastre_attendances
      has_many :cadastre_checklists
      has_many :attendance_logs
      has_many :cadastre_geolocations
      has_many :enterprise_cadastres,   foreign_key: "cadastre_id",                   class_name: ::Core::Candidate::EnterpriseCadastre

      has_many :invoices,               foreign_key: :cpf,         primary_key: :cpf, class_name: ::Core::Brb::Invoice
      has_many :cadastre_address
      has_many :cadastre_procedurals
      has_many :cadastre_logs
      has_many :inheritors
      has_many :cadastre_activities
      has_many :cadastre_convocations

      has_many :old_candidates,                                                       class_name: ::Core::Entity::OldCandidate
      has_many :olds, through: :old_candidates,                                       class_name: ::Core::Entity::Old


      has_many :cadastre_attendances
      has_many :cadastre_attendance_statuses, through: :cadastre_attendances
      has_many :attendance_chats,  class_name: ::Core::Attendance::Chat

      enum gender: ['N/D', 'masculino', 'feminino']
    end
  end
end
