#!/usr/bin/ruby

require 'yaml'

OBJECT_TYPE = ARGV[0]

def create_method(method_name)
  # Check if we're under a .class directory or a __methods__ directory
    # Create __methods__ directory if it doesn't exist
  # Create empty Ruby file under __methods__ directory
  File.write("#{method_name}.rb","")
  # Create a corresponding yaml definition for the method from the template
    # Read yaml template and create object
  method_definition = YAML.load_file("#{__dir__}/object_templates/method.yaml")
  # Set the method's name
  method_definition["object"]["attributes"]["name"] = method_name
  # Write the yaml file to disk
  File.write("#{method_name}.yaml", method_definition.to_yaml)
  return 0
end

begin
  case OBJECT_TYPE
  when "method"
    puts "Enter the desired method name"
    method_name = STDIN.gets.chomp
    create_method(method_name)
  else
    puts "Object type of #{OBJECT_TYPE} is not recognized"
    return 0
  end
  puts "method created"
  return 0
end
