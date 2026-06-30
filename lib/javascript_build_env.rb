# frozen_string_literal: true

require 'json'

# jsbundling-rails and bin/yarn shell out to yarn; prepend the Node version from
# .nvmrc when nvm is installed so builds work even if an older node or yarn
# binary appears earlier on PATH. Activates Yarn via Corepack from that Node's
# bin directory (bare `yarn` is unavailable until corepack enable runs there).
module JavascriptBuildEnv
  module_function

  def apply!(root = default_root)
    node_bin = node_bin_directory(root)
    return unless node_bin

    ENV['PATH'] = "#{node_bin}:#{ENV['PATH']}" unless path_prefixed_with?(node_bin)
    activate_yarn!(root, node_bin)
  end

  def node_bin_directory(root = default_root)
    nvm_node_bin(root)
  end

  def nvm_node_bin(root = default_root)
    nvmrc = root.join('.nvmrc')
    return unless nvmrc.exist?

    version = nvmrc.read.strip.delete_prefix('v')
    nvm_dir = ENV.fetch('NVM_DIR') { File.expand_path('~/.nvm') }
    node_bin = File.join(nvm_dir, 'versions', 'node', "v#{version}", 'bin')

    node_bin if File.directory?(node_bin)
  end

  def activate_yarn!(root, node_bin)
    package_manager = package_manager_for(root)
    return unless package_manager

    corepack = File.join(node_bin, 'corepack')
    return unless File.executable?(corepack)

    # Invoke Corepack from node_bin so shims land in a user-writable directory,
    # not /usr/local when a system Node appears earlier on PATH (CircleCI cimg).
    system(corepack, 'enable', out: File::NULL, err: File::NULL)
    system(corepack, 'prepare', package_manager, '--activate', out: File::NULL, err: File::NULL)
  end

  def package_manager_for(root)
    package_json = root.join('package.json')
    return unless package_json.exist?

    JSON.parse(package_json.read).fetch('packageManager', nil).presence
  rescue JSON::ParserError
    nil
  end

  def path_prefixed_with?(node_bin)
    ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).first == node_bin
  end

  def default_root
    if defined?(Rails) && Rails.application&.initialized?
      Rails.root
    else
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
