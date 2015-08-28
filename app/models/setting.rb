class Setting < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def self.evaluation_url
    evaluation_url = find_by(name: 'evaluation_url')
    evaluation_url ? evaluation_url.value : nil
  end
end
