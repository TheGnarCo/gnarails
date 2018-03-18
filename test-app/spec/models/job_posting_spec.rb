require "rails_helper"

RSpec.describe JobPosting, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  it { should have_many :comments }
  it { should validate_presence_of(:title) }
  it { should define_enum_for(:status).with([:new_post, :pending, :complete]) }

  describe "defaults" do
    subject(:posting) { build :job_posting }
    let(:posted_time) { Time.zone.local(2017, 4, 21, 4, 44) }

    before { travel_to(posted_time) }

    after { travel_back }

    its(:posted_at) { should eq posted_time }
    its(:status) { should eq "new_post" }
  end
end
