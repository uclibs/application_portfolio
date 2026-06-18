# frozen_string_literal: true

module JavascriptBuild
  module_function

  def dependencies_installed?
    Rails.root.join('node_modules/.bin/esbuild').exist?
  end

  def run!
    # package.json requires Node 24; allow the spec to run when deps were installed
    # under a matching Node but the current shell still has an older `node` on PATH.
    env = ENV.to_h.merge('YARN_IGNORE_ENGINES' => 'true')
    success = system(env, 'yarn', 'build', chdir: Rails.root.to_s)
    raise 'yarn build failed' unless success
  end
end
