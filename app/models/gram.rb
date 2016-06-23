class Gram < ActiveRecord::Base
	validates :message, presence: true

	mount_uploader :image, ImageUploader

	belongs_to :user
end

