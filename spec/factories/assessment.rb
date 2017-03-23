FactoryGirl.define do
  factory Core::Protocol::Assessment do
    recipient 'Teste'
    document_type_id 3
    subject_id 6
    description_subject 'isso é um teste'
  end
end
