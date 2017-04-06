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


      has_many :requeriments,      primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Regularization::Requeriment
      has_many :schedules,         primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Schedule::AgendaSchedule
      has_many :assessments,       primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Protocol::Assessment
      has_many :assessment_forms,       primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Protocol::AssessmentForm
      has_many :exemptions,        primary_key: :cpf, foreign_key: :cpf, class_name: ::Core::Sefaz::Exemption

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
      has_many :enterprise_cadastres,   foreign_key: "cadastre_id",       class_name: ::Core::Candidate::EnterpriseCadastre

      has_many :invoices,               foreign_key: :cpf,         primary_key: :cpf, class_name: ::Core::Brb::Invoice
      has_many :iptus,                  foreign_key: :cpf,         primary_key: :cpf, class_name: ::Core::Candidate::Iptu
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

      scope :by_cpf,          -> (cpf = nil) { where(cpf: cpf.gsub('-','').gsub('.','')) }

      mount_uploader :avatar, Core::Cadastre::AvatarUploader

      def income
        self[:income].present? ? '%.2f' % self[:income] : 0
      end

      def main_income
        self[:main_income].present? ? '%.2f' % self[:main_income] : 0
      end

      def age
       ((Date.today - self.born).to_i / 365.25).to_i rescue I18n.t(:no_information)
     end


     def special?
         (self.special_condition_id == 2 || self.special_condition_id == 3) || self.program_id == 5
     end

     def older?
         if self.born.present?
           (self.age >= 60)
         else
           false
         end
     end

     def zone?
         case self.income.to_f
         when 0..1800
           [1, 0, 1800]
         when 1800.01..2350
           [1.5, 1800.01, 2350]
         when 2350.01..3600
           [2, 2350.01, 3600]
         when 3600.01..6500
           [3, 3600.01, 6500]
         else
           [4, 6500.01, 11244]
         end
     end


     def special_family?
       self.dependents.where(special_condition_id: [2,3]).present?
     end

     def older_family?
       self.dependents.where('extract(year from age(born)) >= 60').present?
     end

     def list
       array = Array.new


       list_rii          = rii
       list_rie          = rie
       list_olders       = olders
       list_vulnerables  = vulnerables
       list_specials     = specials

       array << list_rii         unless list_rii.nil?
       array << list_rie         unless list_rie.nil?

       if self.presenter.current_situation_id != 2
         array << list_olders      unless list_olders.nil?
         array << list_vulnerables unless list_vulnerables.nil?
         array << list_specials    unless list_specials.nil?
       end

       array.each_with_index do |a, i|

         array[i] << position(array[i])
       end

       array
     end

     private

     def rii
       (self.program_id == 1) ? ['rii', self.zone?] : nil
     end

     def rie
       (self.program_id == 2) ? ['rie', self.zone?] : nil
     end

     def specials
       (self.special? || self.special_family?) ? ['special', self.zone?] : nil
     end

     def olders
       (self.older? || self.older_family?) ? ['older', self.zone?] : nil
     end

     def vulnerables
       (self.program_id == 4) ? ['vulnerable', self.zone?] : nil
     end

     def position(array)

         if array[0] == 'rii' || array[0] == 'rie'
             if [2,52].include? self.presenter.current_situation_id

               sql = "program_id = ? AND code = 20141201"
               @geral = Core::View::GeneralPontuation.select(:id)
                                                          .where(sql,
                                                                 self.program_id)
                                                          .map(&:id)
                                                          .find_index(self.id)
             else

               sql = "program_id = ? AND
                      situation_status_id in (4,54)
                      AND convocation_id > 1524
                      AND procedural_status_id IN(14, 72)
                      AND income BETWEEN ? AND ?"

               @geral = Core::View::GeneralPontuation.select(:id)
                                                          .where(sql,
                                                                 self.program_id,
                                                                 array[1][1],
                                                                 array[1][2])
                                                          .map(&:id)
                                                          .find_index(self.id)

             end
         else
             case array[0]
             when 'older'

                 sql = "(extract(year from age(born)) >= 60 or (select COUNT(*)
                        from extranet.candidate_dependents
                        where extract(year from age(born)) >= 60
                        and cadastre_id = general_pontuations.id) > 0)
                        AND convocation_id > 1524
                        AND procedural_status_id IN(14, 72)
                        AND situation_status_id in (4,54)
                        AND income BETWEEN  ? AND ?"

                 @geral = Core::View::GeneralPontuation.select(:id)
                                                            .where(sql,
                                                                   array[1][1],
                                                                   array[1][2])
                                                            .map(&:id)
                                                            .find_index(self.id)
             when 'special'
                 sql = "(special_condition_id in (2,3) or (select COUNT(*)
                         from extranet.candidate_dependents
                         where special_condition_id in (2,3)
                         and cadastre_id = general_pontuations.id) > 0)
                         and situation_status_id in (4,54)
                         and convocation_id > 1524
                         and procedural_status_id IN(14, 72)
                         and income BETWEEN ? AND ?"

                 @geral = Core::View::GeneralPontuation.select(:id)
                                                            .where(sql,
                                                                   array[1][1],
                                                                   array[1][2])
                                                            .map(&:id).find_index(self.id)

             when 'vulnerable'
                 sql = "program_id = ?
                       AND convocation_id > 1524
                       AND procedural_status_id IN(14, 72)
                       AND income BETWEEN ? AND ?"

                 @geral = Core::View::GeneralPontuation.select(:id)
                                                            .where(sql,4,
                                                                   array[1][1],
                                                                   array[1][2])
                                                            .map(&:id).find_index(self.id)
             end
         end

         @geral.present? ? @geral + 1 : nil
     end


    end
  end
end
