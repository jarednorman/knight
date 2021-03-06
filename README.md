# Knight

__Knight is a dependency manager/injector for Lua.__

Modules are namespaced dependency graphs. Components are whatever you are
wiring together. Components can be classes or services or constants; Knight
doesn't care.

## Installation

Copy the `knight.lua` somewhere in the require path, then throw `knight =
require 'knight'` somewhere near the start of your code.

## Get Knighted

Just provide the name of the module, and then chain components off it. The
`:component` method takes the name of the component, the list of dependencies,
and a function that should construct the component when passed the
dependencies.

Here's some example code, assume I've got [kikito's
middleclass](https://github.com/kikito/middleclass) loaded (but it's not a
dependency, Knight has no dependecies.)

```lua
-- some_subclass.lua
knight.module("MyApplication")
.component("SomeSubclass", {"SomeClass"}, function(SomeClass)
  local SomeSubclass = class("SomeSubclass", SomeClass)

  function SomeSubclass:bar()
    print(foos)
  end

  return SomeSubclass
end)

-- some_class.lua
knight.module("MyApplication")
.component("SomeClass", {"foo_service"}, function(foo_service)
  local SomeClass = class("SomeClass")

  function SomeClass:initialize()
    self.foos = foo_service.get_some_foos()
  end

  return SomeClass
end)

-- foo_service.lua
knight.module("MyApplication")
.component("foo_service", {}, function()
  local FooService = class("FooService")

  function FooService:get_some_foos()
    {"foo", "foo", "foo"}
  end

  return FooService:new()
end)
```

## Rationale

I didn't like managing dependencies and load order in my more complicated Lua
applications. I also wanted a way to test code that would be run in
environments that were substantially different from the test environment, like
in [Löve](http://love2d.org/).

Dependency injection isn't a very elegant pattern, especially not as a core
application design pattern, but it seemed better than what I had been doing.

