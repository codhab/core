module Core
  class ApplicationPolicy < SimpleDelegator

    def allow_recadastre?
      (self.current_situation_id == 4 && true)
    end

    def allow_update_cadastre?
      true
    end

    def allow_habilitation?
      (self.current_situation_id == 3 && true)
    end

  end
end