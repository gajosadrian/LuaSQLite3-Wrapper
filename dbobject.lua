local class = SQLite_lib.class
local trim = SQLite_lib.trim

dbObject = class(function()
  self.db = nil
  self.dbTable = nil
  self.dbColumns = {}
  self._where = {}

  function self:__construct()
    self.db = SQLite3.getInstance()
  end

  function self:dbMapping()
    local data = self:getData('id', value);

    for _, column in pairs(self.dbColumns) do
      self[column] = data[column]
    end
  end

  function self:getData(column, value)
    return self.db:where(column, value):getOne()
  end

  function self:save()
    local array = {}
  end

  function self:dbReset()
    self._where = {}
  end
end)

function dbObject.byId(id)
  local instance = self.new()
  instance.id = id
  instace:dbMapping()
end

function dbObject.get(numRows, columns)
  for property, value in pairs(self._where) do
    db:where(property, value)
  end

  db:get(self.dbTable, numRows, columns)
  self:reset()
end

function dbObject.test()
  print('test')
end

function dbObject.getOne(columns)
  local result = self:get(1, columns)
  return result[1]
end

function dbObject.where(property, value)
  table.insert(self._where, {
    property = property,
    value = value
  })
end

dbObject.__newindex = function(self, key, value)
  if key == 'dbTable' then
    if not self.db then return end
    local columns = {}

    for row in self.db:nrows('PRAGMA table_info(' .. value .. ')') do
      table.insert(columns, row.name)
    end

    self.dbColumns = columns
  else
    rawset(self, key, value)
  end
end
