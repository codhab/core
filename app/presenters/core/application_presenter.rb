module Core
  class ApplicationPresenter < SimpleDelegator

    attr_accessor :model, :view
    
    def initialize(model, view = nil)
      super(model)
      @view = view
    end

    def h
      @view
    end

  end
end