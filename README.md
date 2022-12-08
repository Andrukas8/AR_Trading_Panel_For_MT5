# AR_Trading_Panel_For_MT5

[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

![image](https://user-images.githubusercontent.com/21954163/206441625-ce8843eb-438c-4872-9c17-6c415b38fd98.png)

A trading panel for MT5 trading platform, written in MQL5.
WORK IN PROGRESS.

Author is not reponsible for the correctnes of the program. Please test before using and use at your own risk.

Features:
- Automatic position size calculator;
- Indication of total volume at rist;
- Alerts on:
  - Line crossing;
  - Price closed over the moving average;
  - Price closed over Tenkansen or Kijunsen lines;
  - Bill Williams Wise Man 1, 2, 3 allerts;
- Filters for alerts:
  - Volume at risk > than predefined limit (allows not to risk more than what's predefined by money management strategy);
  - Symetrical pair filter - cancels an alert if the signal comes for a pair symetrical to the one for which there is an open position already;
  - Alligator filter;
  - Kijunsen and Senkou Span A filter;
- Automatic breack even;
- Break even if price reached a predefined break even line;
- Ability to split the position into two in order to take profit of one position earlier and break even the remaining position;
- Indication of free margin and margin needed in order to open the position;

Description of Buttons:
- Market/Pending = changes between market and pending orders;
- Show Lines/Hide Lines = Shows and hides lines which can be used for placing the SL, TP and price;
- S / B = toggles between Sell and Buy orders;
- STP / LMT = toggles between Stop and Limit orders;
- SELL / BUY = used for imidiate market order placements according to Lots, SLp and RRR;
- Close = closes all active open positions on current chart;
- Send Order = sends market or pending stop/limit sell or buy orders;
- Send D Order = same as Send Order but it places two orders instead of 1, 50% lot size each and 1 to 1 RRR for one order and no TP for the second order;
- BE = moves the SL of all positions to break even wherever possible;
- Clear = delets all inputs in Edit fields;
- Calc = calculates the lot size based on SL and Risk %;
- APM = turns on and off the Automatic Position Management function, parameters of which can be changed in Input window;
- Draw = button goes through all active positions and draws a red rectangle to show the SL and green rectangle to show the TP;
- W1, W2, W3 = switches on and off alerts for Wise Man 1, 2, 3 signals (Bill Williams Profitunity strategy).

