class ProjectOrder < ActiveRecord::Base
	belongs_to :project 
	belongs_to :order
end
