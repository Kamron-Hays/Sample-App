class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } # rails infers that uniqueness should be true as well
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string. Placed here for reuse with
  # the User model.
  def User.digest(string)
    # Cost is the computational cost to calculate the hash. Using a high cost
    # makes it computationally intractable to use the hash to determine the
    # original password, which is an important security precaution in a
    # production environment, but in tests we want the digest method to be as
    # fast as possible.
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
