local Maid = {}
Maid.ClassName = "Maid"

function Maid.new(MINERVA)
	local proxy = setmetatable({
		_tasks = {}
	}, Maid)
	table.insert(MINERVA.maids,proxy)
	return proxy
end

function Maid.isMaid(value)
	return type(value) == "table" and value.ClassName == "Maid"
end

function Maid:__index(index)
	if Maid[index] then
		return Maid[index]
	else
		return self._tasks[index]
	end
end

function Maid:__newindex(index, newTask)
	if Maid[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end
	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return
	end
	tasks[index] = newTask

	if oldTask then
		if type(oldTask) == "function" then
			oldTask()
		elseif typeof(oldTask) == "RBXScriptConnection" then
			oldTask:Disconnect()
		elseif typeof(oldTask) == 'thread' and coroutine.status(oldTask) ~= 'dead' then
			coroutine.close(oldTask)
		elseif oldTask.Destroy then
			oldTask:Destroy()
		end
	end
end

local function threadDebug(task,ok,...)
	if not ok then
		print(debug.traceback(
			task,
			"ERROR: "..tostring((...))
			))
	end
end
function Maid:GiveTask(task)
	if not task then
		error("Task cannot be false or nil", 2)
	end

	local taskId = #self._tasks+1
	self[taskId] = task

	if type(task) == "table" and (not task.Destroy) then
		warn("[Maid.GiveTask] - Gave table task without .Destroy")
	end

	if typeof(task) == 'thread' then
		threadDebug(task,coroutine.resume(task))
	end

	return taskId
end

function Maid:DoCleaning()
	local tasks = self._tasks

	for index, task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			tasks[index] = nil
			task:Disconnect()
		elseif typeof(task) == 'thread' and coroutine.status(task) ~= 'dead' then
			tasks[index] = nil
			coroutine.close(task)
		end
	end

	local index, task = next(tasks)
	while task ~= nil do
		tasks[index] = nil
		if type(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif typeof(task) == 'thread' and coroutine.status(task) ~= 'dead' then
			coroutine.close(task)
		elseif task.Destroy then
			task:Destroy()
		end
		index, task = next(tasks)
	end
end

Maid.Destroy = Maid.DoCleaning

return Maid.new
