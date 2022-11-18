# AR_Trading_Panel_For_MT5

[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

![image](https://user-images.githubusercontent.com/21954163/202746018-72f1f1a8-0c3f-4610-a5e1-48550ebd756d.png)

A trading panel for MT5 trading platform, written in MQL5. All buttons and control of the panel are in one window.

WORK IN PROGRESS.

Author is not reponsible for the correctnes of the program. Please test before using and use at your own risk.

Description of Buttons:
- Market/Pending = changes between market and pending orders;
- Show Lines/Hide Lines = Shows and hides lines which can be used for placing the SL, TP and price;
- S / B = toggles between Sell and Buy orders;
- STP / LMT = toggles between Stop and Limit orders;
- SELL / BUY = used for imidiate market order placements according to Lots, SLp and RRR;
- Close All = closes all active open positions on current chart;
- Send Order = sends market or pending stop/limit sell or buy orders;
- Send D Order = same as Send Order but it places two orders instead of 1, 50% lot size each and 1 to 1 RRR for one order and no TP for the second order;
- Break Even All = moves the SL of all positions to break even wherever possible;
- Clear Inputs = delets all inputs in Edit fields;
- Calc Position = calculates the lot size based on SL and Risk %;
- APM = turns on and off the Automatic Position Management function, parameters of which can be changed in Input window;
- Draw = button goes through all active positions and draws a red rectangle to show the SL and green rectangle to show the TP.

