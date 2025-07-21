local Timer = {}
Timer.__index = Timer

export type Timer = {
	new: (countTime: number, isCountDown: boolean) -> Timer,
	Destroy: (Timer) -> (),
	Start: (Timer) -> (),
	StartTime: number,
	TimeChanged: RBXScriptSignal,
	TimerEnded: RBXScriptSignal,
}

function Timer.new(countTime: number, isCountDown: boolean?)
	local self = setmetatable({}, Timer)

	self._timerEnded = Instance.new("BindableEvent")
	self._timeChanged = Instance.new("BindableEvent")
	self.TimerEnded = self._timerEnded.Event
	self.TimeChanged = self._timeChanged.Event
	self.COUNT_TIME = countTime
	self.CountDown = if isCountDown ~= nil then isCountDown else true
	self.elapsed = 0
	return self
end

function Timer:Start(startTime: number?)
	if self._isRunning then
		warn("timer already running")
		return
	end
	self._isRunning = true
	self.StartTime = startTime or os.time()
	self.timerThread = task.spawn(function()
		while self.COUNT_TIME >= self.elapsed do
			self:_changed(self.elapsed)
			self.elapsed += 1
			task.wait(1)
		end
		self._timerEnded:Fire()
		self.timerThread = nil
	end)
end

function Timer:Stop()
	if self.timerThread then
		task.cancel(self.timerThread)
	end
end

function Timer:_changed(currentTime: number)
	if self.CountDown == true then
		self._timeChanged:Fire(self.COUNT_TIME - currentTime)
	elseif self.CountDown == false then
		self._timeChanged:Fire(currentTime)
	end
end

function Timer:Destroy()
	if self.timerThread ~= nil then
		task.cancel(self.timerThread)
	end
	self._timerEnded:Destroy()
	self._timeChanged:Destroy()
	table.clear(self)
end

return Timer
