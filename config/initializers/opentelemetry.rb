require "coverage"

require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/all'
require 'codecov_opentelem'

OpenTelemetry::SDK.configure do |c|
    c.service_name = 'Codecov'
    c.use_all() # enables all instrumentation!

    current_env = ENV['CODECOV_OPENTELEMETRY_ENV'] || 'production'
    current_version = ENV['CURRENT_VERSION'] || '0.1.4'
    export_rate = 1
    untracked_export_rate = 0

    generator, exporter = get_codecov_opentelemetry_instances(
        repository_token: ENV['CODECOV_OPENTELEMETRY_TOKEN'],
        sample_rate: export_rate,
        untracked_export_rate: untracked_export_rate,
        code: "#{current_version}:#{current_env}",
        filters: {
            'file_ignore_regex'=>/\/gems\//,
        },
        version_identifier: current_version,
        environment: current_env,
    )

    c.add_span_processor(generator)
    c.add_span_processor(OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(exporter))
end
