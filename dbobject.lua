local class = SQLite_lib.class
local classExtends = SQLite_lib.classExtends
local trim = SQLite_lib.trim

dbObject = class(function(static)
  static.db = SQLite3.getInstance()
  static._where = {}
  static.dbTable = nil
  static.dbColumns = {}

  self.id = nil
  self._where = {}

  function self:dbMapping()
    local data = self:getData('id', self.id);

    for _, column in pairs(static.dbColumns) do
      self[column] = data[column]
    end
  end

  function self:getData(column, value)
    print(static.dbTable)
    -- return static.db:where(column, value):getOne(static.dbTable)
  end

  function self:save()
    local array = {}
  end

  function self:dbReset()
    static._where = {}
  end
end)

function dbObject.byId(id)
  local instance = dbObject.newChild()

  instance.id = id
  instance:dbMapping()

  return instance
end

function dbObject.get(numRows)
  for property, value in pairs(dbObject._where) do
    db:where(property, value)
  end

  db:get(dbObject.dbTable, numRows, 'id')
  self:reset()
end

function dbObject.getOne()
  local result = dbObject.get(1)
  return result[1]
end

function dbObject.where(property, value)
  table.insert(dbObject._where, {
    property = property,
    value = value
  })
end

dbObject.__newindex = function(self, key, value)
  if key == 'dbTable' then
    if not dbObject.db then return end
    local columns = {}

    for row in static.db:nrows('PRAGMA table_info(' .. value .. ')') do
      table.insert(columns, row.name)
    end

    dbObject.dbColumns = columns
  else
    rawset(self, key, value)
  end
end
