local knight = {}

function knight.module()
  local module = {}

  function module.class(_, _, constructor)
    constructor()
    return module
  end

  function module.component(_, _, constructor)
    constructor()
    return module
  end

  return module
end

return knight
