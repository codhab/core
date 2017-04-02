module Core
  module Attendance
    class AvatarForm < Core::Candidate::Cadastre 
     
      validates :avatar, file_size: { less_than_or_equal_to: 50.megabytes },
                         file_content_type: { allow: ['image/jpeg', 'image/png'] },
                         allow_blank: true 
     
    end
  end
end