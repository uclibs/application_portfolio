# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapVendor do
  let(:root) { Rails.root }
  let(:scss_source) { root.join('node_modules/bootstrap/scss') }
  let(:scss_destination) { root.join('app/assets/stylesheets/vendor/bootstrap/scss') }
  let(:css_destination) { root.join('app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css') }
  let(:css_source) { root.join('node_modules/bootstrap/dist/css/bootstrap.min.css') }

  describe '.copy_css!' do
    it 'copies bootstrap.min.css from node_modules into vendor assets' do
      skip 'run yarn install first' unless css_source.file?

      backup = root.join('tmp/bootstrap_vendor_css_backup')
      if css_destination.file?
        FileUtils.mkdir_p(backup.parent)
        FileUtils.cp(css_destination, backup)
      end
      original_existed = css_destination.file?

      result = described_class.copy_css!

      expect(result).to eq(css_destination)
      expect(css_destination).to exist
    ensure
      if original_existed && backup.file?
        FileUtils.mkdir_p(css_destination.parent)
        FileUtils.cp(backup, css_destination)
      elsif !original_existed
        FileUtils.rm_f(css_destination)
      end
      FileUtils.rm_f(backup)
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

    it 'aborts when bootstrap scss is missing from node_modules' do
      missing_root = root.join('tmp/bootstrap_vendor_scss_missing')
      FileUtils.mkdir_p(missing_root)

      expect do
        described_class.copy_stylesheets!(missing_root)
      end.to output("Run yarn install first; bootstrap package not found in node_modules\n").to_stderr.and raise_error(SystemExit)
    ensure
      FileUtils.rm_rf(missing_root)
    end
  end

  describe '.vendor!' do
    it 'copies bootstrap scss into vendor assets' do
      skip 'run yarn install first' unless scss_source.directory?

      backup = root.join('tmp/bootstrap_vendor_scss_backup')
      if scss_destination.directory?
        FileUtils.rm_rf(backup)
        FileUtils.cp_r(scss_destination, backup)
      end
      original_existed = scss_destination.directory?

      result = described_class.vendor!

      expect(result[:scss]).to eq(scss_destination)
      expect(result[:css]).to eq(css_destination)
      expect(scss_destination.join('bootstrap.scss')).to exist
      expect(css_destination).to exist
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

  describe '.stylesheets_path' do
    it 'prefers the vendored bootstrap scss directory when present' do
      expect(described_class.stylesheets_path).to eq(scss_destination)
    end

    it 'falls back to node_modules bootstrap scss when the vendored copy is missing' do
      skip 'run yarn install first' unless scss_source.directory?

      tmp_root = root.join('tmp/bootstrap_vendor_stylesheets_path')
      FileUtils.rm_rf(tmp_root)
      FileUtils.mkdir_p(tmp_root.join('node_modules/bootstrap'))
      FileUtils.cp_r(scss_source, tmp_root.join('node_modules/bootstrap/scss'))

      expect(described_class.stylesheets_path(tmp_root)).to eq(tmp_root.join('node_modules/bootstrap/scss'))
    ensure
      FileUtils.rm_rf(tmp_root)
    end

    it 'aborts when bootstrap scss is missing from both vendor and node_modules' do
      missing_root = root.join('tmp/bootstrap_vendor_stylesheets_missing')
      FileUtils.mkdir_p(missing_root)

      expect do
        described_class.stylesheets_path(missing_root)
      end.to output("Bootstrap SCSS not found. Run yarn install and rake bootstrap:vendor.\n").to_stderr.and raise_error(SystemExit)
    ensure
      FileUtils.rm_rf(missing_root)
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
    it 'prints the updated vendor scss path' do
      Rails.application.load_tasks
      task = Rake::Task['bootstrap:vendor']
      task.reenable

      expect { task.invoke }.to output(
        a_string_including(
          'Updated app/assets/stylesheets/vendor/bootstrap/scss',
          'Updated app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css'
        )
      ).to_stdout
    ensure
      task.reenable
    end
  end
end
