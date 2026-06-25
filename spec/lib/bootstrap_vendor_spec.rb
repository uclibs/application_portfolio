# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapVendor do
  describe '.vendor!' do
    it 'copies bootstrap.min.css from node_modules into vendor assets' do
      with_vendored_bootstrap_css_backup do |css_source, css_destination|
        result = described_class.vendor!

        expect(result).to eq(css_destination)
        expect(css_destination).to exist
        expect(Digest::SHA256.file(css_destination).hexdigest)
          .to eq(Digest::SHA256.file(css_source).hexdigest)
      end
    end

    it 'aborts when bootstrap css is missing from node_modules' do
      missing_root = Rails.root.join('tmp/bootstrap_vendor_css_missing')
      FileUtils.mkdir_p(missing_root)

      expect do
        described_class.vendor!(missing_root)
      end.to output("Run yarn install first; bootstrap package not found in node_modules\n").to_stderr.and raise_error(SystemExit)
    ensure
      FileUtils.rm_rf(missing_root)
    end
  end

  describe 'path constants' do
    it 'keeps the Sass load path aligned with the vendor destination' do
      relative = Pathname.new(described_class::VENDOR_CSS_RELATIVE)
                         .relative_path_from(Pathname.new(StylesheetExpectations::STYLESHEETS_ROOT))
                         .to_s

      expect(relative).to eq(described_class::SASS_LOAD_CSS_PATH)
    end

    it 'resolves vendor and npm paths from the repository root' do
      root = Rails.root

      expect(described_class.vendor_css_path(root)).to eq(root.join(described_class::VENDOR_CSS_RELATIVE))
      expect(described_class.npm_css_path(root)).to eq(root.join(described_class::NPM_CSS_RELATIVE))
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

  describe '.stale_vendored_css?' do
    it 'returns false when the vendored file matches node_modules' do
      skip 'run yarn install first' unless described_class.npm_css_path.file?

      with_vendored_bootstrap_css_backup do
        described_class.vendor!

        expect(described_class.stale_vendored_css?).to be(false)
      end
    end

    it 'returns false when node_modules is absent' do
      missing_root = Rails.root.join('tmp/bootstrap_vendor_stale_missing')
      FileUtils.mkdir_p(missing_root)

      expect(described_class.stale_vendored_css?(missing_root)).to be(false)
    ensure
      FileUtils.rm_rf(missing_root)
    end
  end

  describe 'bootstrap:vendor rake task' do
    it 'prints the updated vendor css path' do
      Rails.application.load_tasks
      task = Rake::Task['bootstrap:vendor']
      task.reenable

      expect { task.invoke }.to output(
        a_string_including("Updated #{described_class::VENDOR_CSS_RELATIVE}")
      ).to_stdout
    ensure
      task.reenable
    end
  end
end
