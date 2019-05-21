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

def create_instance()
  # verify that we're under a .class directory... check for existence of __class__.yaml
  if !File.exists?("__class__.yaml")
    puts "You must be in a class's directory to create an Instance"
    exit 0
  end

  class_definition = YAML.load_file("__class__.yaml")
  instance_definition = YAML.load_file("#{__dir__}/object_templates/instance.yaml")

  puts "Enter the desired instance name"
  instance_name = STDIN.gets.chomp
  instance_definition["object"]["attributes"]["name"] = instance_name

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
    end
  end
  File.write("#{instance_name}.yaml", instance_definition.to_yaml)
  return 0
end

def create_class()
  # verify that you are in a namespace... look for __namespace__.yaml
  if !File.exists?("__namespace__.yaml")
    puts "You must be in a namespace's directory to create a Class"
    exit 0
  end

  puts "Enter the desired class name"
  class_name = STDIN.gets.chomp

  #import class definition
  class_definition = YAML.load_file("#{__dir__}/object_templates/class.yaml")

  loop do
    puts "Would you like to add a field to the class? [y/n]"
    add_field = STDIN.gets.chomp
    if add_field == "n"
      break
    elsif add_field == "y"
      field_attributes = collect_field_attributes()
      #modify class definition
      #if [object][schema].nil?
        #creat [object][schema]
      #[object][schema] = [{field => {}...yadda yadda
    end

  end

  #create the directory with '.class' appended to the name
  Dir.mkdir "#{class_name}+.class"
  #write the file to disk
  return 0
end

begin
  case OBJECT_TYPE
  when "method"
    puts "Enter the desired method name"
    method_name = STDIN.gets.chomp
    create_method(method_name)
  when "instance"
    create_instance()
  when "class"
    create_class()
  when ""
    puts "This script requires an automate object type as a paramater [method, instance, class, or namespace]"
    return 0
  else
    puts "Object type of #{OBJECT_TYPE} is not recognized"
    return 0
  end
  puts "#{OBJECT_TYPE} created"
  return 0
end
