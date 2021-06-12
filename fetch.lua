-- script to fetch all scrripts from my github repo
-- written by matm616
-- To use authentication, place a file within /githubToken/ named the github user account and containing a personal access token


-- gets JSON API written by ElvishJerricco
if not (fs.exists("/json.lua")) then
  shell.run("pastebin get 4nRg9CHU json.lua")
end
os.loadAPI("json.lua")

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
  headers = {}
  headers["Authorization: Basic"] = user .. ":" .. token
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
    if not (value.path == "readme.md") then
      print("Getting " .. value.path .. "...")
      local repoFile = http.get(value.url).readAll()
      f = fs.open("/matm/" .. value.path, "w")
      f.write(repoFile)
      f.close()
    end
  end
  print()
  print("Done!")
end