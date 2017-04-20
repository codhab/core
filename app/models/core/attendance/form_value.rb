require_dependency 'core/application_record'

module Core
  module Attendance
    class FormValue < ApplicationRecord
      self.table_name = 'extranet.attendance_form_values'
      belongs_to :form

      before_save :normalize_fields

      def initialize(attributes = {})
        super

        write_attributes
      end
      
      def write_attributes
        return if !fields.present?

        fields.each do |field|
          self.class.store_accessor :store, field.name.to_sym
          self.class.validates field.name.to_sym, presence: true
        end

      end

      def fields
        form.form_fields
      end

      private

      def normalize_fields
        self.store.each do |field|
          case field[1].class.to_s
          when 'ActionDispatch::Http::UploadedFile'
            self.send("#{field[0]}=", write_file(field[1]))
            errors.add(field[0].to_sym, 'Arquivo bla') if self.send(field[0].to_sym)
          end
          
        end
      end

      def write_file(file)
        begin
          extension = file.original_filename.split('.')[-1]
          new_name  = "teste.#{extension}"

          file.original_filename = new_name

          File.open(Rails.root.join('public', new_name), 'wb') do |wfile|
            wfile.write(file.read)
          end

          return new_name
        rescue Exception => e
          puts e

          return nil
        end
      end

    end
  end
end
