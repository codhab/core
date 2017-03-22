describe Core::Protocol::AssessmentService do
  let(:params) do
    {
      assessment: {
        document_type_id: 3,
        subject_id: 6,
        recipient: 'Teste do sistema'
      }
     }
  end

   it 'create a new assessment' do
     expect do
       assessment :create, params
     end.to change(Core::Protocol::Assessment, :count).by(1)
   end
end
