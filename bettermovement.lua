-- BetterMovement
-- A better (and incomplete) turtle movement API
-- by matm616


-- Variables
location = {
    ["currentX"] = 0,
    ["currentY"] = 0,
    ["currentZ"] = 0,
    ["currentHeading"] = 0,
}

waypoints = {}

-- Functions
function forward()
end

function up()
end

function down()
end

function right()
end

function left()
end

function u()
end

function moveTo(x, y, z)
end

function checkpoint()
end

function lastCheckpoint()
end

function setHeading(direction)
end

-- untested save to file
-- saves the current location and any waypoints into files
function saveToFile()
    -- if /BetterMovement dir does not exists
    if not (fs.exists("/BetterMovement")) then
        fs.makeDir("/BetterMovement")
    end

    -- if location file already exist, delete file
    if (fs.exists("/BetterMovement/location")) then
        fs.delete("/BetterMovement/location")
    end
    -- serialise data into location file
    local locationFile = fs.open("/BetterMovement/location", "w") -- open file
    textutils.serialise(location) -- serialise var into file
    locationFile.close() -- close (save) file

    -- if waypoints file already exist, delete file
    if (fs.exists("/BetterMovement/waypoints")) then
        fs.delete("/BetterMovement/waypoints")
    end
    -- serialise data into waypoints file
    local waypointsFile = fs.open("/BetterMovement/waypoints", "w") -- open file
    textutils.serialise(waypoints) -- serialise var into file
    waypointsFile.close() -- close (save) file
end

-- untested load from file
-- loads what should be the current location and any left over previous waypoints
function loadFromFile()
    -- if /BetterMovement dir exists
    if (fs.exists("/BetterMovement") and fs.isDir("/BetterMovement")) then
        -- if location file exists
        if (fs.exists("/BetterMovement/location")) then
            location = {} -- empty location var
            local locationFile = fs.open("/BetterMovement/location", "r") -- open file read only
            location = textutils.unserialise(locationFile.readAll()) -- unserialise data into var
            locationFile.close() -- close file
        end
        -- if waypoint file exists
        if (fs.exists("/BetterMovement/waypoints")) then
            waypoints = {} -- empty waypoints var
            local waypointsFile = fs.open("/BetterMovement/waypoints", "r") -- open file read only
            waypoints = textutils.unserialise(waypointsFile.readAll()) -- unserialise data into var
            waypointsFile.close() -- close file
        end
    end
end

return {
    location = location,
    waypoints = waypoints,
    forward = forward,
    up = up,
    down = down,
    right = right,
    left = left,
    u = u,
    moveTo = moveTo,
    checkpoint = checkpoint,
    lastCheckpoint = lastCheckpoint,
    setHeading = setHeading
}