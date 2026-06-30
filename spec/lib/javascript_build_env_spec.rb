# frozen_string_literal: true

require 'rails_helper'
require 'shellwords'

RSpec.describe JavascriptBuildEnv do
  describe '.nvm_node_bin' do
    let(:root) { Pathname.new(Dir.mktmpdir) }

    after { FileUtils.rm_rf(root) }

    it 'returns nil when .nvmrc is missing' do
      expect(described_class.nvm_node_bin(root)).to be_nil
    end

    it 'returns the nvm bin path when the version directory exists' do
      root.join('.nvmrc').write("24.16.0\n")
      nvm_dir = root.join('.nvm')
      node_bin = nvm_dir.join('versions/node/v24.16.0/bin')
      node_bin.mkpath

      original_nvm_dir = ENV.fetch('NVM_DIR', nil)
      ENV['NVM_DIR'] = nvm_dir.to_s
      expect(described_class.nvm_node_bin(root)).to eq(node_bin.to_s)
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
    end

    it 'strips a leading v from .nvmrc' do
      root.join('.nvmrc').write("v24.16.0\n")
      nvm_dir = root.join('.nvm')
      node_bin = nvm_dir.join('versions/node/v24.16.0/bin')
      node_bin.mkpath

      original_nvm_dir = ENV.fetch('NVM_DIR', nil)
      ENV['NVM_DIR'] = nvm_dir.to_s
      expect(described_class.nvm_node_bin(root)).to eq(node_bin.to_s)
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
    end
  end

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
      allow(described_class).to receive(:activate_yarn!)

      described_class.apply!(root)

      expect(ENV['PATH'].split(File::PATH_SEPARATOR)).to include(node_bin.to_s)
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
    end

    it 'activates Yarn via scripts/corepack_yarn.sh when present' do
      root = Pathname.new(Dir.mktmpdir)
      script = root.join(described_class::COREPACK_SCRIPT)
      script.dirname.mkpath
      script.write("#!/usr/bin/env bash\nsetup_corepack_yarn(){ :; }\n")
      script.chmod(0o755)

      allow(described_class).to receive(:system).and_return(true)

      described_class.activate_yarn!(root)

      expect(described_class).to have_received(:system)
        .with('bash', '-c', "source #{Shellwords.escape(script.to_s)} && setup_corepack_yarn", chdir: root)
    ensure
      FileUtils.rm_rf(root)
    end

    it 'warns when Yarn activation fails' do
      root = Pathname.new(Dir.mktmpdir)
      allow(described_class).to receive(:nvm_node_bin).and_return(nil)
      allow(described_class).to receive(:system_node_bin_directory).and_return(nil)
      allow(described_class).to receive(:activate_yarn!).and_return(false)

      expect { described_class.apply!(root) }.to output(%r{JavascriptBuildEnv: Corepack/Yarn activation failed}).to_stderr
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
      allow(described_class).to receive(:activate_yarn!)

      described_class.apply!(root)

      expect(ENV['PATH'].split(File::PATH_SEPARATOR)).to include(node_bin.to_s)
    ensure
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
      FileUtils.rm_rf(node_root)
    end
  end
end
