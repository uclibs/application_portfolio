# frozen_string_literal: true

module BootstrapVendorExamples
  def with_vendored_bootstrap_css_backup
    css_destination = BootstrapVendor.vendor_css_path
    css_source = BootstrapVendor.npm_css_path
    backup = Rails.root.join('tmp/bootstrap_vendor_css_backup')
    original_existed = false

    skip 'run yarn install first' unless css_source.file?

    if css_destination.file?
      FileUtils.mkdir_p(backup.parent)
      FileUtils.cp(css_destination, backup)
      original_existed = true
    end

    yield css_source, css_destination
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

RSpec.configure do |config|
  config.include BootstrapVendorExamples
end
