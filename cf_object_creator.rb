#!/usr/bin/ruby

require 'yaml'

OBJECT_TYPE = ARGV[0]

def create_method()
  # Check if we're in a .class directory or a __methods__ directory
  is_class_directory = File.exists?("__class__.yaml")
  is_methods_directory = (Dir.pwd.split('/')[-1] == "__methods__")
  if !is_class_directory && !is_methods_directory
    puts "You must be in a class's directory or a __methods__ directory to create a method"
    exit
  end

  # Create __methods__ directory if it doesn't exist
  if !is_methods_directory && !File.directory?("__methods__")
    puts "creating __methods__ directory"
    Dir.mkdir("__methods__")
  end

  # If we're not already in the __methods__ directory, move into it
  if !is_methods_directory
    puts "changing to __methods__ dir"
    Dir.chdir("__methods__")
  end

  # Get the method name
  puts "Enter the desired method name"
  method_name = STDIN.gets.chomp
  # Create empty Ruby file under __methods__ directory
  File.write("#{method_name}.rb","")

  # Read yaml template and create object
  method_definition = YAML.load_file("#{__dir__}/object_templates/method.yaml")
  # Set the method's name
  method_definition["object"]["attributes"]["name"] = method_name
  # Write the yaml file to disk
  File.write("#{method_name}.yaml", method_definition.to_yaml)
end

def create_instance()
  # verify that we're under a .class directory... check for existence of __class__.yaml
  if !File.exists?("__class__.yaml")
    puts "You must be in a class's directory to create an Instance"
    exit
  end

  class_definition = YAML.load_file("__class__.yaml")
  instance_definition = YAML.load_file("#{__dir__}/object_templates/instance.yaml")

  puts "Enter the desired instance name"
  instance_name = STDIN.gets.chomp
  instance_definition["object"]["attributes"]["name"] = instance_name

  # If the schema of the class is empty, there is nothing more to do
  # There are no fields to copy, no default values to set.
  unless class_definition["object"]["schema"].nil?
    puts "Would you like you use the class defaults? [y/n]"
    use_class_defaults = STDIN.gets.chomp
    if use_class_defaults == "n"
      fields = ""
      class_definition["object"]["schema"].each do |field|
        fields += field["field"]["name"] + " "
      end

      continue = true
      while continue
        puts "Which field would you like to modify? Leave blank to exit"
        puts "#{fields}"
        field_name = STDIN.gets.chomp
        while !fields.include?(field_name)
          puts "There is no field named #{field_name}. Please select a field from the list below"
          puts "#{fields}"
          field_name = STDIN.gets.chomp
        end

        if field_name == ""
          continue = false
          break
        end

        puts "Enter the new value"
        field_value = STDIN.gets.chomp

        # The yaml object is a little akward to work with...
        # Make sure you have the fields attribute created
        if instance_definition["object"]["fields"].nil?
          instance_definition["object"]["fields"] = []
        end
        # Add the field and the value to the instance definition
        instance_definition["object"]["fields"].append({"#{field_name}" => {"value" => "#{field_value}"}})
        puts "field #{field_name} updated with value #{field_value}"
      end # while continue
    end # if didn't want the class defaults
  end # unless schema is empty
  File.write("#{instance_name}.yaml", instance_definition.to_yaml)
end

def create_class()
  # verify that you are in a namespace... look for __namespace__.yaml
  if !File.exists?("__namespace__.yaml")
    puts "You must be in a namespace's directory to create a Class"
    exit
  end

  #import class definition
  class_definition = YAML.load_file("#{__dir__}/object_templates/class.yaml")

  # Set the class name
  puts "Enter the desired class name"
  class_name = STDIN.gets.chomp
  class_definition["object"]["attributes"]["name"] = class_name

  # Need to track priority
  priority = 1
  loop do
    puts "Would you like to add a field to the class's schema? [y/n]"
    add_field = STDIN.gets.chomp
    if add_field == "n"
      break
    elsif add_field == "y"
      schema_field_definition = YAML.load_file("#{__dir__}/object_templates/schema_field.yaml")
      schema_field_definition["field"]["priority"] = priority.to_i
      collect_schema_field_options(schema_field_definition)

      #modify class definition
      #create the schema section of the class definition
      if class_definition["object"]["schema"].nil?
        class_definition["object"]["schema"]=[]
      end

      # Add the field to the class definition
      class_definition["object"]["schema"].append(schema_field_definition)

      # Track the priority of the field
      priority += 1
    end
  end

  #create the directory with '.class' appended to the name
  puts "creating class directory"
  Dir.mkdir("#{class_name}.class")
  puts "changing to class directory"
  Dir.chdir("#{class_name}.class")
  # write the file to disk
  puts "creating class yaml file"
  File.write("__class__.yaml", class_definition.to_yaml)
end

# This method prompts the user for several options related to the field
# It will populate the schema_field_definition hash with the values
#
# could try something like...
# schema_field_definition["field"].each do |option|
#   puts "#{option} [leave blank for no value]"
#   schema_field_definition["field"]["#{option}"] = STDIN.gets.chomp
#   need to leave the populated values (priority and name) alone
#     unless ["field"]["#{option}"].to_s.empty?
#
def collect_schema_field_options(schema_field_definition)
  puts "field type [attribute, relationship, method, state]:"
  schema_field_definition["field"]["aetype"] = STDIN.gets.chomp

  puts "field name:"
  schema_field_definition["field"]["name"] = STDIN.gets.chomp

  #TODO: find out what datatypes there are
  puts "field datatype [string, integer, array, etc]"
  schema_field_definition["field"]["datatype"] = STDIN.gets.chomp

  puts "default value [leave blank for no default]:"
  schema_field_definition["field"]["default_value"] = "#{STDIN.gets.chomp}"

  puts "message [leave blank for no message]:"
  schema_field_definition["field"]["message"] = STDIN.gets.chomp

  puts "collect [leave blank to collect nothing]:"
  schema_field_definition["field"]["collect"] = STDIN.gets.chomp

  puts "on entry [leave blank for no action]:"
  schema_field_definition["field"]["on_entry"] = STDIN.gets.chomp

  puts "on exit [leave blank for no action]:"
  schema_field_definition["field"]["on_exit"] = STDIN.gets.chomp

  puts "on error [leave blank for no action]:"
  schema_field_definition["field"]["on_error"] = STDIN.gets.chomp

  puts "max retries [leave blank for no limit]:"
  schema_field_definition["field"]["max_retries"] = "#{STDIN.gets.chomp}"
end

def create_namespace()
  # make sure you're in a domain or another namespace
  if !File.exists?("__domain__.yaml") && !File.exists?("__namespace__.yaml")
    puts "you must be in a domain or namespace directory"
    exit
  end

  puts "Enter the desired namespace name"
  namespace_name = STDIN.gets.chomp

  # Create the directory
  puts "creating namespace directory"
  Dir.mkdir("#{namespace_name}")

  # Change to the directory
  puts "changing to new directory"
  Dir.chdir("#{namespace_name}")

  # Read in namespace yaml template
  namespace_definition = YAML.load_file("#{__dir__}/object_templates/namespace.yaml")

  # Modify the template
  namespace_definition["object"]["attributes"]["name"] = namespace_name

  # Write the yaml file to disk
  puts "creating namespace yaml file"
  File.write("__namespace__.yaml", namespace_definition.to_yaml)
end

begin
  case OBJECT_TYPE
  when "method"
    create_method()
  when "instance"
    create_instance()
  when "class"
    create_class()
  when "namespace"
    create_namespace()
  else
    puts "This script requires an automate object type as a paramater [method, instance, class, or namespace]"
  end
  puts "#{OBJECT_TYPE} created"
end
