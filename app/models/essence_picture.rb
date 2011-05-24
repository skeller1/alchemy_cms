module Alchemy
  class EssencePicture < ActiveRecord::Base

  	acts_as_essence(
  		:ingredient_column => :picture,
  		:preview_text_method => :name
  	)
	
  	belongs_to :picture
  	before_save :replace_newlines
	
  	def replace_newlines
  		return nil if caption.nil?
  		caption.gsub!(/(\r\n|\r|\n)/, "<br/>")
  	end
	
  	# Saves the ingredient
  	def save_ingredient(params, options = {})
  		return true if params.blank?
  		self.link_class_name = params['link_class_name']
  		self.open_link_in_new_window = (params['open_link_in_new_window'] == '1')
  		self.link = params['link']
  		self.link_title = params['link_title']
  		self.picture_id = params['picture_id']
  		self.save
  	end

  end
end