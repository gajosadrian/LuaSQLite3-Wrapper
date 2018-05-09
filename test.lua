-- local db = SQLite3.new('test.db')
local db = SQLite3.new('sys/lua/LuaSQLite3-Wrapper/test.db')

local result = db
  :orderBy('name', 'desc')
  :get('users')

for _, row in pairs(result) do
  print(row.id, row.name, row.level, row.exp)
end
