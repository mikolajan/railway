require_relative 'lib/console_interface'
require_relative 'lib/railway'

railway = Railway.new
console_interface = ConsoleInterface.new(railway)

loop do
  console_interface.show_actions

  user_input = console_interface.get_input

  break if user_input == '0'

  action, params = console_interface.process(user_input)

  puts "ОТЛАДОЧНЫЙ ВЫВОД action: #{action}, params: #{params}"

  if params.any?
    railway.make_action!(action, params)
    console_interface.show_railway_status
  end
end
