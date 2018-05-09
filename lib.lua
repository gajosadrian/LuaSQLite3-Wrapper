local function class(constructor)
  local namespace = {}
  namespace.__index = namespace
  namespace.new = function(...)
    local outerSelf = self
    -- aliases
    local this = {}
    self = this
    -- metatable
    setmetatable(this,namespace)
    constructor(unpack(arg))
    -- constructor
    if this.__construct then
      this:__construct(unpack(arg))
    end
    -- finish
    self = outerSelf -- used to allow constructors inside constructors
    return this
  end
  return namespace
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
