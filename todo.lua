-- ToDo program
-- by zeta

-- vars
data = {{},{}}
windowMaxX, windowMaxY = term.getSize()

-- setting up
term.clear()
term.redirect(term.native())

topWindow = window.create(term.current(),1,1,windowMaxX,1)
doWindow = window.create(term.current(),1,2,windowMaxX/2,windowMaxY-1)
doneWindow = window.create(term.current(),(windowMaxX/2)+1,2,windowMaxX,windowMaxY-1)
bottomWindow = window.create(term.current(),1,windowMaxY,windowMaxX,windowMaxY)

topWindow.setBackgroundColor(colors.lightGray)
doWindow.setBackgroundColor(colors.cyan)
doneWindow.setBackgroundColor(colors.green)
bottomWindow.setBackgroundColor(colors.gray)

topWindow.setTextColor(colors.black)
doWindow.setTextColor(colors.white)
doneWindow.setTextColor(colors.white)
bottomWindow.setTextColor(colors.white)

-- helper functions
function loadTodo()  -- load todo from file
    local file = fs.open("/data/todo","r")  -- open file in read only
    data = textutils.unserialise(file.readAll())  -- unserialise it to table
    file.close()  -- close file
end

function saveTodo()  -- save table to todo
    local file = fs.open("/data/todo","w")  -- open file and remove old contents
    file.write(textutils.serialise(data))  -- write serialised table to file
    file.close()  -- save file
end

function drawScreen(terminalText)
	term.native().clear()
	topWindow.clear()
	doWindow.clear()
	doneWindow.clear()
	bottomWindow.clear()
	
	term.redirect(topWindow)
	topWindow.setTextColor(colors.black)
	topWindow.setCursorPos(1,1)
	topWindow.write("To Do List")
	topWindow.setCursorPos(windowMaxX,1)
	topWindow.setTextColor(colors.red)
	topWindow.write("X")

	term.redirect(doWindow)
	doWindow.setCursorPos(1,1)
	if data[1] == nil or #data[1] == 0 then
		print("Nothing to do")
	else
		print("To Do:")
		for i=1,#data[1] do
			print("* " .. data[1][i])
		end
	end
	term.redirect(doneWindow)
	doneWindow.clear()
	doneWindow.setCursorPos(1,1)
	if data[2] == nil or #data[2] == 0 then
		print("Nothing completed")
	else
		print("Done:")
		for i=1,#data[2] do
			print("- " .. data[2][i])
		end
	end

	term.redirect(bottomWindow)
	bottomWindow.setCursorPos(1,1)
	bottomWindow.write(">>> " .. terminalText)
end

-- logic
if (fs.exists("/data") ~= true) then  -- if /data doesnt exist
    fs.makeDir("/data")  -- make dir
end
if (fs.exists("/data/todo") ~= true) then  -- if /data/todo doesnt exist
    data = {{},{}}  -- create empty data table
    saveTodo()  -- save empty data table
end
loadTodo()

drawScreen("")

while true do
	event, button, x, y = os.pullEvent( "mouse_click" )
	--bottomWindow.write("event: " .. event .. "Button: " .. button .. "X: " .. x .. "Y: " .. y)
	entry = y-2
	input = ""
	if (y == windowMaxY) then -- left window
		term.redirect(bottomWindow)
		input = read()
		table.insert(data[1], input)
		saveTodo()
	elseif (x == 1 and y >= 3 and y <= #data[1]+3 and button == 2) then
		table.insert(data[2], table.remove(data[1], entry))
		saveTodo()
	elseif (x == math.floor((windowMaxX/2)+1) and y >= 3 and y <= #data[2]+3 and button == 2) then
		table.remove(data[2], entry)
		saveTodo()
	elseif (x == windowMaxX and y == 1 and button == 1) then
		term.native().clear()
		os.reboot()
	end
	drawScreen("")
end
