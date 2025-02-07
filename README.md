# Timer Module

## Overview
The Timer module provides a simple and efficient way to manage countdown timers in the game. It allows you to create timers that can count down from a specified duration, trigger events when the time changes, and notify when the timer has ended.

## Features
- Create a new timer with a specified countdown duration.
- Start the timer and track the elapsed time.
- Receive updates on the remaining time through events.
- Cleanly destroy the timer and release resources.

## Usage
To use the Timer module, follow these steps:

1. **Create a Timer Instance:**
   ```lua
   local Timer = require(path.to.Timer)
   local myTimer = Timer.new(60) -- Create a timer for 60 seconds
   ```

2. **Start the Timer:**
   ```lua
   myTimer:Start() -- Start the countdown
   ```

3. **Connect to Time Changed Event:**
   ```lua
   myTimer.TimeChanged:Connect(function(remainingTime)
       print("Time remaining: " .. remainingTime)
   end)
   ```

4. **Connect to Timer Ended Event:**
   ```lua
   myTimer.TimerEnded:Connect(function()
       print("Timer has ended!")
   end)
   ```

5. **Destroy the Timer:**
   ```lua
   myTimer:Destroy() -- Clean up when done
   ```

## Example
Here is a complete example of using the Timer module:
