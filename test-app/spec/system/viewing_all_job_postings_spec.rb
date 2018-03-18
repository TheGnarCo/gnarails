require "rails_helper"

RSpec.feature "Viewing all job postings", type: :system do
  scenario "Accessibility", js: true do
    create_list :job_posting, 1
    visit job_postings_path

    expect(page).to be_accessible
  end

  scenario "N+1 query proteection" do
    job_posting = create :job_posting
    job_posting.comments.create(body: "first comment")
    job_posting.comments.create(body: "second comment")

    another_posting = create :job_posting
    another_posting.comments.create(body: "third comment")
    another_posting.comments.create(body: "fourth comment")

    expect { visit job_postings_path }
      .to raise_error Bullet::Notification::UnoptimizedQueryError
  end

  scenario "Viewing a posting on the page" do
    posting = create :job_posting
    visit job_postings_path

    expect(has_job_posting?(posting)).to be true
  end

  def has_job_posting?(posting)
    within(".job-posting-#{posting.id}") do
      expect(page).to have_css("td.posting-title", text: posting.title)
    end
  end
end
