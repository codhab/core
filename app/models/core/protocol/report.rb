module Protocol
  class Report
    include ActiveModel::Model

    attr_accessor :date_start, :date_end, :document_type, :subject

  end
end
