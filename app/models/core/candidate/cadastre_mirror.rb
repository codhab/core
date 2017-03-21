module CoreCandidate
  class CadastreMirror < ApplicationRecord
    self.table_name = 'extranet.candidate_cadastre_mirrors'

    belongs_to :special_condition, required: false
    belongs_to :city, required: false, class_name: ::CoreAddress::City
    belongs_to :state, required: false, class_name: ::CoreAddress::State
    belongs_to :work_city, required: false, class_name: ::CoreAddress::City
    belongs_to :civil_state, required: false
    belongs_to :program
    belongs_to :city, required: false, class_name: ::CoreAddress::City
    belongs_to :work_city, required: false, class_name: ::CoreAddress::City
    belongs_to :work_state, required: false, class_name: ::CoreAddress::State
    belongs_to :cadastre
    belongs_to :special_condition_type, required: false, class_name: ::CoreCandidate::SpecialConditionType
    belongs_to :cadastre_situation, required: false, class_name: ::CoreCandidate::CadastreSituation, foreign_key: 'situation_id', primary_key: "id"
    belongs_to :cadastre_procedural, required: false, class_name: ::CoreCandidate::CadastreProcedural, foreign_key: 'procedural_id', primary_key: "id"

    has_many :dependent_mirrors, dependent: :destroy
    has_many :attendance_logs
    has_many :cadastre_procedurals
    has_many :attendances, class_name: "Attendance::Cadastre"
    has_many :iptus, foreign_key: 'cpf'
    has_many :cadastre_attendances


    has_one :pontuation

    enum situation: ['em_progresso','pendente', 'aprovado']
    enum gender: ['N/D', 'masculino', 'feminino']



  end
end
