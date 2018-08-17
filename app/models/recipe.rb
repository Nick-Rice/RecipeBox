class Recipe < ApplicationRecord
	belongs_to :user
	
	has_many :ingredients, dependent: :destroy
	has_many :directions, dependent: :destroy
	
	accepts_nested_attributes_for :ingredients,
		reject_if: proc { |attributes| attributes['name'].blank? },
		allow_destroy: true
		
	accepts_nested_attributes_for :directions,
		reject_if: proc { |attributes| attributes['step'].blank? },
		allow_destroy: true
	
	has_one_attached :image
	validates :title, presence: true
	validates :description, presence: true
	validate :correct_image
	
	private
	
	def correct_image
		if image.attached? == false
			errors.add(:image, 'attachment required')
		elsif image.attached? && !image.content_type.in?(%w(image/jpeg image/png))	
			errors.add(:image, 'file extension must be .jpeg or .png')
		end
	end
end
