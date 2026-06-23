# frozen_string_literal: true

# Esbuild bundle is not served until #12. Skip jsbundling auto-build on
# assets:precompile for deploy (QA/production hosts lack Node yet) and during
# tests (avoids Sprockets logical-path collision; see spec/support/jsbundling.rb).
ENV['SKIP_JS_BUILD'] = 'true' if Rails.env.production? || Rails.env.test?
