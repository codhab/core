describe Core::Protocol::Assessment do

   it 'create a new assessment' do
     expect do
       FactoryGirl.create(Core::Protocol::Assessment)
     end.to change(Core::Protocol::Assessment, :count).by(1)
   end
end
