require_dependency 'core/application_record'
require_dependency 'core/person/sector'
require_dependency 'core/person/staff'

module Core
  module Protocol
    class Conduct < ApplicationRecord
      self.table_name = 'extranet.protocol_conducts'

      belongs_to :assessment,  required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :allotment,   required: false, class_name: ::Core::Protocol::Allotment
      belongs_to :staff,       required: false, class_name: ::Core::Person::Staff
      belongs_to :sector,      required: false, class_name: ::Core::Person::Sector

      enum :conduct_type => [:doc_create, :doc_sent, :doc_return, :doc_cancel, :doc_receive, :doc_to_send]

      scope :find_last, -> { where(created_at: Conduct.select("MAX(created_at)").group(:assessment_id))}

      scope :find_by_type, -> (type){ where(created_at: Conduct.select("MAX(created_at)").group(:assessment_id), conduct_type: type)}

      scope :find_sector, -> (sector,type) { where(id: Conduct.select("MAX(id)").group(:assessment_id), conduct_type: type, sector_id: sector)}

      scope :find_allotment, -> (allotment) { where(created_at: Conduct.select("MAX(created_at)").where(allotment_id: allotment).group(:assessment_id), conduct_type: 5)}

      scope :by_sector,  -> (sector) {where(sector_id: sector)}

      scope :by_subject,  -> (subject) {where("protocol_assessments.subject_id = ? ", subject)}

      scope :by_doc_type,  -> (doc_type) {where("protocol_assessments.document_type_id = ?", doc_type)}

      # QUERY DO
      scope :find_document, -> (document_number, document_type, type, sector_id,document_current){
      where(created_at: Protocol::Conduct
                .joins(:assessment)
                .select("MAX(protocol_conducts.created_at)")
                .where("protocol_assessments.document_number = ?
                             AND protocol_assessments.document_type_id in (?)
                             AND protocol_conducts.sector_id = ? AND protocol_assessments.id <> ?",
                            document_number, document_type, sector_id,document_current)
                .group(:assessment_id), conduct_type: type)}


    end
  end
end
