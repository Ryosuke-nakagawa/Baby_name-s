class User < ApplicationRecord
  belongs_to :group
  belongs_to :editing_name, class_name: 'FirstName', optional: true
  has_many :rates, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_first_names, through: :likes, source: :first_name
  has_many :comments, dependent: :destroy

  validates :line_id, presence: true, uniqueness: true
  validates :sound_rate_setting, numericality: { in: 1..3 }, allow_nil: true
  validates :character_rate_setting, numericality: { in: 1..3 }, allow_nil: true
  validates :fortune_telling_rate_setting, numericality: { in: 1..3 }, allow_nil: true

  enum status: { normal: 0, name_add: 1, reading_add: 2, sound_rate_add: 3, character_rate_add: 4 }
  enum role: { general: 0, admin: 10 }

  before_create -> { self.uuid = SecureRandom.uuid }

  def like?(first_name)
    like_first_names.include?(first_name)
  end

  def like(first_name)
    like_first_names << first_name
  end

  def unlike(first_name)
    like_first_names.destroy(first_name)
  end

  def name_add(replied_message)
    new_first_name = FirstName.create(name: replied_message, group: group)
    update(editing_name: new_first_name)

    fortune_telling = FortuneTelling.new(first_name: new_first_name.name, last_name: group.last_name)
    result = fortune_telling.rates
    new_first_name.update(fortune_telling_url: fortune_telling.search_url,
                          fortune_telling_rate: result[:rate], fortune_telling_heaven: result[:heaven], fortune_telling_person: result[:person], fortune_telling_land: result[:land], fortune_telling_outside: result[:outside], fortune_telling_all: result[:all], fortune_telling_talent: result[:talent])
    reading_add!
  end

  def reading_add(replied_message)
    editing_name.update!(reading: replied_message)
    sound_rate_add!
  end

  def sound_rate_add(replied_message)
    Rate.create!(user: self, first_name: editing_name, sound_rate: replied_message.to_i)
    character_rate_add!
  end

  def character_rate_add(replied_message)
    rate = Rate.find_by(user: self, first_name: editing_name)
    rate.update!(character_rate: replied_message.to_i)
  end

  def own?(object)
    id == object.user_id
  end
end
