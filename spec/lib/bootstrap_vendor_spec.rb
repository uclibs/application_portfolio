# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapVendor do
  let(:root) { Rails.root }
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

    it 'aborts when bootstrap css is missing from node_modules' do
      missing_root = root.join('tmp/bootstrap_vendor_css_missing')
      FileUtils.mkdir_p(missing_root)

      expect do
        described_class.copy_css!(missing_root)
      end.to output("Run yarn install first; bootstrap package not found in node_modules\n").to_stderr.and raise_error(SystemExit)
    ensure
      FileUtils.rm_rf(missing_root)
    end
  end

  describe '.vendor!' do
    it 'copies bootstrap.min.css into vendor assets' do
      skip 'run yarn install first' unless css_source.file?

      backup = root.join('tmp/bootstrap_vendor_css_backup')
      if css_destination.file?
        FileUtils.mkdir_p(backup.parent)
        FileUtils.cp(css_destination, backup)
      end
      original_existed = css_destination.file?

      result = described_class.vendor!

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
    it 'prints the updated vendor css path' do
      Rails.application.load_tasks
      task = Rake::Task['bootstrap:vendor']
      task.reenable

      expect { task.invoke }.to output(
        a_string_including('Updated app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css')
      ).to_stdout
    ensure
      task.reenable
    end
  end
end
