# frozen_string_literal: true

require 'rails_helper'

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

      described_class.apply!(root)

      expect(ENV['PATH']).to start_with("#{node_bin}:")
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
    end

    it 'activates Yarn via Corepack from the nvm Node bin directory' do
      root = Pathname.new(Dir.mktmpdir)
      root.join('.nvmrc').write("26.4.0\n")
      root.join('package.json').write('{"packageManager":"yarn@4.17.0"}')
      nvm_dir = root.join('.nvm')
      node_bin = nvm_dir.join('versions/node/v26.4.0/bin')
      node_bin.mkpath
      corepack = node_bin.join('corepack')
      corepack.write("#!/bin/sh\n")
      corepack.chmod(0o755)

      original_nvm_dir = ENV.fetch('NVM_DIR', nil)
      original_path = ENV.fetch('PATH', nil)
      ENV['NVM_DIR'] = nvm_dir.to_s
      ENV['PATH'] = '/usr/bin'
      allow(described_class).to receive(:system).and_call_original
      allow(described_class).to receive(:system)
        .with(corepack.to_s, 'enable', out: File::NULL, err: File::NULL).and_return(true)
      allow(described_class).to receive(:system)
        .with(corepack.to_s, 'prepare', 'yarn@4.17.0', '--activate', out: File::NULL, err: File::NULL)
        .and_return(true)

      described_class.apply!(root)

      expect(described_class).to have_received(:system).with(corepack.to_s, 'enable', out: File::NULL, err: File::NULL)
      expect(described_class).to have_received(:system).with(corepack.to_s, 'prepare', 'yarn@4.17.0', '--activate',
                                                             out: File::NULL, err: File::NULL)
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
      ENV['PATH'] = original_path
      FileUtils.rm_rf(root)
    end
  end
end
