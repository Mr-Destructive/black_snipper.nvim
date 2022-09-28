local function get_selected_text()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return lines
end

local function run_black(file_name)
  vim.cmd("!black " .. file_name, {})
end

local function get_postion()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  pos = {s_start, s_end}
  return unpack({pos})
end

local function  get_tmp_file_name()
  local file_name = os.tmpname() .. ".py"
  return file_name
end

local function write_to_tmp(lines, file_name)
  local filehandle = assert(io.open(file_name, "w"))
  for _, line in ipairs(lines) do
    filehandle:write(line .. "\n")
  end
  filehandle:close()
end

local function read_file_after_format(file_name)
  local filehandle = assert(io.open(file_name, "r"))
  local contents = filehandle:read("*all")
  filehandle:close()
  print(contents)
  return contents
end


lines = get_selected_text()
file_name = get_tmp_file_name()
file = write_to_tmp(lines, file_name)
run_black(file_name)
formatted_code = read_file_after_format(file_name)
local pos = get_postion(lines)
startpos = pos[1][2]
endpos = pos[2][2]
local lines = table.concat(lines, "\n"):gsub("\n", "\\n"):gsub('"', "\\'")
local formatted_code = formatted_code:gsub("\n", "\\n"):gsub('"', "\\'")
local str =  "'<,'>s/" .. lines .. "/" .. formatted_code .. "/g"
--local str = startpos .. "," .. endpos .. "s/" .. table.concat(lines, "\n") .. "/" .. formatted_code
--local str = str:gsub("\n", "\\n")
print(str)
vim.cmd(str)
print(formatted_code)
local escaped = formatted_code:gsub("\\%x00", "\r\r")
local str =  "'<,'>s/\\%x00/\r/g"
print(str)
vim.cmd(str)
os.remove(file_name)

--[[
print("hello")
x = 3
x += 7
print(x)
for i in range(5):
    print(i + 4)

]]--
