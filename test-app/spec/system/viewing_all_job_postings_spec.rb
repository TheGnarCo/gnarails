require "rails_helper"

RSpec.feature "Viewing all job postings", type: :system do
  scenario "Accessibility", js: true do
    create_list :job_posting, 3
    visit job_postings_path

    expect(page).to be_accessible
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
