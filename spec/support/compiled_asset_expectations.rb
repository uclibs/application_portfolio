# frozen_string_literal: true

module CompiledAssetExpectations
  module_function

  def fingerprinted_asset?(directory, prefix, extension)
    unless File.directory?(directory)
      raise ArgumentError, "missing compiled assets directory: #{directory}"
    end

    Dir.children(directory).any? do |name|
      name.start_with?("#{prefix}-") && name.end_with?(extension)
    end
  end
end
