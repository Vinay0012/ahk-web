; AutoHotkey v2 script for ODIN Options Order Entry (interactive, auto-select scrip, no submit)
#SingleInstance Force

; MsgBox("Please contact support.")
; return

^!n:: {  

	groups := [
	[
		{ id: "ahk_id {{ID1}}", qty: "525" },
		{ id: "ahk_id {{ID2}}", qty: "1575" },
		{ id: "ahk_id {{ID3}}", qty: "525" },
		{ id: "ahk_id {{ID4}}", qty: "525" },
	],
	[
		{ id: "ahk_id {{ID5}}", qty: "1575" },
		{ id: "ahk_id {{ID6}}", qty: "525" },
		{ id: "ahk_id {{ID7}}", qty: "150" },
	],
	[
		{ id: "ahk_id {{ID8}}", qty: "525" },
		{ id: "ahk_id {{ID9}}", qty: "1050" },
		{ id: "ahk_id {{ID10}}", qty: "2700" },
	],
	[
		{ id: "ahk_id {{ID11}}", qty: "390" },
		{ id: "ahk_id {{ID12}}", qty: "390" },
		{ id: "ahk_id {{ID13}}", qty: "260" },
		{ id: "ahk_id {{ID14}}", qty: "195" },
		{ id: "ahk_id {{ID15}}", qty: "195" },
		{ id: "ahk_id {{ID16}}", qty: "195" },
		{ id: "ahk_id {{ID17}}", qty: "130" },
		{ id: "ahk_id {{ID18}}", qty: "130" },
		{ id: "ahk_id {{ID19}}", qty: "130" },
		{ id: "ahk_id {{ID20}}", qty: "130" }
	]
	]

	input 	:= InputBox("Enter the group numbers to trade (e.g. 1 3 for groups 1 and 3):", "Trade Selection")
	if(input.Result = "Cancel" or input.Value = "")
		ExitApp

	selectedGroups	:= StrSplit(input.Value, A_Space)

	number 	  := InputBox("Enter the Number of trades:", "Trade Setup").Value
	if (number < "1" && number > "2")
	{
		MsgBox("Invalid number of trades.")
	}

    if (number = "1")
	{
		expiry    := InputBox("Enter Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter Strike Price (e.g. 25200):", "Trade Setup").Value
		optType   := InputBox("Enter Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter Price:", "Trade Setup").Value
		orderType := InputBox("Enter Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter the Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through groups and accounts ---
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
			
			; MsgBox("Executing trades for group" gNum)
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 75) != 0)
					{
						finalQty := Ceil(finalQty / 75) * 75
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("N")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
		
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
		
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
		
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	}
	
	else if (number = "2")
	{
		expiry    := InputBox("Enter 1st Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter 1st Trade Strike Price (e.g. 25200):", "Trade Setup").Value
		optType   := InputBox("Enter 1st Trade Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter 1st Trade Price:", "Trade Setup").Value
		orderType := InputBox("Enter 1st Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter 1st Trade Quantity Multiplier:", "Trade Setup").Value
		
		; --- Details for the 2nd trade ---
		expiry2	   := InputBox("Enter 2nd Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike2    := InputBox("Enter 2nd Trade Strike Price (eg. 25000):", "Trade Setup").Value
		optType2   := InputBox("Enter 2nd Trade Option Type (C or P):", "Trade Setup").Value
		if (optType2 != "C" && optType2 != "CE" && optType2 != "P" && optType2 != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price2     := InputBox("Enter 2nd Trade Price:", "Trade Setup").Value
		orderType2 := InputBox("Enter 2nd Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType2 != "B" && orderType2 != "S" && orderType2 != "BUY" && orderType2 != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier2 := InputBox("Enter 2nd Trade Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through accounts ---
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
		
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 75) != 0)
					{
						finalQty := Ceil(finalQty / 75) * 75
					}
					finalQty2 := account.qty * multiplier2
					finalQty2 := Round(finalQty2)
					if(Mod(finalQty2, 75) != 0)
					{
						finalQty2 := Ceil(finalQty2 / 75) * 75
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("N")          
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
            
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				
					Sleep(100)
				
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
				
					Send("{Home}")
					Sleep(100)
					Send("N")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry2 > 0)
					{
						Loop expiry2
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					if (orderType2 = "B" or orderType2 = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType2 = "S" or orderType2 = "SELL")
					{
						Send("{F2}")
					}
					else	
					{
						return
					}
					Sleep (500)
            
					Send(finalQty2)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price2)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	}
	
	for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
	
			for account in groups[gNum] {
		
			{
			if WinExist(account.id)
			{
				WinActivate(account.id)
				Sleep (100)
				Send("{Esc}")
				Sleep (100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep (100)
				Send("!{F6}")
				Sleep (300)
				}
			}
		}
	}
}

^!b:: {  
	groups := [
	[
		{ id: "ahk_id {{ID1}}", qty: "175" },
		{ id: "ahk_id {{ID2}}", qty: "525" },
		{ id: "ahk_id {{ID3}}", qty: "175" },
		{ id: "ahk_id {{ID4}}", qty: "175" },
	],
	[
		{ id: "ahk_id {{ID5}}", qty: "525" },
		{ id: "ahk_id {{ID6}}", qty: "175" },
		{ id: "ahk_id {{ID7}}", qty: "35" },
	],
	[
		{ id: "ahk_id {{ID8}}", qty: "175" },
		{ id: "ahk_id {{ID9}}", qty: "350" },
		{ id: "ahk_id {{ID10}}", qty: "875" },
	],
	[
		{ id: "ahk_id {{ID11}}", qty: "30" },
		{ id: "ahk_id {{ID12}}", qty: "30" },
		{ id: "ahk_id {{ID13}}", qty: "30" },
		{ id: "ahk_id {{ID14}}", qty: "30" },
		{ id: "ahk_id {{ID15}}", qty: "30" },
		{ id: "ahk_id {{ID16}}", qty: "30" },
		{ id: "ahk_id {{ID17}}", qty: "30" },
		{ id: "ahk_id {{ID18}}", qty: "30" },
		{ id: "ahk_id {{ID19}}", qty: "30" },
		{ id: "ahk_id {{ID20}}", qty: "30" }
	]
	]

	input 	:= InputBox("Enter the group numbers to trade (e.g. 1 3 for groups 1 and 3):", "Trade Selection")
	if(input.Result = "Cancel" or input.Value = "")
		ExitApp

	selectedGroups	:= StrSplit(input.Value, A_Space)

	number 	  := InputBox("Enter the Number of trades:", "Trade Setup").Value
	if (number < "1" && number > "2")
	{
		MsgBox("Invalid number of trades.")
	}

    if (number = "1")
	{
		expiry    := InputBox("Enter Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter Strike Price (e.g. 54000):", "Trade Setup").Value
		optType   := InputBox("Enter Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter Price:", "Trade Setup").Value
		orderType := InputBox("Enter Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter the Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through accounts ---
		
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
			
			; MsgBox("Executing trades for group" gNum)
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 35) != 0)
					{
						finalQty := Ceil(finalQty / 35) * 35
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("B")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
		
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
		
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
		
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	}
	
	else if (number = "2")
	{
		expiry    := InputBox("Enter 1st Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter 1st Trade Strike Price (e.g. 54000):", "Trade Setup").Value
		optType   := InputBox("Enter 1st Trade Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter 1st Trade Price:", "Trade Setup").Value
		orderType := InputBox("Enter 1st Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter 1st Trade Quantity Multiplier:", "Trade Setup").Value
		
		; --- Details for the 2nd trade ---
		expiry2	   := InputBox("Enter 2nd Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike2    := InputBox("Enter 2nd Trade Strike Price (eg. 54000):", "Trade Setup").Value
		optType2   := InputBox("Enter 2nd Trade Option Type (C or P):", "Trade Setup").Value
		if (optType2 != "C" && optType2 != "CE" && optType2 != "P" && optType2 != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price2     := InputBox("Enter 2nd Trade Price:", "Trade Setup").Value
		orderType2 := InputBox("Enter 2nd Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType2 != "B" && orderType2 != "S" && orderType2 != "BUY" && orderType2 != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier2 := InputBox("Enter 2nd Trade Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through accounts ---
		
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
		
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 35) != 0)
					{
						finalQty := Ceil(finalQty / 35) * 35
					}
					finalQty2 := account.qty * multiplier2
					finalQty2 := Round(finalQty2)
					if(Mod(finalQty2, 35) != 0)
					{
						finalQty2 := Ceil(finalQty2 / 35) * 35
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("B")          
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
            
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				
					Sleep(100)
				
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
				
					Send("{Home}")
					Sleep(100)
					Send("B")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry2 > 0)
					{
						Loop expiry2
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					if (orderType2 = "B" or orderType2 = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType2 = "S" or orderType2 = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
            
					Send(finalQty2)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price2)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	} 
	
	for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
	
		for account in groups[gNum]
		{
			if WinExist(account.id)
			{
				WinActivate(account.id)
				Sleep (100)
				Send("{Esc}")
				Sleep (100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep (100)
				Send("!{F6}")
				Sleep (300)
			}
		}
	}
}

^!m:: {  

	groups := [
	[
		{ id: "ahk_id {{ID1}}", qty: "140" },
		{ id: "ahk_id {{ID2}}", qty: "420" },
		{ id: "ahk_id {{ID3}}", qty: "140" },
		{ id: "ahk_id {{ID4}}", qty: "140" },
	],
	[
		{ id: "ahk_id {{ID5}}", qty: "420" },
		{ id: "ahk_id {{ID6}}", qty: "140" },
		{ id: "ahk_id {{ID7}}", qty: "140" },
	],
	[
		{ id: "ahk_id {{ID8}}", qty: "140" },
		{ id: "ahk_id {{ID9}}", qty: "280" },
		{ id: "ahk_id {{ID10}}", qty: "420" },
	],
	[
		{ id: "ahk_id {{ID11}}", qty: "0" },
		{ id: "ahk_id {{ID12}}", qty: "0" },
		{ id: "ahk_id {{ID13}}", qty: "0" },
		{ id: "ahk_id {{ID14}}", qty: "0" },
		{ id: "ahk_id {{ID15}}", qty: "0" },
		{ id: "ahk_id {{ID16}}", qty: "0" },
		{ id: "ahk_id {{ID17}}", qty: "0" },
		{ id: "ahk_id {{ID18}}", qty: "0" },
		{ id: "ahk_id {{ID19}}", qty: "0" },
		{ id: "ahk_id {{ID20}}", qty: "0" }
	]
	]

	input 	:= InputBox("Enter the group numbers to trade (e.g. 1 3 for groups 1 and 3):", "Trade Selection")
	if(input.Result = "Cancel" or input.Value = "")
		ExitApp

	selectedGroups	:= StrSplit(input.Value, A_Space)

	number 	  := InputBox("Enter the Number of trades:", "Trade Setup").Value
	if (number < "1" && number > "2")
	{
		MsgBox("Invalid number of trades.")
	}

    if (number = "1")
	{
		expiry    := InputBox("Enter Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter Strike Price (e.g. 12000):", "Trade Setup").Value
		optType   := InputBox("Enter Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter Price:", "Trade Setup").Value
		orderType := InputBox("Enter Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter the Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through accounts ---
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
			
			; MsgBox("Executing trades for group" gNum)
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 140) != 0)
					{
						finalQty := Ceil(finalQty / 140) * 140
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("M")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
		
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
		
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
		
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
		
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	}
	
	else if (number = "2")
	{
		expiry    := InputBox("Enter 1st Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike    := InputBox("Enter 1st Trade Strike Price (e.g. 12000):", "Trade Setup").Value
		optType   := InputBox("Enter 1st Trade Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter 1st Trade Price:", "Trade Setup").Value
		orderType := InputBox("Enter 1st Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier := InputBox("Enter 1st Trade Quantity Multiplier:", "Trade Setup").Value
		
		; --- Details for the 2nd trade ---
		expiry2	   := InputBox("Enter 2nd Trade Expiry (e.g. 0 for current, 1 for next etc.):", "Trade Setup").Value
		strike2    := InputBox("Enter 2nd Trade Strike Price (eg. 12000):", "Trade Setup").Value
		optType2   := InputBox("Enter 2nd Trade Option Type (C or P):", "Trade Setup").Value
		if (optType2 != "C" && optType2 != "CE" && optType2 != "P" && optType2 != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price2     := InputBox("Enter 2nd Trade Price:", "Trade Setup").Value
		orderType2 := InputBox("Enter 2nd Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType2 != "B" && orderType2 != "S" && orderType2 != "BUY" && orderType2 != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		multiplier2 := InputBox("Enter 2nd Trade Quantity Multiplier:", "Trade Setup").Value

		; --- Loop through accounts ---
		
		for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
		
			for account in groups[gNum] {
				if WinExist(account.id) {
					finalQty := account.qty * multiplier
					finalQty := Round(finalQty)
					if(Mod(finalQty, 140) != 0)
					{
						finalQty := Ceil(finalQty / 140) * 140
					}
					finalQty2 := account.qty * multiplier2
					finalQty2 := Round(finalQty2)
					if(Mod(finalQty2, 140) != 0)
					{
						finalQty2 := Ceil(finalQty2 / 140) * 140
					}
					WinActivate(account.id)
					Sleep (100)

					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)

					Send("{Home}")
					Sleep(100)
					Send("M")          
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry > 0)
					{
						Loop expiry
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
				
					if (orderType = "B" or orderType = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType = "S" or orderType = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
            
					Send(finalQty)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				
					Sleep(100)
				
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
					Send("{Esc}")
					Sleep(100)
				
					Send("{Home}")
					Sleep(100)
					Send("M")
					Sleep (100)
			
					Send("{F5}")
					Sleep (300)
					Send("{Tab}")
					Sleep (100)
			
					if(expiry2 > 0)
					{
						Loop expiry2
						{
							Sleep (100)
							Send("{Down}")
							Sleep (200)
							Send("+{Tab}")
							Sleep (100)
						}
						Send("{Tab}")
					}
					else
					{
						Send("{Tab}")
					}
			
					Send(strike2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					Send(optType2)
					Sleep (100)
					Send("{Tab}")
					Sleep (100)
			
					if (orderType2 = "B" or orderType2 = "BUY")
					{
						Send("{F1}")
					}
					else if (orderType2 = "S" or orderType2 = "SELL")
					{
						Send("{F2}")
					}
					else
					{
						return
					}
					Sleep (500)
            
					Send(finalQty2)  
					Sleep (100)
					Send("{Tab}")
					Sleep (100)

					Send(price2)
					Sleep (100)
			
					Send("{Enter}")
					Sleep(300)
					Send("Y")
					Sleep(200)
					Send("Y")
					Sleep(300)
				}
			}
		}
	}
	
	for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}
	
		for account in groups[gNum]
		{
			if WinExist(account.id)
			{
				WinActivate(account.id)
				Sleep (100)
				Send("{Esc}")
				Sleep (100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep (100)
				Send("!{F6}")
				Sleep (300)
			}
		}
	}
}

^!i:: {
	groups := [
	[
		{ id: "ahk_id {{ID1}}", qty: "525" },
		{ id: "ahk_id {{ID2}}", qty: "1575" },
		{ id: "ahk_id {{ID3}}", qty: "525" },
		{ id: "ahk_id {{ID4}}", qty: "525" },
	],
	[
		{ id: "ahk_id {{ID5}}", qty: "1575" },
		{ id: "ahk_id {{ID6}}", qty: "525" },
		{ id: "ahk_id {{ID7}}", qty: "150" },
	],
	[
		{ id: "ahk_id {{ID8}}", qty: "525" },
		{ id: "ahk_id {{ID9}}", qty: "1050" },
		{ id: "ahk_id {{ID10}}", qty: "2700" },
	],
	[
		{ id: "ahk_id {{ID11}}", qty: "390" },
		{ id: "ahk_id {{ID12}}", qty: "390" },
		{ id: "ahk_id {{ID13}}", qty: "260" },
		{ id: "ahk_id {{ID14}}", qty: "195" },
		{ id: "ahk_id {{ID15}}", qty: "195" },
		{ id: "ahk_id {{ID16}}", qty: "195" },
		{ id: "ahk_id {{ID17}}", qty: "130" },
		{ id: "ahk_id {{ID18}}", qty: "130" },
		{ id: "ahk_id {{ID19}}", qty: "130" },
		{ id: "ahk_id {{ID20}}", qty: "130" }
	]
	]

	input 	:= InputBox("Enter the group numbers to trade (e.g. 1 3 for groups 1 and 3):", "Trade Selection")
	if(input.Result = "Cancel" or input.Value = "")
		ExitApp

	selectedGroups	:= StrSplit(input.Value, A_Space)

	for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}

		for account in groups[gNum]
		{
			if WinExist(account.id)
			{
				WinActivate(account.id)
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("!{F6}")
				Sleep(300)
			}
		}
	}
}

^!c:: {

	groups := [
	[
		{ id: "ahk_id {{ID1}}", qty: "525" },
		{ id: "ahk_id {{ID2}}", qty: "1575" },
		{ id: "ahk_id {{ID3}}", qty: "525" },
		{ id: "ahk_id {{ID4}}", qty: "525" },
	],
	[
		{ id: "ahk_id {{ID5}}", qty: "1575" },
		{ id: "ahk_id {{ID6}}", qty: "525" },
		{ id: "ahk_id {{ID7}}", qty: "150" },
	],
	[
		{ id: "ahk_id {{ID8}}", qty: "525" },
		{ id: "ahk_id {{ID9}}", qty: "1050" },
		{ id: "ahk_id {{ID10}}", qty: "2700" },
	],
	[
		{ id: "ahk_id {{ID11}}", qty: "390" },
		{ id: "ahk_id {{ID12}}", qty: "390" },
		{ id: "ahk_id {{ID13}}", qty: "260" },
		{ id: "ahk_id {{ID14}}", qty: "195" },
		{ id: "ahk_id {{ID15}}", qty: "195" },
		{ id: "ahk_id {{ID16}}", qty: "195" },
		{ id: "ahk_id {{ID17}}", qty: "130" },
		{ id: "ahk_id {{ID18}}", qty: "130" },
		{ id: "ahk_id {{ID19}}", qty: "130" },
		{ id: "ahk_id {{ID20}}", qty: "130" }
	]
	]

	input 	:= InputBox("Enter the group numbers to trade (e.g. 1 3 for groups 1 and 3):", "Trade Selection")
	if(input.Result = "Cancel" or input.Value = "")
		ExitApp

	selectedGroups	:= StrSplit(input.Value, A_Space)

	for _, g in selectedGroups {
			gNum := Integer(g)
			if(gNum < 1 or gNum > groups.length) {
				MsgBox("Invalid Group number: " gNum)
				continue
			}

		for account in groups[gNum]
		{
			if WinExist(account.id)
			{
				WinActivate(account.id)
				Sleep (100)
				Send("{Esc}")
				Sleep (100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("{Home}")
			}
		}
	}
}
