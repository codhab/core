require_dependency 'core/application_record'
require_dependency 'core/person/staff'
require_dependency 'core/person/sector'

module Core
 module Protocol
  class Assessment < ApplicationRecord
    self.table_name = 'extranet.protocol_assessments'

    belongs_to :document_type,  class_name: ::Core::Protocol::DocumentType
    belongs_to :subject,        required: false, class_name: ::Core::Protocol::Subject
    belongs_to :staff,          required: false, class_name: ::Core::Person::Staff
    belongs_to :sector,         required: false, class_name: ::Core::Person::Sector
    belongs_to :cadastre,      required: false, class_name: ::Core::Candidate::Cadastre,            primary_key: :cpf, foreign_key: :cpf
    belongs_to :general, class_name: ::Core::View::GeneralPontuation, foreign_key: :cpf, primary_key: :cpf

    has_many :conducts
    has_many :digital_documents, class_name: ::Core::Protocol::DigitalDocument
    has_many :digital_document_forms, class_name: ::Core::Protocol::DigitalDocumentForm
    has_many :locations
    has_many :controls
    has_many :call_controls
    has_many :workflows

    has_many :solicitations

    has_many :attach_documents, foreign_key: "document_father_id"
    has_many :attach_document_children, class_name: ::Core::Protocol::AttachDocument, foreign_key: "document_child_id"

    accepts_nested_attributes_for :digital_documents
    accepts_nested_attributes_for :digital_document_forms

    scope :by_process,  -> (process) {where(document_number: process)}
    scope :by_external_number,  -> (external) {where(external_number: external)}
    scope :by_doc_type,  -> (doc_type) {where(document_type_id: doc_type)}
    scope :by_finalized,  -> (finalized) {where(finalized: finalized)}
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

    scope :requeriments, -> { where(prefex: 777, subject_id: [1746,1747]) }

    scope :not_requeriments, -> { where.not(prefex: 777, subject_id: [1746,1747]) }

    validates :document_number, uniqueness: { scope: [:document_type] }, presence: true, on: :create

  end
 end
end
