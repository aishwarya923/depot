require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new(
				title: 'Randome one',
				description: 'Random desc',
				image_url: 'zz.jpg'
			)
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors["price"]

		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors["price"]
	end

	def create_product(image_url)
		product = Product.new(
			title: 'Randome one',
			description: 'Random desc',
			price: 10,
			image_url: image_url
		)
	end

	test "image url must be correct" do
		correct = %w{ trial.jpg trial1.png trial_2.gif trial3.PNG
		}

		incorrect = %w{ trial trial1.txt trial_2.more
		}

		correct.each do |image_name|
			product = create_product(image_name)
			assert product.valid?
		end

		incorrect.each do |image_name|
			product = create_product(image_name)
			assert product.invalid?
			assert_equal ["must be a URL for GIF, JPG or PNG image."], product.errors[:image_url]
		end
	end
end
