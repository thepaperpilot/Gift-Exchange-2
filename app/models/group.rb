class Group < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :rules, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :instructions, presence: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  before_create :randomize_id

  def to_param
    code
  end

  private

  def randomize_id
    begin
      self.code = SecureRandom.random_number(36**6).to_s(36).rjust(6, '0')
    end while Group.where(code: code).exists?
  end
end
