# frozen_string_literal: true

require 'json'
require 'fileutils'

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

    runner, *runner_args = corepack_command(node_bin)
    return unless runner

    install_dir = File.expand_path('~/bin')
    FileUtils.mkdir_p(install_dir)
    ENV['PATH'] = "#{install_dir}:#{ENV['PATH']}" unless path_includes?(install_dir)

    enable_args = runner_args + ['enable', '--install-directory', install_dir]
    prepare_args = runner_args + ['prepare', package_manager, '--activate']
    system(runner, *enable_args, out: File::NULL, err: File::NULL)
    system(runner, *prepare_args, out: File::NULL, err: File::NULL)
  end

  def corepack_command(node_bin)
    corepack_bin = File.join(node_bin, 'corepack')
    return [corepack_bin] if File.executable?(corepack_bin)

    corepack_js = File.expand_path(File.join(node_bin, '..', 'lib', 'node_modules', 'corepack', 'dist', 'corepack.js'))
    return ['node', corepack_js] if File.file?(corepack_js)

    nil
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

  def path_includes?(directory)
    ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).include?(directory)
  end

  def default_root
    if defined?(Rails) && Rails.application&.initialized?
      Rails.root
    else
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
