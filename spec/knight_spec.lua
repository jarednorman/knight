inspect = (function()
  local inspect = require 'inspect'
  return function(arg) print(inspect(arg)) end
end)()

knight = require 'knight'

describe("knight", function()
  it("figures out dependencies like a big boy", function()
    local thing2 = {}
    local componentConstructor1 = spy.new(function(thing2) return 3 end)
    local componentConstructor2 = spy.new(function() return thing2 end)

    local dependencyTest = knight.module("dependencyTest")
    .component("Thing1", {"Thing2"}, componentConstructor1)
    .component("Thing2", {}, componentConstructor2)

    assert.spy(componentConstructor1).was.called_with(thing2)
    assert.spy(componentConstructor2).was.called()
  end)
end)
