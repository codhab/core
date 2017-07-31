module Core
  module Attendance
    class CadastrePolicy < ApplicationPolicy

      # Scope :attendance_tickets
      #
      # define :ticket_situations, table: `attendance_ticket_situations`
      # 1 => pendente com candidato
      # 2 => pendente com atendente
      # 3 => pendente com supervisor
      # 4 => cancelado pelo candidato
      # 5 => deferido
      # 6 => indeferido
      # 7 => finalizado pelo candidato

      # define :ticket_contexts table: `attendance_ticket_contexts`
      # 1 => atualização cadastral (recadastramento)
      # 2 => atualização cadastral (convocado)
      # 3 => atualização cadastral (habilitado)
      # 4 => atualização cadastral (regularização)
      # 5 => atualização cadastral (outro)

      # Scope :attendance_ticket_actions
      #
      # define :ticket_action_contexts
      # 1 => atualização dados básicos
      # 2 => atualização de dependentes
      # 3 => atualização de renda
      # 4 => atualização de dados de contato

      # define :ticket_action_situations
      # 1 => em processo de atualização
      # 2 => atualizado
      # 3 => confirmado

      def allow_recadastre_update?

        if !self.tickets.where(context_id: 1).present? && (Date.current > Date.parse('2017-07-31'))
          return false
        end

        ([4,54].include?(self.current_situation_id) && ![3, 6, 8].include?(self.program_id))
=begin
        (!self.tickets.where(context_id: 1).present? ||
        self.tickets.where(context_id: 1, active: true).present?) &&
        [4,54].include?(self.current_situation_id) &&
        ![3, 6, 8].include?(self.program_id)
=end
      end

      def allow_able_update?
        ![3, 6, 8].include?(self.program_id) &&
        [4,54].include?(self.current_situation_id) &&
        self.tickets.where(context_id: 1, situation_id: [5,7]).present?
      end

      def allow_other_update?
        self.current_situation_id == 2
      end

      def allow_regularization_update?
        (self.program_id == 3)
      end

      def allow_convoked_update?
        ![3, 6, 8].include?(self.program_id) &&
        (self.current_situation_id == 3)
      end

      def allow_chats?
        ([3, 4, 54].include?(self.current_situation_id) && [1,2].include?(self.program_id)) || self.program_id == 3
      end

      def allow_to_question?

=begin
        cadastres = Core::View::GeneralPontuation.select(:id)
                                                            .where(situation_status_id: [54,4],
                                                                   program_id: 1,
                                                                   procedural_status_id: [14, 72],
                                                                   income: 0..1800)
                                                            .where('convocation_id > 1524')
                                                            .order('total DESC')
                                                            .limit(100)
=end

        cpfs = [300319,
                211718,
                207924,
                229298,
                209240,
                214573,
                206831,
                205575,
                350245,
                206379,
                260129,
                301972,
                216225,
                247685,
                231079,
                263862,
                223416,
                268351,
                319998,
                225673,
                312072,
                237623,
                205982,
                358710,
                233988,
                228570,
                221154,
                234723,
                296953,
                296213,
                231925,
                214197,
                222970,
                211955,
                319233,
                237783,
                224235,
                219168,
                216668,
                234938,
                207000,
                236818,
                349158,
                320810,
                320773,
                217904,
                308138,
                227273,
                209446,
                318703,
                225492,
                277435,
                212282,
                320741,
                229503,
                225265,
                219362,
                288275,
                332108,
                229636,
                222013,
                233629,
                318565,
                268852,
                218734,
                319027,
                225902,
                207880,
                226301,
                344975,
                319925,
                307265,
                222054,
                319120,
                226692,
                220675,
                359940,
                209562,
                236850,
                206690,
                221749,
                240366,
                219899,
                229051,
                229552,
                320723,
                228548,
                227429,
                253670,
                230988,
                228911,
                229017,
                229976,
                208112,
                230228,
                320074,
                216126,
                285261,
                320235,
                209805]

       # cadastres = Core::View::GeneralPontuation.select(:id)
       #                                          .where(id: cpfs)
        (cpfs.include? self.id)
      end

    end
  end
end
