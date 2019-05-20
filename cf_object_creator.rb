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

def create_instance(instance_name)
  # verify that we're under a .class directory
  instance_definition = YAML.load_file("#{__dir__}/object_templates/instance.yaml")
  instance_definition["object"]["attributes"]["name"] = instance_name

  puts "Would you like you use the class defaults? [y/n]"
  use_class_defaults = STDIN.gets.chomp
  if use_class_defaults == "n"
    puts "This feature has not yet been implemented"
    #Need to pull the class definition to see what fields are available, not the instance
    #fields = instance_definition["object"]["fields"]
    #puts "Which field would you like to modify? [#{fields.keys}]"
  end

  File.write("#{instance_name}.yaml", instance_definition.to_yaml)
  return 0
end

begin
  case OBJECT_TYPE
  when "method"
    puts "Enter the desired method name"
    method_name = STDIN.gets.chomp
    create_method(method_name)
  when "instance"
    puts "Enter the desired instance name"
    instance_name = STDIN.gets.chomp
    create_instance(instance_name)
  else
    puts "Object type of #{OBJECT_TYPE} is not recognized"
    return 0
  end
  puts "#{OBJECT_TYPE} created"
  return 0
end
