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

function saveToFile()
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