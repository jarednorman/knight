-- FIXME: use normal Lua naming conventions
local knight = {}

local function map(array, func)
  local new_array = {}
  for index, value in ipairs(array) do
    new_array[index] = func(value)
  end
  return new_array
end

local function dependenciesMet(module, dependencies)
  for _, name in pairs(dependencies) do
    if module.components[name] == nil then
      return false
    end
  end
  return true
end

local function getDependencies(module, dependencyList)
  return map(dependencyList, function(dependency)
    if module.components[dependency] then
      return module.components[dependency].component
    else
      return nil
    end
  end)
end

local function checkDependencies(module)
  for name, componentInfo in pairs(module.components) do
    local dependencies = componentInfo.dependencies
    if dependenciesMet(module, dependencies) then
      componentInfo.component = componentInfo.constructor(unpack(getDependencies(module, dependencies)))
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
    checkDependencies(module)
    return module
  end

  return module
end

return knight
