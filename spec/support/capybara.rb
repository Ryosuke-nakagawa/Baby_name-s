RSpec.configure do |config|
  config.before(:each, type: :system) do
    # ブラウザon
    # driven_by(:selenium_chrome)
    # ブラウザoff
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
