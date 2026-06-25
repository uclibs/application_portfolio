# frozen_string_literal: true

module CompiledAssetExpectations
  module_function

  def fingerprinted_asset?(directory, prefix, extension)
    raise ArgumentError, "missing compiled assets directory: #{directory}" unless File.directory?(directory)

    Dir.children(directory).any? do |name|
      name.start_with?("#{prefix}-") && name.end_with?(extension)
    end
  end
end
