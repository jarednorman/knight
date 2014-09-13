-- FIXME: use normal Lua naming conventions
local knight = {}

local function map(array, func)
  local new_array = {}
  for index, value in ipairs(array) do
    new_array[index] = func(value)
  end
  return new_array
end

local function dependencies_met(module, dependencies)
  for _, name in pairs(dependencies) do
    if module.components[name] == nil then
      return false
    end
  end
  return true
end

local function get_dependencies(module, dependencies)
  return map(dependencies, function(dependency)
    if module.components[dependency] then
      return module.components[dependency].component
    else
      return nil
    end
  end)
end

local function check_dependencies(module)
  for name, component_info in pairs(module.components) do
    local dependencies = component_info.dependencies
    if dependencies_met(module, dependencies) then
      component_info.component = component_info.constructor(unpack(get_dependencies(module, dependencies)))
    end
  end
end

function knight.module()
  local module = {components = {}}

  function module.component(name, dependencies, constructor)
    module.components[name] = {
      dependencies=dependencies,
      constructor=constructor
    }
    check_dependencies(module)
    return module
  end

  return module
end

return knight
