require_dependency 'core/application_record'

module Core
  module Manager
    class Project < ApplicationRecord
      self.table_name = 'extranet.manager_projects'

      belongs_to :project_category

      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id
      belongs_to :manager,     class_name: ::Core::Person::Staff, foreign_key: :manager_id

      belongs_to :responsible_sector, class_name: ::Core::Person::Sector, foreign_key: :responsible_sector_id

      has_many   :tasks,       dependent: :delete_all
      has_many   :activities,  dependent: :delete_all
      has_many   :problems,    through: :tasks
      has_many   :comments,    through: :tasks
      has_many   :attachments, through: :tasks

      enum situation: ['em_construção', 'em_produção', 'cancelado']
      enum priority: ['baixa', 'média', 'alta']


      # Scopes para gem has_scope

      scope :by_project_category, -> (category_id) do
        where(project_category_id: category_id)
      end

      scope :by_sector, -> (sector_id) {

        sector = Core::Person::Sector.find(sector_id) rescue nil

        childrens = Core::Person::Sector.where(father_id: sector.id, status: true)

        if childrens.present?
          array = childrens.map(&:id)
          array << sector_id

          where(responsible_sector: array)
        else
          where(responsible_sector: sector_id)
        end

      }

      scope :by_order, -> (order) do
        order(order.to_sym)
      end

      scope :by_responsible, -> (responsible_id) do
        where(responsible_id: responsible_id)
      end

      scope :by_assessment, -> (assessment) do
        where(assessment: assessment)
      end

    end
  end
end
