# Description

The goal of this project is to assist CloudForms administrators in writing code for CloudForms outside of the UI. This script will create CloudForms objects locally, such as classes, methods, namespaces, instances, etc.

## Usage

This script requires an automate object type as a paramater: method, instance, class, or namespace.

I recommend creating an alias to launch the script.

```
alias cf-object-creator='ruby ../../cf_object_creator.rb'
```

### Creating a Namespace

Before you can create a namespace, you must navigate to a domain or another namespace.

Pass the parameter `namespace` to the script.

```
$ cf-object-creator namespace
```

You will be prompted for the namespace's name.

```
Enter the desired namespace name
```

Enter the name of the namespace and the script will then create the namespace.

```
Enter the desired namespace name
MyNameSpaceName
```

### Creating a Class

Before you can create a class, you must navigate to a namespace.

Pass the parameter `class` to the script.

```
$ cf-object-creator class
```

You will be prompted for the class's name.

```
Enter the desired class name
```

Enter the name of the class.

```
Enter the desired class name
MyClass
```

You will then be asked if you would like to add any fields to the class's schema. If you choose `n`, the script will create the class with a blank schema.

```
Would you like to add a field to the class's schema? [y/n]
n
creating class directory
changing to class directory
creating class yaml file
class created
```

If you select `y`, the script will walk you through adding a field to the schema.

```
Would you like to add a field to the class's schema? [y/n]
y
field type [attribute, relationship, method, state]:
attribute
field name:
my_attribute
field datatype [string, integer, array, etc]
string
default value [leave blank for no default]:
"a default value"   
message [leave blank for no message]:

collect [leave blank to collect nothing]:

on entry [leave blank for no action]:

on exit [leave blank for no action]:

on error [leave blank for no action]:

max retries [leave blank for no limit]:

```

Once you are finished, the script will ask you if you'd like to add anymore fields. Select `n` to complete the class creation or select `y` to repeat the above process for adding another field.

```
Would you like to add a field to the class's schema? [y/n]
n
creating class directory
changing to class directory
creating class yaml file
class created
```

### Creating an Instance

Before you can create an instance, you must navigate to a class.

Pass the parameter `instance` to the script.

```
$ cf-object-creator instance
```

You will be prompted for the instance's name.

```
Enter the desired instance name
```

Enter the name of the instance.

```
Enter the desired instance name
my_instance_name
```

You will be asked if you want to use the class defaults.

```
Would you like you use the class defaults? [y/n]
```

If you would like this instance to inherit all of the default values from the class's schema, select `y`. If you would like to modify any of the values, select `n`.

If you select `y`, the script will create the instance with the given name, using the default values from the class.

If you select `n`, the script will display all of the fields in the schema and allow you to select one to modify.

```
Would you like you use the class defaults? [y/n]
n
Which field would you like to modify? Leave blank to exit
snow_server snow_user snow_password sys_id table_name execute
```

Enter the name of the field you would like to modify. If you do not wish to modify any fields, simply leave the field blank and press enter and the script will complete.

```
Which field would you like to modify? Leave blank to exit
snow_server snow_user snow_password sys_id table_name execute
snow_password
```

You will now be asked to enter the new value for that field.

```
Enter the new value
my_bad_password
```

After you enter your value, you will be brought to the list of fields and given the opportunity to select another field and modify its value. Once you are done modifying fields, leave the entry blank and press enter to complete the instance creation.


### Creating a Method

Before you can create a method, you must navigate to a class or method directory.

Pass the parameter `method` to the script.

```
$ cf-object-creator method
```

You will be prompted for the method's name.

```
Enter the desired method name
```

Enter the name of the method and the script will then create the method.

```
Enter the desired method name
my_method_name
```
