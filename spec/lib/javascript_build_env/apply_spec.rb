# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JavascriptBuildEnv do
  describe '.apply!' do
    it 'prepends the nvm Node bin directory to PATH' do
      root = Pathname.new(Dir.mktmpdir)
      root.join('.nvmrc').write("24.16.0\n")
      nvm_dir = root.join('.nvm')
      node_bin = nvm_dir.join('versions/node/v24.16.0/bin')
      node_bin.mkpath

      original_nvm_dir = ENV.fetch('NVM_DIR', nil)
      original_path = ENV.fetch('PATH', nil)
      ENV['NVM_DIR'] = nvm_dir.to_s
      ENV['PATH'] = '/usr/bin'
      allow(described_class).to receive(:activate_yarn!).and_return(true)

      described_class.apply!(root)

      expect(ENV['PATH'].split(File::PATH_SEPARATOR)).to include(node_bin.to_s)
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
    end

    it 'warns when Yarn activation fails and yarn is unavailable' do
      root = Pathname.new(Dir.mktmpdir)
      allow(described_class).to receive(:nvm_node_bin).and_return(nil)
      allow(described_class).to receive(:system_node_bin_directory).and_return(nil)
      allow(described_class).to receive(:activate_yarn!).and_return(false)
      allow(described_class).to receive(:yarn_executable?).and_return(false)

      expect { described_class.apply!(root) }.to output(%r{JavascriptBuildEnv: Corepack/Yarn activation failed}).to_stderr
    ensure
      FileUtils.rm_rf(root)
    end

    it 'does not warn when Yarn activation fails but yarn is already on PATH' do
      root = Pathname.new(Dir.mktmpdir)
      allow(described_class).to receive(:nvm_node_bin).and_return(nil)
      allow(described_class).to receive(:system_node_bin_directory).and_return(nil)
      allow(described_class).to receive(:activate_yarn!).and_return(false)
      allow(described_class).to receive(:yarn_executable?).and_return(true)

      expect { described_class.apply!(root) }.not_to output(%r{JavascriptBuildEnv: Corepack/Yarn activation failed}).to_stderr
    ensure
      FileUtils.rm_rf(root)
    end

    it 'prepends the system Node bin directory when nvm is absent' do
      root = Pathname.new(Dir.mktmpdir)
      node_root = Pathname.new(Dir.mktmpdir)
      original_path = ENV.fetch('PATH', nil)
      node_bin = node_root.join('fake-node', 'bin')
      node_bin.mkpath
      node_bin.join('node').write('')
      node_bin.join('node').chmod(0o755)

      ENV['PATH'] = '/usr/bin'
      allow(described_class).to receive(:nvm_node_bin).and_return(nil)
      allow(described_class).to receive(:system_node_bin_directory).and_return(node_bin.to_s)
      allow(described_class).to receive(:activate_yarn!).and_return(true)

      described_class.apply!(root)

      expect(ENV['PATH'].split(File::PATH_SEPARATOR)).to include(node_bin.to_s)
    ensure
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
      FileUtils.rm_rf(node_root)
    end
  end
end
