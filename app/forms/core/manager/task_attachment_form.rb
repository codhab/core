module Core
  module Manager
    class TaskAttachmentForm < ::Core::Manager::TaskAttachment 

      validates :name, :document, presence: true

      validates :document, file_size: { less_than_or_equal_to: 25.megabytes },
                file_content_type: { allow: ['application/pdf', 
                                             'image/jpeg',
                                             'image/png',
                                             'image/jpg'] }
        

      mount_uploader :document, Core::Manager::DocumentUploader
    end
  end
end
