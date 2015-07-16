ENV['PUMA_THREADS_MIN'] ||= '1'
ENV['PUMA_THREADS_MAX'] ||= '10'
ENV['PUMA_WORKERS']     ||= '1'
ENV['PUMA_BIND']        ||= 'tcp://0.0.0.0:3000'
raise 'RACK_ENV is not set' if ENV['RACK_ENV'].to_s.empty?

bind ENV['PUMA_BIND']
environment ENV['RACK_ENV']
threads ENV['PUMA_THREADS_MIN'].to_i, ENV['PUMA_THREADS_MAX'].to_i
workers ENV['PUMA_WORKERS'].to_i
daemonize false
