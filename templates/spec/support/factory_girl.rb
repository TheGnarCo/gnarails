RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.use_parent_strategy = true
