-- script to fetch all scrripts from my github repo
-- written by matm616


-- gets JSON API written by ElvishJerricco
if not (fs.exists("/json.lua")) then
  shell.run("pastebin get 4nRg9CHU json.lua")
end

os.loadAPI("json.lua")
githubLink = "https://api.github.com/repos/matm616/ComputerCraft-Scripts/contents"

local githubHandle = http.get(githubLink)
if not githubHandle then
  print("Oops! I can't access the github api.")
else
  local content = githubHandle.readAll()
  githubHandle.close()
  
  obj = json.decode(content)
  for key,value in pairs( obj ) do
    if not (value.path == "readme.md") then
      print("Getting " .. value.path .. "...")
      local repoFile = http.get(value.url).readAll()
      f = fs.open("/matm/" .. value.path, "w")
      f.write(repoFile)
      f.close()
      print()
    end
  end
  print("Done!")
end