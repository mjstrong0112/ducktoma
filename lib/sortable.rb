module SortableModel
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :default_sort, :default_sort_direction

    def sort column, dir
      order("#{column} #{dir}")
    end

    def acts_as_sortable default, direction='asc'
      self.default_sort = default
      self.default_sort_direction = direction
    end

  end
end


module SortableController
  extend ActiveSupport::Concern

  included do  
    class_eval do
      helper_method :sort_column, :sort_direction
      def self.sortable_for resource      
        self.sortable_resource = resource.to_s.classify.constantize
      end      
    end  
  end

  module ClassMethods
    attr_accessor :sortable_resource  
  end

  def sort_column
    params[:sort] || self.class.sortable_resource.default_sort || :created_at
  end

  def sort_direction
    if %w[asc desc].include?(params[:direction]) 
      params[:direction]
    else
      self.class.sortable_resource.default_sort_direction || "asc"
    end
  end
end

module SortableHelper
  extend ActiveSupport::Concern
  included do
    def sortable_col(column, title = nil)
      title ||= column.titleize
      css_class = column == sort_column ? "current #{sort_direction}" : nil
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    end
  end
end

ActiveRecord::Base.send(:include, SortableModel)
ActionController::Base.send(:include, SortableController)
ApplicationHelper.send(:include, SortableHelper)