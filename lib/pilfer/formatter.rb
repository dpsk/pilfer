# Formatting a profile as JSON may eventually be provided by rblineprof.
module Pilfer
  module Formatter
    def self.json(profile, profile_start)
      files = profile.each_with_object({}) do |(file, lines), files|
        profile_lines = lines[1..-1].
                          each_with_index.
                          each_with_object({}) do |(data, number), lines|
          next unless data.any? {|datum| datum > 0 }
          wall_time, cpu_time, calls = data
          lines[number] = { 'wall_time' => wall_time,
                            'cpu_time'  => cpu_time,
                            'calls'     => calls }
        end

        total_wall, child_wall, exclusive_wall,
          total_cpu, child_cpu, exclusive_cpu = lines[0]

        wall = total_wall
        cpu  = total_cpu

        files[file] = { 'wall_time' => wall,
                        'cpu_time'  => cpu,
                        'lines'     => profile_lines }
      end

      {
        'profile' => {
          'version'   => '0.2.5',
          'timestamp' => profile_start.to_i,
          'files'     => files
        }
      }
    end
  end
end
