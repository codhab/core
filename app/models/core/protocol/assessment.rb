require_dependency 'core/application_record'
require_dependency 'core/person/staff'
require_dependency 'core/person/sector'
require_dependency 'core/candidate/cadastre'

module Core
 module Protocol
  class Assessment < ApplicationRecord
    self.table_name = 'extranet.protocol_assessments'

    belongs_to :document_type,  required: false, class_name: ::Core::Protocol::DocumentType
    belongs_to :subject,        required: false, class_name: ::Core::Protocol::Subject
    belongs_to :staff,          required: false, class_name: ::Core::Person::Staff
    belongs_to :sector,         required: false, class_name: ::Core::Person::Sector

    has_many :conducts
    has_many :digital_documents
    has_many :locations
    has_many :controls
    has_many :call_controls

    has_many :solicitations

    has_many :attach_documents, foreign_key: "document_father_id"
    has_many :attach_document_children, class_name: ::Core::Protocol::AttachDocument, foreign_key: "document_child_id"

    accepts_nested_attributes_for :digital_documents

    scope :by_process,  -> (process) {where(document_number: process)}
    scope :by_external_number,  -> (external) {where(external_number: external)}
    scope :by_doc_type,  -> (doc_type) {where(document_type_id: doc_type)}
    scope :by_cpf,  -> (cpf) {where(cpf: cpf.gsub('-','').gsub('.',''))}
    scope :by_cnpj,  -> (cnpj) {where(cnpj: cnpj)}
    scope :by_sector,  -> (sector) {where(sector_id: sector)}
    scope :by_subject,  -> (subject) {where(subject_id: subject)}
    scope :by_desc_subject,  -> (desc_subject) {where('description_subject ilike ?', "%#{desc_subject}%")}
    scope :by_interested,  -> (interested) {where("recipient ilike ? ", "%#{interested}%")}
    scope :by_external_agency,  -> (external_agency) {where("external_agency ilike ? ", "%#{external_agency}%")}
    scope :by_observation,  -> (observation) {where("observation ilike ? ", "%#{observation}%")}

    scope :by_date_start, -> (date_start) { where("protocol_assessments.created_at::date >= ?", Date.parse(date_start))}
    scope :by_date_end, -> (date_end) { where("protocol_assessments.created_at::date <= ?", Date.parse(date_end))}

    validates :document_number, uniqueness: { scope: [:document_type] }, presence: true
    

  end
 end
end
