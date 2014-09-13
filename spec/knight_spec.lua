knight = require 'knight'

describe("knight", function()
  it("accepts module definitions", function()
    knight.module("moduleTest")
  end)

  it("allows defining components on modules", function()
    local componentConstructor = spy.new(function() end)

    knight.module("componentTest").component("Service", {}, componentConstructor)

    assert.spy(componentConstructor).was.called()
  end)

  it("allows defining classes on modules", function()
    local classConstructor = spy.new(function() end)

    knight.module("componentTest").class("Thing", {}, classConstructor)

    assert.spy(classConstructor).was.called()
  end)

  it("allows chaining multiple service definition", function()
    local componentConstructor1 = spy.new(function() end)
    local componentConstructor2 = spy.new(function() end)

    knight.module("chainingTest")
    .class("Thing1", {}, componentConstructor1)
    .class("Thing2", {}, componentConstructor2)

    assert.spy(componentConstructor1).was.called()
    assert.spy(componentConstructor2).was.called()
  end)
end)
