module CoreCandidate
  class Dependent < ApplicationRecord
    self.table_name = 'extranet.candidate_dependents'

    belongs_to :cadastre
    belongs_to :civil_state
    belongs_to :kinship
    belongs_to :special_condition
    belongs_to :rg_uf, class_name: "Address::State"

    enum gender: ['N/D', 'masculino', 'feminino']


    # Define dependent age through born
    def age
      ((Date.today - self.born).to_i / 365.25).to_i rescue I18n.t(:no_information)
    end

  end
end
