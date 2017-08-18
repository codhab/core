module Core
  module SocialWork
    class AllotmentService

      def create_allotment! ids, description, staff
        @allotment = Core::SocialWork::Allotment.new(
          description: description,
          status: true
        )
        @allotment.save
        create_allotment_project!(@allotment, ids)
        create_execute!(@allotment, staff)
      end

      def create_allotment_project! allotment, ids
        ids.each do |project|
          @allotment_project = Core::SocialWork::AllotmentProject.new(
            candidate_project_id: project,
            allotment_id: allotment.id
          )
          @allotment_project.save
        end
      end

      def create_execute! (allotment, staff)
        @campany = Core::SocialWork::ExecutorCompany.where(position: 1).last
        @execute = Core::SocialWork::ProjectExecute.new(
          company_id: @company.id,
          allotment_id: allotment.id,
          staff_id: staff
        )
        @execute.save
      end

    end
  end
end
