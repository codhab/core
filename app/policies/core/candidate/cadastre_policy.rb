module Core
  module Candidate
    class CadastrePolicy < ApplicationPolicy

      def allow_update?
        false
      end
      
    end
  end
end