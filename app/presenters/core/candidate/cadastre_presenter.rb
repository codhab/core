require_dependency 'core/application_presenter'

module Core
  module Candidate
    class CadastrePresenter < ApplicationPresenter

      def hello
        case Time.now.strftime("%H").to_i
        when 18..23
          @string = "Boa noite"
        when 0..6
          @string = "Boa noite"
        when 6..12
          @string = "Bom dia"
        when 12..18
          @string = "Boa tarde"
        end

        "#{@string}, #{self.humanize_first_name}"
      end

      def humanize_first_name
        self.name.split(' ')[0].humanize
      end

      def humanize_complete_name
        self.name.titleize
      end


      def special_condition_name
        self.special_condition.name rescue nil
      end

      def civil_state_name
        self.civil_state.name rescue nil
      end

      # => cadastre_situation

      def current_situation
        self.cadastre_situations.order('created_at ASC').last rescue nil
      end

      def current_situation_name
        current_situation.situation_status.name.mb_chars.upcase rescue nil
      end

      def current_situation_id
        current_situation.situation_status_id rescue nil
      end

      # => procedural

      def current_procedural
        self.cadastre_procedurals.order('created_at ASC').last rescue nil
      end

      def current_procedural_name
        current_procedural.procedural_status.name.mb_chars.upcase rescue nil
      end

      # => convocation

      def current_convocation
        self.cadastre_convocations.where(status: true).order('created_at ASC').last rescue nil
      end

      def current_convocation_name
        "#{current_convocation.convocation.id} - #{current_convocation.convocation.description}" rescue nil
      end

      def current_convocation_id
        current_convocation.convocation_id rescue nil
      end

      def current_cadastre_address
        self.cadastre_address.where(situation_id: [0,1,5]).order('created_at ASC').last rescue nil
      end

      def age
       ((Date.today - self.born).to_i / 365.25).to_i rescue I18n.t(:no_information)
     end


     def special?
         (self.special_condition_id == 2 || self.special_condition_id == 3) || self.program_id == 5
     end

     def older?
         if self.born.present?
           (self.age >= 60)
         else
           false
         end
     end

     def zone?
         case self.income
         when 0..1600
           [1, 0, 1600]
         when 1601..3275
           [2, 1601, 3275]
         when 3276..5000
           [3, 3276, 5000]
         else
           [4, 5001, 99999]
         end
     end


     def special_family?
       self.dependents.where(special_condition_id: [2,3]).present?
     end

     def older_family?
       self.dependents.where('extract(year from age(born)) >= 60').present?
     end


      def list
      array = Array.new


      list_rii          = rii
      list_rie          = rie
      list_olders       = olders
      list_vulnerables  = vulnerables
      list_specials     = specials

      array << list_rii         unless list_rii.nil?
      array << list_rie         unless list_rie.nil?

      if self.current_situation_id != 2
        array << list_olders      unless list_olders.nil?
        array << list_vulnerables unless list_vulnerables.nil?
        array << list_specials    unless list_specials.nil?
      end

      array.each_with_index do |a, i|
        array[i] << position(array[i])
      end

      array
    end

    private

    def rii
      (self.program_id == 1) ? ['rii', self.zone?] : nil
    end

    def rie
      (self.program_id == 2) ? ['rie', self.zone?] : nil
    end

    def specials
      (self.special? || self.special_family?) ? ['special', self.zone?] : nil
    end

    def olders
      (self.older? || self.older_family?) ? ['older', self.zone?] : nil
    end

    def vulnerables
      (self.program_id == 4) ? ['vulnerable', self.zone?] : nil
    end

    def position(array)

        if array[0] == 'rii' || array[0] == 'rie'
            if [2,52].include? self.current_situation_id

              sql = "program_id = ? AND code = 20141201"
              @geral = Core::View::GeneralPontuation.select(:id)
                                                         .where(sql,
                                                                self.program_id)
                                                         .map(&:id)
                                                         .find_index(self.id)
            else

              sql = "program_id = ? AND
                     situation_status_id = ?
                     AND convocation_id > 1524
                     AND procedural_status_id IN(14, 72)
                     AND income BETWEEN ? AND ?"

              @geral = Core::View::GeneralPontuation.select(:id)
                                                         .where(sql,
                                                                self.program_id,
                                                                self.current_situation_id,
                                                                array[1][1],
                                                                array[1][2])
                                                         .map(&:id)
                                                         .find_index(self.id)
            end
        else
            case array[0]
            when 'older'

                sql = "(extract(year from age(born)) >= 60 or (select COUNT(*)
                       from extranet.candidate_dependents
                       where extract(year from age(born)) >= 60
                       and cadastre_id = general_pontuations.id) > 0)
                       AND convocation_id > 1524
                       AND procedural_status_id IN(14, 72)
                       AND situation_status_id = ?
                       AND income BETWEEN  ? AND ?"

                @geral = Core::View::GeneralPontuation.select(:id)
                                                           .where(sql,
                                                                  self.current_situation_id,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id)
                                                           .find_index(self.id)
            when 'special'
                sql = "(special_condition_id in (2,3) or (select COUNT(*)
                        from extranet.candidate_dependents
                        where special_condition_id in (2,3)
                        and cadastre_id = general_pontuations.id) > 0)
                        and situation_status_id = ?
                        and convocation_id > 1524
                        and procedural_status_id IN(14, 72)
                        and income BETWEEN ? AND ?"

                @geral = Core::View::GeneralPontuation.select(:id)
                                                           .where(sql,
                                                                  self.current_situation_id,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id).find_index(self.id)

            when 'vulnerable'
                sql = "program_id = ?
                      AND convocation_id > 1524
                      AND procedural_status_id IN(14, 72)
                      AND income BETWEEN ? AND ?"

                @geral = Core::View::GeneralPontuation.select(:id)
                                                           .where(sql,4,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id).find_index(self.id)
            end
        end

        @geral.present? ? @geral + 1 : nil
    end

    end
  end
end
