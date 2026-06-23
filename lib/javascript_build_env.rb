# frozen_string_literal: true

require 'pathname'

# jsbundling-rails and bin/yarn shell out to yarn; prepend the Node version from
# .nvmrc when nvm is installed so builds work even if an older node or yarn
# binary appears earlier on PATH.
module JavascriptBuildEnv
  module_function

  def apply!(root = default_root)
    node_bin = nvm_node_bin(root)
    return unless node_bin

    ENV['PATH'] = "#{node_bin}:#{ENV['PATH']}"
  end

  def nvm_node_bin(root = default_root)
    nvmrc = root.join('.nvmrc')
    return unless nvmrc.exist?

    version = nvmrc.read.strip.delete_prefix('v')
    nvm_dir = ENV.fetch('NVM_DIR') { File.expand_path('~/.nvm') }
    node_bin = File.join(nvm_dir, 'versions', 'node', "v#{version}", 'bin')

    node_bin if File.directory?(node_bin)
  end

  def default_root
    if defined?(Rails) && Rails.application
      Rails.root
    else
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
