# frozen_string_literal: true

json.array! @hosting_environments, partial: 'hosting_environments/hosting_environment',
                                   as: :hosting_environment
