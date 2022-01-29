RSpec.configure do |config|
  config.before(:each, type: :system) do
    # ブラウザon
    driven_by(:selenium_chrome)
    # ブラウザoff
    # driven_by(:selenium_chrome_headless)
  end
end
