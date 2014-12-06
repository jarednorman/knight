local function map(array, func)
  local new_array = {}
  for index, value in ipairs(array) do new_array[index] = func(value) end
  return new_array
end

local knight = {}
local modules= {}

function knight.module(name)
  if modules[name] then return modules[name] end

  modules[name] = {}
  local module = modules[name]
  local components = {}
  local dependency_sweep
  local dependencies_met
  local get_dependencies

  modules[name].component = function(name, dependencies, constructor)
    components[name] = {
      dependencies=dependencies,
      constructor=constructor
    }
    dependency_sweep()
    return module
  end

  modules[name].create_component = function(name, dependencies)
    return components[name].constructor(unpack(dependencies))
  end

  dependency_sweep = function()
    local found_one = false
    for name, component in pairs(components) do
      local dependencies = component.dependencies

      if dependencies_met(dependencies) and not component.loaded then
        found_one = true
        component.result = component.constructor(unpack(get_dependencies(dependencies)))
        component.loaded = true
      end
    end

    if found_one then dependency_sweep() end
  end

  dependencies_met = function(dependencies)
    for _, name in pairs(dependencies) do
      if not (components[name] and components[name].loaded) then
        return false
      end
    end
    return true
  end

  get_dependencies = function(dependencies)
    return map(dependencies, function(dependency)
      if components[dependency] then
        return components[dependency].result
      end
    end)
  end

  return modules[name]
end

return knight
