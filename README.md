# Description

The goal of this project is to assist developers in writing code for CloudForms outside of the UI. This script will create CloudForms objects locally, such as classes, methods, namespaces, instances, etc.

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

### Creating an Instance

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
