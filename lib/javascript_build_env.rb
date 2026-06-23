# frozen_string_literal: true

# jsbundling-rails shells out to yarn; prepend the Node version from .nvmrc when
# nvm is installed so `bin/rails javascript:build` works even if an older node or
# yarn binary appears earlier on PATH.
module JavascriptBuildEnv
  module_function

  def apply!
    node_bin = nvm_node_bin
    return unless node_bin

    ENV['PATH'] = "#{node_bin}:#{ENV['PATH']}"
  end

  def nvm_node_bin
    nvmrc = Rails.root.join('.nvmrc')
    return unless nvmrc.exist?

    version = nvmrc.read.strip.delete_prefix('v')
    nvm_dir = ENV.fetch('NVM_DIR') { File.expand_path('~/.nvm') }
    node_bin = File.join(nvm_dir, 'versions', 'node', "v#{version}", 'bin')

    node_bin if File.directory?(node_bin)
  end
end
