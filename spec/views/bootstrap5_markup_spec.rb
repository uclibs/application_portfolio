# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bootstrap 5 markup' do
  let(:view_files) { Dir.glob(Rails.root.join('app/views/**/*.erb')).sort }
  let(:markup_files) do
    Dir.glob(Rails.root.join('{app/views/**/*.erb,app/helpers/**/*.rb,public/*.html}')).sort
  end

  let(:legacy_patterns) do
    [
      /\bbadge-pill\b/,
      /\bbadge-(dark|info|warning|primary|success|danger|light)\b/,
      /\bbtn-block\b/,
      /\bfont-weight-/,
      /\bfloat-left\b/,
      /\bfloat-right\b/,
      /\btext-left\b/,
      /\btext-right\b/,
      /\bjumbotron\b/,
      %r{bootstrap/4},
      %r{bootstrapcdn\.com/bootstrap/4}
    ]
  end

  def legacy_markup_violations(files, patterns)
    files.flat_map do |path|
      content = File.read(path)
      patterns.filter_map do |pattern|
        "#{path.relative_path_from(Rails.root)} matches #{pattern.inspect}" if content.match?(pattern)
      end
    end
  end

  it 'does not use Bootstrap 4 data API attributes in views' do
    violations = view_files.flat_map do |path|
      content = File.read(path)
      %w[data-toggle data-target data-dismiss data-parent].filter_map do |attribute|
        "#{path.relative_path_from(Rails.root)} uses #{attribute}" if content.include?(attribute)
      end
    end

    expect(violations).to be_empty, violations.join("\n")
  end

  it 'does not use removed Bootstrap 4 component or utility classes' do
    violations = legacy_markup_violations(markup_files, legacy_patterns)

    expect(violations).to be_empty, violations.join("\n")
  end
end
