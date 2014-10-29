class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy
  has_many :enrollments, through: :sections

  validates :title, :description, :course_number, presence: true
  validates :title, :course_number, uniqueness: true

  def description_html
    markdown.render(description).html_safe
  end

  def duration
    return nil unless sections.any?
    # duration should be the same across sections, so use the first one
    sections.first.duration
  end


  def multi_session?
    sections.each do |section|
      return true if section.parts.count > 1
    end
    false
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
