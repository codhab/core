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

        ([4,54,67].include?(self.current_situation_id) && ![3, 6, 8].include?(self.program_id))
=begin
        (!self.tickets.where(context_id: 1).present? ||
        self.tickets.where(context_id: 1, active: true).present?) &&
        [4,54].include?(self.current_situation_id) &&
        ![3, 6, 8].include?(self.program_id)
=end
      end

      def allow_able_update?
        ![3, 6, 8].include?(self.program_id) &&
        [4,54,67].include?(self.current_situation_id) &&
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
        ([3, 4, 54, 67].include?(self.current_situation_id) && [1,2].include?(self.program_id)) || self.program_id == 3
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
=end
       cpfs = [403836,
              203772,
              296606,
              357482,
              342604,
              203823,
              203829,
              203833,
              283153,
              342984,
              346480,
              386990,
              313561,
              330472,
              368149,
              204047,
              320962,
              319990,
              341632,
              259127,
              263827,
              204225,
              204272,
              383047,
              252395,
              204332,
              311400,
              204444,
              204460,
              204479,
              341194,
              340336,
              339959,
              366007,
              204545,
              288038,
              321738,
              204621,
              401285,
              279974,
              204991,
              205014,
              285861,
              205110,
              205114,
              276892,
              306992,
              260629,
              271311,
              381996,
              205247,
              366130,
              205287,
              205399,
              205437,
              205517,
              205586,
              242779,
              205723,
              205856,
              337123,
              206005,
              381122,
              206208,
              206254,
              206263,
              306376,
              206357,
              206363,
              387825,
              206373,
              206453,
              206602,
              206639,
              206684,
              206694,
              207055,
              207204,
              354806,
              360056,
              207362,
              207472,
              369910,
              291910,
              306170,
              368038,
              207913,
              371791,
              208043,
              208228,
              208288,
              305428,
              208494,
              311754,
              342200,
              208672,
              342345,
              208971,
              208992,
              277267,
              353633,
              297966,
              314534,
              209456,
              209467,
              272816,
              209780,
              210185,
              343317,
              366765,
              361722,
              210780,
              353614,
              211124,
              211217,
              211557,
              336983,
              368429,
              211978,
              212091,
              309726,
              212166,
              212328,
              212494,
              212706,
              212873,
              212926,
              212932,
              331693,
              213209,
              362362,
              364794,
              367893,
              214131,
              214307,
              371524,
              382227,
              215015,
              351987,
              215941,
              216026,
              369087,
              341823,
              216356,
              216566,
              216685,
              216702,
              387289,
              217408,
              217776,
              217927,
              218189,
              218222,
              218540,
              218778,
              350464,
              219087,
              219119,
              271055,
              219435,
              332593,
              301674,
              334027,
              219906,
              219998,
              278036,
              220244,
              360625,
              220990,
              221188,
              361534,
              221518,
              221683,
              221783,
              221913,
              222147,
              222273,
              345390,
              223282,
              223517,
              224065,
              380962,
              224142,
              217968,
              224394,
              344983,
              224549,
              286697,
              224994,
              225175,
              225416,
              288806,
              381207,
              333753,
              354700,
              287837,
              226137,
              350593,
              332419,
              226524,
              329391,
              226921,
              226940,
              227301,
              330561,
              361495,
              227812,
              227891,
              402606,
              334554,
              274719,
              341238,
              352288,
              404661,
              346887,
              347439,
              383267,
              371658,
              265194,
              370970,
              301980,
              268816,
              369316,
              387174,
              232760,
              348031,
              353296,
              338343,
              268315,
              341397,
              207104,
              235850,
              311198,
              236288,
              373771,
              275894,
              363717,
              329498,
              283276,
              282935,
              356887,
              298329,
              372304,
              292789,
              360648,
              237614,
              266149,
              239750,
              354540,
              285504,
              340498,
              354294 ]
       # cadastres = Core::View::GeneralPontuation.select(:id)
       #                                          .where(id: cpfs)
        (cpfs.include? self.id)
      end

    end
  end
end
