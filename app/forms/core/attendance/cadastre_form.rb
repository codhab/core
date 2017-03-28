require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class CadastreForm < Core::Candidate::CadastreMirror
      validates :name, :cpf, presence: true

      validates :rg, :rg_org, :rg_uf, :place_birth, :special_condition_id, presence: true
      validates :special_condition_type_id, presence: true, if: 'self.special_condition_id == 2'
      validates :cid, presence: true, if: 'self.special_condition_id == 2'
    end
  end
end