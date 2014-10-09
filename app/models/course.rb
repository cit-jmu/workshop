class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy

  validates :title, :description, :duration, :instructor, presence: true
  validates :title, uniqueness: true
  validates :duration, numericality: {only_integer: true, greater_than: 0}

  def description_html
    markdown.render(description).html_safe
  end

  def summary_html
    markdown.render(summary).html_safe
  end

  private

  def markdown
    @@markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(escape_html: true),
      autolink: true,
      space_after_headers: true,
      strikethrough: true,
      no_intra_emphasis: true,
      tables: true
    )
  end
end
