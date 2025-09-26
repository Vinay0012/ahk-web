; AutoHotkey v2 script for ODIN Options Order Entry (interactive, auto-select scrip, no submit)
#SingleInstance Force

accounts := [
	{ id: "{{ID1}}", qty: "375" },
	{ id: "{{ID2}}", qty: "375" },
	{ id: "{{ID3}}", qty: "225" },
	{ id: "{{ID4}}", qty: "150" },
	{ id: "{{ID5}}", qty: "150" },
	{ id: "{{ID6}}", qty: "150" },
	{ id: "{{ID7}}", qty: "75" },
	{ id: "{{ID8}}", qty: "75" },
	{ id: "{{ID9}}", qty: "75" },
	{ id: "{{ID10}}", qty: "75" }
]

MsgBox("Your free trial has ended. Thank you for using the product.")
return

; --- Hotkey to trigger ---
^!n:: {  ; Ctrl+Alt+N for NIFTY

	number 	  := InputBox("Enter the Number of trades:", "Trade Setup").Value
	if (number < "1" && number > "2")
	{
		MsgBox("Invalid number of trades.")
	}

    if (number = "1")
	{
		; --- Ask user for trade details ---
		; symbol    := InputBox("Enter Symbol (NIFTY or BANKNIFTY):", "Trade Setup").Value
		expiry    := InputBox("Enter Expiry (e.g. 0 for current, etc):", "Trade Setup").Value
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

		; --- Loop through accounts ---
		for account in accounts {
			if WinExist(account.id) {
				WinActivate(account.id)
				Sleep (100)

				Send("{Home}")
				Sleep(100)
				Send("N")
				Sleep (100)
		
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (300)
		
				if(expiry > 0)
				{
					Loop expiry
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
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
		
				Send(account.qty)  
				Sleep (100)
				Send("{Tab}")
				Sleep (100)

				Send(price)
				Sleep (300)
		
				; Send("{Enter}")
				; Sleep(300)
				; Send("Y")
				; Sleep(200)
				; Send("Y")
				; Sleep(300)
			}
		}
	}
	
	else if (number = "2")
	{
		; symbol    := InputBox("Enter Symbol (NIFTY or BANKNIFTY):", "Trade Setup").Value
		expiry    := InputBox("Enter Expiry (eg. 0 for current, etc):", "Trade Setup").Value
		strike    := InputBox("Enter Strike Price (eg. 25200):", "Trade Setup").Value
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
		
		; --- Details for the 2nd trade ---
		expiry2	   := InputBox("Enter Expiry (eg. 0 for current, etc):", "Trade Setup").Value
		strike2    := InputBox("Enter Strike Price (eg. 25000):", "Trade Setup").Value
		optType2   := InputBox("Enter Option Type (C or P):", "Trade Setup").Value
		if (optType2 != "C" && optType2 != "CE" && optType2 != "P" && optType2 != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price2     := InputBox("Enter Price:", "Trade Setup").Value
		orderType2 := InputBox("Enter Order Type (B or S):", "Trade Setup").Value
		if (orderType2 != "B" && orderType2 != "S" && orderType2 != "BUY" && orderType2 != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}

		; --- Loop through accounts ---
		for account in accounts {
			if WinExist(account.id) {
				WinActivate(account.id)
				Sleep (100)

				; --- Step 1: Ensure correct scrip is selected ---
				Send("{Home}")
				Sleep(100)
				Send("N")          ; Searches for Nifty
				Sleep (100)
			
				; --- Step 2: Open F5
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (300)
			
				if(expiry > 0)
				{
					Loop expiry
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
						Send("+{Tab}")
						Sleep (100)
					}
					Send("{Tab}")
				}
				else
				{
					Send("{Tab}")
				}
			

				; --- Step 3: Select Strike ---
			
				Send(strike)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 4: Select Option Type ---
			
				Send(optType)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 5: Select Form ---
			
				if (orderType = "B" or orderType = "BUY")
					Send("{F1}")
				else if (orderType = "S" or orderType = "SELL")
					Send("{F2}")
				else
					return
				Sleep (500)

				; --- Step 6: Fill quantity and price ---
            
				Send(account.qty)  
				Sleep (100) ; account-specific quantity
				Send("{Tab}")
				Sleep (100)

				Send(price)
				Sleep (300)
			
				Send("{Enter}")
				Sleep(300)
				Send("Y")
				Sleep(200)
				Send("Y")
				Sleep(300)
				
				; Sleep(2000)
				
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				
				; --- Step 1: Ensure correct scrip is selected ---
				Send("{Home}")
				Sleep(100)
				Send("N")          ; Searches for Nifty
				Sleep (100)
			
				; --- Step 2: Open F5
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				if(expiry2 > 0)
				{
					Loop expiry2
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
						Send("+{Tab}")
						Sleep (100)
					}
					Send("{Tab}")
				}
				else
				{
					Send("{Tab}")
				}
			

				; --- Step 3: Select Strike ---
			
				Send(strike2)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 4: Select Option Type ---
			
				Send(optType2)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 5: Select Form ---
			
				if (orderType2 = "B" or orderType2 = "BUY")
					Send("{F1}")
				else if (orderType2 = "S" or orderType2 = "SELL")
					Send("{F2}")
				else
					return
				Sleep (500)

				; --- Step 6: Fill quantity and price ---
            
				Send(account.qty)  
				Sleep (100) ; account-specific quantity
				Send("{Tab}")
				Sleep (100)

				Send(price2)
				Sleep (300)
			
				Send("{Enter}")
				Sleep(300)
				Send("Y")
				Sleep(200)
				Send("Y")
				Sleep(300)
			}
		}
	}
	
	for account in accounts
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
			Sleep (300)
			Send("!{F6}")
		}
	}
}

^!b:: {  ; Ctrl+Alt+B

	; Enter number of trades
	number 	  := InputBox("Enter the Number of trades:", "Trade Setup").Value
	if (number < "1" && number > "2")
	{
		MsgBox("Invalid number of trades.")
	}

    if (number = "1")
	{
		; --- Ask user for trade details ---
		; symbol    := InputBox("Enter Symbol (NIFTY or BANKNIFTY):", "Trade Setup").Value
		expiry    := InputBox("Enter Expiry (eg. 0 for current, etc):", "Trade Setup").Value
		strike    := InputBox("Enter Strike Price (eg. 25500):", "Trade Setup").Value
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

		; --- Loop through accounts ---
		for account in accounts {
			if WinExist(account.id) {
				WinActivate(account.id)
				Sleep (100)

				; --- Step 1: Ensure correct scrip is selected ---
				Send("{Home}")
				Sleep(100)
				Send("B")          ; Searches for BankNifty
				Sleep (100)
			
				; --- Step 2: Open F5
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (300)
			
				if(expiry > 0)
				{
					Loop expiry
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
						Send("+{Tab}")
						Sleep (100)
					}
					Send("{Tab}")
				}
				else
				{
					Send("{Tab}")
				}
			

				; --- Step 3: Select Strike ---
			
				Send(strike)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 4: Select Option Type ---
			
				Send(optType)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 5: Select Form ---
			
				if (orderType = "B" or orderType = "BUY")
					Send("{F1}")
				else if (orderType = "S" or orderType = "SELL")
					Send("{F2}")
				else
					return
				Sleep (500)

				; --- Step 6: Fill quantity and price ---
            
				Send("35")  
				Sleep (100) ; account-specific quantity
				Send("{Tab}")
				Sleep (100)

				Send(price)
				Sleep (300)
			
				; Send("{Enter}")
				; Sleep(300)
				; Send("Y")
				; Sleep(200)
				; Send("Y")
				; Sleep(300)
			}
		}
	}
	
	else if (number = "2")
	{
		; --- Ask user for trade details ---
		; symbol    := InputBox("Enter Symbol (NIFTY or BANKNIFTY):", "Trade Setup").Value
		expiry    := InputBox("Enter 1st Trade Expiry (eg. 0 for current, etc):", "Trade Setup").Value
		strike    := InputBox("Enter 1st Trade Strike Price (eg. 25500):", "Trade Setup").Value
		optType   := InputBox("Enter 1st Trade Option Type (C or P):", "Trade Setup").Value
		if (optType != "C" && optType != "CE" && optType != "P" && optType != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price     := InputBox("Enter Price:", "Trade Setup").Value
		orderType := InputBox("Enter 1st Trade Order Type (B or S):", "Trade Setup").Value
		if (orderType != "B" && orderType != "S" && orderType != "BUY" && orderType != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}
		
		; --- Details for the 2nd trade ---
		expiry2	   := InputBox("Enter 2nd Trade Expiry (eg. 0 for current, etc):", "Trade Setup").Value
		strike2    := InputBox("Enter 2nd Trade Strike Price (eg. 25000):", "Trade Setup").Value
		optType2   := InputBox("Enter 2nd Trade Option Type (C or P):", "Trade Setup").Value
		if (optType2 != "C" && optType2 != "CE" && optType2 != "P" && optType2 != "PE")
		{
			MsgBox("Invalid Option Type.")
			Sleep(1000)
			return
		}
		price2     := InputBox("Enter Price:", "Trade Setup").Value
		orderType2 := InputBox("Enter 2nd Order Type (B or S):", "Trade Setup").Value
		if (orderType2 != "B" && orderType2 != "S" && orderType2 != "BUY" && orderType2 != "SELL")
		{
			MsgBox("Invalid Order Type.")
			Sleep(1000)
			return
		}

		; --- Loop through accounts ---
		for account in accounts {
			if WinExist(account.id) {
				WinActivate(account.id)
				Sleep (100)

				; --- Step 1: Ensure correct scrip is selected ---
				Send("{Home}")
				Sleep(100)
				Send("B")          ; Searches for BankNifty
				Sleep (100)
			
				; --- Step 2: Open F5
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				if(expiry > 0)
				{
					Loop expiry
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
						Send("+{Tab}")
						Sleep (100)
					}
					Send("{Tab}")
				}
				else
				{
					Send("{Tab}")
				}
			

				; --- Step 3: Select Strike ---
			
				Send(strike)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 4: Select Option Type ---
			
				Send(optType)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 5: Select Form ---
			
				if (orderType = "B" or orderType = "BUY")
					Send("{F1}")
				else if (orderType = "S" or orderType = "SELL")
					Send("{F2}")
				else
					return
				Sleep (500)

				; --- Step 6: Fill quantity and price ---
            
				Send("35")  
				Sleep (100) ; account-specific quantity
				Send("{Tab}")
				Sleep (100)

				Send(price)
				Sleep (300)
			
				Send("{Enter}")
				Sleep(300)
				Send("Y")
				Sleep(200)
				Send("Y")
				Sleep(300)
				
				; Sleep(2000)
				
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				Send("{Esc}")
				Sleep(100)
				
				; --- Step 1: Ensure correct scrip is selected ---
				Send("{Home}")
				Sleep(100)
				Send("B")          ; Searches for BankNifty
				Sleep (100)
			
				; --- Step 2: Open F5
				Send("{F5}")
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				if(expiry2 > 0)
				{
					Loop expiry2
					{
						Sleep (100)
						Send("{Down}")
						Sleep (100)
						Send("+{Tab}")
						Sleep (100)
					}
					Send("{Tab}")
				}
				else
				{
					Send("{Tab}")
				}
			

				; --- Step 3: Select Strike ---
			
				Send(strike2)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 4: Select Option Type ---
			
				Send(optType2)
				Sleep (100)
				Send("{Tab}")
				Sleep (100)
			
				; --- Step 5: Select Form ---
			
				if (orderType2 = "B")
					Send("{F1}")
				else if (orderType2 = "S")
					Send("{F2}")
				else
					return
				Sleep (500)

				; --- Step 6: Fill quantity and price ---
            
				Send("35")  
				Sleep (100) ; account-specific quantity
				Send("{Tab}")
				Sleep (100)

				Send(price2)
				Sleep (300)
			
				Send("{Enter}")
				Sleep(300)
				Send("Y")
				Sleep(200)
				Send("Y")
				Sleep(300)
			}
		}
	}
	
	for account in accounts
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
			Sleep (300)
			Send("!{F6}")
		}
	} 
}

^!i:: {
	for account in accounts
	{
		if WinExist(account.id)
		{
			Sleep (100)
			WinActivate(account.id)
			Sleep (200)
			Send("!{F6}")
		}
	}
}

^!c:: {
	for account in accounts
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