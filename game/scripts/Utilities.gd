extends Object
class_name Utilities

static func print_object_properties(obj):
	var prop_list = obj.get_property_list()
	for prop in prop_list:
		var prop_name = prop.name
		var prop_value = obj.get(prop_name)
		print(prop_name + ": " + str(prop_value))
