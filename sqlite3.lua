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

local sqlite3 = require('lsqlite3')
SQLite3 = class(function()
  self.db = nil
  self._where = ''
  self._order = ''

  function self:__construct(path)
    self.db = sqlite3.open(path)
  end

  function self:get(table_name, num_rows, columns)
    local limit = self:_limit(num_rows)
    local columns = columns and table.concat(columns, ',') or '*'
    local query = trim('SELECT ' .. columns .. ' FROM ' .. table_name .. ' ' .. self._where .. ' ' .. self._order .. ' ' .. limit)
    self:reset()

    local array = {}
    for row in self.db:nrows(query) do
      local tab = {}

      for column, value in pairs(row) do
        tab[column] = value
      end

      table.insert(array, tab)
    end

    return array
  end

  function self:getOne(table_name, columns)
    local result = self:get(table_name, 1, columns)
    return result[1]
  end

  function self:where(property, value, operator, condition)
    operator = operator or '='
    condition = condition or 'AND'
    local sql = property .. operator .. value

    if self._where == '' then
      self._where = 'WHERE ' .. sql
    else
      self._where = self._where .. ' ' .. condition .. ' ' .. sql
    end

    return self
  end

  function self:insert(table_name, table_data)
    local columns, values = {}, {}
    for column, value in pairs(table_data) do
      table.insert(columns, column)
      table.insert(values, '"' .. value .. '"')
    end

    self.db:exec(trim('INSERT INTO ' .. table_name .. ' (' .. table.concat(columns, ',') .. ') VALUES(' .. table.concat(values, ',') .. ')'))
    self:reset()
  end

  function self:update(table_name, table_data)
    local array = {}
    for column, value in pairs(table_data) do
      table.insert(array, column .. '="' .. value .. '"')
    end
    local sql = table.concat(array, ',')

    self.db:exec(trim('UPDATE ' .. table_name .. ' SET ' .. sql .. ' ' .. self._where))
    self:reset()
  end

  function self:delete(table_name, num_rows)
    local limit = self:_limit(num_rows)

    self.db:exec(trim('DELETE FROM ' .. table_name .. ' '  .. self._where .. ' ' .. limit))
    self:reset()
  end

  function self:orderBy(column, direction)
    direction = direction and direction:upper() or 'DESC'
    local sql = column .. ' ' .. direction

    if self._order == '' then
      self._order = 'ORDER BY ' .. sql
    else
      self._order = self._order .. ',' .. ' ' .. sql
    end

    return self
  end

  function self:_limit(num_rows)
    return num_rows and ('LIMIT ' .. num_rows) or ''
  end

  function self:reset()
    self._where = ''
    self._order = ''
  end
end)
