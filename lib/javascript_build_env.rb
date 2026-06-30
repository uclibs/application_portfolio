# frozen_string_literal: true

# jsbundling-rails and bin/yarn shell out to yarn; prepend Node from .nvmrc when nvm
# is installed, or from the system Node binary (GitHub Actions setup-node). Activates
# Yarn via scripts/corepack_yarn.sh so Corepack shims are on PATH during Rake tasks.
module JavascriptBuildEnv
  COREPACK_SCRIPT = 'scripts/corepack_yarn.sh'

  module_function

  def apply!(root = default_root)
    node_bin = node_bin_directory(root) || system_node_bin_directory
    prepend_path!(node_bin)
    prepend_path!(corepack_shim_directory)
    activate_yarn!(root)
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

  def activate_yarn!(root)
    script = root.join(COREPACK_SCRIPT)
    return unless script.file?

    system('bash', '-c', "source #{script} && setup_corepack_yarn", chdir: root, out: File::NULL, err: File::NULL)
  end

  def system_node_bin_directory
    node = `command -v node 2>/dev/null`.strip
    return if node.empty?

    File.dirname(node)
  end

  def corepack_shim_directory
    File.expand_path('~/bin')
  end

  def prepend_path!(directory)
    return if directory.nil? || directory.empty?
    return if path_includes?(directory)

    ENV['PATH'] = "#{directory}:#{ENV['PATH']}"
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
