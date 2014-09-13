-- FIXME: use normal Lua naming conventions
local knight = {}

local function map(array, func)
  local new_array = {}
  for index, value in ipairs(array) do
    new_array[index] = func(value)
  end
  return new_array
end


function knight:module()
  local module = {halted=false, components={}}

  function module:halt()
    self.halted = true
    return self
  end

  function module:resume()
    self.halted = false
    self:check_dependencies()
    return self
  end

  function module:component(name, dependencies, constructor)
    self.components[name] = {
      dependencies=dependencies,
      constructor=constructor
    }
    self:check_dependencies()
    return self
  end

  function module:dependencies_met(dependencies)
    for _, name in pairs(dependencies) do
      if self.components[name] == nil then return false end
    end
    return true
  end

  function module:get_dependencies(dependencies)
    return map(dependencies, function(dependency)
      if self.components[dependency] then
        return self.components[dependency].component
      else
        return nil
      end
    end)
  end

  function module:check_dependencies()
    if self.halted then return end
    for name, component_info in pairs(self.components) do
      local dependencies = component_info.dependencies
      if self:dependencies_met(dependencies) then
        component_info.component = component_info.constructor(unpack(self:get_dependencies(dependencies)))
      end
    end
  end

  return module
end

return knight
