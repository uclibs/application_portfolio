# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SoftwareRecordsHelper. For example:
#
# describe SoftwareRecordsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SoftwareRecordsHelper, type: :helper do
  describe 'pills' do
    it 'returns correct value' do
      expect(helper.pills('In Design')).to eq('<span class="badge badge-pill badge-light">In Design</span>')
      expect(helper.pills('In Development')).to eq('<span class="badge badge-pill badge-info">In Development</span>')
      expect(helper.pills('Production')).to eq('<span class="badge badge-pill badge-primary">Production</span>')
      expect(helper.pills('Available')).to eq('<span class="badge badge-pill badge-success">Available</span>')
      expect(helper.pills('To be decomissioned')).to eq('<span class="badge badge-pill badge-danger">To be decomissioned</span>')
      expect(helper.pills('Something')).to eq('<span class="badge badge-pill badge-info">Something</span>')
    end
  end

  describe 'encrypt' do
    it 'returns encrypted value' do
      expect(helper.encrypt('lets encrypt')).not_to eq('lets encrypt')
    end
  end

  describe 'decrypt' do
    it 'returns expected decrypt value' do
      encrypted = helper.encrypt('lets encrypt v2')
      expect(helper.decrypt(encrypted)).to eq('lets encrypt v2')
    end
  end
end
