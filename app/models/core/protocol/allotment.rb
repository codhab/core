module Protocol
  class Allotment < ActiveRecord::Base
    audited

    belongs_to :staff, class_name: "Person::Staff"
    has_many :conducts

    enum :priority => [:baixa, :media, :alta]

    scope :by_description,  -> (description) {where('description ilike ?', "%#{description}%")}
    scope :by_situation,  -> (situation) {where(status: situation)}
    scope :by_date_start, -> (date_start) { where("protocol_allotments.created_at::date >= ?", Date.parse(date_start))}

    scope :document_conduct_cancel, -> (sector_id) {
      @max = Protocol::Conduct.select('MAX(id)').group(:assessment_id)
      @conduct = Protocol::Conduct.select(:allotment_id).where(id: @max, conduct_type: 1)
      @cond = Protocol::Allotment.where(id: @conduct,sector_id: 5)

    }

  end
end
