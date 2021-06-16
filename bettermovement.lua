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
    turtle.forward()
    -- Lua doesn't have switch statements. We have this.
    -- It should be faster than lots of if statements. Probably.
    local switch = {
        [0] = function()
            location["currentX"] = location["currentX"] + 1
        end,
        [1] = function()
            location["currentZ"] = location["currentZ"] + 1
        end,
        [2] = function()
            location["currentX"] = location["currentX"] - 1
        end,
        [3] = function()
            location["currentZ"] = location["currentZ"] - 1
        end
    }
    switch(location["currentHeading"])
end

function back()
    turtle.back()
    local switch = {
        [0] = function()
            location["currentX"] = location["currentX"] - 1
        end,
        [1] = function()
            location["currentZ"] = location["currentZ"] - 1
        end,
        [2] = function()
            location["currentX"] = location["currentX"] + 1
        end,
        [3] = function()
            location["currentZ"] = location["currentZ"] + 1
        end
    }
    switch(location["currentHeading"])
end

function up()
    turtle.up()
    location["currentY"] = location["currentY"] + 1
end

function down()
    turtle.down()
    location["currentY"] = location["currentY"] - 1
end

function right()
    turtle.turnRight()
    location["currentHeading"] = location["currentHeading"] + 1
    location["currentHeading"] = location["currentHeading"] % 4
end

function left()
    turtle.turnLeft()
    location["currentHeading"] = location["currentHeading"] - 1
    if location["currentHeading"] == -1 then
        location["currentHeading"] = 3
    end
    location["currentHeading"] = location["currentHeading"] % 4
end

function u()
    left()
    left()
end

function moveTo(x, y, z, direction)
    if (location["currentX"] > x) then
        turn(3)
        while (location["currentX"] ~= x) do
            forward()
        end
    elseif (location["currentX"] < x) then
        turn(1)
        while (location["currentX"] ~= x) do
            forward()
        end
    end

    while (location["currentY"] ~= y) do
        sleep(0.4)
        if (location["currentY"] > y) then
            down()
        elseif (location["currentY"] < y) then
            up()
        end
    end

    if (location["currentZ"] > z) then
        turn(2)
        while (location["currentZ"] ~= z) do
            forward()
        end
    elseif (location["currentZ"] < z) then
        turn(0)
        while (location["currentZ"] ~= z) do
            forward()
        end
    end

    -- set direction to current direction unless specified
    direction = direction or location["currentHeading"];
    turn(direction)
end

function setCheckpoint()
    table.insert(waypoints, location)
end

function lastCheckpoint()
    return table.remove(waypoints)
end

function turn(direction)
    if ((location["currentHeading"] + 1) % 4 == direction) then
        right()
    elseif ((location["currentHeading"] - 1) % 4 == direction) then
        left()
    elseif (location["currentHeading"] == direction ) then
    else
        u()
    end
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

function update()
    
end

-- return statement for use with require()
return {
    location = location,
    waypoints = waypoints,
    forward = forward,
    back = back,
    up = up,
    down = down,
    right = right,
    left = left,
    u = u,
    moveTo = moveTo,
    setCheckpoint = setCheckpoint,
    lastCheckpoint = lastCheckpoint,
    turn = turn
}