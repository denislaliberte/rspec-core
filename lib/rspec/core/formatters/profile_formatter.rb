RSpec::Support.require_rspec_core "formatters/console_codes"
require 'yaml'

module RSpec
  module Core
    module Formatters
      # @api private
      # Formatter for providing profile output.
      class ProfileFormatter
        Formatters.register self, :dump_profile, :example_group_started, :example_group_finished

        def initialize(output)
          initialize_profile
          @output = output
        end

        def initialize_profile()
          @clock = RSpec::Core::Time
          @start = Hash.new(0)
          @result = Hash.new(0)
        end

        def example_group_started(group)
          key =  group.group.metadata[:location]
          @start[key] = @clock.now
        end

        def example_group_finished(group)
          key =  group.group.metadata[:location]
          @result[key] = @clock.now - @start[key]
        end
        def get_slowest
          @result.sort.reverse
        end

        # @private
        attr_reader :output

        # @api public
        #
        # This method is invoked after the dumping the summary if profiling is
        # enabled.
        #
        # @param profile [ProfileNotification] containing duration,
        #   slowest_examples and slowest_example_groups
        def dump_profile(profile)
          dump_profile_slowest_examples(profile)
          dump_profile_slowest_example_groups(profile)
        end

      private

        def dump_profile_slowest_examples(profile)
          @output.puts "\nTop #{profile.slowest_examples.size} slowest " \
            "examples (#{Helpers.format_seconds(profile.slow_duration)} " \
            "seconds, #{profile.percentage}% of total time):\n"

          profile.slowest_examples.each do |example|
            @output.puts "  #{example.full_description}"
            @output.puts "    #{bold(Helpers.format_seconds(example.execution_result.run_time))} " \
                         "#{bold("seconds")} #{format_caller(example.location)}"
          end
        end

        def dump_profile_slowest_example_groups(profile)
          puts "get slowests"
          slowest = self.get_slowest
          puts YAML::dump(slowest)
          return if profile.slowest_groups(slowest).empty?

          @output.puts "\nTop #{profile.slowest_groups(slowest).size} slowest example groups:"
          profile.slowest_groups(slowest).each do |loc, hash|
            average = "#{bold(Helpers.seconds(hash[:average]))} #{bold("seconds")} average"
            total   = "#{Helpers.format_seconds(hash[:total_time])} seconds"
            count   = Helpers.pluralize(hash[:count], "example")
            @output.puts "  #{hash[:description]}"
            @output.puts "    #{average} (#{total} / #{count}) #{loc}"
          end
        end

        def format_caller(caller_info)
          RSpec.configuration.backtrace_formatter.backtrace_line(
            caller_info.to_s.split(':in `block').first)
        end

        def bold(text)
          ConsoleCodes.wrap(text, :bold)
        end
      end
    end
  end
end
