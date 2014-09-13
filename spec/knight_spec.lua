inspect = (function()
  local inspect = require 'inspect'
  return function(arg) print(inspect(arg)) end
end)()

knight = require 'knight'

describe("knight", function()
  it("figures out dependencies like a big boy", function()
    local thing1 = {thing=1}
    local thing2 = {thing=2}
    local thing3 = {thing=3}
    local component_constructor1 = spy.new(function(thing2) return thing1 end)
    local component_constructor2 = spy.new(function() return thing2 end)
    local component_constructor3 = spy.new(function(thing1, thing2) return thing3 end)

    local dependencyTest = knight.module("dependencyTest")
    .component("Thing1", {"Thing2"}, component_constructor1)
    .component("Thing2", {}, component_constructor2)
    .component("Thing3", {"Thing1", "Thing2"}, component_constructor3)

    assert.spy(component_constructor1).was.called_with(thing2)
    assert.spy(component_constructor2).was.called()
    assert.spy(component_constructor3).was.called_with(thing1, thing2)
  end)
end)
