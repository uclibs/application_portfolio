# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bootstrap 5 view markup' do
  let(:view_files) { Dir.glob(Rails.root.join('app/views/**/*.erb')) }

  it 'does not use Bootstrap 4 data API attributes' do
    violations = view_files.flat_map do |path|
      content = File.read(path)
      %w[data-toggle data-target data-dismiss data-parent].filter_map do |attribute|
        "#{path.relative_path_from(Rails.root)} uses #{attribute}" if content.include?(attribute)
      end
    end

    expect(violations).to be_empty, violations.join("\n")
  end

  it 'does not use removed Bootstrap 4 component or utility classes' do
    legacy_patterns = [
      /\bbadge-pill\b/,
      /\bbadge-(dark|info|warning|primary|success|danger|light)\b/,
      /\bbtn-block\b/,
      /\bfont-weight-/,
      /\bfloat-left\b/,
      /\bfloat-right\b/,
      /\btext-left\b/,
      /\btext-right\b/,
      /\bjumbotron\b/
    ]

    violations = view_files.flat_map do |path|
      content = File.read(path)
      legacy_patterns.filter_map do |pattern|
        "#{path.relative_path_from(Rails.root)} matches #{pattern.inspect}" if content.match?(pattern)
      end
    end

    expect(violations).to be_empty, violations.join("\n")
  end
end
