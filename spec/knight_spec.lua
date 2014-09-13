knight = require 'knight'

describe("knight", function()
  it("accepts module definitions", function()
    knight.module("moduleTest")
  end)

  it("allows chaining of components to modules", function()
    knight.module("componentTest").component("Thing", [], function()
    end)
  end)

  it("allows chaining of classes to modules", function()
    knight.module("componentTest").class("Thing", [], function()
    end)
  end)
end)
