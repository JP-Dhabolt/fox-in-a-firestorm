extends Object
class_name IEdible

static func implements(obj: Object) -> bool:
	return obj.has_method("eat_me")
