require "pig_ci/version"
require "pig_ci/rails"

require "pig_ci/loggers"
require "pig_ci/loggers/instantiation_active_record"
require "pig_ci/loggers/memory"
require "pig_ci/loggers/sql_active_record"

require "pig_ci/reports"
require "pig_ci/reports/instantiation_active_record"
require "pig_ci/reports/memory"
require "pig_ci/reports/sql_active_record"

module PigCi

  extend self

  attr_accessor :running
  attr_accessor :pid
  attr_accessor :tmp_directory

  module_function
  def start
    self.tmp_directory = Pathname.new(Dir.getwd).join('tmp')
    self.running = true
    self.pid = Process.pid
    puts '[PigCi] Starting up'

    # Purge any previous logs and attach some listeners
    ::PigCi::Rails.setup!
  end

  def run_exit_tasks!
    puts '[PigCI] Finished, expect an output or something in a moment'

    ::PigCi::Rails.print_reports!
    ::PigCi::Rails.send_reports!
  end
end

at_exit do
  # If we are in a different process than called start, don't interfere.
  next if PigCi.pid != Process.pid

  PigCi.run_exit_tasks!
end
