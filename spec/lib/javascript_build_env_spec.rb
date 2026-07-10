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

    it 'returns nil when the nvm version directory does not exist' do
      root.join('.nvmrc').write("99.99.99\n")

      original_nvm_dir = ENV.fetch('NVM_DIR', nil)
      ENV['NVM_DIR'] = root.join('.nvm').to_s
      expect(described_class.nvm_node_bin(root)).to be_nil
    ensure
      ENV['NVM_DIR'] = original_nvm_dir
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

  describe '.activate_yarn!' do
    it 'returns false when the corepack script is missing' do
      root = Pathname.new(Dir.mktmpdir)

      expect(described_class.activate_yarn!(root)).to be(false)
    ensure
      FileUtils.rm_rf(root)
    end

    it 'sources scripts/corepack_yarn.sh when present' do
      root = Pathname.new(Dir.mktmpdir)
      script = root.join(described_class::COREPACK_SCRIPT)
      script.dirname.mkpath
      script.write("#!/usr/bin/env bash\nsetup_corepack_yarn(){ :; }\n")
      script.chmod(0o755)

      allow(described_class).to receive(:system).and_return(true)

      expect(described_class.activate_yarn!(root)).to be(true)
      expect(described_class).to have_received(:system)
        .with('bash', '-c', "source #{Shellwords.escape(script.to_s)} && setup_corepack_yarn", chdir: root)
    ensure
      FileUtils.rm_rf(root)
    end
  end

  describe '.system_node_bin_directory' do
    it 'finds node on PATH without shelling out' do
      node_root = Pathname.new(Dir.mktmpdir)
      node_bin = node_root.join('bin')
      node_bin.mkpath
      node = node_bin.join('node')
      node.write('#!/usr/bin/env sh')
      node.chmod(0o755)

      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = node_bin.to_s

      expect(described_class.system_node_bin_directory).to eq(node_bin.to_s)
    ensure
      ENV['PATH'] = original_path
      FileUtils.rm_rf(node_root)
    end

    it 'returns nil when no executable node is on PATH' do
      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = '/tmp/empty-nonexistent'

      expect(described_class.system_node_bin_directory).to be_nil
    ensure
      ENV['PATH'] = original_path
    end
  end

  describe '.yarn_executable?' do
    it 'returns true when yarn is executable on PATH' do
      yarn_root = Pathname.new(Dir.mktmpdir)
      yarn_bin = yarn_root.join('bin')
      yarn_bin.mkpath
      yarn = yarn_bin.join('yarn')
      yarn.write('#!/usr/bin/env sh')
      yarn.chmod(0o755)

      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = yarn_bin.to_s

      expect(described_class.yarn_executable?).to be(true)
    ensure
      ENV['PATH'] = original_path
      FileUtils.rm_rf(yarn_root)
    end

    it 'returns false when yarn is not on PATH' do
      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = '/tmp/empty-nonexistent'

      expect(described_class.yarn_executable?).to be(false)
    ensure
      ENV['PATH'] = original_path
    end
  end

  describe '.prepend_path!' do
    it 'skips nil and empty directories' do
      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = '/usr/bin'

      described_class.prepend_path!(nil)
      described_class.prepend_path!('')

      expect(ENV['PATH']).to eq('/usr/bin')
    ensure
      ENV['PATH'] = original_path
    end

    it 'skips directories already on PATH' do
      original_path = ENV.fetch('PATH', nil)
      ENV['PATH'] = '/custom/bin:/usr/bin'

      described_class.prepend_path!('/custom/bin')

      expect(ENV['PATH']).to eq('/custom/bin:/usr/bin')
    ensure
      ENV['PATH'] = original_path
    end
  end

  describe '.default_root' do
    it 'returns Rails.root when the application is initialized' do
      expect(described_class.default_root).to eq(Rails.root)
    end

    it 'returns the lib parent directory when Rails is not defined' do
      lib_dir = Rails.root.join('lib').to_s
      expected = Pathname.new(File.expand_path('..', lib_dir))

      hide_const('Rails')

      expect(described_class.default_root).to eq(expected)
    end

    it 'returns the lib parent directory when Rails.application is nil' do
      lib_dir = Rails.root.join('lib').to_s
      expected = Pathname.new(File.expand_path('..', lib_dir))

      allow(Rails).to receive(:application).and_return(nil)

      expect(described_class.default_root).to eq(expected)
    end
  end
end
