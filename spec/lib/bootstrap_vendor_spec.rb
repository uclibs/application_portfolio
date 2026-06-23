# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapVendor do
  let(:root) { Rails.root }
  let(:source) { root.join('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js') }
  let(:destination) { root.join('app/assets/javascripts/vendor/bootstrap.bundle.js') }

  describe '.copy_bundle!' do
    it 'copies the bootstrap bundle from node_modules into vendor assets' do
      skip 'run yarn install first' unless source.exist?

      original = destination.exist? ? destination.read : nil

      result = described_class.copy_bundle!

      expect(result).to eq(destination)
      expect(destination.read).to eq(source.read)
    ensure
      if original
        destination.write(original)
      else
        FileUtils.rm_f(destination)
      end
    end

    it 'aborts when the bootstrap bundle is missing from node_modules' do
      skip 'run yarn install first' unless source.exist?

      backup = source.sub_ext('.bak')
      FileUtils.mv(source, backup)

      expect { described_class.copy_bundle! }.to raise_error(SystemExit, /Run yarn install first/)
    ensure
      FileUtils.mv(backup, source) if backup.exist?
    end
  end

  describe '.default_root' do
    it 'returns Rails.root when the app is initialized' do
      expect(described_class.default_root).to eq(Rails.root)
    end

    it 'falls back to the repository root when Rails is not initialized' do
      app_root = Rails.root
      allow(Rails).to receive(:application).and_return(nil)

      expect(described_class.default_root).to eq(app_root)
    end
  end

  describe 'bootstrap:vendor rake task' do
    it 'prints the updated destination path' do
      Rails.application.load_tasks
      task = Rake::Task['bootstrap:vendor']
      task.reenable

      expect { task.invoke }.to output(%r{Updated app/assets/javascripts/vendor/bootstrap\.bundle\.js}).to_stdout
    ensure
      task.reenable
    end
  end
end
