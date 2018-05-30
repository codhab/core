require_dependency 'core/application_record'

module Core
  module Document
    class Allotment < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.document_allotments'

      belongs_to :template, class_name: ::Core::Document::Template
      belongs_to :staff,    class_name: ::Core::Person::Staff
      belongs_to :main,     class_name: ::Core::Person::Staff, foreign_key: :main_authenticate_id
      belongs_to :first,    class_name: ::Core::Person::Staff, foreign_key: :first_authenticate_id
      belongs_to :second,   class_name: ::Core::Person::Staff, foreign_key: :second_authenticate_id
      belongs_to :third,    class_name: ::Core::Person::Staff, foreign_key: :third_authenticate_id
      belongs_to :fourth,   class_name: ::Core::Person::Staff, foreign_key: :fourth_authenticate_id
      belongs_to :fifth,    class_name: ::Core::Person::Staff, foreign_key: :fifth_authenticate_id

      has_many :data_prints, class_name: ::Core::Document::DataPrint

      enum allotment_type: %w(Escritura Reetificação)

      validates :template_id, :data_document, presence: true

      scope :by_date, -> (date) {where('created_at::date = ?', Date.parse(date))}
      scope :by_cpf, -> (cpf) {joins(:data_prints).where('document_data_prints.cpf = ?', cpf.gsub('-','').gsub('.',''))}

    end
  end
end
