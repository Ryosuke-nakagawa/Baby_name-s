RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chome, screen_size: [1920, 1080]
  end
end
