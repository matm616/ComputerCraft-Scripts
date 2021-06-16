-- Script to fetch all scripts from my github repo
-- Written by matm616
-- To use authentication, place a file within /githubToken/ named the github user account and containing a personal access token

-- gets JSON API written by ElvishJerricco
if not (fs.exists("/matm/json.lua")) then
  print("Getting JSON library")
  shell.run("pastebin get 4nRg9CHU /matm/json.lua")
  -- adds functionality to the json api so you can use
  -- require() instead of the deprecated os.loadAPI()
  local jsonFile = fs.open("/matm/json.lua", "a")
  jsonFile.write("\nreturn {decode = decode}")
  jsonFile.close()
end
json = require("/matm/json")

-- reading the first file within /githubTokens
auth = false
if (fs.exists("/githubToken")) then
  FileList = fs.list("/githubToken")
  for _, file in ipairs(FileList) do
    user = file
    tokenFile = fs.open("/githubToken/" .. user, "r")
    token = tokenFile.readAll()
    tokenFile.close()
    auth = true
    break
  end
end


githubLink = "https://api.github.com/repos/matm616/ComputerCraft-Scripts/contents"
if (auth == false) then
  print("Accessing GitHub API without authentication. Beware of the rate limit! (60 requests per hour)")
  githubHandle = http.get(githubLink)
else
  headers = {user .. ":" .. token}
  print("Using " .. user .. " for API")
  githubHandle = http.get(githubLink, headers)
end
print()
if not githubHandle then
  print("Uh oh! I can't access the GitHub API!")
else
  local content = githubHandle.readAll()
  githubHandle.close()
  
  obj = json.decode(content)
  for key,value in pairs( obj ) do
    if not (value.path == "readme.md" or value.path == ".gitignore") then
      print("Getting " .. value.path .. "...")
      local repoFile = http.get(value.download_url).readAll()
      f = fs.open("/matm/" .. value.path, "w")
      f.write(repoFile)
      f.close()
    end
  end
end
print()
print("Copying fetch.lua to root")
fs.delete("/fetch.lua")
fs.copy("/matm/fetch.lua", "/fetch.lua")
print("Fetch done!")