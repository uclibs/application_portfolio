# frozen_string_literal: true

# Esbuild output at app/assets/builds/application.js collides with Sprockets'
# legacy logical path until #12. Remove stale artifacts so feature specs keep
# using app/assets/javascripts/application.js.
module EsbuildBuildArtifacts
  module_function

  def remove!
    builds = Rails.root.join('app/assets/builds')
    FileUtils.rm_f(builds.join('application.js'))
    FileUtils.rm_f(builds.join('application.js.map'))
  end
end

RSpec.configure do |config|
  config.before(:suite) { EsbuildBuildArtifacts.remove! }
end
