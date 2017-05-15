module Core
  class ApplicationPresenter < SimpleDelegator
    
    def initialize(model, view = nil)
      super(model)
      @view = view
    end
  end
end