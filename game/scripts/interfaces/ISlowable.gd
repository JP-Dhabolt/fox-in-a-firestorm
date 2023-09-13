extends Object
class_name ISlowable

static func implements(obj: Object) -> bool:
	return obj.has_method("determine_slowdown")
