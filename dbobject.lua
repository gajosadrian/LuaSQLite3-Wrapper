local class = SQLite_lib.class
local classExtends = SQLite_lib.classExtends
local trim = SQLite_lib.trim

dbObject = class({
  _where = {},
  dbTable = nil,

  byId = function(id)
    local instance = dbObject.newChild()

    instance.id = id
    instance:dbMapping()

    return instance
  end,

  get = function(numRows)
    for property, value in pairs(dbObject._where) do
      db:where(property, value)
    end

    db:get(dbObject.dbTable, numRows, 'id')
    self:reset()
  end,

  getOne = function()
    local result = dbObject.get(1)
    return result[1]
  end,

  where = function(property, value)
    table.insert(dbObject._where, {
      property = property,
      value = value
    })
  end,
}, function()
  self.id = nil
  self.db = nil
  self.dbColumns = {}

  function self:__construct()
    self.db = SQLite3.getInstance()
    self.dbColumns = self:getColumns()
  end

  function self:dbMapping()
    local data = self:getData('id', self.id)

    for _, column in pairs(self.dbColumns) do
      self[column] = data[column]
    end
  end

  function self:getData(column, value)
    return self.db:where(column, value):getOne(dbObject.dbTable)
  end

  function self:getColumns()
    local columns = {}

    for row in self.db.db:nrows('PRAGMA table_info(' .. dbObject.dbTable .. ')') do
      table.insert(columns, row.name)
    end

    return columns
  end

  function self:save()
    local data = {}

    for _, column in pairs(self.dbColumns) do
      data[column] = self[column]
    end

    self.db:update(dbObject.dbTable, data)
  end

  function self:dbReset()
    dbObject._where = {}
  end
end)
