# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'change_request/delete.html.erb', type: :view do
  shared_examples 'role-based access' do |user_role|
    before(:each) do
      assign(:change_requests, [
               ChangeRequest.new(
                 change_title: 'Change Request 1',
                 change_description: 'Description 1',
                 change_submitted_date: Date.today,
                 change_completed: false,
                 software_record_id: 1
               ),
               ChangeRequest.new(
                 change_title: 'Change Request 2',
                 change_description: 'Description 2',
                 change_submitted_date: Date.today,
                 change_completed: true,
                 software_record_id: 2
               )
             ])
      assign(:change_request_counts, 2)
      user_type = FactoryBot.create(user_role)
      sign_in(user_type)
      #    assign(:current_user, double(role: 'root_admin'))
      render
    end
    pending "add some examples to (or delete) #{__FILE__}"
  end

  context 'when user is an admin' do
    let(:user) { admin }
    it_behaves_like 'role-based access', :admin
  end

  context 'when user is an owner' do
    let(:user) { owner }
    it_behaves_like 'role-based access', :owner
  end

  context 'when user is a manager' do
    let(:user) { manager }
    it_behaves_like 'role-based access', :manager
  end

  context 'when user is a viewer' do
    let(:user) { viewer }
    it_behaves_like 'role-based access', :viewer
  end
end
