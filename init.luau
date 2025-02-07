local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Timer = {}
Timer.__index = Timer

export type Timer = {
	new: (number) -> Timer,
	Destroy: (Timer) -> (),
	Start: (Timer) -> (),
	StartTime: number,
	TimeChanged: RBXScriptSignal,
	TimerEnded: RBXScriptSignal,
}

function Timer.new(countTime: number)
	local self = setmetatable({}, Timer)

	self._timerEnded = Instance.new("BindableEvent")
	self._timeChanged = Instance.new("BindableEvent")
	self.TimerEnded = self._timerEnded.Event
	self.TimeChanged = self._timeChanged.Event
	self.COUNT_TIME = countTime
	self.CountDown = true
	self.elapsed = 0
	return self
end

function Timer:Start()
	self.StartTime = os.time()
	self.timerThread = coroutine.wrap(function()
		local elapsed = 0
		self:_changed(self.elapsed)
		while self.COUNT_TIME >= self.elapsed do
			local t = task.wait()
			elapsed += t
			self.elapsed += t
			if elapsed >= 1 then
				elapsed = 0
				self:_changed(self.elapsed)
			end
		end
		self._timerEnded:Fire()
	end)()
end

function Timer:GetCurrent()
	if self.CountDown == true then
		return self.COUNT_TIME - self.elapsed
	elseif self.CountDown == false then
		return self.elapsed
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
	self._timerEnded:Destroy()
	self._timeChanged:Destroy()
	if self.timerThread ~= nil then
		coroutine.close(self.timerThread)
	end
end

return Timer
