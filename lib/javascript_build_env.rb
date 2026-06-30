# frozen_string_literal: true

# jsbundling-rails and bin/yarn shell out to yarn; prepend the Node version from
# .nvmrc when nvm is installed so builds work even if an older node or yarn
# binary appears earlier on PATH. Activates Yarn via scripts/corepack_yarn.sh.
module JavascriptBuildEnv
  COREPACK_SCRIPT = 'scripts/corepack_yarn.sh'

  module_function

  def apply!(root = default_root)
    node_bin = node_bin_directory(root)
    return unless node_bin

    ENV['PATH'] = "#{node_bin}:#{ENV['PATH']}" unless path_prefixed_with?(node_bin)
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
