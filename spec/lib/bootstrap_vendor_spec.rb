# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapVendor do
  let(:root) { Rails.root }
  let(:js_source) { root.join('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js') }
  let(:js_destination) { root.join('app/assets/javascripts/vendor/bootstrap.bundle.js') }
  let(:scss_source) { root.join('node_modules/bootstrap/scss') }
  let(:scss_destination) { root.join('app/assets/stylesheets/vendor/bootstrap/scss') }

  describe '.copy_bundle!' do
    it 'copies the bootstrap bundle from node_modules into vendor assets' do
      skip 'run yarn install first' unless js_source.exist?

      original = js_destination.exist? ? js_destination.read : nil

      result = described_class.copy_bundle!

      expect(result).to eq(js_destination)
      expect(js_destination.read).to eq(js_source.read)
    ensure
      if original
        js_destination.write(original)
      else
        FileUtils.rm_f(js_destination)
      end
    end

    it 'aborts when the bootstrap bundle is missing from node_modules' do
      missing_root = root.join('tmp/bootstrap_vendor_spec')
      FileUtils.mkdir_p(missing_root)

      expect do
        described_class.copy_bundle!(missing_root)
      end.to output("Run yarn install first; bootstrap package not found in node_modules\n").to_stderr.and raise_error(SystemExit)
    ensure
      FileUtils.rm_rf(missing_root)
    end
  end

  describe '.copy_stylesheets!' do
    it 'copies bootstrap scss from node_modules into vendor assets' do
      skip 'run yarn install first' unless scss_source.directory?

      backup = root.join('tmp/bootstrap_vendor_scss_backup')
      if scss_destination.directory?
        FileUtils.rm_rf(backup)
        FileUtils.cp_r(scss_destination, backup)
      end
      original_existed = scss_destination.directory?

      result = described_class.copy_stylesheets!

      expect(result).to eq(scss_destination)
      expect(scss_destination.join('bootstrap.scss')).to exist
      expect(scss_destination.join('_variables.scss')).to exist
    ensure
      if original_existed && backup.directory?
        FileUtils.rm_rf(scss_destination)
        FileUtils.mkdir_p(scss_destination.parent)
        FileUtils.cp_r(backup, scss_destination)
      elsif !original_existed
        FileUtils.rm_rf(scss_destination.parent)
      end
      FileUtils.rm_rf(backup)
    end
  end

  describe '.vendor!' do
    it 'copies both bootstrap js and scss into vendor assets' do
      skip 'run yarn install first' unless js_source.exist? && scss_source.directory?

      result = described_class.vendor!

      expect(result[:js]).to eq(js_destination)
      expect(result[:scss]).to eq(scss_destination)
      expect(js_destination).to exist
      expect(scss_destination.join('bootstrap.scss')).to exist
    end
  end

  describe '.stylesheets_path' do
    it 'prefers the vendored bootstrap scss directory when present' do
      expect(described_class.stylesheets_path).to eq(scss_destination)
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
    it 'prints the updated vendor paths' do
      Rails.application.load_tasks
      task = Rake::Task['bootstrap:vendor']
      task.reenable

      expect { task.invoke }.to output(
        %r{Updated app/assets/javascripts/vendor/bootstrap\.bundle\.js\nUpdated app/assets/stylesheets/vendor/bootstrap/scss}
      ).to_stdout
    ensure
      task.reenable
    end
  end
end
