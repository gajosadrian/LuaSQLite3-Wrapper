local class = SQLite_lib.class
local classExtends = SQLite_lib.classExtends
local trim = SQLite_lib.trim

dbObject = class({
  _where = {},
  dbTable = nil,

  byId = function(id)
    local instance = dbObject.newChild()

    instance.id = id
    local data = instance:getData()
    instance:dbMapping(data)

    return instance
  end,

  get = function(numRows)
    local db = SQLite3.getInstance()
    local instances = {}

    for property, value in pairs(dbObject._where) do
      db:where(property, value)
    end

    local users = db:get(dbObject.dbTable, numRows)
    for _, data in pairs(users) do
      local instance = dbObject.newChild()
      instance:dbMapping(data)

      table.insert(instances, instance)
    end

    self:reset()
    return instances
  end,

  getOne = function()
    local instances = dbObject.get(1)
    return instances[1]
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

  function self:dbMapping(data)
    for _, column in pairs(self.dbColumns) do
      self[column] = data[column]
    end
  end

  function self:getData()
    return self.db:where('id', self.id):getOne(dbObject.dbTable)
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

    if data['id'] then
      self.db:update(dbObject.dbTable, data)
    else
      print 'insert'
    end
  end

  function self:dbReset()
    dbObject._where = {}
  end
end)
