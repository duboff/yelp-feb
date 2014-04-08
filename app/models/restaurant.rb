class Restaurant < ActiveRecord::Base
  has_many :reviews

  def average_score
    return 'No reviews' if reviews.none?
    reviews.average(:rating)
    
    # total_score = reviews.inject(0) do |total, review|
    #   total += review.rating
    # end
    # total_score / reviews.length
  end
end
