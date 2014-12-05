local knight = require 'knight'

describe("knight", function()
  it("figures out dependencies like a big boy", function()
    local thing1 = {thing=1}
    local thing2 = {thing=2}
    local thing3 = {thing=3}
    local component_constructor1 = spy.new(function(thing2) return thing1 end)
    local component_constructor2 = spy.new(function() return thing2 end)
    local component_constructor3 = spy.new(function(thing1, thing2) return thing3 end)

    knight.module("dependencyTest")
    .component("Thing1", {"Thing2"}, component_constructor1)
    .component("Thing2", {}, component_constructor2)
    .component("Thing3", {"Thing1", "Thing2"}, component_constructor3)

    assert.spy(component_constructor1).was.called(1)
    assert.spy(component_constructor1).was.called_with(thing2)
    assert.spy(component_constructor2).was.called(1)
    assert.spy(component_constructor3).was.called_with(thing1, thing2)
    assert.spy(component_constructor3).was.called(1)
  end)

  it("treats modules with the same name as the same module", function()
    local thing1 = {thing=1}
    local thing2 = {thing=2}
    local component_constructor1 = spy.new(function() return thing1 end)
    local component_constructor2 = spy.new(function() return thing2 end)

    knight.module("identityTest")
    .component("Thing1", {"Thing2"}, component_constructor1)

    knight.module("identityTest")
    .component("Thing2", {}, component_constructor2)

    assert.spy(component_constructor1).was.called(1)
    assert.spy(component_constructor1).was.called_with(thing2)
    assert.spy(component_constructor2).was.called(1)
  end)

  it("exposes components for testing purposes", function()
    knight.module("testTest")
    .component('testableThing', {'dependency'}, function(dependency)
      return dependency
    end)

    assert(knight.module("testTest").create_component('testableThing', {'foo'}) == 'foo')
  end)
end)
