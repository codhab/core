module Core
  module Schedule
    class AgendaSchedule < ApplicationRecord
      self.table_name = 'extranet.schedule_agenda_schedules'
      
        scope :desc_created_at, -> { order('date DESC')}

        scope :date_start,   -> (date) { where('date >= ?', Date.parse(date))}
        scope :date_end,   -> (date) { where('date <= ?', Date.parse(date))}

        scope :by_status, -> (status) {where(status: status)}
        scope :by_cpf,    -> (cpf) {where(cpf: cpf.to_s.unformat_cpf)}
        scope :by_cnpj,   -> (cnpj) {where(cnpj: cnpj)}
        scope :by_hour,   -> (hour) {where(hour: hour)}
        scope :by_name,   -> (name) {where("name ILIKE '%#{name}%'")}
        scope :by_document,   -> (document) {where("document_number ILIKE '%#{document}%'")}

        scope :by_schedule,   -> (id) {where(agenda_id: id)}

        scope :by_year,  -> (year) {where("date_part('year', date) = ?", year)}
        scope :by_month,  -> (month) {where("date_part('month', date) = ?", month)}
        scope :by_week,  -> (week) {where("to_char(date::timestamp, 'W') = ?", week.to_s)}

        belongs_to :city, class_name: "Address::City"
        belongs_to :agenda

        enum status: ['agendado', 'liberado_para_retorno', 'cancelado', 'finalizado_sem_retorno']


    end
  end
end
