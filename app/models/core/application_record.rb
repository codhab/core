module Core
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # self.class.superclass.name
    # => Core::Candidate::Cadastre
    
    def presenter(presenter = nil)
      presenter = presenter.nil? ? "#{self.class.superclass.name}Presenter" : "#{presenter}Presenter"
      return presenter.constantize.new(self)
    end

    def policy(policy = nil)
      policy = policy.nil? ? "#{self.class.superclass.name}Policy" : "#{policy}Policy"
      return policy.constantize.new(self)
    end

  end
end
