-- script to fetch all scrripts from my github repo
-- written by matm616

if not (fs.exists("/json.lua")) then
  shell.run("pastebin get 4nRg9CHU json.lua")
end

os.loadAPI("json.lua")

github_link = "https://api.github.com/repos/matm616/ComputerCraft-Scripts/contents"

local github_handle = http.get(github_link)
if not github_handle then
  print("Oops! I can't access the github api.")
else
  local content = github_handle.readAll()
  github_handle.close()
  
  obj = json.decode(content)
  for key,value in pairs( obj ) do
    if not (value.path == "readme.md") then
      local repo_file = http.get(value.url).readAll()
      f = fs.open("/matm/" .. value.path, "w")
      f.write(repo_file)
      f.close()
      print()
    end
  end
end