module Protocol
  class Assessment < ActiveRecord::Base

    audited

    attr_accessor :prefex_protocol

    belongs_to :document_type, -> {order(:name)}
    belongs_to :subject, -> {order(:name)}
    belongs_to :staff, class_name: "Person::Staff"
    belongs_to :sector, class_name: "Person::Sector"

    belongs_to :candidate, class_name: "Candidate::Cadastre", primary_key: :cpf, foreign_key: :cpf

    has_many :conducts
    has_many :digital_documents
    has_many :locations
    has_many :controls
    has_many :call_controls

    has_many :solicitations

    has_many :attach_documents, foreign_key: "document_father_id"
    has_many :attach_document_children, class_name: "Protocol::AttachDocument", foreign_key: "document_child_id"

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



    before_validation :set_number, on: :create

    validates :document_type,  presence: true
    validates :subject, presence: true
    validates :requesting_unit, presence: true
    validates :cpf, cpf: true, if: lambda {|attr| attr.cpf.present?}

    validates :document_number, uniqueness: { scope: [:document_type] }, presence: true

    after_create :set_conduct

    def set_conduct
        current_user = Person::Staff.find(self.staff_id)
        @conduct  = Protocol::Conduct.new
        @conduct.conduct_type = 0
        @conduct.assessment_id = self.id
        @conduct.staff_id = current_user.id
        @conduct.sector_id = current_user.sector_current.id
        @conduct.save
    end


    def set_staff(staff_id)
        self.staff_id = staff_id
    end

    def self.to_csv(options = {})
       CSV.generate(options) do |csv|
         csv << all.first.attributes.keys
             all.each do |assessment|
               csv << assessment.attributes.values
             end
       end
    end

    private

    def set_number

      current_user = Person::Staff.find(self.staff_id)

        if  current_user.sector_current.present?

          if self.prefex_protocol == "true" || self.document_type.prefex == 777
            self.prefex = 777  #prefixo de documento externo
            self.staff_id    =  current_user.id
            document_type = Protocol::DocumentType.find(self.document_type_id)
            self.year = Time.now.year
            documents = Assessment.where(document_type_id:  self.document_type_id,
                                         year: self.year, prefex: self.prefex).order('id asc').last

            self.number = (documents.present?) ? documents.number + 1 :  1
          elsif self.document_type.prefex == 392
            self.prefex = 392
            document_type = Protocol::DocumentType.find(self.document_type_id)
            self.year = Time.now.year
            documents = Assessment.where(document_type_id:  self.document_type_id,
                                         year: self.year, prefex: self.prefex).order('id asc').last

            self.number = (documents.present?) ? documents.number + 1 :  1

          else
            self.staff_id    =  current_user.id
            document_type = Protocol::DocumentType.find(self.document_type_id)
            self.prefex = (!document_type.prefex.nil?) ? document_type.prefex  : self.sector.prefex
            self.year = Time.now.year
            documents = Assessment.where("sector_id = ? and document_type_id = ? and year = ? and prefex <> '777' ",self.sector_id,
                                         self.document_type_id,
                                         self.year).order('id ASC').last

            self.number = (documents.present?) ? documents.number + 1 :  1
          end

           format_document_number

        end
    end




    def format_document_number
        number = "#{self.prefex}#{'%06d' % self.number}#{self.year}"
        number =~ /(\d{3})\.?(\d{3})\.?(\d{3})-?(\d{4})/
        number = "#{$1}-#{$2}.#{$3}/#{$4}"

        self.document_number = number
    end




  end
end
