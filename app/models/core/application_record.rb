require 'bcrypt'

module Core
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # self.class.superclass.name
    # => Core::Candidate::Cadastre

    def presenter(presenter = nil)

      if presenter.nil?
        super_class = self.class.superclass.name rescue nil
        name_class  = self.class.name rescue nil
        presenter   = (super_class == "Core::ApplicationRecord") ? name_class : super_class
      end

      begin
        return "#{presenter}Presenter".constantize.new(self)
      rescue Exception => e
        raise ArgumentError, e
      end

    end

    def policy(policy = nil)

      if policy.nil?
        super_class = self.class.superclass.name rescue nil
        name_class  = self.class.name rescue nil
        policy   = (super_class == "Core::ApplicationRecord") ? name_class : super_class
      end

      begin
        return "#{policy}Policy".constantize.new(self)
      rescue Exception => e
        raise ArgumentError, e
      end


    end

  end
end
