# AR_Trading_Panel_For_MT5

[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

![image](https://github.com/user-attachments/assets/ddbf2628-3c95-4135-ab3a-299de95b6bc1)


A trading panel for MT5 trading platform, written in MQL5.
WORK IN PROGRESS.

The author is not responsible for the program's correctness. Please test before using and use at your own risk.

## Features:
- Automatic position size calculator;
- Indication of total volume at risk;
- Alerts on:
  - Line crossing;
  - Price closed over the moving average;
  - Price closed over Tenkansen or Kijunsen lines;
  - Bill Williams Wise Man 1, 2, 3 alerts;
- Filters for alerts:
  - Volume at risk > than predefined limit (allows not to risk more than what's predefined by money management strategy);
  - Symmetrical pair filter - cancels an alert if the signal comes for a pair symmetrical to the one for which there is an open position already;
  - Alligator filter;
  - Kijunsen and Senkou Span A filter;
- Automatic break even;
- Break-even if the price reaches a predefined break-even line;
- Ability to split the position into two to take profit from one position earlier and break even the remaining position;
- Indication of free margin and margin needed to open the position;

## Description of Buttons:
- **M/P** = changes between market and pending orders;
- **S** = sets future position to Sell;
- **B** = sets future position to Buy;
- **ST** = sets the future position to Stop order;
- **LM** = sets the future position to Limit order;
- **三** = Shows and hides lines which can be used for placing the SL, TP, and price;
- **CLC** = calculates the lot size based on SL and Risk %;
- **✓✓** = same as Send Order but it places two orders instead of 1, 50% lot size each and 1 to 1 RRR for one order and no TP for the second order;
- **✔** = sends market or pending stop/limit sell or buy orders;
- **PM** = turns on and off the Automatic Position Management function, the parameters of which can be changed in the Input window;
- **BE** = moves the SL of all positions to break even wherever possible;
- **SCN** = the "Ichimoku Scanner", scans the list of pairs in the "Market Watch" list and checks if they are trending on at least two timeframes at the same time according to Ichimoku Kinko Hyo;
- **SELL** / **BUY** = used for immediate market order placements according to Lots, SLp, and RRR;
- **✖** = closes all active open positions on current chart;
- **❒** = draws session boxes limited by the beginning and end of the sessions on the x-axis and max/min prices on the y-axis;
- **CLR** = deletes all inputs in Edit fields;
- **🖉** = button goes through all active positions and draws a red rectangle to show the SL and a green rectangle to show the TP;
- **W1**, **W2**, **W3** = switches on and off alerts for Wise Man 1, 2, 3 signals (Bill Williams Profitunity strategy);
- **⼆** = shows two lines, which can be moved and used for setting alerts when the price closes above/below one of the lines;
- **⏰** = sets an alarm that goes off if the price closes above or below one of the lines that were added using ⼆ button;
- **MBE** = If the price closes above one of the lines that were added using ⼆ button, all positions on the chart are set to break even;
- **OC** = Open Chart button: opens all charts from the "Market Watch" list.
