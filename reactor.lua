-- Simple internal buffer based reactor control program
-- Attach a 3x3 advanced monitor and reactor via computer port
-- By matm616

-- Setup
print("Reactor Control Program")
print("Outputing to monitor")
monitor = peripheral.wrap("monitor_0")
reactor = peripheral.wrap("BigReactors-Reactor_1")
monitor.setTextScale(1.5)
sizeX, sizeY = monitor.getSize()
mainWindow={}
mainWindow["window"] = window.create(monitor, 2, 3, sizeX-2, sizeY-3)
mainWindow["sizeX"], mainWindow["sizeY"] = mainWindow["window"].getSize()



-- Variables
reactorActive = false
energyProduced = 0
energyStored = 0
percentStored = 0
minStored = 20
maxStored = 80
controlRodLevel = 0

-- Helper functions
function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

-- Reactor Vars loop
function updateReactorVars()
	energyProduced = reactor.getEnergyProducedLastTick()
	controlRodLevel = reactor.getControlRodLevel(1)  -- using first control rod as basis for all control rods
	energyStored = reactor.getEnergyStored()
	percentStored = round((energyStored/10000000)*100,1)
	reactorActive = reactor.getActive()
end

-- Reactor loop
function updateReactor()
	if percentStored > maxStored then
		reactor.setActive(false)
	elseif percentStored < minStored then
		reactor.setActive(true)
	end	
end

-- Monitor loop
function updateMonitor()
	term.redirect(monitor)
	monitor.setBackgroundColor(colors.white)
	monitor.setTextColor(colors.black)
	monitor.clear()
	monitor.setCursorPos(3,1)
	print("    Lab Zeta\n  Extreme Reactor")
	term.redirect(mainWindow["window"])
	mainWindow["window"].setBackgroundColor(colors.black)
	mainWindow["window"].setTextColor(colors.lightGray)
	mainWindow["window"].clear()
	
	
	-- Energy stored section
	mainWindow["window"].setCursorPos(3,2)
	print("Energy Stored")
	
	-- Deciding bar colour
	barColour = colors.green
	if percentStored < 30 then
		barColour = colors.red
	elseif percentStored < 60 then
		barColour = colors.orange
	elseif percentStored == 100 then
		barColour = colors.cyan
	end
	
	-- Deciding bar length
	barLength = (percentStored/10) + 1
	if barLength > 10 then
		barLength = 10
	end
	
	-- Bar 1
	mainWindow["window"].setCursorPos(3,3)
	mainWindow["window"].setBackgroundColor(barColour)
	for i=1,barLength do
		write(" ")
	end
	mainWindow["window"].setBackgroundColor(colors.black)
	write(percentStored)
	-- Bar 2
	mainWindow["window"].setCursorPos(3,4)
	mainWindow["window"].setBackgroundColor(barColour)
	for i=1,barLength do
		write(" ")
	end
	mainWindow["window"].setBackgroundColor(colors.black)
	write("%")
	
	
	
	-- Control Rod section
	mainWindow["window"].setCursorPos(2,7)
	print("Control Rod Lvl")
	
	-- Deciding bar colour
	barColour = colors.cyan
	if controlRodLevel < 20 then
		barColour = colors.red
	elseif controlRodLevel < 85 then
		barColour = colors.green
	end
	
	-- Deciding bar length
	barLength = (controlRodLevel/10) + 1
	if barLength > 10 then
		barLength = 10
	end
	
	-- Bar 1
	mainWindow["window"].setCursorPos(3,8)
	mainWindow["window"].setBackgroundColor(barColour)
	for i=1,barLength do
		write(" ")
	end
	mainWindow["window"].setBackgroundColor(colors.black)
	write(controlRodLevel)
	-- Bar 2
	mainWindow["window"].setCursorPos(3,9)
	mainWindow["window"].setBackgroundColor(barColour)
	for i=1,barLength do
		write(" ")
	end
	mainWindow["window"].setBackgroundColor(colors.black)
	write("%")
	
	
	
	
	-- Extra Section
	term.redirect(monitor)
	monitor.setCursorPos(1,sizeY)
	if reactorActive == true then
		monitor.setTextColor(colors.green)
		write("Online")
	elseif reactorActive == false then
		monitor.setTextColor(colors.red)
		write("Offline")
	end
	monitor.setTextColor(colors.orange)
	energy=round(energyProduced/1000,1).."KiRF"
	monitor.setCursorPos(sizeX-string.len(energy)+1,sizeY)
	write(energy)
	
end

-- Main loop
while true do
	updateReactorVars()
	updateMonitor()
	updateReactor()
	sleep(0.5)
end