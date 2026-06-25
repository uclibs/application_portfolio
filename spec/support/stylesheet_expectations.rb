# frozen_string_literal: true

module StylesheetExpectations
  STYLESHEETS_ROOT = 'app/assets/stylesheets'
  ENTRY_POINTS = %w[application.scss software_records.scss].freeze
  DASHBOARD_CORE = '_dashboard_core.scss'
  BOOTSTRAP_SETUP = '_bootstrap_setup.scss'

  module_function

  def stylesheets_root(root = Rails.root)
    root.join(STYLESHEETS_ROOT)
  end

  def app_owned_paths(root = Rails.root)
    Dir.glob(stylesheets_root(root).join('**/*.{scss,sass}')).reject do |path|
      path.include?('/vendor/')
    end
  end

  def read_relative(relative_path, root = Rails.root)
    stylesheets_root(root).join(relative_path).read
  end
end

RSpec.configure do |config|
  config.include StylesheetExpectations
end
