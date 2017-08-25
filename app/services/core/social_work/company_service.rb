module Core
  module SocialWork
    class CompanyService

      def reorder_company!
        @companies = Core::SocialWork::Company.where(company_type: 1)

        @companies.each do |company|
          new_position = company.executor_companies.last.position + 1
          @executor = company.executor_companies.new(
            position: new_position
          )
          @executor.save
        end

      end
    end
  end
end
