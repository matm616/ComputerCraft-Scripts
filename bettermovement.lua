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
    if (fs.exists("/BetterMovement")) then
        -- if location file exists
        if (fs.exists("/BetterMovement/location")) then
            location = {} -- empty location var
            varFile = fs.open("/BetterMovement/location", "r") -- open file
            location = textutils.unserialise(varFile.readAll()) -- unserialise data into var
            varFile.close() -- close file
        end
        -- if waypoint file exists
        if (fs.exists("/BetterMovement/waypoints")) then
            waypoints = {} -- empty waypoints var
            varFile = fs.open("/BetterMovement/waypoints", "r") -- open file
            waypoints = textutils.unserialise(varFile.readAll()) -- unserialise data into var
            varFile.close() -- close file
        end
    end
end