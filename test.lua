local class = SQLite_lib.class
local classExtends = SQLite_lib.classExtends

-- local db = SQLite3.new('test.db')
local db = SQLite3.new('sys/lua/LuaSQLite3-Wrapper/test.db')

-- local result = db
--   :orderBy('name', 'desc')
--   :get('users')
--
-- for _, row in pairs(result) do
--   print(row.id, row.name, row.level, row.exp)
-- end

User = classExtends(dbObject, {
  dbTable = 'users',
}, function()
  function self:__construct()
    self.name = math.random(100, 999)
  end
end)

local user = User.byId(1)
print(user.id, user.name, user.level, user.exp)
