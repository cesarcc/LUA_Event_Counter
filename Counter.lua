--[[
	---------------------------------------------------------
	
	Event counter takes any switch available in transmitter
	and count how many times it have been used. 
	
	Great for counting for example how many times retracts 
	have been used and to keep track of service-intervalls.
	
	Three counters are possible to configure, Counter 1 can
	be used as telemetry window on main screen.
	
	Label can be configured for all counters and counter
	display is updated on app-screen per usage.
	
	Count can be adjusted manually from application itself
	if needed.
	
	Max value is 32767, after that counter resets to 0.
	
	---------------------------------------------------------
	
	Event Counter is also included in RC-Thoughts Tools.
	
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]

local appName = "Event Counter"
local cnt1, cnt2, cnt3, cntLb1, cntLb2, cntLb3, cntSw1, cntSw2, cntSw3
local stateCnt1, stateCnt2, stateCnt3 = 0,0,0
----------------------------------------------------------------------
local function printCounter1()
	lcd.drawText(145 - lcd.getTextWidth(FONT_BIG,string.format("%.0f", cnt1)),0,string.format("%.0f", cnt1),FONT_BIG)
end
----------------------------------------------------------------------
local function cntLbChanged1(value)
	cntLb1=value
	system.pSave("cntLb1",value)
	system.registerTelemetry(1,cntLb1,1,printCounter1)
end

local function cntLbChanged2(value)
	cntLb2=value
	system.pSave("cntLb2",value)
end

local function cntLbChanged3(value)
	cntLb3=value
	system.pSave("cntLb3",value)
end

local function cntChanged1(value)
	cnt1=value
	system.pSave("cnt1",value)
end

local function cntChanged2(value)
	cnt2=value
	system.pSave("cnt2",value)
end

local function cntChanged3(value)
	cnt3=value
	system.pSave("cnt3",value)
end

local function cntSwChanged1(value)
	cntSw1 = value
	system.pSave("cntSw1",value)
end

local function cntSwChanged2(value)
	cntSw2 = value
	system.pSave("cntSw2",value)
end

local function cntSwChanged3(value)
	cntSw3 = value
	system.pSave("cntSw3",value)
end
----------------------------------------------------------------------
local function initForm()
	form.addRow(1)
	form.addLabel({label="Counter 1",font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label="Telemetry window label",width=175})
	form.addTextbox(cntLb1,14,cntLbChanged1)
	
	form.addRow(2)
	form.addLabel({label="Activating switch"})
	form.addInputbox(cntSw1,true,cntSwChanged1)
	
	form.addRow(2)
	form.addLabel({label="Current count"})
	form.addIntbox(string.format("%f", cnt1),0,32767,0,0,1,cntChanged1)
	
	form.addRow(1)
	form.addLabel({label="Counter 2",font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label="Counter name",width=175})
	form.addTextbox(cntLb2,14,cntLbChanged2)
	
	form.addRow(2)
	form.addLabel({label="Activating switch"})
	form.addInputbox(cntSw2,true,cntSwChanged2)
	
	form.addRow(2)
	form.addLabel({label="Current count"})
	form.addIntbox(string.format("%f", cnt2),0,32767,0,0,1,cntChanged2)
	
	form.addRow(1)
	form.addLabel({label="Counter 3",font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label="Counter name",width=175})
	form.addTextbox(cntLb3,14,cntLbChanged3)
	
	form.addRow(2)
	form.addLabel({label="Activating switch"})
	form.addInputbox(cntSw3,true,cntSwChanged3)
	
	form.addRow(2)
	form.addLabel({label="Current count"})
	form.addIntbox(string.format("%f", cnt3),0,32767,0,0,1,cntChanged3)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com",font=FONT_MINI, alignRight=true})
end
----------------------------------------------------------------------
local function loop()
	local cntSw1, cntSw2, cntSw3 = system.getInputsVal(cntSw1, cntSw2, cntSw3)
	
	if (cntSw1 == 1 and stateCnt1 == 0) then
		stateCnt1 = 1
		cnt1 = cnt1 + 1
		if (cnt1 == 32768) then
			cnt1 = 0
		end
		system.pSave("cnt1",cnt1)
		form.reinit()
		else if (cntSw1 ~= 1 and stateCnt1 == 1) then
			stateCnt1 = 0
		end
	end	
	
	if (cntSw2 == 1 and stateCnt2 == 0) then
		stateCnt2 = 1
		cnt2 = cnt2 + 1
		if (cnt2 == 32768) then
			cnt2 = 0
		end
		system.pSave("cnt2",cnt2)
		form.reinit()
		else if (cntSw2 ~= 1 and stateCnt2 == 1) then
			stateCnt2 = 0
		end
	end
	
	if (cntSw3 == 1 and stateCnt3 == 0) then
		stateCnt3 = 1
		cnt3 = cnt3 + 1
		if (cnt3 == 32768) then
			cnt3 = 0
		end
		system.pSave("cnt3",cnt3)
		form.reinit()
		else if (cntSw3 ~= 1 and stateCnt3 == 1) then
			stateCnt3 = 0
		end
	end
end
----------------------------------------------------------------------
local function init()
	system.registerForm(1,MENU_APPS,appName,initForm)	
	cntLb1 = system.pLoad("cntLb1", "Counter 1")
	cntLb2 = system.pLoad("cntLb2", "Counter 2")
	cntLb3 = system.pLoad("cntLb3", "Counter 3")
	cnt1 = system.pLoad("cnt1", 0)
	cnt2 = system.pLoad("cnt2", 0)
	cnt3 = system.pLoad("cnt3", 0)
	cntSw1 = system.pLoad("cntSw1")
	cntSw2 = system.pLoad("cntSw2")
	cntSw3 = system.pLoad("cntSw3")
	system.registerTelemetry(1,cntLb1,1,printCounter1)
end
----------------------------------------------------------------------
return { init=init, loop=loop, author="RC-Thoughts", version="1.0", name=appName}