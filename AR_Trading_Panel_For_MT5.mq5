//+--------------------------------------------------------------------------------+
//|  AR TPanel - a universal Expert Adviser for MT5 / AR_Trading_Panel_For_MT5.mq5 |
//+--------------------------------------------------------------------------------+

#property description "AR TPanel"

#property copyright "Andrukas8"
#property link      "https://github.com/Andrukas8/AR_Trading_Panel_For_MT5"
#property version   "2.01"

#include <Trade/Trade.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\ComboBox.mqh>

#include <Controls\CheckBox.mqh>

enum ENUM_STRATEGY
  {
   NOSTRATEGY,
   KTS,
   MACD,
   ICHIMOKU,
   ICHI_TENKANBR,
   ICHI_KINJUNBR,
   ICHI_KUMOBR,
   BILL_WILLIAMS,
   THREELINESTRIKE,
   RSIMA,
   PRICEACTION,
   ORDERBLOCK,
   PINBAR
  };

string StrategySelected = "";

string StrategyStr[13] =
  {
   "NOSTRATEGY",
   "KTS",
   "MACD",
   "ICHIMOKU",
   "ICHI_TENKANBR",
   "ICHI_KINJUNBR",
   "ICHI_KUMOBR",
   "BILL_WILLIAMS",
   "THREELINESTRIKE",
   "RSIMA",
   "PRICEACTION",
   "ORDERBLOCK",
   "PINBAR"
  };

input group "------------- POSITIONS MANAGEMENT SETTINGS -------------"
input int TslOffsetPoints = 0; // TSL BUFFER POINTS FOR MA/TKS/KJS
input ENUM_TIMEFRAMES TimeFrame = 2; // EA TIMEFRAME
input bool showTotalRiskCurrent = true; // Show Total Risk in Caption
input double maxVARFiltervalue = 2; // Max VaR filter value in % (use 100% to turn off)
input bool autoBreakEven = false; // AUTO BREAKEVEN
input double breakevenRatio = 1; //  _____ BE RATIO
input bool alertBreakEven = false; // _____ ALERT ON BE
input bool showEAComment = false; // SHOW EA COMMENT
input bool debuggingComments = false; // SHOW DEBUGGING COMMENTS
input bool showProfitOnChart = false; // SHOW POSITION PROFIT ON CHART
input bool useSymmetricalPositionFilter = false; // DO NOT SHOW SIGNALS FOR SYMMETRICAL PAIRS
input bool useOpenPositionFilter = false; // DO NOT SHOW SIGNALS FOR INSTRUMENTS WITH OPEN POSITIONS
input ENUM_STRATEGY StrategySelect = NOSTRATEGY;
input string posLotsDef = "0.2"; // LOT SIZE
input string slPipsDef = "10"; // SL pips
input string RiskToRewardDef = "2"; // RRR
input string RiskLevelDef = "0.1"; // RISK % OF DEPOSIT
input double marginToBallancePercent = 90; // MARGIN TO DEPOSIT %

input group "------------- TRAILING STOP LOSS ------------"
input bool fractalsTSL = false; // TSL FRACTALS
input bool prevCandleTSL = false; // TSL PREVIOUS CANDLE
input bool tenkansenTSL = false; // TSL ICHIMOKU TENKANSEN
input bool kijunsenTSL = false; // TSL ICHIMOKU KIJUNSEN
input bool pointsTSL = false; // TSL REGULAR IN POINTS
input int TslPoints = 50; // _____ TSL REGULAR POINTS
input bool movingAverageTSL = false; // TSL MA
input int MaPeriod = 8; // _____ MA TSL PERIOD
input int MaShift = 5;  // _____ MA TSL SHIFT
input ENUM_MA_METHOD TslMaMethod = MODE_SMMA; // _____ MA TSL METHOD
input ENUM_APPLIED_PRICE TslMaAppPrice = PRICE_MEDIAN; // _____ MA TSL PRICE

input group "------------- MACD CROSSOVER ALERT --------------------------"
input bool MACDAlert = false; // ALERT MACD SIGNAL

input group "------------- RSI MA CROSSOVER ALERT --------------------------"
input bool RSIMAAlert = false; // ALERT RSI MA SIGNAL

input group "------------- TENKANSEN BREAK ALERT --------------------------"
input bool SignalTenkansenBreak = false; // ALERT ON TK BREAK
input bool KJSSAFilter = false; // _____ KJ & SSA FILTER
input int KJSSAFilterRange = 2; // __________ KJ & SSA FILTER RANGE
input bool fractalTrendFilter = false; // USE FRACTALS FILTER

input group "------------- MOVING AVERAGE BREAK ALERT --------------------------"
input bool MABreak = false; // ALERT ON MA BREAK
input bool MABreakUseAlligatorFilter = false; // _____ USE ALLIGATOR FILTER ON MA BREAK ALERT
input int alligatorMultiplierMABreak = 1; // __________ ALLIGATOR MULTIPLIER FILTER ON MA BREAK ALERT
input int MABreakPeriod = 5; // __________ BREAK MA PERIOD
input int MABreakShift = 3; // __________ BREAK MA SHIFT
input ENUM_MA_METHOD MABreakMethod = MODE_SMMA; // __________ BREAK MA METHOD
input ENUM_APPLIED_PRICE MABreakPrice = PRICE_MEDIAN; // __________ BREAK MA PRICE

input group "------------- STOCHASTIC OSCILATOR FILTER ---------------------"
input bool soFilter = false; // STOCHASTIC OSCILATOR FILTER
input double soFilterStrength = 1; // __________ DIFFERENCE BETWEEN SIGNAL AND MAIN SHOULD BE
input int soKPeriod = 30; // __________ %K Period
input int soDPeriod = 10; // __________ %D Period
input int soSlowing = 10; // __________ SLOWING

input group "------------- BILL WILLIAMS PROFITUNITY BUTTONS ---------------------"
input bool wiseMenAlertsToggle = false;     // ACTIVATE BW PROFITUNITY 3 WISE MEN ALERT BUTTONS
input bool wiseMan1PermanentToggle = false; // _____ activeate WM1 permanently
input bool wiseMan2PermanentToggle = false; // _____ activeate WM2 permanently
input bool wiseMan3PermanentToggle = false; // _____ activeate WM3 permanently
input int inp_fractalShoulder = 2;          // __________ WM3 Fractal Shoulder
input int fractalBufferWM3 = 20;            // __________ WM3 Fractal Buffer in points
input double atrMultiplier = 1; // _____ ATR multiplier for filtering WM1 signals
input int atrPeriod = 14; // _____ ATR PERIOD
input int alligatorMultiplier = 1; // _____ Alligator multiplier for filtering WM signals

input group "------------- ALERTS ------------"
input bool pinbarAlert = false; // PINBAR
input bool threeLinesStrikeActivate = false; // 3 LINES STRIKE
input double ToleranceOpenPercent = 50; // _____ Engulfing Range Tolerance Open %
input double ToleranceClosePercent = 50; // _____ Engulfing Range Tolerance Close %
input bool EngulfingModeStrict = false; // _____ Strict mode

input bool NewBarAlert = false; // NEW BAR ALERT

input bool AlertAutoClosePosition = false; // ALERT ON POSITIONS CLOSE

input group "------------- FILTERS ------------"
input bool rsiMAFilter = false; // RSI-MA FILTER
input int rsiMA_RSI_Range = 150; // __________ RSI RANGE
input int rsiMA_MA_Range = 35; // __________ MA PERIOD
input int rsiMA_MA_Shift = 0; // __________ MA SHIFT
input ENUM_MA_METHOD rsiMA_MA_Method = MODE_SMA; // __________ MA METHOD

input bool useAlligatorFilter = false; // USE ALLIGATOR FILTER
input bool useAOFilter = false; // USE AO FILTER
input bool useACFilter = false; // USE AC FILTER
input bool useIchimokuFilter = false; // USE ICHIMOKU FILTER

input bool useMAFilter = false; // USE MA FILTER
input int MaFilterPeriod = 200; // __________ MA PERIOD
input int MaFilterShift = 0; // __________ MA SHIFT
input ENUM_MA_METHOD MaFilterMethod = MODE_EMA; // __________ MA METHOD
input ENUM_APPLIED_PRICE MaFilterAppPrice = PRICE_CLOSE; // __________ MA PRICE

input bool use3xMAFilter = false; // USE MAx3 FILTER for WM3
input int Ma1FilterPeriod = 200; // __________ 1 MA PERIOD
input int Ma2FilterPeriod = 50; // __________ 2 MA PERIOD
input int Ma3FilterPeriod = 20; // __________ 3 MA PERIOD

input int Ma1FilterShift = 0; // __________ 1 MA SHIFT
input int Ma2FilterShift = 0; // __________ 2 MA SHIFT
input int Ma3FilterShift = 0; // __________ 3 MA SHIFT

input ENUM_MA_METHOD Ma3xFilterMethod = MODE_EMA; // __________ 3x MAs METHOD
input ENUM_APPLIED_PRICE Ma3xFilterAppPrice = PRICE_CLOSE; // __________ 3x MAs PRICE

input bool useMAFilter3LS = false; // USE MA FILTER FOR 3LS SIGNALS
input int FastMaPeriod3LS = 21; // __________ 3 LS FAST MA PERIOD
input int FastMaShift3LS = 0; // __________ 3 LS FAST MA SHIFT
input ENUM_MA_METHOD FastMaMethod3LS = MODE_SMMA; // __________ 3LS FAST MA METHOD
input ENUM_APPLIED_PRICE FastMaAppPrice3LS = PRICE_CLOSE; // __________ 3LS FAST MA PRICE
input int MiddleMaPeriod3LS = 50; // __________ 3 LS MIDDLE MA PERIOD
input int MiddleMaShift3LS = 0; // __________ 3 LS MIDDLE MA SHIFT
input ENUM_MA_METHOD MiddleMaMethod3LS = MODE_SMMA; // __________ 3LS MIDDLE MA METHOD
input ENUM_APPLIED_PRICE MiddleMaAppPrice3LS = PRICE_CLOSE; // __________ 3LS MIDDLE MA PRICE
input int SlowMaPeriod3LS = 200; // __________ 3 LS SLOW MA PERIOD
input int SlowMaShift3LS = 0; // __________ 3 LS SLOW MA SHIFT
input ENUM_MA_METHOD SlowMaMethod3LS = MODE_SMMA; // __________ 3LS SLOW MA METHOD
input ENUM_APPLIED_PRICE SlowMaAppPrice3LS = PRICE_CLOSE; // __________ 3LS SLOW MA PRICE

input group "------------- CLOSE POSITIONS WHEN PRICE CLOSED OVER TENKANSEN -------------"
input bool ClosePosTenkansen = false; // CLOSE OVER TENKANSEN
input group "------------- CLOSE POSITIONS WHEN PRICE CLOSED OVER MOVING AVERAGE ------------"
input bool ClosePosMa = false; // CLOSE OVER MA
input int ClosePosMaPeriod = 5; // _____ CLOSE MA PERIOD
input int ClosePosMaShift = 3; // _____ CLOSE MA SHIFT
input ENUM_MA_METHOD ClosePosMaMethod = MODE_SMMA; // _____ CLOSE MA METHOD
input ENUM_APPLIED_PRICE ClosePosMaAppPrice = PRICE_MEDIAN; // _____ CLOSE MA PRICE

input group "------------- Box Settings ----------------------------------"
input bool customBox = true;
input string timeCustomBoxFrom = "00:00"; // CUSTOM BOX FROM
input string timeCustomBoxTill = "23:59"; // CUSTOM BOX TILL
input color colorCustomBox = clrDarkGray; // CUSTOM BOX COLOR

input bool SydneySession = true; // SHOW SYDNEY SESSION
input string timeFromSydney = "00:00"; // SYDNEY SESSION START
input string timeTillSydney = "08:00"; // SYDNEY SESSION FINISH
input color colorSydney = clrIndianRed; // SYDNEY SESSION COLOR

input bool TokyoSession = true; // SHOW TOKYO SESSION
input string timeFromTokyo = "02:00"; // TOKYO SESSION START
input string timeTillTokyo = "10:00"; // TOKYO SESSION FINISH
input color colorTokyo = clrDeepSkyBlue; // TOKYO SESSION COLOR

input bool LondonSession = true; // SHOW LONDON SESSION
input string timeFromLondon = "10:00"; // LONDON SESSION START
input string timeTillLondon = "19:00"; // LONDON SESSION FINISH
input color colorLondon = clrLimeGreen; // LONDON SESSION COLOR

input bool NewYorkSession = true; // SHOW NEW YORK SESSION
input string timeFromNewYork = "15:00"; // NEW YORK SESSION START
input string timeTillNewYork = "23:59"; // NEW YORK SESSION FINISH
input color colorNewYork = clrGoldenrod; // NEW YORK SESSION COLOR

int barsTotal;

double mainUpper = 0;
double mainLower = 0;

int maShift;

// Handles
int handleMA;
int handleIchimoku;
int handleClosePosMA;
int handleATR;
int handleAlligator;
int handleAwesomeOscillator;
int handleFast3LSMA;
int handleMiddle3LSMA;
int handleSlow3LSMA;
int handleMABreak;
int handleAlligatorMABreak;
int handleUpperTFIchimoku;
int handleSOFilter;
int handleRSIFilter;
int handleRSIMAFilter;
int handleAlligatorFilter;
int handleMAFilter;

int handleMA1Filter;
int handleMA2Filter;
int handleMA3Filter;

int handleAOFilter;
int handleACFilter;
int handleMACD;

int barCountFractals;
string textComment;
string debugComment;
bool updateProfitOnchart = false; // SHOW POSITION PROFIT ON CHART
double ask;
double bid;
double tpBuy;
double tpSell;
double slSell;
double slBuy;
double posLots; // Lot size
double slPips; // Stoploss in pips
double RiskToReward; // Risk to Reward Ratio
bool lineInput = false; // show lines for graphical input
bool pendingToggle = false; // toggle between market and pending order types
bool sellToggle = false;
bool buyToggle = false;
bool stopToggle = false;
bool limitToggle = false;
bool autoPosMgmtToggle = false;
bool boxOnToggle = false;
bool manualBEToggle = false;
bool wm1AlertToggle = false;
bool wm2AlertToggle = false;
bool wm3AlertToggle = false;
double upperFractalWM3;
double lowerFractalWM3;
double usedFractalWM3Upper;
double usedFractalWM3Lower;

bool fractalBreakBull = false;
bool fractalBreakBear = false;

bool alertCloseLine = false;
double alertLinePrice1;
double alertLinePrice2;
double alertClosePrevBar1;
double alertClosePrevBar2;
bool setAlarmCloseLine = false;

double inputStopLoss;
double inputTakeProfit;
double inputPrice;
double calcSlPips;
double calcTpPips;
double calcRRR;

double linePriceNew;
double lineSlNew;
double lineTpNew;
double AccountFreeMargin;

string StrBuySignal_GO;
string StrBuySignal_1;
string StrBuySignal_2;
string StrBuySignal_3;
string StrBuySignal_4;

string StrSellSignal_GO;
string StrSellSignal_1;
string StrSellSignal_2;
string StrSellSignal_3;
string StrSellSignal_4;

string captionString = "AR TPanel ";

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate // 3
#define CONTROLS_GAP_Y                      (7)       // gap by Y coordinate // 3
//--- for buttons
#define BUTTON_WIDTH                        (100)     // size by X coordinate
#define BUTTON_HEIGHT                       (25)      // size by Y coordinate //20
//--- for the indication area
#define EDIT_HEIGHT                         (20)      // size by Y coordinate // 20
#define EDIT_WIDTH                          (60)      // size by X coordinate
#define EDIT_WIDTH_SMALL                    (40)      // size by X coordinate
//--- for group controls
#define GROUP_WIDTH                         (150)     // size by X coordinate
#define LIST_HEIGHT                         (179)     // size by Y coordinate
#define RADIO_HEIGHT                        (56)      // size by Y coordinate
#define CHECK_HEIGHT                        (93)      // size by Y coordinate

//+------------------------------------------------------------------+
//| Class CControlsDialog                                            |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CControlsDialog : public CAppDialog
  {
private:
   // Labels
   CLabel            m_LotsLbl;                       // Label for Lots
   CLabel            m_SlPipsLbl;                     // Label for Lots
   CLabel            m_RiskToRewardRatioLbl;          // Label for Risk to Reward Ratio
   CLabel            m_RiskLbl;                       // Label for Risk percentage
   CLabel            m_TpPipsLbl;                     // Label for Take Profit price level
   CLabel            m_PriceLbl;                      // Label for Price for pending orders
   CLabel            m_SlLbl;                         // Label for Stop Loss
   CLabel            m_TpLbl;                         // Label for Take Profit
   CLabel            m_MarginRequiredLbl;             // Label for Margin Required
   CLabel            m_MarginRequiredDisplLbl;        // Label for Margin Required Display
   CLabel            m_MarginAvailableLbl;            // Label for Margin Required
   CLabel            m_MarginAvailableDisplLbl;       // Label for Margin Required Display
   CLabel            m_SpreadLbl;                     // Label for Margin Required Display
   CLabel            m_TimeTillCandleCloseLbl;        // Label for Margin Required Display
   CLabel            m_ProfitLbl;                     // Label for Profit Display

   // Edits
   CEdit             m_LotsEdit;                      // Edit field for the lots
   CEdit             m_SlPipsEdit;                    // Edit field for the sl pips
   CEdit             m_RiskToRewardRatioEdit;         // Edit field for Risk to Reward Ratio
   CEdit             m_RiskEdit;                      // Edit field for Risk percentage
   CEdit             m_TpPipsEdit;                    // Edit field for Risk percentage
   CEdit             m_PriceEdit;                     // Edit field for Risk percentage
   CEdit             m_SlEdit;                        // Edit field for Risk percentage
   CEdit             m_TpEdit;                        // Edit field for Risk percentage

   // Buttons
   CButton           m_SellBtn;                       // button to sell
   CButton           m_BuyBtn;                        // button to buy
   CButton           m_CloseAllBtn;                   // button to close all positions
   CButton           m_CalculatePosBtn;               // button to calculate lot size based on % of deposit to risk
   CButton           m_ClearInputsBtn;                // button to clear the input fields
   CButton           m_BreakEvenBtn;                  // button to break even all traded on the current chart
   CButton           m_MarketPendingBtn;              // Button to toggle between market and pending orders
   CButton           m_ShowLinesBtn;                  // Button to show price sl and tp prices for order placing
   CButton           m_SellToggleBtn;
   CButton           m_BuyToggleBtn;
   CButton           m_SendOrderBtn;
   CButton           m_StopToggleBtn;
   CButton           m_LimitToggleBtn;
   CButton           m_AutoPosMgmtToggleBtn;
   CButton           m_DoubleOrderBtn;
   CButton           m_DrawPositionsBtn;
   CButton           m_Box;
   CButton           m_ShowAlertLinesBtn;            // Shows two alert lines to set price close alerts
   CButton           m_AlertCloseBtn;                // Sets a line, closing over which price triggers alarm
   CButton           m_ManualBEBtn;

   CButton           m_wm1AlertBtn;                  // Bill Williams Wise Man 1 (divergent bar) alert toggle button
   CButton           m_wm2AlertBtn;                  // Bill Williams Wise Man 2 (AO 3 bars of same color) alert toggle button
   CButton           m_wm3AlertBtn;                  // Bill Williams Wise Man 3 (Fractal break) alert toggle button

   CButton           m_ScanChartsBtn;                // Scanner button to scan if any of the aisigned instruments meets partibular conditions

   CComboBox         m_StrategySelectorCBox;         // Dropdown list to select the strategy for the trade comment
   CButton           m_OpenChartsBtn;                // Open all charts from the Market Watch List
   CButton           m_CloseChartsBtn;               // Close all charts
   CButton           m_OpenActiveChartsBtn;          // Open all charts which have open positions

public:
                     CControlsDialog(void);
                    ~CControlsDialog(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

protected:
   //--- create dependent controls
   bool              CreateSellBtn(void);
   bool              CreateBuyBtn(void);
   bool              CreateCloseAllBtn(void);
   bool              CreateCalculatePosBtn(void);
   bool              CreateClearInputsBtn(void);
   bool              CreateBreakEvenBtn(void);
   bool              CreateMarketPendingBtn(void);
   bool              CreateShowLinesBtn(void);
   bool              CreateSellToggleBtn(void);
   bool              CreateBuyToggleBtn(void);
   bool              CreateSendOrderBtn(void);
   bool              CreateStopToggleBtn(void);
   bool              CreateLimitToggleBtn(void);
   bool              CreateAutoPosMgmtToggleBtn(void);
   bool              CreateDoubleOrderBtn(void);
   bool              CreateDrawPositionsBtn(void);
   bool              CreateBoxBtn(void);
   bool              CreateShowAlertLinesBtn(void);
   bool              CreateAlertCloseBtn(void);
   bool              CreateManualBEBtn(void);
   bool              CreateWm1AlertBtn(void);
   bool              CreateWm2AlertBtn(void);
   bool              CreateWm3AlertBtn(void);
   bool              CreateScanChartsBtn(void);
   bool              CreateOpenChartsBtn(void);
   bool              CreateCloseChartsBtn(void);
   bool              CreateOpenActiveChartsBtn(void);

   bool              CreateLotsEdit(void);
   bool              CreateSlPipsEdit(void);
   bool              CreateRiskToRewardRatioEdit(void);
   bool              CreateRiskEdit(void);
   bool              CreateTpPipsEdit(void);
   bool              CreatePriceEdit(void);
   bool              CreateSlEdit(void);
   bool              CreateTpEdit(void);

   bool              CreateLotsLbl(void);
   bool              CreateSlPipsLbl(void);
   bool              CreateRiskToRewardRatioLbl(void);
   bool              CreateRiskLbl(void);
   bool              CreateTpPipsLbl(void);
   bool              CreatePriceLbl(void);
   bool              CreateSlLbl(void);
   bool              CreateTpLbl(void);
   bool              CreateMarginRequiredLbl(void);
   bool              CreateMarginRequiredDisplLbl(void);
   bool              CreateMarginAvailableLbl(void);
   bool              CreateMarginAvailableDisplLbl(void);
   bool              CreateSpreadLbl(void);
   bool              CreateTimeTillCandleCloseLbl(void);
   bool              CreateProfitLbl(void);
   bool              CreateStrategySelectorCBox(void);



   // -- Auxilary functions
   bool              GetOrderData(void);
   bool              GetDataFromLines(void);
   bool              MarketSellOrder(void);
   bool              MarketBuyOrder(void);
   bool              PendingSellStopOrder(void);
   bool              PendingSellLimitOrder(void);
   bool              PendingBuyStopOrder(void);
   bool              PendingBuyLimitOrder(void);
   bool              MarketSellDoubleOrder(void);
   bool              MarketBuyDoubleOrder(void);
   bool              PendingSellStopDoubleOrder(void);
   bool              PendingSellLimitDoubleOrder(void);
   bool              PendingBuyStopDoubleOrder(void);
   bool              PendingBuyLimitDoubleOrder(void);
   bool              CalculatePosition(void);
   double            CheckPositionVolume(double lotSize);
   bool              DisplayInfo(void);
   bool              DrawPositionRectangles(void);
   bool              SetManualBE(void);
   bool              CreateAlertCloseLines(void);

   //--- handlers of the dependent controls events
   void              OnClickSellBtn(void);
   void              OnClickBuyBtn(void);
   void              OnClickCloseAllBtn(void);
   void              OnClickCalculatePosBtn(void);
   void              OnClickClearInputsBtn(void);
   void              OnClickBreakEvenBtn(void);
   void              OnClickMarketPendingBtn(void);
   void              OnClickShowLinesBtn(void);
   void              OnClickSellToggleBtn(void);
   void              OnClickBuyToggleBtn(void);
   void              OnClickSendOrderBtn(void);
   void              OnClickStopToggleBtn(void);
   void              OnClickLimitToggleBtn(void);
   void              OnClickAutoPosMgmtToggleBtn(void);
   void              OnClickDoubleOrderBtn(void);
   void              OnClickDrawPositionsBtn(void);
   void              OnClickBoxBtn(void);
   void              OnClickShowAlertLinesBtn(void);
   void              OnClickAlertCloseBtn(void);
   void              OnClickManualBEBtn(void);
   void              OnClickWm1AlertBtn(void);
   void              OnClickWm2AlertBtn(void);
   void              OnClickWm3AlertBtn(void);
   void              OnClickScanChartsBtn(void);
   void              OnClickOpenChartsBtn(void);
   void              OnClickCloseChartsBtn(void);
   void              OnClickOpenActiveChartsBtn(void);

  };
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CControlsDialog)
ON_EVENT(ON_CLICK,m_SellBtn,OnClickSellBtn)
ON_EVENT(ON_CLICK,m_BuyBtn,OnClickBuyBtn)
ON_EVENT(ON_CLICK,m_CloseAllBtn,OnClickCloseAllBtn)
ON_EVENT(ON_CLICK,m_CalculatePosBtn,OnClickCalculatePosBtn)
ON_EVENT(ON_CLICK,m_ClearInputsBtn,OnClickClearInputsBtn)
ON_EVENT(ON_CLICK,m_BreakEvenBtn,OnClickBreakEvenBtn)
ON_EVENT(ON_CLICK,m_MarketPendingBtn,OnClickMarketPendingBtn)
ON_EVENT(ON_CLICK,m_ShowLinesBtn,OnClickShowLinesBtn)
ON_EVENT(ON_CLICK,m_SellToggleBtn,OnClickSellToggleBtn)
ON_EVENT(ON_CLICK,m_BuyToggleBtn,OnClickBuyToggleBtn)
ON_EVENT(ON_CLICK,m_SendOrderBtn,OnClickSendOrderBtn)
ON_EVENT(ON_CLICK,m_StopToggleBtn,OnClickStopToggleBtn)
ON_EVENT(ON_CLICK,m_LimitToggleBtn,OnClickLimitToggleBtn)
ON_EVENT(ON_CLICK,m_AutoPosMgmtToggleBtn,OnClickAutoPosMgmtToggleBtn)
ON_EVENT(ON_CLICK,m_DoubleOrderBtn,OnClickDoubleOrderBtn)
ON_EVENT(ON_CLICK,m_DrawPositionsBtn,OnClickDrawPositionsBtn)
ON_EVENT(ON_CLICK,m_Box,OnClickBoxBtn)
ON_EVENT(ON_CLICK,m_ShowAlertLinesBtn,OnClickShowAlertLinesBtn)
ON_EVENT(ON_CLICK,m_AlertCloseBtn,OnClickAlertCloseBtn)
ON_EVENT(ON_CLICK,m_ManualBEBtn,OnClickManualBEBtn)
ON_EVENT(ON_CLICK,m_wm1AlertBtn,OnClickWm1AlertBtn)
ON_EVENT(ON_CLICK,m_wm2AlertBtn,OnClickWm2AlertBtn)
ON_EVENT(ON_CLICK,m_wm3AlertBtn,OnClickWm3AlertBtn)
ON_EVENT(ON_CLICK,m_ScanChartsBtn,OnClickScanChartsBtn)
ON_EVENT(ON_CLICK,m_OpenChartsBtn,OnClickOpenChartsBtn)
ON_EVENT(ON_CLICK,m_CloseChartsBtn,OnClickCloseChartsBtn)
ON_EVENT(ON_CLICK,m_OpenActiveChartsBtn,OnClickOpenActiveChartsBtn)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CControlsDialog::CControlsDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CControlsDialog::~CControlsDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   ObjectsDeleteAll(0,-1,OBJ_LABEL); // patch to remove residual labels
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls

// --- Create Labels
   if(!CreateLotsLbl())
      return(false);
   if(!CreateSlPipsLbl())
      return(false);
   if(!CreateRiskToRewardRatioLbl())
      return(false);
   if(!CreateRiskLbl())
      return(false);
   if(!CreateTpPipsLbl())
      return(false);
   if(!CreatePriceLbl())
      return(false);
   if(!CreateSlLbl())
      return(false);
   if(!CreateTpLbl())
      return(false);
   if(!CreateMarginRequiredLbl())
      return(false);
   if(!CreateMarginRequiredDisplLbl())
      return(false);
   if(!CreateMarginAvailableLbl())
      return(false);
   if(!CreateMarginAvailableDisplLbl())
      return(false);
   if(!CreateSpreadLbl())
      return(false);
   if(!CreateTimeTillCandleCloseLbl())
      return(false);
   if(!CreateProfitLbl())
      return(false);

// --- Create Edit fields
   if(!CreateLotsEdit())
      return(false);
   if(!CreateSlPipsEdit())
      return(false);
   if(!CreateRiskToRewardRatioEdit())
      return(false);
   if(!CreateRiskEdit())
      return(false);
   if(!CreateTpPipsEdit())
      return(false);
   if(!CreatePriceEdit())
      return(false);
   if(!CreateSlEdit())
      return(false);
   if(!CreateTpEdit())
      return(false);

// --- Create Buttons
   if(!CreateSellBtn())
      return(false);
   if(!CreateBuyBtn())
      return(false);
   if(!CreateCloseAllBtn())
      return(false);
   if(!CreateCalculatePosBtn())
      return(false);
   if(!CreateClearInputsBtn())
      return(false);
   if(!CreateBreakEvenBtn())
      return(false);
   if(!CreateMarketPendingBtn())
      return(false);
   if(!CreateShowLinesBtn())
      return(false);
   if(!CreateSellToggleBtn())
      return(false);
   if(!CreateBuyToggleBtn())
      return(false);
   if(!CreateSendOrderBtn())
      return(false);
   if(!CreateStopToggleBtn())
      return(false);
   if(!CreateLimitToggleBtn())
      return(false);
   if(!CreateAutoPosMgmtToggleBtn())
      return(false);
   if(!CreateDoubleOrderBtn())
      return(false);
   if(!CreateDrawPositionsBtn())
      return(false);
   if(!CreateBoxBtn())
      return(false);
   if(!CreateShowAlertLinesBtn())
      return(false);
   if(!CreateAlertCloseBtn())
      return(false);
   if(!CreateManualBEBtn())
      return(false);
   if(!CreateWm1AlertBtn())
      return(false);
   if(!CreateWm2AlertBtn())
      return(false);
   if(!CreateWm3AlertBtn())
      return(false);
   if(!CreateScanChartsBtn())
      return(false);
   if(!CreateStrategySelectorCBox())
      return(false);
   if(!CreateOpenChartsBtn())
      return(false);
   if(!CreateCloseChartsBtn())
      return(false);
   if(!CreateOpenActiveChartsBtn())
      return(false);


//--- succeed
   return(true);
  }


// Creating Labels =====================================================================================================


//+------------------------------------------------------------------+
//| Create the Lots Label                  #1                        |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateLotsLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_LotsLbl.Create(m_chart_id,m_name+"LotsLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_LotsLbl.Text("L"))
      return(false);
   if(!Add(m_LotsLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the SlPips label             #2                           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSlPipsLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+EDIT_WIDTH_SMALL+CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;

//--- create
   if(!m_SlPipsLbl.Create(m_chart_id,m_name+"SlPipsLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SlPipsLbl.Text("SLp"))
      return(false);
   if(!Add(m_SlPipsLbl))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Tp pips label                   #3                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateTpPipsLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_TpPipsLbl.Create(m_chart_id,m_name+"TpPipsLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_TpPipsLbl.Text("TPp"))
      return(false);
   if(!Add(m_TpPipsLbl))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the risk to reward ratio Label              #4            |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateRiskToRewardRatioLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT+3*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;

//--- create
   if(!m_RiskToRewardRatioLbl.Create(m_chart_id,m_name+"RRRLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_RiskToRewardRatioLbl.Text("RRR"))
      return(false);
   if(!Add(m_RiskToRewardRatioLbl))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Risk label                   #5                       |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateRiskLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+4*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_RiskLbl.Create(m_chart_id,m_name+"RiskLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_RiskLbl.Text("R %"))
      return(false);
   if(!Add(m_RiskLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Price  label                   #6                     |
//+------------------------------------------------------------------+
bool CControlsDialog::CreatePriceLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_PriceLbl.Create(m_chart_id,m_name+"PriceLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_PriceLbl.Text("$"))
      return(false);
   if(!Add(m_PriceLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Sl  label                   #7                        |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSlLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+ 5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X) + (EDIT_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_SlLbl.Create(m_chart_id,m_name+"SlLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SlLbl.Text("SL"))
      return(false);
   if(!Add(m_SlLbl))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Tp  label                   #8                        |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateTpLbl(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+ 5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X) + 2*(EDIT_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_TpLbl.Create(m_chart_id,m_name+"TpLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_TpLbl.Text("TP"))
      return(false);
   if(!Add(m_TpLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Margin Required  label #9                             |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateMarginRequiredLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_MarginRequiredLbl.Create(m_chart_id,m_name+"MarginRequiredLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_MarginRequiredLbl.Text("Margin Needed"))
      return(false);
   if(!Add(m_MarginRequiredLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Margin Required Displ label #10                       |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateMarginRequiredDisplLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT;
   int y1=5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_MarginRequiredDisplLbl.Create(m_chart_id,m_name+"MarginRequiredDisplLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_MarginRequiredDisplLbl.Text("0"))
      return(false);
   if(!Add(m_MarginRequiredDisplLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Margin Available  label #11                           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateMarginAvailableLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_MarginAvailableLbl.Create(m_chart_id,m_name+"MarginAvailableLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_MarginAvailableLbl.Text("Margin Available"))
      return(false);
   if(!Add(m_MarginAvailableLbl))
      return(false);
//--- succeed
   return(true);
  }



//+------------------------------------------------------------------+
//| Create the Margin Available Displ label #12                      |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateMarginAvailableDisplLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_MarginAvailableDisplLbl.Create(m_chart_id,m_name+"MarginAvailableDisplLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_MarginAvailableDisplLbl.Text("0"))
      return(false);
   if(!Add(m_MarginAvailableDisplLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create Spread  label #13                                         |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSpreadLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_SpreadLbl.Create(m_chart_id,m_name+"SpreadLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SpreadLbl.Text(""))
      return(false);
   if(!Add(m_SpreadLbl))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Time Till Candle Close label #14                      |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateTimeTillCandleCloseLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_TimeTillCandleCloseLbl.Create(m_chart_id,m_name+"TimeTillCandleCloseLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_TimeTillCandleCloseLbl.Text(""))
      return(false);
   if(!Add(m_TimeTillCandleCloseLbl))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Profit label #15                                      |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateProfitLbl(void)
  {
//--- coordinates

   int x1=INDENT_LEFT;//+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;

//--- create
   if(!m_ProfitLbl.Create(m_chart_id,m_name+"ProfitLbl",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_ProfitLbl.Text(""))
      return(false);
   if(!Add(m_ProfitLbl))
      return(false);
//--- succeed
   return(true);
  }


// Creating Edit Fields =====================================================================================================

//+------------------------------------------------------------------+
//| Create the Lots field                  #1                        |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateLotsEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_LotsEdit.Create(m_chart_id,m_name+"Lots",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_LotsEdit.ReadOnly(false))
      return(false);
   if(!Add(m_LotsEdit))
      return(false);
//--- Assign default value from the inputs
   if(!m_LotsEdit.Text(posLotsDef))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the SlPips field             #2                           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSlPipsEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+EDIT_WIDTH_SMALL+CONTROLS_GAP_X;
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_SlPipsEdit.Create(m_chart_id,m_name+"SlPips",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_SlPipsEdit.ReadOnly(false))
      return(false);
   if(!Add(m_SlPipsEdit))
      return(false);
//--- Assign default value from the inputs
   if(!m_SlPipsEdit.Text(slPipsDef))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the TP Pips Edit field              #3                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateTpPipsEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_TpPipsEdit.Create(m_chart_id,m_name+"TpRiskEdit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_TpPipsEdit.ReadOnly(false))
      return(false);
   if(!Add(m_TpPipsEdit))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Risk to reward ratio edit field          #4           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateRiskToRewardRatioEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_RiskToRewardRatioEdit.Create(m_chart_id,m_name+"RRR",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_RiskToRewardRatioEdit.ReadOnly(false))
      return(false);
   if(!Add(m_RiskToRewardRatioEdit))
      return(false);
//--- Assign default value from the inputs
   if(!m_RiskToRewardRatioEdit.Text(RiskToRewardDef))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Risk Edit field              #5                       |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateRiskEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+4*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH_SMALL;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_RiskEdit.Create(m_chart_id,m_name+"Risk",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_RiskEdit.ReadOnly(false))
      return(false);
//--- Assign default value from the inputs
   if(!m_RiskEdit.Text(RiskLevelDef))
      return(false);
   if(!Add(m_RiskEdit))
      return(false);
//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the Price Edit field              #6                      |
//+------------------------------------------------------------------+
bool CControlsDialog::CreatePriceEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_PriceEdit.Create(m_chart_id,m_name+"PriceEdit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_PriceEdit.ReadOnly(false))
      return(false);
   if(!Add(m_PriceEdit))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Sl Edit field              #7                         |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSlEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+ 5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X) + (EDIT_WIDTH+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_SlEdit.Create(m_chart_id,m_name+"SlEdit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_SlEdit.ReadOnly(false))
      return(false);
   if(!Add(m_SlEdit))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the Tp Edit field              #8                         |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateTpEdit(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+ 5*(EDIT_WIDTH_SMALL+CONTROLS_GAP_X) + 2*(EDIT_WIDTH+CONTROLS_GAP_X);
   int y1= EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- create
   if(!m_TpEdit.Create(m_chart_id,m_name+"TpEdit",m_subwin,x1,y1,x2,y2))
      return(false);
//--- allow editing the content
   if(!m_TpEdit.ReadOnly(false))
      return(false);
   if(!Add(m_TpEdit))
      return(false);
//--- succeed
   return(true);
  }

// Creating Buttons =====================================================================================================

//+------------------------------------------------------------------+
//| Create the "SellBtn" button                                      |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSellBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_SellBtn.Create(m_chart_id,m_name+"SellBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SellBtn.Text("SELL"))
      return(false);
   if(!Add(m_SellBtn))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "BuyBtn" button                                       |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateBuyBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_BuyBtn.Create(m_chart_id,m_name+"BuyBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_BuyBtn.Text("BUY"))
      return(false);
   if(!Add(m_BuyBtn))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "CloseAllBtn"   button                                |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateCloseAllBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_CloseAllBtn.Create(m_chart_id,m_name+"CloseAllBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CloseAllBtn.Text("\x2716")) // "X"
      return(false);
   if(!Add(m_CloseAllBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Box"   button                                        |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateBoxBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+BUTTON_WIDTH+CONTROLS_GAP_X+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_Box.Create(m_chart_id,m_name+"BoxBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_Box.Text("\x2752"))
      return(false);
   if(!Add(m_Box))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "DoubleOrderBtn"   button                             |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateDoubleOrderBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X) + BUTTON_WIDTH/3;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_DoubleOrderBtn.Create(m_chart_id,m_name+"DoubleOrderBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_DoubleOrderBtn.Text("\x2713"+"\x2713"))
      return(false);
   if(!Add(m_DoubleOrderBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "CalculatePosBtn" button                              |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateCalculatePosBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_CalculatePosBtn.Create(m_chart_id,m_name+"CalculatePosBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_CalculatePosBtn.Text("CLC"))
      return(false);
   if(!Add(m_CalculatePosBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "ClearInputs" button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateClearInputsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+BUTTON_WIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_ClearInputsBtn.Create(m_chart_id,m_name+"ClearInputsBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_ClearInputsBtn.Text("CLR"))

      return(false);
   if(!Add(m_ClearInputsBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Break Even"  button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateBreakEvenBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_BreakEvenBtn.Create(m_chart_id,m_name+"BreakEvenBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_BreakEvenBtn.Text("BE"))
      return(false);
   if(!Add(m_BreakEvenBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Market Pending"  button                              |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateMarketPendingBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_MarketPendingBtn.Create(m_chart_id,m_name+"MarketPending",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_MarketPendingBtn.Text("[ M ]"))
      return(false);
   if(!Add(m_MarketPendingBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Show Lines"  button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateShowLinesBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X)+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_ShowLinesBtn.Create(m_chart_id,m_name+"ShowLinesBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_ShowLinesBtn.Text("\x4E09"))
      return(false);
   if(!Add(m_ShowLinesBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Sell Toggle"  button                                 |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSellToggleBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+(BUTTON_WIDTH/3);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_SellToggleBtn.Create(m_chart_id,m_name+"SellToggleBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SellToggleBtn.Text("S"))
      return(false);
   if(!Add(m_SellToggleBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Buy Toggle"  button                                 |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateBuyToggleBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH/3);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_BuyToggleBtn.Create(m_chart_id,m_name+"BuyToggleBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_BuyToggleBtn.Text("B"))
      return(false);
   if(!Add(m_BuyToggleBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Stop Toggle"  button                                 |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateStopToggleBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_StopToggleBtn.Create(m_chart_id,m_name+"StopToggleBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_StopToggleBtn.Text("ST"))
      return(false);
   if(!Add(m_StopToggleBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Limit Toggle"  button                                |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateLimitToggleBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+(BUTTON_WIDTH+BUTTON_WIDTH/3+CONTROLS_GAP_X);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_LimitToggleBtn.Create(m_chart_id,m_name+"LimitToggleBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_LimitToggleBtn.Text("LM"))
      return(false);
   if(!Add(m_LimitToggleBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Send Order"  button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateSendOrderBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X) + 2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_SendOrderBtn.Create(m_chart_id,m_name+"SendOrderBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_SendOrderBtn.Text("\x2714"))
      return(false);
   if(!Add(m_SendOrderBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Auto Position Management"  button                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateAutoPosMgmtToggleBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_AutoPosMgmtToggleBtn.Create(m_chart_id,m_name+"AutoPosMgmtToggleBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(autoPosMgmtToggle)
     {
      if(!m_AutoPosMgmtToggleBtn.Text("[PM]"))
         return(false);
     }
   else
      if(!autoPosMgmtToggle)
        {
         if(!m_AutoPosMgmtToggleBtn.Text("PM"))
            return(false);
        }

   if(!Add(m_AutoPosMgmtToggleBtn))
      return(false);
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Draw Positions"  button                              |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateDrawPositionsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+BUTTON_WIDTH+CONTROLS_GAP_X+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_DrawPositionsBtn.Create(m_chart_id,m_name+"DrawPositionsBtn",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_DrawPositionsBtn.Text("\x270F"))
      return(false);
   if(!Add(m_DrawPositionsBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "Select Strategy"  Combobox                           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateStrategySelectorCBox(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+2*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_StrategySelectorCBox.Create(m_chart_id,m_name+"StrategySelectorCBox",m_subwin,x1,y1,x2,y2))
      return(false);

   for(int i=0; i<10; i++)
     {
      if(!m_StrategySelectorCBox.ItemAdd(StrategyStr[i]))
         return(false);
     }

   if(!m_StrategySelectorCBox.SelectByText(StrategySelected))
      return(false);

   if(!Add(m_StrategySelectorCBox))
      return(false);
//--- succeed

   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "Show Alert Lines" button                             |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateShowAlertLinesBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_ShowAlertLinesBtn.Create(m_chart_id,m_name+"ShowAlertLinesBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_ShowAlertLinesBtn.Text("\x2F06"))
      return(false);

   if(!Add(m_ShowAlertLinesBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "Alert Close Btn" button                              |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateAlertCloseBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_AlertCloseBtn.Create(m_chart_id,m_name+"AlertCloseBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_AlertCloseBtn.Text("\x23F0"))
      return(false);

   if(!Add(m_AlertCloseBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "Manual BE Btn" button                                |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateManualBEBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+4*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_ManualBEBtn.Create(m_chart_id,m_name+"ManualBEBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_ManualBEBtn.Text("MBE"))
      return(false);

   if(!Add(m_ManualBEBtn))
      return(false);

//--- succeed
   return(true);
  }



//+------------------------------------------------------------------+
//| Create the "Open Charts" button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateOpenChartsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_OpenChartsBtn.Create(m_chart_id,m_name+"OpenChartsBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_OpenChartsBtn.Text("OC"))
      return(false);

   if(!Add(m_OpenChartsBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "Open Active Charts" button                           |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateOpenActiveChartsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_OpenActiveChartsBtn.Create(m_chart_id,m_name+"OpenActiveChartsBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_OpenActiveChartsBtn.Text("AC"))
      return(false);

   if(!Add(m_OpenActiveChartsBtn))
      return(false);

//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Close Charts" button                                 |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateCloseChartsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+5*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_CloseChartsBtn.Create(m_chart_id,m_name+"CloseChartsBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_CloseChartsBtn.Text("CC"))
      return(false);

   if(!Add(m_CloseChartsBtn))
      return(false);

//--- succeed
   return(true);
  }




//+------------------------------------------------------------------+
//| Create the "WM1 Alert" button                                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateWm1AlertBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_wm1AlertBtn.Create(m_chart_id,m_name+"wm1AlertBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_wm1AlertBtn.Text("W1"))
      return(false);

   if(!Add(m_wm1AlertBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "WM2 Alert" button                                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateWm2AlertBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_wm2AlertBtn.Create(m_chart_id,m_name+"wm2AlertBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_wm2AlertBtn.Text("W2"))
      return(false);

   if(!Add(m_wm2AlertBtn))
      return(false);

//--- succeed
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the "WM3 Alert" button                                    |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateWm3AlertBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_wm3AlertBtn.Create(m_chart_id,m_name+"wm3AlertBtn",m_subwin,x1,y1,x2,y2))
      return(false);



   if(wiseMan1PermanentToggle)
     {
      if(!m_wm1AlertBtn.Text("[W1]"))
         return(false);
     }
   else
      if(!m_wm1AlertBtn.Text("W1"))
         return(false);


   if(wiseMan2PermanentToggle)
     {
      if(!m_wm2AlertBtn.Text("[W2]"))
         return(false);
     }
   else
      if(!m_wm2AlertBtn.Text("W2"))
         return(false);



   if(wiseMan3PermanentToggle)
     {
      if(!m_wm3AlertBtn.Text("[W3]"))
         return(false);
     }
   else
      if(!m_wm3AlertBtn.Text("W3"))
         return(false);





   if(!Add(m_wm3AlertBtn))
      return(false);

//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Create the "Scan Charts" button                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateScanChartsBtn(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+3*(BUTTON_WIDTH+CONTROLS_GAP_X)+2*BUTTON_WIDTH/3;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH/3;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_ScanChartsBtn.Create(m_chart_id,m_name+"ScanChartsBtn",m_subwin,x1,y1,x2,y2))
      return(false);

   if(!m_ScanChartsBtn.Text("SCN"))
      return(false);

   if(!Add(m_ScanChartsBtn))
      return(false);

//--- succeed
   return(true);
  }


/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//+------------------------------------------------------------------+
//| +++   Event handlers   +++                                       |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Event handler for Sell Button                                    |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickSellBtn(void)
  {
   MarketSellOrder();
  }
//+------------------------------------------------------------------+
//| Event handler for Buy Button                                     |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickBuyBtn(void)
  {
   MarketBuyOrder();
  }


//+------------------------------------------------------------------+
//| Event handler for Close All Positions Button                     |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickCloseAllBtn(void)
  {
   CTrade trade;
   for(int i = PositionsTotal() - 1; i>=0; i--)
     {
      ulong posTicket = PositionGetTicket(i);
      if(trade.PositionClose(_Symbol))
        {
         Print(i," Position #",posTicket," Was closed...");
        }
     } // end of for loop
  }

//+------------------------------------------------------------------+
//| Event handler for Box Button                                     |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickBoxBtn(void)
  {
   if(boxOnToggle)
     {
      boxOnToggle = false;
     }
   else
      if(!boxOnToggle)
        {
         boxOnToggle = true;
        }

   if(boxOnToggle)
     {
      if(customBox)
         if(!drawBox("Box_Custom", timeCustomBoxFrom, timeCustomBoxTill, colorCustomBox))
            Print("Failed to draw box...");

      if(SydneySession)
         if(!drawBox("Box_Sydney", timeFromSydney, timeTillSydney, colorSydney))
            Print("Failed to draw box...");

      if(TokyoSession)
         if(!drawBox("Box_Tokyo", timeFromTokyo, timeTillTokyo, colorTokyo))
            Print("Failed to draw box...");



      if(LondonSession)
         if(!drawBox("Box_London", timeFromLondon, timeTillLondon, colorLondon))
            Print("Failed to draw box...");


      if(NewYorkSession)
         if(!drawBox("Box_NewYork", timeFromNewYork, timeTillNewYork, colorNewYork))
            Print("Failed to draw box...");

     }
   else
      if(!boxOnToggle)
        {
         // remove box
         string Name;
         for(int i = ObjectsTotal(0,0) -1 ; i >= 0; i--)
           {
            Name = ObjectName(0,i);
            if(StringSubstr(Name, 0, 4) == "Box_")
               ObjectDelete(0,Name);
           }
        }
  }


//+------------------------------------------------------------------+
//| Event handler for Send D Order Button                            |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickDoubleOrderBtn(void)
  {
   CTrade trade;

   Print("Market/Pending = " + IntegerToString(pendingToggle) + " Sell = " + IntegerToString(sellToggle) + " Buy = " + IntegerToString(buyToggle));

   if(!pendingToggle && sellToggle && !buyToggle) // if market sell order
     {
      MarketSellDoubleOrder();
     }
   else
      if(!pendingToggle && !sellToggle && buyToggle) // if market buy order
        {
         MarketBuyDoubleOrder();
        }
      else
         if(pendingToggle && sellToggle && !buyToggle)
           {
            //+------------------------------------------------------------------+
            //|                          Pending Order   Sell                    |
            //+------------------------------------------------------------------+

            if(limitToggle && !stopToggle)
              {
               PendingSellLimitDoubleOrder();
              }
            else
               if(!limitToggle && stopToggle)
                 {
                  PendingSellStopDoubleOrder();
                 }

           }
         else
            if(pendingToggle && !sellToggle && buyToggle)
              {
               //+------------------------------------------------------------------+
               //|                          Pending Order   Buy                    |
               //+------------------------------------------------------------------+
               if(limitToggle && !stopToggle)
                 {
                  PendingBuyLimitDoubleOrder();
                 }
               else
                  if(!limitToggle && stopToggle)
                    {
                     PendingBuyStopDoubleOrder();
                    }
              }

   ObjectDelete(0,"priceLine");
   ObjectDelete(0,"stopLossLine");
   ObjectDelete(0,"takeProfitLine");

   if(!DrawPositionRectangles())
      Print(__FUNCTION__," Failed...");

   if(!SetManualBE())
      Print(__FUNCTION__," Failed...");

  }


//+------------------------------------------------------------------+
//| Event handler for Calculate Position Button                      |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickCalculatePosBtn(void)
  {
   CalculatePosition();
  }


//+------------------------------------------------------------------+
//| Event handler for Clear Inputs Button                            |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickClearInputsBtn(void)
  {
   m_LotsEdit.Text(NULL);
   m_SlPipsEdit.Text(NULL);
   m_RiskToRewardRatioEdit.Text(NULL);
   m_RiskEdit.Text(NULL);
   m_PriceEdit.Text(NULL);
   m_SlEdit.Text(NULL);
   m_TpEdit.Text(NULL);
   m_TpPipsEdit.Text(NULL);

   stopToggle = false;
   limitToggle  = false;
   pendingToggle = false;

   sellToggle = false;
   buyToggle = false;
   m_MarketPendingBtn.Text("P");
   m_StopToggleBtn.Text("ST");
   m_LimitToggleBtn.Text("LM");
   m_BuyToggleBtn.Text("B");
   m_SellToggleBtn.Text("S");
  }

//+------------------------------------------------------------------+
//| Event handler for Break Even Button                              |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickBreakEvenBtn(void)
  {
   CTrade trade;
   for(int i = PositionsTotal() - 1; i>=0; i--)
     {
      ulong posTicket = PositionGetTicket(i);
      string posSymbol = PositionGetSymbol(i);
      double posOpen = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
      double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),_Digits);
      double posTp = NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits);
      double posCurrent = NormalizeDouble(PositionGetDouble(POSITION_PRICE_CURRENT),_Digits);

      if(posSymbol == _Symbol)
        {
         if((posCurrent > posOpen && posOpen > posSl) || (posCurrent < posOpen && posOpen < posSl))
           {
            trade.PositionModify(posTicket,posOpen,posTp);
            Print(i," Position #",posTicket," Break Even...");
           }
         else
           {
            Print("Break Even not possible");
           }
        }
     } // end of for loop
  }

//+------------------------------------------------------------------+
//| Event handler for Market Pending Button                          |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickMarketPendingBtn(void)
  {
   if(pendingToggle)
     {
      m_MarketPendingBtn.Text("[ M ]");
      pendingToggle = false;
      stopToggle = false;
      limitToggle = false;
      m_StopToggleBtn.Text("ST");
      m_LimitToggleBtn.Text("LM");
     }
   else
      if(!pendingToggle)
        {
         m_MarketPendingBtn.Text("[ P ]");
         pendingToggle = true;
         stopToggle = true;
         limitToggle = true;
        }
  }

//+------------------------------------------------------------------+
//| Event handler for Show Lines Button                              |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickShowLinesBtn(void)
  {
   if(!lineInput)
     {
      lineInput = true;

      // Line Price
      ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);

      double linePrice = 0;
      double lineSl = 0;
      double lineTp = 0;
      double inputLineRRR = 0;
      inputLineRRR = StringToDouble(ObjectGetString(0,ExtDialog.Name()+"RRR",OBJPROP_TEXT));
      double lineSlPips = StringToDouble(ObjectGetString(0,ExtDialog.Name()+"SlPips",OBJPROP_TEXT));
      double upperFractal = UpperFractalCalculation();
      double lowerFractal = LowerFractalCalculation();

      if(sellToggle && !buyToggle)
        {
         // SELL
         linePrice = NormalizeDouble(ask,_Digits);

         if(upperFractal > 0 && upperFractal > ask)
           {
            lineSl = upperFractal;
           }
         else
           {
            lineSl = NormalizeDouble(ask + lineSlPips*10*_Point,_Digits);
           }

         lineTp = NormalizeDouble(ask - (lineSl - ask) * inputLineRRR,_Digits);

        }
      else
         if(!sellToggle && buyToggle)
           {
            // BUY
            linePrice = NormalizeDouble(bid,_Digits);


            if(lowerFractal > 0 && lowerFractal < bid)
              {
               lineSl = lowerFractal;
              }
            else
              {
               lineSl = NormalizeDouble(bid - lineSlPips*10*_Point,_Digits);
              }

            lineTp = NormalizeDouble(bid + (bid - lineSl) * inputLineRRR,_Digits);
           }

      if(sellToggle || buyToggle)
        {
         // Create Price Line
         if(pendingToggle)
           {
            ObjectCreate(0,"priceLine",OBJ_HLINE,0,0,linePrice);
            ObjectSetInteger(0, "priceLine", OBJPROP_COLOR, clrGoldenrod);
            ObjectSetInteger(0, "priceLine", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, "priceLine", OBJPROP_WIDTH, 3);
            ObjectSetInteger(0, "priceLine", OBJPROP_BACK, true);
            ObjectSetInteger(0, "priceLine", OBJPROP_SELECTABLE, true);
            ObjectSetInteger(0, "priceLine", OBJPROP_SELECTED, true);
            ObjectSetInteger(0, "priceLine", OBJPROP_HIDDEN, false);
            ObjectSetInteger(0, "priceLine", OBJPROP_ZORDER, 0);
           }

         // Create Stoploss Line
         ObjectCreate(0,"stopLossLine",OBJ_HLINE,0,0,lineSl);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_COLOR, clrTomato);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_WIDTH, 3);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_BACK, true);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_SELECTABLE, true);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_SELECTED, true);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_HIDDEN, false);
         ObjectSetInteger(0, "stopLossLine", OBJPROP_ZORDER, 0);

         // Create Take Profit Line
         ObjectCreate(0,"takeProfitLine",OBJ_HLINE,0,0,lineTp);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_COLOR, clrDodgerBlue);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_WIDTH, 3);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_BACK, true);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_SELECTABLE, true);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_SELECTED, true);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_HIDDEN, false);
         ObjectSetInteger(0, "takeProfitLine", OBJPROP_ZORDER, 0);

         if(!GetDataFromLines())
           {
            Print("Get Data From Lines Failed...");
           }

         if(!CalculatePosition())
           {
            Print("Position Calculation Failed...");
           }

         if(pendingToggle)
           {
            m_PriceEdit.Text("M");
           }
        }

      // Line Sl
     }
   else
      if(lineInput)
        {
         lineInput = false;
         ObjectDelete(0,"priceLine");
         ObjectDelete(0,"stopLossLine");
         ObjectDelete(0,"takeProfitLine");
         sellToggle = false;
         buyToggle = false;
         m_SellToggleBtn.Text("S");
         m_BuyToggleBtn.Text("B");
         m_StopToggleBtn.Text("ST");
         m_LimitToggleBtn.Text("LM");
        }
  }

//+------------------------------------------------------------------+
//| Event handler for Sell Toggle Button                             |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickSellToggleBtn(void)
  {
   sellToggle = true;
   buyToggle = false;
   m_SellToggleBtn.Text("[ S ]");
   m_BuyToggleBtn.Text("B");
  }

//+------------------------------------------------------------------+
//| Event handler for Buy Toggle Button                              |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickBuyToggleBtn(void)
  {
   sellToggle = false;
   buyToggle = true;
   m_SellToggleBtn.Text("S");
   m_BuyToggleBtn.Text("[B]");
  }

//+------------------------------------------------------------------+
//| Event handler for Stop Toggle Button                             |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickStopToggleBtn(void)
  {
   stopToggle = true;
   limitToggle  = false;
   pendingToggle = true;
   m_MarketPendingBtn.Text("[ P ]");
   m_StopToggleBtn.Text("[ST]");
   m_LimitToggleBtn.Text("LM");
  }

//+------------------------------------------------------------------+
//| Event handler for Limit Toggle Button                            |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickLimitToggleBtn(void)
  {
   stopToggle = false;
   limitToggle  = true;
   pendingToggle = true;
   m_MarketPendingBtn.Text("[ P ]");
   m_StopToggleBtn.Text("ST");
   m_LimitToggleBtn.Text("[LM]");
  }

//+------------------------------------------------------------------+
//| Event handler for Auto Position Management Button                |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickAutoPosMgmtToggleBtn(void)
  {
   barCountFractals = 0;
   if(autoPosMgmtToggle)
     {
      autoPosMgmtToggle = false;
      m_AutoPosMgmtToggleBtn.Text("PM");
     }
   else
      if(!autoPosMgmtToggle)
        {
         autoPosMgmtToggle = true;
         m_AutoPosMgmtToggleBtn.Text("[PM]");
        }
   Print("PM = ",autoPosMgmtToggle);
  }


//+------------------------------------------------------------------+
//| Event handler for Send Order Button                              |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickSendOrderBtn(void)
  {

   CTrade trade;

   Print("Market/Pending = " + IntegerToString(pendingToggle) + " Sell = " + IntegerToString(sellToggle) + " Buy = " + IntegerToString(buyToggle));

   if(!pendingToggle && sellToggle && !buyToggle) // if market sell order
     {
      MarketSellOrder();
     }
   else
      if(!pendingToggle && !sellToggle && buyToggle) // if market buy order
        {
         MarketBuyOrder();
        }
      else
         if(pendingToggle && sellToggle && !buyToggle)
           {
            //+------------------------------------------------------------------+
            //|                          Pending Order   Sell                    |
            //+------------------------------------------------------------------+

            if(limitToggle && !stopToggle)
              {
               PendingSellLimitOrder();
              }
            else
               if(!limitToggle && stopToggle)
                 {
                  PendingSellStopOrder();
                 }

           }
         else
            if(pendingToggle && !sellToggle && buyToggle)
              {
               //+------------------------------------------------------------------+
               //|                          Pending Order   Buy                    |
               //+------------------------------------------------------------------+
               if(limitToggle && !stopToggle)
                 {
                  PendingBuyLimitOrder();
                 }
               else
                  if(!limitToggle && stopToggle)
                    {
                     PendingBuyStopOrder();
                    }
              }

   ObjectDelete(0,"priceLine");
   ObjectDelete(0,"stopLossLine");
   ObjectDelete(0,"takeProfitLine");

   if(!DrawPositionRectangles())
      Print(__FUNCTION__," Failed...");

  }


//+------------------------------------------------------------------+
//| Event handler for "Draw Positions" Button                        |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickDrawPositionsBtn(void)
  {
   Print(__FUNCTION__);
   if(!DrawPositionRectangles())
      Print(__FUNCTION__," Failed...");
  }


//+------------------------------------------------------------------+
//| Event handler for "Show Alert Lines" Button                      |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickShowAlertLinesBtn(void)
  {

   if(alertCloseLine)
      alertCloseLine = false;
   else
      if(!alertCloseLine)
         alertCloseLine = true;

   if(alertCloseLine)
     {
      m_ShowAlertLinesBtn.Color(clrBlue);

      if(!CreateAlertCloseLines())
         Print(__FUNCTION__, " Failed...");

     }
   else
      if(!alertCloseLine)
        {
         ObjectDelete(0,"alertCloseLine_1");
         ObjectDelete(0,"alertCloseLine_2");
         setAlarmCloseLine = false;
         manualBEToggle = false;
         m_ShowAlertLinesBtn.Text("\x2F06");
         m_ShowAlertLinesBtn.Color(clrBlack);
         m_ManualBEBtn.Color(clrBlack);
         m_AlertCloseBtn.Color(clrBlack);
        }
  }


//+------------------------------------------------------------------+
//| Event handler for "Alert Close Btn" Button                       |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickAlertCloseBtn(void)
  {
   if(alertCloseLine)
     {
      if(setAlarmCloseLine)
         setAlarmCloseLine = false;
      else
         if(!setAlarmCloseLine)
            setAlarmCloseLine = true;

      if(setAlarmCloseLine)
        {
         setAlarmCloseLine = true;
         manualBEToggle = false;
         m_AlertCloseBtn.Color(clrOrange);
         m_ManualBEBtn.Color(clrBlack);

         ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrOrange);
         ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrOrange);

         ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTED, false);
         ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTED, false);
        }
      else
         if(!setAlarmCloseLine)
           {
            setAlarmCloseLine = false;
            m_AlertCloseBtn.Color(clrBlack);
            ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrSilver);
            ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrSilver);
           }
     }
  }


//+------------------------------------------------------------------+
//| Event handler for "Manual BE Btn" Button                         |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickManualBEBtn(void)
  {
   if(!SetManualBE())
      Print(__FUNCTION__," Failed...");
  }


//+------------------------------------------------------------------+
//| Event handler for "WM1 Alert" Button                             |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickWm1AlertBtn(void)
  {
   if(wiseMenAlertsToggle)
     {
      if(wm1AlertToggle)
         wm1AlertToggle = false;
      else
         if(!wm1AlertToggle)
            wm1AlertToggle = true;

      if(wm1AlertToggle)
         m_wm1AlertBtn.Text("[W1]");
      else
         if(!wm1AlertToggle)
            m_wm1AlertBtn.Text("W1");
     }
  }

//+------------------------------------------------------------------+
//| Event handler for "WM2 Alert" Button                             |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickWm2AlertBtn(void)
  {

   if(wiseMenAlertsToggle)
     {

      if(wm2AlertToggle)
         wm2AlertToggle = false;
      else
         if(!wm2AlertToggle)
            wm2AlertToggle = true;

      if(wm2AlertToggle)
         m_wm2AlertBtn.Text("[W2]");
      else
         if(!wm2AlertToggle)
            m_wm2AlertBtn.Text("W2");
     }
  }

//+------------------------------------------------------------------+
//| Event handler for "WM3 Alert" Button                             |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickWm3AlertBtn(void)
  {
   if(wiseMenAlertsToggle)
     {
      if(wm3AlertToggle)
         wm3AlertToggle = false;
      else
         if(!wm3AlertToggle)
            wm3AlertToggle = true;


      if(wiseMan3PermanentToggle)
         m_wm3AlertBtn.Text("[W3]");
      else
         if(!wiseMan3PermanentToggle)
            if(wm3AlertToggle)
               m_wm3AlertBtn.Text("[W3]");
            else
               if(!wm3AlertToggle)
                  m_wm3AlertBtn.Text("W3");

     }
  }


//+------------------------------------------------------------------+
//| Event handler for "Scan Charts" Button                           |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickScanChartsBtn(void)
  {
   const int n = SymbolsTotal(true);
   Print("Scanning ", n, " pairs from Market Watch List...");


   for(int i = 0; i < n; ++i)
     {
      // D1 && H1
      // D1

      Print(SymbolName(i, true));

      int symbolDigits = (int)SymbolInfoInteger(SymbolName(i, true),SYMBOL_DIGITS);
      int handleIchimoku_D1 = iIchimoku(SymbolName(i, true),PERIOD_D1,9,26,52);
      double ClosePrice_D1 = iClose(SymbolName(i, true),PERIOD_D1,1);
      double Bar26High_D1 = iHigh(SymbolName(i, true),PERIOD_D1,26);
      double Bar26Low_D1 = iLow(SymbolName(i, true),PERIOD_D1,26);
      double TenkansenArr_D1[];
      double KijunsenArr_D1[];
      double SenkouspanAArr_D1[];
      double SenkouspanBArr_D1[];
      double ShiftedSenkouspanAArr_D1[];
      double ShiftedSenkouspanBArr_D1[];
      double ChikouspanArr_D1[];

      CopyBuffer(handleIchimoku_D1,0,0,3,TenkansenArr_D1);
      CopyBuffer(handleIchimoku_D1,1,0,3,KijunsenArr_D1);
      CopyBuffer(handleIchimoku_D1,2,0,3,SenkouspanAArr_D1);
      CopyBuffer(handleIchimoku_D1,3,0,3,SenkouspanBArr_D1);

      CopyBuffer(handleIchimoku_D1,2,-26,3,ShiftedSenkouspanAArr_D1);
      CopyBuffer(handleIchimoku_D1,3,-26,3,ShiftedSenkouspanBArr_D1);

      CopyBuffer(handleIchimoku_D1,4,26,3,ChikouspanArr_D1);

      double KumoDeltaCurrent_D1 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_D1[2] - ShiftedSenkouspanBArr_D1[2]),symbolDigits);
      double KumoDeltaPrevious_D1 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_D1[0] - ShiftedSenkouspanBArr_D1[0]),symbolDigits);

      // H1
      int handleIchimoku_H1 = iIchimoku(SymbolName(i, true),PERIOD_H1,9,26,52);
      double ClosePrice_H1 = iClose(SymbolName(i, true),PERIOD_H1,1); // previous close
      double Bar26High_H1 = iHigh(SymbolName(i, true),PERIOD_H1,26);
      double Bar26Low_H1 = iLow(SymbolName(i, true),PERIOD_H1,26);
      double TenkansenArr_H1[];
      double KijunsenArr_H1[];
      double SenkouspanAArr_H1[];
      double SenkouspanBArr_H1[];
      double ShiftedSenkouspanAArr_H1[];
      double ShiftedSenkouspanBArr_H1[];
      double ChikouspanArr_H1[];

      CopyBuffer(handleIchimoku_H1,0,0,3,TenkansenArr_H1);
      CopyBuffer(handleIchimoku_H1,1,0,3,KijunsenArr_H1);
      CopyBuffer(handleIchimoku_H1,2,0,3,SenkouspanAArr_H1);
      CopyBuffer(handleIchimoku_H1,3,0,3,SenkouspanBArr_H1);

      CopyBuffer(handleIchimoku_H1,2,-26,3,ShiftedSenkouspanAArr_H1);
      CopyBuffer(handleIchimoku_H1,3,-26,3,ShiftedSenkouspanBArr_H1);

      CopyBuffer(handleIchimoku_H1,4,26,3,ChikouspanArr_H1);

      double KumoDeltaCurrent_H1 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_H1[2] - ShiftedSenkouspanBArr_H1[2]),symbolDigits);
      double KumoDeltaPrevious_H1 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_H1[0] - ShiftedSenkouspanBArr_H1[0]),symbolDigits);

      if(
         (
            ClosePrice_D1 > SenkouspanAArr_D1[2] &&
            ClosePrice_D1 > SenkouspanBArr_D1[2] &&
            ClosePrice_D1 > KijunsenArr_D1[2] &&
            TenkansenArr_D1[1] > KijunsenArr_D1[1] &&
            TenkansenArr_D1[0] > KijunsenArr_D1[0] &&
            KijunsenArr_D1[1] > KijunsenArr_D1[0] &&
            ShiftedSenkouspanAArr_D1[1] > ShiftedSenkouspanBArr_D1[1] &&
            ShiftedSenkouspanAArr_D1[1] > ShiftedSenkouspanAArr_D1[0] &&
            ChikouspanArr_D1[0] > Bar26High_D1 &&
            KumoDeltaCurrent_D1 > KumoDeltaPrevious_D1
         ) &&
         (
            ClosePrice_H1 > SenkouspanAArr_H1[2] &&
            ClosePrice_H1 > SenkouspanBArr_H1[2] &&
            ClosePrice_H1 > KijunsenArr_H1[2] &&
            TenkansenArr_H1[1] > KijunsenArr_H1[1] &&
            TenkansenArr_H1[0] > KijunsenArr_H1[0] &&
            KijunsenArr_H1[1] > KijunsenArr_H1[0] &&
            ShiftedSenkouspanAArr_H1[1] > ShiftedSenkouspanBArr_H1[1] &&
            ShiftedSenkouspanAArr_H1[1] > ShiftedSenkouspanAArr_H1[0] &&
            ChikouspanArr_H1[0] > Bar26High_H1 &&
            KumoDeltaCurrent_H1 > KumoDeltaPrevious_H1
         )
      )
        {
         Print(SymbolName(i, true)," is Bullish on D1 and H1");
        }
      else
         if(
            (
               ClosePrice_D1 < SenkouspanAArr_D1[2] &&
               ClosePrice_D1 < SenkouspanBArr_D1[2] &&
               ClosePrice_D1 < KijunsenArr_D1[2] &&
               TenkansenArr_D1[1] < KijunsenArr_D1[1] &&
               TenkansenArr_D1[0] < KijunsenArr_D1[0] &&
               KijunsenArr_D1[1] < KijunsenArr_D1[0] &&
               ShiftedSenkouspanAArr_D1[1] < ShiftedSenkouspanBArr_D1[1] &&
               ShiftedSenkouspanAArr_D1[1] < ShiftedSenkouspanAArr_D1[0] &&
               ChikouspanArr_D1[0] < Bar26High_D1 &&
               KumoDeltaCurrent_D1 > KumoDeltaPrevious_D1
            ) &&
            (
               ClosePrice_H1 < SenkouspanAArr_H1[2] &&
               ClosePrice_H1 < SenkouspanBArr_H1[2] &&
               ClosePrice_H1 < KijunsenArr_H1[2] &&
               TenkansenArr_H1[1] < KijunsenArr_H1[1] &&
               TenkansenArr_H1[0] < KijunsenArr_H1[0] &&
               KijunsenArr_H1[1] < KijunsenArr_H1[0] &&
               ShiftedSenkouspanAArr_H1[1] < ShiftedSenkouspanBArr_H1[1] &&
               ShiftedSenkouspanAArr_H1[1] < ShiftedSenkouspanAArr_H1[0] &&
               ChikouspanArr_H1[0] < Bar26High_H1 &&
               KumoDeltaCurrent_H1 > KumoDeltaPrevious_H1
            )
         )
           {
            Print(SymbolName(i, true)," is Bearish on D1 and H1");
           }



      // H4 && M30
      // H4
      int handleIchimoku_H4 = iIchimoku(SymbolName(i, true),PERIOD_H4,9,26,52);
      double ClosePrice_H4 = iClose(SymbolName(i, true),PERIOD_H4,1);
      double Bar26High_H4 = iHigh(SymbolName(i, true),PERIOD_H4,26);
      double Bar26Low_H4 = iLow(SymbolName(i, true),PERIOD_H4,26);
      double TenkansenArr_H4[];
      double KijunsenArr_H4[];
      double SenkouspanAArr_H4[];
      double SenkouspanBArr_H4[];
      double ShiftedSenkouspanAArr_H4[];
      double ShiftedSenkouspanBArr_H4[];
      double ChikouspanArr_H4[];

      CopyBuffer(handleIchimoku_H4,0,0,3,TenkansenArr_H4);
      CopyBuffer(handleIchimoku_H4,1,0,3,KijunsenArr_H4);
      CopyBuffer(handleIchimoku_H4,2,0,3,SenkouspanAArr_H4);
      CopyBuffer(handleIchimoku_H4,3,0,3,SenkouspanBArr_H4);

      CopyBuffer(handleIchimoku_H4,2,-26,3,ShiftedSenkouspanAArr_H4);
      CopyBuffer(handleIchimoku_H4,3,-26,3,ShiftedSenkouspanBArr_H4);

      CopyBuffer(handleIchimoku_H4,4,26,3,ChikouspanArr_H4);

      double KumoDeltaCurrent_H4 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_H4[2] - ShiftedSenkouspanBArr_H4[2]),symbolDigits);
      double KumoDeltaPrevious_H4 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_H4[0] - ShiftedSenkouspanBArr_H4[0]),symbolDigits);

      // M30
      int handleIchimoku_M30 = iIchimoku(SymbolName(i, true),PERIOD_M30,9,26,52);
      double ClosePrice_M30 = iClose(SymbolName(i, true),PERIOD_M30,1);
      double Bar26High_M30 = iHigh(SymbolName(i, true),PERIOD_M30,26);
      double Bar26Low_M30 = iLow(SymbolName(i, true),PERIOD_M30,26);
      double TenkansenArr_M30[];
      double KijunsenArr_M30[];
      double SenkouspanAArr_M30[];
      double SenkouspanBArr_M30[];
      double ShiftedSenkouspanAArr_M30[];
      double ShiftedSenkouspanBArr_M30[];
      double ChikouspanArr_M30[];

      CopyBuffer(handleIchimoku_M30,0,0,3,TenkansenArr_M30);
      CopyBuffer(handleIchimoku_M30,1,0,3,KijunsenArr_M30);
      CopyBuffer(handleIchimoku_M30,2,0,3,SenkouspanAArr_M30);
      CopyBuffer(handleIchimoku_M30,3,0,3,SenkouspanBArr_M30);

      CopyBuffer(handleIchimoku_M30,2,-26,3,ShiftedSenkouspanAArr_M30);
      CopyBuffer(handleIchimoku_M30,3,-26,3,ShiftedSenkouspanBArr_M30);

      CopyBuffer(handleIchimoku_M30,4,26,3,ChikouspanArr_M30);

      double KumoDeltaCurrent_M30 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_M30[2] - ShiftedSenkouspanBArr_M30[2]),symbolDigits);
      double KumoDeltaPrevious_M30 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_M30[0] - ShiftedSenkouspanBArr_M30[0]),symbolDigits);

      if(
         (
            ClosePrice_H4 > SenkouspanAArr_H4[2] &&
            ClosePrice_H4 > SenkouspanBArr_H4[2] &&
            ClosePrice_H4 > KijunsenArr_H4[2] &&
            TenkansenArr_H4[1] > KijunsenArr_H4[1] &&
            TenkansenArr_H4[0] > KijunsenArr_H4[0] &&
            KijunsenArr_H4[1] > KijunsenArr_H4[0] &&
            ShiftedSenkouspanAArr_H4[1] > ShiftedSenkouspanBArr_H4[1] &&
            ShiftedSenkouspanAArr_H4[1] > ShiftedSenkouspanAArr_H4[0] &&
            ChikouspanArr_H4[0] > Bar26High_H4 &&
            KumoDeltaCurrent_H4 > KumoDeltaPrevious_H4
         ) &&
         (
            ClosePrice_M30 > SenkouspanAArr_M30[2] &&
            ClosePrice_M30 > SenkouspanBArr_M30[2] &&
            ClosePrice_M30 > KijunsenArr_M30[2] &&
            TenkansenArr_M30[1] > KijunsenArr_M30[1] &&
            TenkansenArr_M30[0] > KijunsenArr_M30[0] &&
            KijunsenArr_M30[1] > KijunsenArr_M30[0] &&
            ShiftedSenkouspanAArr_M30[1] > ShiftedSenkouspanBArr_M30[1] &&
            ShiftedSenkouspanAArr_M30[1] > ShiftedSenkouspanAArr_M30[0] &&
            ChikouspanArr_M30[0] > Bar26High_M30 &&
            KumoDeltaCurrent_M30 > KumoDeltaPrevious_M30
         )
      )
        {
         Print(SymbolName(i, true)," is Bullish on H4 and M30");
        }
      else
         if(
            (
               ClosePrice_H4 < SenkouspanAArr_H4[2] &&
               ClosePrice_H4 < SenkouspanBArr_H4[2] &&
               ClosePrice_H4 < KijunsenArr_H4[2] &&
               TenkansenArr_H4[1] < KijunsenArr_H4[1] &&
               TenkansenArr_H4[0] < KijunsenArr_H4[0] &&
               KijunsenArr_H4[1] < KijunsenArr_H4[0] &&
               ShiftedSenkouspanAArr_H4[1] < ShiftedSenkouspanBArr_H4[1] &&
               ShiftedSenkouspanAArr_H4[1] < ShiftedSenkouspanAArr_H4[0] &&
               ChikouspanArr_H4[0] < Bar26High_H4 &&
               KumoDeltaCurrent_H4 > KumoDeltaPrevious_H4
            ) &&
            (
               ClosePrice_M30 < SenkouspanAArr_M30[2] &&
               ClosePrice_M30 < SenkouspanBArr_M30[2] &&
               ClosePrice_M30 < KijunsenArr_M30[2] &&
               TenkansenArr_M30[1] < KijunsenArr_M30[1] &&
               TenkansenArr_M30[0] < KijunsenArr_M30[0] &&
               KijunsenArr_M30[1] < KijunsenArr_M30[0] &&
               ShiftedSenkouspanAArr_M30[1] < ShiftedSenkouspanBArr_M30[1] &&
               ShiftedSenkouspanAArr_M30[1] < ShiftedSenkouspanAArr_M30[0] &&
               ChikouspanArr_M30[0] < Bar26High_M30 &&
               KumoDeltaCurrent_M30 > KumoDeltaPrevious_M30
            )
         )
           {
            Print(SymbolName(i, true)," is Bearish on H4 and M30");
           }



      // H1 && M15
      // H1 : All parameters for H1 have already been defined for D1 - H1 conditions

      // M30
      int handleIchimoku_M15 = iIchimoku(SymbolName(i, true),PERIOD_M15,9,26,52);
      double ClosePrice_M15 = iClose(SymbolName(i, true),PERIOD_M15,1);
      double Bar26High_M15 = iHigh(SymbolName(i, true),PERIOD_M15,26);
      double Bar26Low_M15 = iLow(SymbolName(i, true),PERIOD_M15,26);
      double TenkansenArr_M15[];
      double KijunsenArr_M15[];
      double SenkouspanAArr_M15[];
      double SenkouspanBArr_M15[];
      double ShiftedSenkouspanAArr_M15[];
      double ShiftedSenkouspanBArr_M15[];
      double ChikouspanArr_M15[];

      CopyBuffer(handleIchimoku_M15,0,0,3,TenkansenArr_M15);
      CopyBuffer(handleIchimoku_M15,1,0,3,KijunsenArr_M15);
      CopyBuffer(handleIchimoku_M15,2,0,3,SenkouspanAArr_M15);
      CopyBuffer(handleIchimoku_M15,3,0,3,SenkouspanBArr_M15);

      CopyBuffer(handleIchimoku_M15,2,-26,3,ShiftedSenkouspanAArr_M15);
      CopyBuffer(handleIchimoku_M15,3,-26,3,ShiftedSenkouspanBArr_M15);

      CopyBuffer(handleIchimoku_M15,4,26,3,ChikouspanArr_M15);

      double KumoDeltaCurrent_M15 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_M15[2] - ShiftedSenkouspanBArr_M15[2]),symbolDigits);
      double KumoDeltaPrevious_M15 = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr_M15[0] - ShiftedSenkouspanBArr_M15[0]),symbolDigits);

      if(
         (
            ClosePrice_H1 > SenkouspanAArr_H1[2] &&
            ClosePrice_H1 > SenkouspanBArr_H1[2] &&
            ClosePrice_H1 > KijunsenArr_H1[2] &&
            TenkansenArr_H1[1] > KijunsenArr_H1[1] &&
            TenkansenArr_H1[0] > KijunsenArr_H1[0] &&
            KijunsenArr_H1[1] > KijunsenArr_H1[0] &&
            ShiftedSenkouspanAArr_H1[1] > ShiftedSenkouspanBArr_H1[1] &&
            ShiftedSenkouspanAArr_H1[1] > ShiftedSenkouspanAArr_H1[0] &&
            ChikouspanArr_H1[0] > Bar26High_H1 &&
            KumoDeltaCurrent_H1 > KumoDeltaPrevious_H1
         ) &&
         (
            ClosePrice_M15 > SenkouspanAArr_M15[2] &&
            ClosePrice_M15 > SenkouspanBArr_M15[2] &&
            ClosePrice_M15 > KijunsenArr_M15[2] &&
            TenkansenArr_M15[1] > KijunsenArr_M15[1] &&
            TenkansenArr_M15[0] > KijunsenArr_M15[0] &&
            KijunsenArr_M15[1] > KijunsenArr_M15[0] &&
            ShiftedSenkouspanAArr_M15[1] > ShiftedSenkouspanBArr_M15[1] &&
            ShiftedSenkouspanAArr_M15[1] > ShiftedSenkouspanAArr_M15[0] &&
            ChikouspanArr_M15[0] > Bar26High_M15 &&
            KumoDeltaCurrent_M15 > KumoDeltaPrevious_M15
         )
      )
        {
         Print(SymbolName(i, true)," is Bullish on H1 and M15");
        }
      else
         if(
            (
               ClosePrice_H1 < SenkouspanAArr_H1[2] &&
               ClosePrice_H1 < SenkouspanBArr_H1[2] &&
               ClosePrice_H1 < KijunsenArr_H1[2] &&
               TenkansenArr_H1[1] < KijunsenArr_H1[1] &&
               TenkansenArr_H1[0] < KijunsenArr_H1[0] &&
               KijunsenArr_H1[1] < KijunsenArr_H1[0] &&
               ShiftedSenkouspanAArr_H1[1] < ShiftedSenkouspanBArr_H1[1] &&
               ShiftedSenkouspanAArr_H1[1] < ShiftedSenkouspanAArr_H1[0] &&
               ChikouspanArr_H1[0] < Bar26High_H1 &&
               KumoDeltaCurrent_H1 > KumoDeltaPrevious_H1
            ) &&
            (
               ClosePrice_M15 < SenkouspanAArr_M15[2] &&
               ClosePrice_M15 < SenkouspanBArr_M15[2] &&
               ClosePrice_M15 < KijunsenArr_M15[2] &&
               TenkansenArr_M15[1] < KijunsenArr_M15[1] &&
               TenkansenArr_M15[0] < KijunsenArr_M15[0] &&
               KijunsenArr_M15[1] < KijunsenArr_M15[0] &&
               ShiftedSenkouspanAArr_M15[1] < ShiftedSenkouspanBArr_M15[1] &&
               ShiftedSenkouspanAArr_M15[1] < ShiftedSenkouspanAArr_M15[0] &&
               ChikouspanArr_M15[0] < Bar26High_M15 &&
               KumoDeltaCurrent_M15 > KumoDeltaPrevious_M15
            )
         )
           {
            Print(SymbolName(i, true)," is Bearish on H1 and M15");
           }


     } // for loop

   Print("Scanning Finished...");

  }




//+------------------------------------------------------------------+
//| Event handler for "Open Charts" Button                           |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickOpenChartsBtn(void)
  {
   CChart chart;

   string currentChartSymbol = _Symbol;
   const int n = SymbolsTotal(true);

   for(int i = 0; i < n; ++i)
      if(SymbolName(i, true) != currentChartSymbol)
         chart.Open(SymbolName(i, true),PERIOD_CURRENT);
   Print(n, " Charts Opened...");
  }


//+------------------------------------------------------------------+
//| Event handler for "Open Active Charts" Button                    |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickOpenActiveChartsBtn(void)
  {
   CChart chart;

   int totalPos = PositionsTotal();

   string sym;

   for(int i = 0; i < totalPos; i++)
     {
      ulong posTicket = PositionGetTicket(i);
      sym = PositionGetString(POSITION_SYMBOL);

      bool   found = false;
      long   ID    = ChartFirst();
      while(ID>=0)
        {
         if(ChartSymbol(ID)==sym)
           {
            found=true;
            break;
           }
         ID=ChartNext(ID);
        }
      if(!found)
        {
         ChartOpen(sym,PERIOD_CURRENT);
        }

     }

  }




//+------------------------------------------------------------------+
//| Event handler for "Open Charts" Button                           |
//+------------------------------------------------------------------+
void CControlsDialog::OnClickCloseChartsBtn(void)
  {
   string cs = ChartSymbol();
   long chid=ChartFirst();

   while(chid >= 0)
     {
      long nextID = ChartNext(chid);
      if(ChartSymbol(chid)!=cs)
         ChartClose(chid);
      chid = nextID;
     }
   Print(" Charts Closed...");
  }










//+------------------------------------------------------------------+
//|         -------- END OF EVENT HANDLERS --------------            |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
CControlsDialog ExtDialog;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   StrategySelected = EnumToString(StrategySelect);
   ObjectDelete(0,"priceLine");
   ObjectDelete(0,"stopLossLine");
   ObjectDelete(0,"takeProfitLine");

//--- create application dialog
   if(showEAComment) // here if is used to move the panel to the right in case if the comments are engaged
     {
      if(!ExtDialog.Create(0,captionString,0,210,0,670,200))
         return(INIT_FAILED);
     }
   else
     {
      if(!ExtDialog.Create(0,captionString,0,0,15,460,215))
         return(INIT_FAILED);
     }


//--- run application
   ExtDialog.Run();

// Auto Position Management EA initialization

   if(fractalsTSL)
      barCountFractals = 0;

   if(movingAverageTSL)
      handleMA = iMA(_Symbol, TimeFrame, MaPeriod, MaShift, TslMaMethod, TslMaAppPrice);

   if(kijunsenTSL || tenkansenTSL || ClosePosTenkansen || SignalTenkansenBreak || useIchimokuFilter)
      handleIchimoku = iIchimoku(_Symbol,TimeFrame,9,26,52);

   if(ClosePosMa)
      handleClosePosMA = iMA(_Symbol, TimeFrame, ClosePosMaPeriod, ClosePosMaShift, ClosePosMaMethod, ClosePosMaAppPrice);

   if(wiseMenAlertsToggle || wiseMan1PermanentToggle || wiseMan2PermanentToggle || wiseMan3PermanentToggle)
     {
      handleATR = iATR(_Symbol,TimeFrame,atrPeriod);
      handleAlligator = iAlligator(_Symbol,TimeFrame,13*alligatorMultiplier,8*alligatorMultiplier,8*alligatorMultiplier,5*alligatorMultiplier,5*alligatorMultiplier,3*alligatorMultiplier,MODE_SMMA,PRICE_MEDIAN);
      handleAwesomeOscillator = iAO(_Symbol,TimeFrame);
     }

   if(threeLinesStrikeActivate)
     {
      handleFast3LSMA = iMA(_Symbol,TimeFrame,FastMaPeriod3LS,FastMaShift3LS,FastMaMethod3LS,FastMaAppPrice3LS);
      handleMiddle3LSMA = iMA(_Symbol,TimeFrame,MiddleMaPeriod3LS,MiddleMaShift3LS,MiddleMaMethod3LS,MiddleMaAppPrice3LS);
      handleSlow3LSMA = iMA(_Symbol,TimeFrame,SlowMaPeriod3LS,SlowMaShift3LS,SlowMaMethod3LS,SlowMaAppPrice3LS);
     }

   if(MABreak)
     {
      handleMABreak = iMA(_Symbol,TimeFrame,MABreakPeriod,MABreakShift,MABreakMethod,MABreakPrice);
      handleAlligatorMABreak = iAlligator(_Symbol,TimeFrame,13*alligatorMultiplier,8*alligatorMultiplier,8*alligatorMultiplier,5*alligatorMultiplier,5*alligatorMultiplier,3*alligatorMultiplier,MODE_SMMA,PRICE_MEDIAN);
     }



   if(useAlligatorFilter)
     {
      handleAlligatorFilter = iAlligator(_Symbol,TimeFrame,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN);
     }



   if(useAOFilter)
     {
      handleAOFilter = iAO(_Symbol,TimeFrame);
     }

   if(useACFilter)
     {
      handleACFilter = iAC(_Symbol,TimeFrame);
     }

   if(useMAFilter)
     {
      handleMAFilter = iMA(_Symbol,TimeFrame,MaFilterPeriod,MaFilterShift,MaFilterMethod,MaFilterAppPrice);
     }

   if(use3xMAFilter)
     {
      handleMA1Filter = iMA(_Symbol,TimeFrame,Ma1FilterPeriod,Ma1FilterShift,Ma3xFilterMethod,Ma3xFilterAppPrice);
      handleMA2Filter = iMA(_Symbol,TimeFrame,Ma2FilterPeriod,Ma2FilterShift,Ma3xFilterMethod,Ma3xFilterAppPrice);
      handleMA3Filter = iMA(_Symbol,TimeFrame,Ma3FilterPeriod,Ma3FilterShift,Ma3xFilterMethod,Ma3xFilterAppPrice);
     }


   if(soFilter)
     {
      handleSOFilter = iStochastic(_Symbol,TimeFrame,soKPeriod,soDPeriod,soSlowing,MODE_SMA,STO_LOWHIGH);
     }

   if(rsiMAFilter || RSIMAAlert)
     {
      handleRSIFilter = iRSI(_Symbol,TimeFrame,rsiMA_RSI_Range,PRICE_CLOSE);
      handleRSIMAFilter = iMA(_Symbol,TimeFrame,rsiMA_MA_Range,rsiMA_MA_Shift,rsiMA_MA_Method,handleRSIFilter);
     }


   if(MACDAlert)
     {
      handleMACD = iMACD(_Symbol,TimeFrame,12,26,9,PRICE_CLOSE);
     }


//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- clear comments
   Comment("");
   ObjectDelete(0,"priceLine");
   ObjectDelete(0,"stopLossLine");
   ObjectDelete(0,"takeProfitLine");

//--- destroy dialog
   ExtDialog.Destroy(reason);
   ObjectsDeleteAll(0,-1,OBJ_LABEL); // patch to remove residual labels


  }

//-------------------------------------------------------------------+
//| Expert chart event function                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam) // event parameter of the string type
  {
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);

// FEATURE UNDER CONSTRUCTION
//recalculates position parameters automatically when the SL line is moved on the chart
   if(id==CHARTEVENT_OBJECT_DRAG)
     {
      if(sparam == "stopLossLine")
        {
         inputStopLoss = NormalizeDouble(ObjectGetDouble(0,"stopLossLine",OBJPROP_PRICE),_Digits);
         double inputLineRRR = StringToDouble(ObjectGetString(0,ExtDialog.Name()+"RRR",OBJPROP_TEXT));
         double newInputTakeProfit = 0;
         if(inputStopLoss < inputTakeProfit) // buy
           {
            double input_line_ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK); // buy
            newInputTakeProfit = (input_line_ask - inputStopLoss) * inputLineRRR + input_line_ask;

           }
         else
            if(inputStopLoss > inputTakeProfit) // sell
              {
               double input_line_bid = SymbolInfoDouble(_Symbol,SYMBOL_BID); // sell
               newInputTakeProfit = input_line_bid - (inputStopLoss - input_line_bid) * inputLineRRR;
              }

         ObjectSetString(0,ExtDialog.Name()+"SlEdit",OBJPROP_TEXT,DoubleToString(inputStopLoss,_Digits));
         ObjectSetString(0,ExtDialog.Name()+"TpEdit",OBJPROP_TEXT,DoubleToString(newInputTakeProfit,_Digits));
         ObjectSetDouble(0,"takeProfitLine",OBJPROP_PRICE,newInputTakeProfit);

        }

     }
// END OF FEATURE UNDER CONSTRUCTION

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   textComment = "";
   debugComment = "";


// sand box
   if(debuggingComments)
     {
      //fractalsTrendFilterBull();
      //fractalsTrendFilterBear();
      //StochasticOscillatorFilterBull();
      //StochasticOscillatorFilterBear();
      //RSI_MA_FilterBull();
      //RSI_MA_FilterBear();
      //MA_FilterBull();
      //MA_FilterBear();
      //AO_FilterBull();
      //AO_FilterBear();
      //AC_FilterBull();
      //AC_FilterBear();
      //Alligator_FilterBull();
      //Alligator_FilterBear();
      //Ichimoku_FilterBull();
      //Ichimoku_FilterBear();
     }



// end of sand box

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Show total risk value in Caption ------------------------ |
//|                                                                  |
//+------------------------------------------------------------------+

   if(showTotalRiskCurrent)
     {
      string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
      double TotalRiskVolume = calculateVaR();
      double accountBallance = AccountInfoDouble(ACCOUNT_BALANCE);
      double percentAtRisk = 0;
      if(accountBallance > 0)
         percentAtRisk = NormalizeDouble(TotalRiskVolume / accountBallance * 100,2);

      captionString += "AR TPanel | " + _Symbol + " | TF " + IntegerToString(TimeFrame) + " | Total VaR: " + accountCurrency + " " + DoubleToString(TotalRiskVolume,2) + " | " + DoubleToString(percentAtRisk,2) + " % | " + IntegerToString(VaRfilterGo(maxVARFiltervalue));
      ObjectSetString(0,ExtDialog.Name()+"Caption",OBJPROP_TEXT,captionString);
      captionString = "";

      textComment += "\nTotalRiskVolume = " + DoubleToString(TotalRiskVolume,2) + " \n";
      textComment += "\npercentAtRisk = " + DoubleToString(percentAtRisk,2) + " \n";
      textComment += "maxVARFiltervalue = " + DoubleToString(maxVARFiltervalue,2) + " \n";
      textComment += "percentAtRisk < maxVARFiltervalue = [ " + IntegerToString(percentAtRisk < maxVARFiltervalue) + " ]\n";
      textComment += "VaRfilterGo(maxVARFiltervalue) = [ " + IntegerToString(VaRfilterGo(maxVARFiltervalue)) + " ]\n";
     }

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- End of Show total risk value in Caption ----------------- |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Handling MA Break Alert --------------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+

   if(Period() == TimeFrame)
     {

      if(VaRfilterGo(maxVARFiltervalue))
        {
         if(MABreak)
           {
            int bars = iBars(_Symbol, TimeFrame);

            if(barsTotal != bars) // New bar appeared on the chart
              {
               barsTotal = bars;

               double ClosePrevBarMABreak = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price
               double ClosePrPrevBarMABreak = NormalizeDouble(iClose(_Symbol,TimeFrame,2),_Digits); // pre previous close price

               double MABreakArr[];
               CopyBuffer(handleMABreak,MAIN_LINE,1,2,MABreakArr);
               ArraySetAsSeries(MABreakArr,true);
               double MABreakPrevBar = NormalizeDouble(MABreakArr[0],_Digits); // Moving Average of previous bar
               double MABreakPrPrevBar = NormalizeDouble(MABreakArr[1],_Digits); // Moving Average of pre previous bar

               bool MABreakAlligatorUp = true;
               bool MABreakAlligatorDn = true;

               if(MABreakUseAlligatorFilter)
                 {
                  MABreakAlligatorUp = false;
                  MABreakAlligatorDn = false;

                  double alligatorLipsEndArr[];
                  double alligatorTeethEndArr[];
                  double alligatorJawEndArr[];

                  ArraySetAsSeries(alligatorLipsEndArr,true);
                  ArraySetAsSeries(alligatorTeethEndArr,true);
                  ArraySetAsSeries(alligatorJawEndArr,true);

                  CopyBuffer(handleAlligatorMABreak,2,-4*alligatorMultiplierMABreak,8,alligatorLipsEndArr);
                  CopyBuffer(handleAlligatorMABreak,1,-6*alligatorMultiplierMABreak,8,alligatorTeethEndArr);
                  CopyBuffer(handleAlligatorMABreak,0,-9*alligatorMultiplierMABreak,8,alligatorJawEndArr);

                  if(alligatorLipsEndArr[0] > alligatorTeethEndArr[0] && alligatorTeethEndArr[0] > alligatorJawEndArr[0])
                    {
                     MABreakAlligatorUp = true;
                     MABreakAlligatorDn = false;
                    }
                  else
                     if(alligatorLipsEndArr[0] < alligatorTeethEndArr[0] && alligatorTeethEndArr[0] < alligatorJawEndArr[0])
                       {
                        MABreakAlligatorUp = false;
                        MABreakAlligatorDn = true;
                       }
                 }

               // Using filter to filter out signals for currency pairs which contain one of the parts of the pair for which we have an open position already
               if(useSymmetricalPositionFilter && SymmetricalPositionFilter(_Symbol))
                 {
                  Print("Rejecting MA Breakout signal on ",_Symbol," because symmetrical position is open already...");
                  MABreakAlligatorUp = false;
                  MABreakAlligatorDn = false;
                 }

               // Using filter to filter out signals for instrumentis which already have open positions
               if(useOpenPositionFilter && OpenPositionFilter(_Symbol))
                 {
                  Print("Rejecting MA Breakout signal on ",_Symbol," because this instrument has an open position already");
                  MABreakAlligatorUp = false;
                  MABreakAlligatorDn = false;
                 }

               // --------------------
               // --- BUY POSITION ---
               // --------------------
               if(ClosePrPrevBarMABreak < MABreakPrPrevBar && ClosePrevBarMABreak > MABreakPrevBar && MABreakAlligatorUp)
                 {
                  Alert(_Symbol," === MOVING AVERAGE BREAK ALERT === BULLISH");
                 }

               // --------------------
               // --- SELL POSITION --
               // --------------------
               else
                  if(ClosePrPrevBarMABreak > MABreakPrPrevBar && ClosePrevBarMABreak < MABreakPrevBar && MABreakAlligatorDn)
                    {
                     Alert(_Symbol," === MOVING AVERAGE BREAK ALERT === BEARISH");
                    }
              }

           } //    if(MABreak)


         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of Handling MA Break Alert -------------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- Handling 3 Lines Strike Alert --------------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(threeLinesStrikeActivate)
           {
            int bars = iBars(_Symbol, TimeFrame);

            if(barsTotal != bars) // New bar appeared on the chart
              {
               barsTotal = bars;
               double ToleranceOpenCoef = ToleranceOpenPercent / 100;
               double ToleranceCloseCoef = ToleranceClosePercent / 100;
               bool strike_up=false;
               bool strike_dn=false;
               bool priceUnderMa = false;
               bool priceAboveMA = false;

               // Strike UP
               double closeUP = iClose(_Symbol,TimeFrame,1) + (iClose(_Symbol,TimeFrame,1) - iOpen(_Symbol,TimeFrame,1)) * ToleranceCloseCoef;
               double openUP = iOpen(_Symbol,TimeFrame,1) - (iClose(_Symbol,TimeFrame,1) - iOpen(_Symbol,TimeFrame,1)) * ToleranceCloseCoef;

               if(
                  closeUP >= MathMax(iClose(_Symbol,TimeFrame,2), MathMax(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  closeUP >= MathMax(iOpen(_Symbol,TimeFrame,2), MathMax(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  closeUP >= MathMin(iOpen(_Symbol,TimeFrame,2), MathMin(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4)))&&
                  openUP <= MathMin(iClose(_Symbol,TimeFrame,2), MathMin(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  openUP <= MathMax(iClose(_Symbol,TimeFrame,2), MathMax(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  openUP <= MathMin(iOpen(_Symbol,TimeFrame,2), MathMin(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  openUP <= MathMax(iOpen(_Symbol,TimeFrame,2), MathMax(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  openUP <= closeUP &&
                  RSI_MA_FilterBull()
               )
                 {
                  strike_up = true;

                  // checking if strict rule is on
                  if(EngulfingModeStrict && !(iOpen(_Symbol,TimeFrame,2) >= iClose(_Symbol,TimeFrame,2) && iOpen(_Symbol,TimeFrame,3) >= iClose(_Symbol,TimeFrame,3) && iOpen(_Symbol,TimeFrame,4) >= iClose(_Symbol,TimeFrame,4)))
                    {
                     strike_up = false;
                    }
                 }

               // Strike DN
               double closeDN = iClose(_Symbol,TimeFrame,1) - (iOpen(_Symbol,TimeFrame,1) - iClose(_Symbol,TimeFrame,1)) * ToleranceCloseCoef;
               double openDN = iOpen(_Symbol,TimeFrame,1) + (iOpen(_Symbol,TimeFrame,1) - iClose(_Symbol,TimeFrame,1)) * ToleranceCloseCoef;

               if(closeDN <= MathMax(iClose(_Symbol,TimeFrame,2), MathMax(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  closeDN <= MathMax(iOpen(_Symbol,TimeFrame,2), MathMax(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  closeDN <= MathMin(iOpen(_Symbol,TimeFrame,2), MathMin(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  openDN >= MathMin(iClose(_Symbol,TimeFrame,2), MathMin(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  openDN >= MathMax(iClose(_Symbol,TimeFrame,2), MathMax(iClose(_Symbol,TimeFrame,3), iClose(_Symbol,TimeFrame,4))) &&
                  openDN >= MathMin(iOpen(_Symbol,TimeFrame,2), MathMin(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  openDN >= MathMax(iOpen(_Symbol,TimeFrame,2), MathMax(iOpen(_Symbol,TimeFrame,3), iOpen(_Symbol,TimeFrame,4))) &&
                  openDN >= closeDN &&
                  RSI_MA_FilterBear()
                 )
                 {
                  strike_dn = true;

                  // checking if strict rule is on

                  if(EngulfingModeStrict && !(iOpen(_Symbol,TimeFrame,2) <= iClose(_Symbol,TimeFrame,2) && iOpen(_Symbol,TimeFrame,3) <= iClose(_Symbol,TimeFrame,3) && iOpen(_Symbol,TimeFrame,4) <= iClose(_Symbol,TimeFrame,4)))
                    {
                     strike_dn = false;
                    }
                 }

               // --- checking that the engulfed candles are shorter than the engulfing candle

               double mainCandleBodyLength = MathAbs(iOpen(_Symbol,TimeFrame,1) - iClose(_Symbol,TimeFrame,1));
               double firstCandleBodyLength = MathAbs(iOpen(_Symbol,TimeFrame,2) - iClose(_Symbol,TimeFrame,2));
               double secondCandleBodyLength = MathAbs(iOpen(_Symbol,TimeFrame,3) - iClose(_Symbol,TimeFrame,3));
               double thirdCandleBodyLength = MathAbs(iOpen(_Symbol,TimeFrame,4) - iClose(_Symbol,TimeFrame,4));

               if(mainCandleBodyLength < firstCandleBodyLength || mainCandleBodyLength < secondCandleBodyLength || mainCandleBodyLength < thirdCandleBodyLength)
                 {
                  strike_up = false;
                  strike_dn = false;
                 }

               if(useMAFilter3LS)
                 {
                  priceAboveMA = false;
                  priceUnderMa = false;

                  double ClosePrevBar3LS = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price

                  double FastMa3LSArr[];
                  CopyBuffer(handleFast3LSMA,MAIN_LINE,1,1,FastMa3LSArr);
                  ArraySetAsSeries(FastMa3LSArr,true);
                  double FastMa3LSArrPrevBar = NormalizeDouble(FastMa3LSArr[0],_Digits);

                  double MiddleMa3LSArr[];
                  CopyBuffer(handleMiddle3LSMA,MAIN_LINE,1,1,MiddleMa3LSArr);
                  ArraySetAsSeries(MiddleMa3LSArr,true);
                  double MiddleMa3LSArrPrevBar = NormalizeDouble(MiddleMa3LSArr[0],_Digits);

                  double SlowMa3LSArr[];
                  CopyBuffer(handleSlow3LSMA,MAIN_LINE,1,1,SlowMa3LSArr);
                  ArraySetAsSeries(SlowMa3LSArr,true);
                  double SlowMa3LSArrPrevBar = NormalizeDouble(SlowMa3LSArr[0],_Digits);

                  if(ClosePrevBar3LS > FastMa3LSArrPrevBar && FastMa3LSArrPrevBar > MiddleMa3LSArrPrevBar && MiddleMa3LSArrPrevBar > SlowMa3LSArrPrevBar)
                    {
                     priceAboveMA = true;
                     priceUnderMa = false;
                    }
                  else
                     if(ClosePrevBar3LS < FastMa3LSArrPrevBar && FastMa3LSArrPrevBar < MiddleMa3LSArrPrevBar && MiddleMa3LSArrPrevBar < SlowMa3LSArrPrevBar)
                       {
                        priceUnderMa = true;
                        priceAboveMA = false;
                       }
                 }
               else
                  if(!useMAFilter3LS)
                    {
                     priceAboveMA = true;
                     priceUnderMa = true;
                    }

               if(strike_up && priceAboveMA)
                  Alert("=== 3 LINES STRIKE ALERT === STRIKE UP === MA Filter is: ",IntegerToString(useMAFilter3LS));
               else
                  if(strike_dn && priceUnderMa)
                     Alert("=== 3 LINES STRIKE ALERT === STRIKE DOWN === MA Filter is: ",IntegerToString(useMAFilter3LS));

              }
           } //   if(threeLinesStrikeActivate)

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of Handling 3 Lines Strike Alert -------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+


         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- Handling Divergent Bar Alert WM1 ------------------------ |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(wm1AlertToggle || wiseMan1PermanentToggle)
           {
            int bars = iBars(_Symbol, TimeFrame);
            if(barsTotal != bars) // New bar appeared on the chart
              {
               barsTotal = bars;

               //getting previous bar Close Open Low High values
               double closePrevBar = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits);
               double openPrevBar = NormalizeDouble(iOpen(_Symbol,TimeFrame,1),_Digits);
               double lowPrevBar = NormalizeDouble(iLow(_Symbol,TimeFrame,1),_Digits);
               double highPrevBar = NormalizeDouble(iHigh(_Symbol,TimeFrame,1),_Digits);

               double upperWickPrevBar = 0;
               double lowerWickPrevBar = 0;
               double bodyPrevBar = 0;
               double distanceToTeethPrevBar = 0;

               double atrPrevBarArr[];
               double alligatorTeethPrevBarArr[];

               CopyBuffer(handleATR,0,0,2,atrPrevBarArr);
               CopyBuffer(handleAlligator,1,0,2,alligatorTeethPrevBarArr);

               double atrPrevBar = NormalizeDouble(atrPrevBarArr[1],_Digits);
               double alligatorTeethPrevBar = alligatorTeethPrevBarArr[1];

               if(closePrevBar > openPrevBar)  // Bullish bar
                 {
                  upperWickPrevBar = NormalizeDouble(highPrevBar - closePrevBar,_Digits);
                  lowerWickPrevBar = NormalizeDouble(openPrevBar - lowPrevBar,_Digits);
                  bodyPrevBar = NormalizeDouble(closePrevBar - openPrevBar,_Digits);
                 }
               else
                  if(closePrevBar <= openPrevBar) // Bearish bar
                    {
                     upperWickPrevBar = NormalizeDouble(highPrevBar - openPrevBar,_Digits);
                     lowerWickPrevBar = NormalizeDouble(closePrevBar - lowPrevBar,_Digits);
                     bodyPrevBar = NormalizeDouble(openPrevBar - closePrevBar,_Digits);
                     distanceToTeethPrevBar = NormalizeDouble(alligatorTeethPrevBar - openPrevBar,_Digits);
                    }

               if(closePrevBar > alligatorTeethPrevBar)
                  distanceToTeethPrevBar = NormalizeDouble(closePrevBar - alligatorTeethPrevBar,_Digits);
               else
                  if(closePrevBar < alligatorTeethPrevBar)
                     distanceToTeethPrevBar = NormalizeDouble(alligatorTeethPrevBar - closePrevBar,_Digits);

               if(distanceToTeethPrevBar > atrPrevBar * NormalizeDouble(atrMultiplier,2))
                 {
                  if(closePrevBar < alligatorTeethPrevBar && lowerWickPrevBar > upperWickPrevBar && lowerWickPrevBar > bodyPrevBar) // Bullish bar
                    {
                     Alert(_Symbol," === DIVERGENT BAR ALERT WISE MAN 1 === BULLISH");
                    }
                  else
                     if(closePrevBar > alligatorTeethPrevBar && upperWickPrevBar > lowerWickPrevBar && upperWickPrevBar > bodyPrevBar) // Bearish bar
                       {
                        Alert(_Symbol," === DIVERGENT BAR ALERT WISE MAN 1 === BEARISH");
                       }
                 }

              }
           }

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End Handling Divergent Bar Alert ------------------------ |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- Handling Awesome Oscillator Alert WM2 ------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(wm2AlertToggle || wiseMan2PermanentToggle)
           {


            static datetime WM3_timeStamp;
            datetime WM3_time = iTime(_Symbol,TimeFrame,0);

            if(WM3_timeStamp != WM3_time)
              {
               WM3_timeStamp = WM3_time;

               double awesomeOscillatorArr[];
               CopyBuffer(handleAwesomeOscillator,0,0,5,awesomeOscillatorArr);

               if(awesomeOscillatorArr[4] < awesomeOscillatorArr[3] && //      0 > 1 < 2 < 3
                  awesomeOscillatorArr[3] < awesomeOscillatorArr[2] &&
                  awesomeOscillatorArr[2] > awesomeOscillatorArr[1] &&
                  //  awesomeOscillatorArr[1] > 0 && // zero line rule
                  Ichimoku_FilterBear() &&
                  Alligator_FilterBear() &&
                  MA_FilterBear()
                 )
                 {
                  Alert(_Symbol," === AWESOME OSCILLATOR ALERT WISE MAN 2 === BEARISH");
                  wm2AlertToggle = false;
                  ObjectSetString(0,ExtDialog.Name()+"wm2AlertBtn",OBJPROP_TEXT,"W2");
                 }

               else
                  if(awesomeOscillatorArr[4] > awesomeOscillatorArr[3] &&  //      1 < 2 > 3 > 4
                     awesomeOscillatorArr[3] > awesomeOscillatorArr[2] &&
                     awesomeOscillatorArr[2] < awesomeOscillatorArr[1] &&
                     //  awesomeOscillatorArr[1] < 0 && // zero line rule
                     Ichimoku_FilterBull() &&
                     Alligator_FilterBull() &&
                     MA_FilterBull()
                    )
                    {
                     Alert(_Symbol," === AWESOME OSCILLATOR ALERT WISE MAN 2 === BULLISH");
                     wm2AlertToggle = false;
                     ObjectSetString(0,ExtDialog.Name()+"wm2AlertBtn",OBJPROP_TEXT,"W2");
                    }


              } //  if(WM3_timeStamp != WM3_time)

           }

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of Handling Awesome Oscillator Alert WM2 ------------ |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- Handling Fractal Break Alert WM3 ------------------------ |
         //|                                                                  |
         //+------------------------------------------------------------------+

         if(wiseMan3PermanentToggle)
           {
            wm3AlertToggle = true;
           }

         if(wm3AlertToggle)
           {

            alertClosePrevBar1 = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price, use "2" for previous previous eee
            alertClosePrevBar2 = NormalizeDouble(iClose(_Symbol,TimeFrame,2),_Digits);

            static datetime timeStamp;
            datetime time = iTime(_Symbol,TimeFrame,0);

            if(timeStamp != time)
              {
               timeStamp = time;

               double fractalBufferWM3Double = NormalizeDouble(fractalBufferWM3*_Point,_Digits);

               // --- Checking if Fractal Shoulder integer is valid

               int fractalShoulder;

               if(inp_fractalShoulder <= 0)
                 {
                  fractalShoulder = 1;
                 }
               else
                 {
                  fractalShoulder = inp_fractalShoulder;
                 }

               for(int i=fractalShoulder+1; i<200; i++)
                 {
                  double highs[];
                  double max_high;
                  double current_high = iHigh(_Symbol,TimeFrame,i);

                  for(int j=1; j<=fractalShoulder; j++)
                    {
                     highs.Push(iHigh(_Symbol,TimeFrame,i+j));
                     highs.Push(iHigh(_Symbol,TimeFrame,i-j));
                    }

                  max_high = highs[ArrayMaximum(highs)];

                  if(current_high > max_high)
                    {
                     upperFractalWM3 = current_high + fractalBufferWM3Double;
                     break;
                    }
                 }

               for(int i=fractalShoulder+1; i<200; i++)
                 {
                  double lows[];
                  double min_low;
                  double current_low = iLow(_Symbol,TimeFrame,i);

                  for(int j=1; j<=fractalShoulder; j++)
                    {
                     lows.Push(iLow(_Symbol,TimeFrame,i+j));
                     lows.Push(iLow(_Symbol,TimeFrame,i-j));
                    }

                  min_low = lows[ArrayMinimum(lows)];

                  if(current_low < min_low)
                    {
                     lowerFractalWM3 = current_low  - fractalBufferWM3Double;
                     break;
                    }
                 }

               if(upperFractalWM3 !=0 && lowerFractalWM3 !=0)
                  if(usedFractalWM3Upper != upperFractalWM3 && usedFractalWM3Lower != lowerFractalWM3)
                     if(alertClosePrevBar1 > upperFractalWM3 &&
                        alertClosePrevBar2 <= upperFractalWM3 &&
                        Alligator_FilterBull() &&
                        MA_FilterBull() &&
                        AO_FilterBull() &&
                        AC_FilterBull() &&
                        Ichimoku_FilterBull()&&
                        MAx3_FilterBull()
                       )
                       {
                        fractalBreakBull = true;
                        usedFractalWM3Upper = upperFractalWM3;
                       }

                     else
                        if(alertClosePrevBar1 < lowerFractalWM3 &&
                           alertClosePrevBar2 >= lowerFractalWM3 &&
                           Alligator_FilterBear() &&
                           MA_FilterBear() &&
                           AO_FilterBear() &&
                           AC_FilterBear() &&
                           Ichimoku_FilterBear()&&
                           MAx3_FilterBear()
                          )
                          {
                           fractalBreakBear = true;
                           usedFractalWM3Lower = lowerFractalWM3;
                          }

               if(fractalBreakBull)
                 {
                  Alert(_Symbol," === FRACTAL BREAK ALERT WISE MAN 3 === BULLISH");
                  fractalBreakBull = false;
                 }
               if(fractalBreakBear)
                 {
                  Alert(_Symbol," === FRACTAL BREAK ALERT WISE MAN 3 === BEARISH");
                  fractalBreakBear = false;
                 }
              }

            // Debugging
            debugComment += "======== DEBUGGING WM3 Alerts ===============\n";
            debugComment += "|=> wm3AlertToggle = " + IntegerToString(wm3AlertToggle) + " \n";
            debugComment += "|=> upperFractal = " + DoubleToString(upperFractalWM3,_Digits) + " \n";
            debugComment += "|=> lowerFractal = " + DoubleToString(lowerFractalWM3,_Digits) + " \n";
            debugComment += "----------------------------------------------\n";
            debugComment += "|=> alertClosePrevBar1 = " + DoubleToString(alertClosePrevBar1,_Digits) + " \n";
            debugComment += "|=> alertClosePrevBar2 = " + DoubleToString(alertClosePrevBar2,_Digits) + " \n";
            debugComment += "----------------------------------------------\n";
            debugComment += "|=> fractalBreakBull = " + IntegerToString(fractalBreakBull) + " \n";
            debugComment += "|=> fractalBreakBear = " + IntegerToString(fractalBreakBear) + " \n";
            // End of debugging

           }

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of Handling Fractal Break Alert WM3 ----------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- Signal If TK Break Strategy Conditions Met -------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         if(SignalTenkansenBreak)
           {
            bool BuySignal_1 = false;
            bool BuySignal_2 = false;
            bool BuySignal_3 = false;
            bool BuySignal_4 = false;
            bool BuySignal_GO = false;

            bool SellSignal_1 = false;
            bool SellSignal_2 = false;
            bool SellSignal_3 = false;
            bool SellSignal_4 = false;
            bool SellSignal_GO = false;

            bool KJSSAFilterUp = false;
            bool KJSSAFilterDn = false;
            bool KumoIsWider = false;

            static datetime timeStamp;
            datetime time = iTime(_Symbol,TimeFrame,0);

            double ClosePrice_1 = iClose(_Symbol,TimeFrame,1);
            double ClosePrice_2 = iClose(_Symbol,TimeFrame,2);
            double ClosePrice_3 = iClose(_Symbol,TimeFrame,3);

            double TenkansenArr[];
            double KijunsenArr[];
            double SenkouspanAArr[];
            double SenkouspanBArr[];

            double ShiftedSenkouspanAArr[];
            double ShiftedSenkouspanBArr[];

            double ChikouspanArr[];

            double Bar26High = iHigh(_Symbol,TimeFrame,26);
            double Bar26Low = iLow(_Symbol,TimeFrame,26);
            double CurrentHigh = iHigh(_Symbol,TimeFrame,0);
            double CurrentLow = iLow(_Symbol,TimeFrame,0);

            CopyBuffer(handleIchimoku,0,0,KJSSAFilterRange+1,TenkansenArr);
            CopyBuffer(handleIchimoku,1,0,KJSSAFilterRange+1,KijunsenArr);
            CopyBuffer(handleIchimoku,2,0,KJSSAFilterRange+1,SenkouspanAArr);
            CopyBuffer(handleIchimoku,3,0,KJSSAFilterRange+1,SenkouspanBArr);

            CopyBuffer(handleIchimoku,2,-26,KJSSAFilterRange+1,ShiftedSenkouspanAArr);
            CopyBuffer(handleIchimoku,3,-26,KJSSAFilterRange+1,ShiftedSenkouspanBArr);

            CopyBuffer(handleIchimoku,4,26,KJSSAFilterRange+1,ChikouspanArr);

            double KumoDeltaCurrent = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr[KJSSAFilterRange] - ShiftedSenkouspanBArr[KJSSAFilterRange]),_Digits);
            double KumoDeltaPrevious = NormalizeDouble(MathAbs(ShiftedSenkouspanAArr[0] - ShiftedSenkouspanBArr[0]),_Digits);

            if(KumoDeltaCurrent > KumoDeltaPrevious)
               KumoIsWider = true;
            else
               KumoIsWider = false;

            if(KJSSAFilter)
              {
               if(KumoIsWider)
                  if(KijunsenArr[KJSSAFilterRange] > KijunsenArr[0])
                     if(ShiftedSenkouspanAArr[KJSSAFilterRange] >  ShiftedSenkouspanAArr[0])
                       {
                        KJSSAFilterUp = true;
                        KJSSAFilterDn = false;
                       }
                     else
                        if(KijunsenArr[KJSSAFilterRange] < KijunsenArr[0])
                           if(ShiftedSenkouspanAArr[KJSSAFilterRange] <  ShiftedSenkouspanAArr[0])
                             {
                              KJSSAFilterUp = false;
                              KJSSAFilterDn = true;
                             }
              }
            else
               if(!KJSSAFilter)
                 {
                  KJSSAFilterUp = true;
                  KJSSAFilterDn = true;
                 }

            if(debuggingComments)
              {
               debugComment += "======== DEBUGGING KJSSAFilter ===============\n";
               debugComment += "|=> KJSSAFilterRange = " + IntegerToString(KJSSAFilterRange) + " \n";
               debugComment += "|=> KJSSAFilter SWITCH = " + IntegerToString(KJSSAFilter) + " \n";
               debugComment += "|=> KJSSAFilterUp = " + IntegerToString(KJSSAFilterUp) + " \n";
               debugComment += "|=> KJSSAFilterDn = " + IntegerToString(KJSSAFilterDn) + " \n";
               debugComment += "|=> CURRENT  KijunsenArr[ " + IntegerToString(KJSSAFilterRange) + " ] = " + DoubleToString(KijunsenArr[KJSSAFilterRange],_Digits) + " \n";
               debugComment += "|=> PREVIOUS KijunsenArr[ 0 ] = " + DoubleToString(KijunsenArr[0],_Digits) + " \n";
               debugComment += "|=> CURRENT  ShiftedSenkouspanAArr[ " + IntegerToString(KJSSAFilterRange) + " ] = " + DoubleToString(ShiftedSenkouspanAArr[KJSSAFilterRange],_Digits) + " \n";
               debugComment += "|=> CURRENT  ShiftedSenkouspanBArr[ " + IntegerToString(KJSSAFilterRange) + " ] = " + DoubleToString(ShiftedSenkouspanBArr[KJSSAFilterRange],_Digits) + " \n";
               debugComment += "|=> PREVIOUS ShiftedSenkouspanAArr[ 0 ] = " + DoubleToString(ShiftedSenkouspanAArr[0],_Digits) + " \n";
               debugComment += "|=> PREVIOUS ShiftedSenkouspanBArr[ 0 ] = " + DoubleToString(ShiftedSenkouspanBArr[0],_Digits) + " \n";
               debugComment += "|=> CURRENT Kumo Delta = " + DoubleToString(ShiftedSenkouspanAArr[KJSSAFilterRange] - ShiftedSenkouspanBArr[KJSSAFilterRange],_Digits) + " \n";
               debugComment += "|=> PREVIOUS Kumo Delta = " + DoubleToString(ShiftedSenkouspanAArr[0] - ShiftedSenkouspanBArr[0],_Digits) + " \n";
               debugComment += "|=> KumoIsWider = " + IntegerToString(KumoIsWider) + "\n";
              }


            if(timeStamp != time)
              {
               timeStamp = time;

               BuySignal_4 = false;
               SellSignal_4 = false;


               // Buy Signal

               if(TenkansenArr[1] > KijunsenArr[1])
                 {
                  BuySignal_1 = true; // TK Cross
                  SellSignal_1 = false; // cancelling sell signal
                 }

               if(ChikouspanArr[0] > Bar26High) // Chikou span above prices
                 {
                  BuySignal_2 = true;
                  SellSignal_2 = false;
                 }
               else
                  BuySignal_2 = false;

               if((ShiftedSenkouspanAArr[0] > ShiftedSenkouspanBArr[0])) // Kumo green
                 {
                  BuySignal_3 = true;
                  SellSignal_3 = false;
                 }

               if(ClosePrice_2 < TenkansenArr[0] && ClosePrice_1 > TenkansenArr[1]) // <<<<<<<<<<<<<<<<<<<<<<<< Buy Signal
                 {
                  BuySignal_4 = true;
                  SellSignal_4 = false;
                 }

               if(BuySignal_1 && BuySignal_2 && BuySignal_3 && BuySignal_4)
                 {
                  BuySignal_GO = true;
                  SellSignal_GO = false;
                 }

               StrBuySignal_GO = IntegerToString(BuySignal_GO);
               StrBuySignal_1 = IntegerToString(BuySignal_1);
               StrBuySignal_2 = IntegerToString(BuySignal_2);
               StrBuySignal_3 = IntegerToString(BuySignal_3);
               StrBuySignal_4 = IntegerToString(BuySignal_4);

               if(BuySignal_GO && KJSSAFilterUp && fractalsTrendFilterBull() && StochasticOscillatorFilterBull() && RSI_MA_FilterBull())
                 {
                  Alert(_Symbol," === Tenkansen Break Strategy: Buy Signal = ",BuySignal_GO," ===");

                  BuySignal_GO = false;
                  BuySignal_1 = false;
                  BuySignal_2 = false;
                  BuySignal_3 = false;
                  BuySignal_4 = false;
                 }

               // SELL trades

               if(TenkansenArr[1] < KijunsenArr[1])
                 {
                  SellSignal_1 = true; // KT Cross
                  BuySignal_1 = false; // cancelling buy signal
                 }

               if(ChikouspanArr[0] < Bar26Low) // Chikous span
                 {
                  SellSignal_2 = true;
                  BuySignal_2 = false;
                 }
               else
                 {
                  SellSignal_2 = false;
                 }

               if((ShiftedSenkouspanAArr[0] < ShiftedSenkouspanBArr[0]))
                 {
                  SellSignal_3 = true; // Kumo red
                  BuySignal_3 = false;
                 }

               if(ClosePrice_2 > TenkansenArr[0] && ClosePrice_1 < TenkansenArr[1]) // <<<<<<<<<<<<<<<<<<<<<<<< Sell Signal
                 {
                  BuySignal_4 = false;
                  SellSignal_4 = true;
                 }

               if(SellSignal_1 && SellSignal_2 && SellSignal_3 && SellSignal_4)
                 {
                  SellSignal_GO = true;
                  BuySignal_GO = false;
                 }

               StrSellSignal_GO = IntegerToString(SellSignal_GO);
               StrSellSignal_1 = IntegerToString(SellSignal_1);
               StrSellSignal_2 = IntegerToString(SellSignal_2);
               StrSellSignal_3 = IntegerToString(SellSignal_3);
               StrSellSignal_4 = IntegerToString(SellSignal_4);

               if(SellSignal_GO  && KJSSAFilterDn && fractalsTrendFilterBear() && StochasticOscillatorFilterBear() && RSI_MA_FilterBear())
                 {
                  Alert(_Symbol," === Tenkansen Break Strategy: Sell Signal = ",SellSignal_GO," ===");

                  SellSignal_GO = false;
                  SellSignal_1 = false;
                  SellSignal_2 = false;
                  SellSignal_3 = false;
                  SellSignal_4 = false;
                 }

              } // timeStamp != time

            textComment += "----- TK BREAK STRATEGY SIGNALS -----\n";
            textComment += "Kinjunsen SSA Filter Toggle = " + IntegerToString(KJSSAFilter) + " \n";

            if(KJSSAFilter)
              {
               textComment += "KJSSAFilterRange = " + IntegerToString(KJSSAFilterRange) + " \n";
               textComment += "KJSSAFilterUp = " + IntegerToString(KJSSAFilterUp) + " \n";
               textComment += "KJSSAFilterDn = " + IntegerToString(KJSSAFilterDn) + " \n";
               textComment += "----- KijunsenArr -----\n";
               textComment += "KijunsenArr[0] previous = " + DoubleToString(KijunsenArr[0],_Digits) + " \n"; // current
               textComment += "KijunsenArr["+IntegerToString(KJSSAFilterRange)+"] current  = " + DoubleToString(KijunsenArr[KJSSAFilterRange],_Digits) + " \n"; // current
               textComment += "----- SenkouspanAArr -----\n";
               textComment += "ShiftedSenkouspanAArr[0] previous = " + DoubleToString(ShiftedSenkouspanAArr[0],_Digits) + " \n"; // previous
               textComment += "ShiftedSenkouspanAArr["+IntegerToString(KJSSAFilterRange)+"] current  = " + DoubleToString(ShiftedSenkouspanAArr[KJSSAFilterRange],_Digits) + " \n"; // current
              }

            textComment += "Buy Signels  = " + StrBuySignal_1 + " " + StrBuySignal_2 + " " + StrBuySignal_3 + " " + StrBuySignal_4 + " = " + StrSellSignal_GO + "\n";
            textComment += "Sell Signals = " + StrSellSignal_1 + " " + StrSellSignal_2 + " " + StrSellSignal_3 + " " + StrSellSignal_4 + " = " + StrSellSignal_GO + "\n";

           } //SignalTenkansenBreak

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of Signal If TK Break Strategy Conditions Met ------- |
         //|                                                                  |
         //+------------------------------------------------------------------+


         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- MACD Alert ---------------------------------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         if(MACDAlert)
           {

            static datetime MACD_timeStamp;
            datetime MACD_time = iTime(_Symbol,TimeFrame,0);

            if(MACD_timeStamp != MACD_time)
              {
               MACD_timeStamp = MACD_time;

               double MACD_Hist[],MADC_Signal[];

               ArraySetAsSeries(MACD_Hist,true);
               ArraySetAsSeries(MADC_Signal,true);

               CopyBuffer(handleMACD,0,0,2,MACD_Hist); // for Histogram
               CopyBuffer(handleMACD,1,0,2,MADC_Signal); // for Signal

               textComment += "----- MACD Alert -----\n";
               textComment += "MACD_Hist[0] = " + DoubleToString(MACD_Hist[0],_Digits) + " \n";
               textComment += "MACD_Hist[1] = " + DoubleToString(MACD_Hist[1],_Digits) + " \n";

               textComment += "MADC_Signal[0] = " + DoubleToString(MADC_Signal[0],_Digits) + " \n";
               textComment += "MADC_Signal[1] = " + DoubleToString(MADC_Signal[1],_Digits) + " \n";

               // Print(textComment);


               if(MACD_Hist[0] > MADC_Signal[0] && MACD_Hist[1] < MADC_Signal[1] && MACD_Hist[0] < 0 && MA_FilterBull())
                 {
                  // Buy Signal
                  Alert(_Symbol," === MACD CROSSOVER ALERT === BULLISH");
                  //   Print(_Symbol," === MACD CROSSOVER ALERT === BULLISH");
                 }
               else
                  if(MACD_Hist[0] < MADC_Signal[0] && MACD_Hist[1] > MADC_Signal[1] && MACD_Hist[0] > 0 && MA_FilterBear())
                    {
                     // Sell Signal
                     Alert(_Symbol," === MACD CROSSOVER ALERT === BEARISH");
                     //    Print(_Symbol," === MACD CROSSOVER ALERT === BEARISH");
                    }

              }
           }

         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of MACD Alert --------------------------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+



         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- RSI MA Alert -------------------------------------------- |
         //|                                                                  |
         //+------------------------------------------------------------------+

         if(RSIMAAlert)
           {

            static datetime RSIMA_timeStamp;
            datetime RSIMA_time = iTime(_Symbol,TimeFrame,0);

            if(RSIMA_timeStamp != RSIMA_time)
              {
               RSIMA_timeStamp = RSIMA_time;

               double RSIMAAlert_RSI_buffer[];
               double RSIMAAlert_RSI_MA_buffer[];

               ArraySetAsSeries(RSIMAAlert_RSI_buffer,true);
               ArraySetAsSeries(RSIMAAlert_RSI_MA_buffer,true);

               CopyBuffer(handleRSIFilter,0,0,2,RSIMAAlert_RSI_buffer);
               CopyBuffer(handleRSIMAFilter,0,0,2,RSIMAAlert_RSI_MA_buffer);

               textComment += "----- RSI MA Alert -----\n";
               textComment += "RSIMAAlert_RSI_buffer[0] = " + DoubleToString(RSIMAAlert_RSI_buffer[0],_Digits) + " \n";
               textComment += "RSIMAAlert_RSI_buffer[1] = " + DoubleToString(RSIMAAlert_RSI_buffer[1],_Digits) + " \n";

               textComment += "RSIMAAlert_RSI_MA_buffer[0] = " + DoubleToString(RSIMAAlert_RSI_MA_buffer[0],_Digits) + " \n";
               textComment += "RSIMAAlert_RSI_MA_buffer[1] = " + DoubleToString(RSIMAAlert_RSI_MA_buffer[1],_Digits) + " \n";

               if(RSIMAAlert_RSI_buffer[0] > RSIMAAlert_RSI_MA_buffer[0] && RSIMAAlert_RSI_buffer[1] < RSIMAAlert_RSI_MA_buffer[1] && MA_FilterBull())

                 {
                  // Buy Signal
                  Alert(_Symbol," === RSI MA CROSSOVER ALERT === BULLISH");
                 }
               else
                  if(RSIMAAlert_RSI_buffer[0] < RSIMAAlert_RSI_MA_buffer[0] && RSIMAAlert_RSI_buffer[1] > RSIMAAlert_RSI_MA_buffer[1] && MA_FilterBear())
                    {
                     // Sell Signal
                     Alert(_Symbol," === RSI MA CROSSOVER ALERT === BEARISH");
                    }
              }
           }


         //+------------------------------------------------------------------+
         //|                                                                  |
         //|  ----- End of RSI LMI Alert ------------------------------------ |
         //|                                                                  |
         //+------------------------------------------------------------------+


        } // if VaRfilterGo(maxVARFiltervalue)
     } // if(Period() == TimeFrame)
//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Handling Manual BE -------------------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(manualBEToggle)
     {
      alertLinePrice1 = NormalizeDouble(ObjectGetDouble(0,"alertCloseLine_1",OBJPROP_PRICE),_Digits);
      alertLinePrice2 = NormalizeDouble(ObjectGetDouble(0,"alertCloseLine_2",OBJPROP_PRICE),_Digits);
      alertClosePrevBar1 = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price
      alertClosePrevBar2 = NormalizeDouble(iClose(_Symbol,TimeFrame,2),_Digits); // previous close price

      bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
      ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);

      if((bid > alertLinePrice1 && alertLinePrice1 > 0) || (ask < alertLinePrice2 && alertLinePrice2 > 0))
        {
         int totalPos = PositionsTotal();

         for(int i = 0; i < totalPos; i++)
           {
            ulong posTicket = PositionGetTicket(i);

            if(PositionSelectByTicket(posTicket))
              {
               if(PositionGetString(POSITION_SYMBOL) == _Symbol)
                 {
                  CTrade trade;
                  double posOpenPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
                  double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),_Digits);
                  double posTp = NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits);

                  // --------------------
                  // --- BUY POSITION ---
                  // --------------------

                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)  // checking if the open position has type BUY
                    {
                     if(bid > alertLinePrice1  && alertLinePrice1 > 0)
                        if(posSl < posOpenPrice)
                           if(ask > posOpenPrice)
                             {
                              Print("BUY Break Even Conditions Met...  Position Open Price = ",posOpenPrice);
                              if(trade.PositionModify(posTicket, posOpenPrice, posTp))
                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Breakeven BUY");
                                 if(alertBreakEven)
                                    Alert("=== Position #", posTicket, " was modified by Breakeven BUY ===");
                                }
                             }
                    }

                  // --------------------
                  // --- SELL POSITION --
                  // --------------------

                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) // checking if the open position has type SELL
                    {
                     if(ask < alertLinePrice2  && alertLinePrice2 > 0)
                        if(posSl > posOpenPrice)
                           if(bid < posOpenPrice)
                             {
                              Print("BUY Break Even Conditions Met...  Position Open Price = ",posOpenPrice);
                              if(trade.PositionModify(posTicket, posOpenPrice, posTp))
                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Breakeven SELL");
                                 if(alertBreakEven)
                                    Alert("=== Position #", posTicket, " was modified by Breakeven SELL ===");
                                }
                             }
                    }
                 } // PositionGetString(POSITION_SYMBOL) == _Symbol
              } // PositionSelectByTicket(posTicket)
           } // for loop

        } // (ask > alertLinePrice1) || (bid < alertLinePrice1)

     } // End of Manual BE


//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- End of Handling Manual BE ------------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Handling alert lines ------------------------------------ |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(setAlarmCloseLine)
     {
      alertLinePrice1 = NormalizeDouble(ObjectGetDouble(0,"alertCloseLine_1",OBJPROP_PRICE),_Digits);
      alertLinePrice2 = NormalizeDouble(ObjectGetDouble(0,"alertCloseLine_2",OBJPROP_PRICE),_Digits);
      alertClosePrevBar1 = NormalizeDouble(iClose(_Symbol,PERIOD_CURRENT,1),_Digits); // previous close price
      alertClosePrevBar2 = NormalizeDouble(iClose(_Symbol,PERIOD_CURRENT,2),_Digits); // previous close price

      if(
         (alertClosePrevBar1 > alertLinePrice1 && alertClosePrevBar2 < alertLinePrice1) || (alertClosePrevBar1 < alertLinePrice1 && alertClosePrevBar2 > alertLinePrice1)
         ||
         (alertClosePrevBar1 > alertLinePrice2 && alertClosePrevBar2 < alertLinePrice2) || (alertClosePrevBar1 < alertLinePrice2 && alertClosePrevBar2 > alertLinePrice2)
      )
        {
         Alert("=== ALERT: PRICE OVER THE LINE ON ",_Symbol," ===");
         setAlarmCloseLine = false;
         ObjectSetString(0,ExtDialog.Name()+"AlertCloseBtn",OBJPROP_TEXT,"\x23F0");
        }

     }

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- End of Handling alert lines ----------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Display Position Profit on the Chart -------------------- |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(showProfitOnChart && updateProfitOnchart)
     {
      int totalPos = PositionsTotal();

      for(int i = 0; i < totalPos; i++)
        {
         ulong posTicket = PositionGetTicket(i);

         if(PositionSelectByTicket(posTicket))
           {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol)
              {
               long time1 = PositionGetInteger(POSITION_TIME);
               long time2 = time1+(PeriodSeconds(_Period)*15);
               double price1 = PositionGetDouble(POSITION_PRICE_OPEN);
               double price2 = PositionGetDouble(POSITION_SL);
               double price3 = PositionGetDouble(POSITION_TP);
               double posProfit = PositionGetDouble(POSITION_PROFIT);
               string posProfitStr = AccountInfoString(ACCOUNT_CURRENCY) + " " + DoubleToString(posProfit,2);

               if(showProfitOnChart)
                 {
                  ObjectSetString(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_TEXT,posProfitStr);
                  if(posProfit>0)
                     ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_COLOR,clrLimeGreen);
                  else
                     if(posProfit<0)
                        ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_COLOR,clrOrangeRed);
                     else
                        if(posProfit==0)
                           ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_COLOR,clrSilver);
                 } // showProfitOnChart
              } // PositionGetString(POSITION_SYMBOL) == _Symbol
           } // PositionSelectByTicket(posTicket)
        } // for loop
     } // showProfitOnChart && updateProfitOnchart

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- End of Display Position Profit on the Chart ------------- |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   string spreadStr = IntegerToString(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
   datetime CandleCountDown_bar_Opened = iTime(_Symbol,PERIOD_CURRENT,0);
   datetime CandleCountDown_bar_Closed = PeriodSeconds(PERIOD_CURRENT);
   datetime CandleCountDown_counting   =  CandleCountDown_bar_Opened + CandleCountDown_bar_Closed - TimeCurrent();
   string timeTillCloseStr = TimeToString(CandleCountDown_counting, TIME_MINUTES|TIME_SECONDS);
   AccountFreeMargin = NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_FREE) * marginToBallancePercent / 100,2);

// for calculating ProfitLbl
   double profitDouble = Profit_Calculation();
   string profitStr = DoubleToString(profitDouble,2);

   if(profitDouble > 0)
     {
      ObjectSetInteger(0,ExtDialog.Name()+"ProfitLbl",OBJPROP_COLOR,clrForestGreen);
     }
   else
      if(profitDouble < 0)
        {
         ObjectSetInteger(0,ExtDialog.Name()+"ProfitLbl",OBJPROP_COLOR,clrRed);
        }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   ObjectSetString(0,ExtDialog.Name()+"MarginAvailableDisplLbl",OBJPROP_TEXT,DoubleToString(AccountFreeMargin,2));
   ObjectSetString(0,ExtDialog.Name()+"SpreadLbl",OBJPROP_TEXT,"Spread: "+spreadStr);
   ObjectSetString(0,ExtDialog.Name()+"TimeTillCandleCloseLbl",OBJPROP_TEXT,timeTillCloseStr);
   ObjectSetString(0,ExtDialog.Name()+"ProfitLbl",OBJPROP_TEXT,profitStr);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(autoPosMgmtToggle)
     {
      long spreadPos = SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
      int bars = iBars(_Symbol, TimeFrame);
      int totalPos = PositionsTotal();

      //+------------------------------------------------------------------+
      //|                                                                  |
      //|  ----- Close All Positions On Condition --------------           |
      //|                                                                  |
      //+------------------------------------------------------------------+

      //+------------------------------------------------------------------+
      //|        Close Positions on Price Close Over Tenkansen             |
      //+------------------------------------------------------------------+

      if(ClosePosTenkansen)
        {
         CTrade trade;
         double TenkansenArr[];
         CopyBuffer(handleIchimoku,0,0,2,TenkansenArr);

         double ClosePrevBar = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price
         double TenkansenPrevBar = NormalizeDouble(TenkansenArr[0],_Digits); // previous kijunsen value

         textComment += "Close Pri Prev bar = " + DoubleToString(ClosePrevBar,_Digits) + "\n";
         textComment += "Tenkansen Prev Bar = " + DoubleToString(TenkansenPrevBar,_Digits) + "\n";

         if(ArraySize(TenkansenArr) > 0)
           {
            // --------------------
            // --- BUY POSITION ---
            // --------------------
            if(ClosePrevBar < TenkansenPrevBar)
               for(int i = 0; i < totalPos; i++)
                 {
                  ulong posTicket = PositionGetTicket(i);
                  if(PositionSelectByTicket(posTicket))
                     if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        int OpenBar = iBarShift(_Symbol,0,PositionGetInteger(POSITION_TIME));
                        double positionProfit = PositionGetDouble(POSITION_PROFIT);
                        if(OpenBar > 1)
                           if(trade.PositionClose(posTicket))
                             {
                              Print(__FUNCTION__," > Position #",posTicket," was closed with profit ",positionProfit," because price closed below Tenkansen. ",ClosePrevBar," < ",TenkansenPrevBar);
                              if(AlertAutoClosePosition)
                                 Alert(" > Position #",posTicket," was closed with profit ",positionProfit," because price closed below Tenkansen. ",ClosePrevBar," < ",TenkansenPrevBar);
                             }
                       }
                 }

            // --------------------
            // --- SELL POSITION --
            // --------------------
            if(ClosePrevBar > TenkansenPrevBar)
               for(int i = 0; i < totalPos; i++)
                 {
                  ulong posTicket = PositionGetTicket(i);
                  if(PositionSelectByTicket(posTicket))
                     if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        int OpenBar = iBarShift(_Symbol,0,PositionGetInteger(POSITION_TIME));
                        double positionProfit = PositionGetDouble(POSITION_PROFIT);
                        if(OpenBar > 1)
                           if(trade.PositionClose(posTicket))
                             {
                              Print(__FUNCTION__," > Position #",posTicket," was closed with profit ",positionProfit," because price closed above Tenkansen. ",ClosePrevBar," > ",TenkansenPrevBar);
                              if(AlertAutoClosePosition)
                                 Alert(" > Position #",posTicket," was closed with profit ",positionProfit," because price closed above Tenkansen. ",ClosePrevBar," > ",TenkansenPrevBar);
                             }
                       }
                 }
           } // ArraySize(TenkansenArr) > 0
        } // ClosePosTenkansen
      //+------------------------------------------------------------------+
      //|      End Close Positions on Price Close Over Tenkansen           |
      //+------------------------------------------------------------------+

      //+------------------------------------------------------------------+
      //|        Close Positions on Price Close Over MA                    |
      //+------------------------------------------------------------------+

      if(ClosePosMa)
        {
         CTrade trade;
         double ClosePosMaArr[];
         CopyBuffer(handleClosePosMA,MAIN_LINE,1,ClosePosMaShift,ClosePosMaArr);

         double ClosePrevBar = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits); // previous close price
         double ClosePosMaPrevBar = NormalizeDouble(ClosePosMaArr[ClosePosMaShift-1],_Digits); // previous Close Pos MA value

         textComment += "Close Pri Prev bar = " + DoubleToString(ClosePrevBar,_Digits) + "\n";
         textComment += "ClosePosMaPrevBar = " + DoubleToString(ClosePosMaPrevBar,_Digits) + "\n";

         if(ArraySize(ClosePosMaArr) > 0)
           {
            // --------------------
            // --- BUY POSITION ---
            // --------------------
            if(ClosePrevBar < ClosePosMaPrevBar && ClosePosMaPrevBar > 0)
               for(int i = 0; i < totalPos; i++)
                 {
                  ulong posTicket = PositionGetTicket(i);
                  if(PositionSelectByTicket(posTicket))
                     if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        int OpenBar = iBarShift(_Symbol,0,PositionGetInteger(POSITION_TIME));
                        double positionProfit = PositionGetDouble(POSITION_PROFIT);
                        if(OpenBar > 1)
                           if(trade.PositionClose(posTicket))
                             {
                              Print(__FUNCTION__," > Position #",posTicket," was closed with profit ",NormalizeDouble(positionProfit,2)," because price closed below Moving Average. ",ClosePrevBar," < ",ClosePosMaPrevBar);
                              if(AlertAutoClosePosition)
                                 Alert(" > Position #",posTicket," was closed with profit ",NormalizeDouble(positionProfit,2)," because price closed below Moving Average. ",ClosePrevBar," < ",ClosePosMaPrevBar);
                             }
                       }
                 }

            // --------------------
            // --- SELL POSITION --
            // --------------------
            if(ClosePrevBar > ClosePosMaPrevBar && ClosePosMaPrevBar > 0)
               for(int i = 0; i < totalPos; i++)
                 {
                  ulong posTicket = PositionGetTicket(i);
                  if(PositionSelectByTicket(posTicket))
                     if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        int OpenBar = iBarShift(_Symbol,0,PositionGetInteger(POSITION_TIME));
                        double positionProfit = PositionGetDouble(POSITION_PROFIT);
                        if(OpenBar > 1)
                           if(trade.PositionClose(posTicket))
                             {
                              Print(__FUNCTION__," > Position #",posTicket," was closed with profit ",positionProfit," because price closed above Moving Average. ",ClosePrevBar," > ",ClosePosMaPrevBar);
                              if(AlertAutoClosePosition)
                                 Alert(" > Position #",posTicket," was closed with profit ",NormalizeDouble(positionProfit,2)," because price closed above Moving Average. ",ClosePrevBar," > ",ClosePosMaPrevBar);
                             }
                       }
                 }
           } // ArraySize(ClosePosMaArr) > 0
        } // ClosePosMa
      //+------------------------------------------------------------------+
      //|      End Close Positions on Price Close Over MA                  |
      //+------------------------------------------------------------------+

      // =========================================================================

      //+------------------------------------------------------------------+
      //|                                                                  |
      //|  ----- End Close All Positions On Condition ----------           |
      //|                                                                  |
      //+------------------------------------------------------------------+



      //+------------------------------------------------------------------+
      //|        Trailing SL activated by a new Tick                       |
      //+------------------------------------------------------------------+
      if(autoBreakEven)
        {
         for(int i = 0; i < totalPos; i++)
           {
            ulong posTicket = PositionGetTicket(i);

            if(PositionSelectByTicket(posTicket))
              {
               if(PositionGetString(POSITION_SYMBOL) == _Symbol)
                 {
                  CTrade trade;
                  double posOpenPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
                  double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),_Digits);
                  double posTp = NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits);

                  bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
                  ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);

                  //+------------------------------------------------------------------+
                  //|         Break Even                                               |
                  //+------------------------------------------------------------------+

                  if(breakevenRatio > 0 && posOpenPrice != posSl)

                    {

                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------


                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)  // checking if the open position has type BUY
                       {
                        double posTriggerBuy = NormalizeDouble((posOpenPrice - posSl) * breakevenRatio,_Digits);
                        if(posSl < posOpenPrice)

                           if(bid > posOpenPrice + posTriggerBuy)
                             {
                              Print("BUY Break Even Conditions Met...  Position Open Price = ",posOpenPrice);
                              if(trade.PositionModify(posTicket, posOpenPrice, posTp))
                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Breakeven BUY");
                                 if(alertBreakEven)
                                    Alert("=== Position #", posTicket, " was modified by Breakeven BUY ===");
                                }

                             }
                       }


                     // --------------------
                     // --- SELL POSITION --
                     // --------------------


                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) // checking if the open position has type SELL
                       {
                        double posTriggerSell = NormalizeDouble((posSl - posOpenPrice) * breakevenRatio,_Digits);
                        if(posSl > posOpenPrice)
                           if(ask < posOpenPrice - posTriggerSell)
                             {
                              Print("BUY Break Even Conditions Met...  Position Open Price = ",posOpenPrice);
                              if(trade.PositionModify(posTicket, posOpenPrice, posTp))
                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Breakeven SELL");
                                 if(alertBreakEven)
                                    Alert("=== Position #", posTicket, " was modified by Breakeven SELL ===");
                                }
                             }
                       }
                    } // Breakeven ratio > 0
                 } // PositionGetString(POSITION_SYMBOL) == _Symbol
              }
           } // for loop
        } // if autobreakeven
      //+------------------------------------------------------------------+
      //|        End of Break Even                                         |
      //+------------------------------------------------------------------+


      //+------------------------------------------------------------------+
      //|       Regular TSL in Points                                      |
      //+------------------------------------------------------------------+

      if(pointsTSL && TslPoints > 0)
        {
         for(int i = 0; i < totalPos; i++)
           {
            ulong posTicket = PositionGetTicket(i);

            if(PositionSelectByTicket(posTicket))
              {
               if(PositionGetString(POSITION_SYMBOL) == _Symbol)
                 {
                  CTrade trade;
                  double posOpenPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
                  double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),_Digits);
                  double posTp = NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits);

                  bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
                  ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);

                  if(TslPoints > spreadPos)
                    {
                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        double sl = NormalizeDouble(bid - TslPoints * _Point,_Digits);

                        if(sl > posSl && sl < bid)
                           if(trade.PositionModify(posTicket,sl,posTp))
                              Print(__FUNCTION__," > Position #",posTicket," was modified by Regular TSL BUY.");
                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        double sl = NormalizeDouble(ask + TslPoints * _Point,_Digits);

                        if((sl < posSl && sl > ask) || (posSl == 0))
                           if(trade.PositionModify(posTicket,sl,posTp))
                              Print(__FUNCTION__," > Position #",posTicket," was modified by Regular TSL SELL.");
                       }
                    }
                 } // +Symbol
              } // posTicket
           } // for loop
        } // pointsTSL && TslPoints
      //+------------------------------------------------------------------+
      //|      End of Regular TSL in Points                                |
      //+------------------------------------------------------------------+


      //+------------------------------------------------------------------+
      //|        Trailing SL activated by a new bar                        |
      //+------------------------------------------------------------------+

      textComment += "BARS = " + IntegerToString(bars) + " BARS TOTAL = " + IntegerToString(barsTotal) + "\n";

      if(barsTotal != bars && totalPos > 0) // New bar appeared on the chart
        {
         barsTotal = bars;

         if(NewBarAlert && barsTotal > 0)
            Alert("=== NEW BAR... === ");

         barsTotal = bars;

         if(fractalsTSL)
            barCountFractals += 1;

         double upperFractal = 0;
         double lowerFractal = 0;

         double high_1 = 0;
         double high_2 = 0;
         double high_3 = 0;
         double high_4 = 0;
         double high_5 = 0;

         double low_1 = 0;
         double low_2 = 0;
         double low_3 = 0;
         double low_4 = 0;
         double low_5 = 0;

         double fractalBufferWM3Double = NormalizeDouble(fractalBufferWM3*_Point,_Digits);

         if(barCountFractals > 5)
           {
            for(int i=3; i<barCountFractals; i++)
              {
               high_1 = iHigh(_Symbol,PERIOD_CURRENT,i+2);
               high_2 = iHigh(_Symbol,PERIOD_CURRENT,i+1);
               high_3 = iHigh(_Symbol,PERIOD_CURRENT,i);
               high_4 = iHigh(_Symbol,PERIOD_CURRENT,i-1);
               high_5 = iHigh(_Symbol,PERIOD_CURRENT,i-2);

               if(high_3 > high_2 && high_3 > high_1 && high_3 > high_4 && high_3 > high_5)
                 {
                  mainUpper = high_3 + fractalBufferWM3Double;
                  break;
                 }
              }

            for(int i=3; i<barCountFractals; i++)
              {
               low_1 = iLow(_Symbol,PERIOD_CURRENT,i+2);
               low_2 = iLow(_Symbol,PERIOD_CURRENT,i+1);
               low_3 = iLow(_Symbol,PERIOD_CURRENT,i);
               low_4 = iLow(_Symbol,PERIOD_CURRENT,i-1);
               low_5 = iLow(_Symbol,PERIOD_CURRENT,i-2);

               if(low_3 < low_2 && low_3 < low_1 && low_3 < low_4 && low_3 < low_5)
                 {
                  mainLower = low_3  - fractalBufferWM3Double;
                  break;
                 }
              }

           }

         for(int i = 0; i < totalPos; i++)
           {
            ulong posTicket = PositionGetTicket(i);
            if(PositionSelectByTicket(posTicket))
              {

               if(PositionGetString(POSITION_SYMBOL) == _Symbol)
                 {
                  CTrade trade;
                  double posOpenPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
                  double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),_Digits);
                  double posTp = NormalizeDouble(PositionGetDouble(POSITION_TP),_Digits);

                  bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
                  ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
                  double ma[];
                  CopyBuffer(handleMA,MAIN_LINE,1,MaShift,ma);

                  //+------------------------------------------------------------------+
                  //|         Fractals                                                 |
                  //+------------------------------------------------------------------+

                  if(fractalsTSL)
                    {
                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)  // checking if the open position if has type BUY
                       {
                        // ---
                        if(posSl < mainLower && bid > mainLower)
                          {
                           double sl = mainLower;

                           if(sl > posSl)
                             {
                              if(trade.PositionModify(posTicket, sl, posTp))

                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Fractal tsl. BUY");
                                }
                             }
                          }
                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        //---
                        if(posSl > mainUpper && ask < mainUpper)
                          {
                           double sl = mainUpper;

                           if(sl < posSl || posSl == 0)
                             {
                              if(trade.PositionModify(posTicket, sl, posTp))
                                {
                                 Print(__FUNCTION__, " > Position #", posTicket, " was modified by Fractal tsl. SELL");
                                }
                             }
                          }
                       }
                    } // end of if fractals


                  //+------------------------------------------------------------------+
                  //|        End of Fractals                                           |
                  //+------------------------------------------------------------------+

                  //+------------------------------------------------------------------+
                  //|        Previous Candle TSL                                       |
                  //+------------------------------------------------------------------+

                  if(prevCandleTSL)
                    {
                     double prevClose = iClose(_Symbol,TimeFrame,1);
                     double prevOpen = iOpen(_Symbol,TimeFrame,1);

                     Print("prevClose = ",prevClose);
                     Print("prevOpen = ",prevOpen);

                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        if(prevClose > prevOpen)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(prevOpen,_Digits) - (TslOffsetPoints + spreadPos) * _Point,_Digits);
                           if(sl > posSl && sl < bid)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(NormalizeDouble(sl - posSl,_Digits), " ", NormalizeDouble(bid - sl,_Digits));
                                 Print("SL = ",sl, " TP = ", posTp);
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Prev Candle TSL.");
                                }
                             }
                          }

                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        if(prevClose < prevOpen)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(prevOpen,_Digits) + (TslOffsetPoints + spreadPos) * _Point,_Digits);
                           if(sl < posSl || posSl == 0)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print("SL = ",sl, " TP = ", posTp);
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Prev Candle TSL.");
                                }
                             }
                          }
                       }


                    }



                  //+------------------------------------------------------------------+
                  //|       End of Previous Candle TSL                                 |
                  //+------------------------------------------------------------------+




                  //+------------------------------------------------------------------+
                  //|         MA                                                       |
                  //+------------------------------------------------------------------+

                  if(movingAverageTSL)
                    {
                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        if(ArraySize(ma) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(ma[MaShift - 1],_Digits) - (TslOffsetPoints + spreadPos) * _Point,_Digits);
                           if(sl > posSl && sl < bid)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(NormalizeDouble(sl - posSl,_Digits), " ", NormalizeDouble(bid - sl,_Digits));
                                 Print("SL = ",sl, " TP = ", posTp);
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by ma tsl.");
                                }
                             }
                          }

                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        if(ArraySize(ma) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(ma[MaShift - 1],_Digits) + (TslOffsetPoints + spreadPos) * _Point,_Digits);
                           if(sl < posSl || posSl == 0)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print("SL = ",sl, " TP = ", posTp);
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by ma tsl.");
                                }
                             }
                          }
                       }

                    }// end of moving average


                  //+------------------------------------------------------------------+
                  //|       end of MA                                                  |
                  //+------------------------------------------------------------------+


                  //+------------------------------------------------------------------+
                  //|       Kinjunsen TSL                                              |
                  //+------------------------------------------------------------------+

                  if(kijunsenTSL)
                    {
                     double KijunsenArr[];
                     CopyBuffer(handleIchimoku,1,0,2,KijunsenArr);

                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        if(ArraySize(KijunsenArr) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(KijunsenArr[0],_Digits) - (TslOffsetPoints + spreadPos) * _Point,_Digits);

                           if(sl > posSl && sl < bid)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Kijunsen tsl.");
                                }
                             }
                          }

                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        if(ArraySize(KijunsenArr) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(KijunsenArr[0],_Digits) + (TslOffsetPoints + spreadPos) * _Point,_Digits);

                           if(sl < posSl || posSl == 0)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Kijunsen tsl.");
                                }
                             }
                          }
                       }
                    }
                  //+------------------------------------------------------------------+
                  //|       End of Kinjunsen TSL                                       |
                  //+------------------------------------------------------------------+


                  //+------------------------------------------------------------------+
                  //|       Tenkansen TSL                                              |
                  //+------------------------------------------------------------------+

                  if(tenkansenTSL)
                    {
                     double TenkansenArr[];
                     CopyBuffer(handleIchimoku,0,0,2,TenkansenArr);

                     // --------------------
                     // --- BUY POSITION ---
                     // --------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                       {
                        if(ArraySize(TenkansenArr) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(TenkansenArr[0],_Digits) - (TslOffsetPoints + spreadPos) * _Point,_Digits);

                           if(sl > posSl && sl < bid)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Tenkansen tsl.");
                                }
                             }
                          }
                       }

                     // ---------------------
                     // --- SELL POSITION ---
                     // ---------------------

                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        if(ArraySize(TenkansenArr) > 0)
                          {
                           double sl = NormalizeDouble(NormalizeDouble(TenkansenArr[0],_Digits) + (TslOffsetPoints + spreadPos)*_Point,_Digits);

                           if(sl < posSl || posSl == 0)
                             {
                              if(trade.PositionModify(posTicket,sl,posTp))
                                {
                                 Print(__FUNCTION__," > Position #",posTicket," was modified by Tenkansen tsl.");
                                }
                             }
                          }
                       }
                    }
                  //+------------------------------------------------------------------+
                  //|       End of Tenkansen TSL                                       |
                  //+------------------------------------------------------------------+

                 } // if pos symbol
              } // if pos ticket
           } // for loop
        } // barsTotal != bars



      textComment += "-----------------------------\nPosition Management EA\n" + _Symbol + " " +IntegerToString(_Period) + "\n";
      textComment += "------EA SETTINGS------------------------\n";
      textComment += "NUMBER OF OPEN POSITIONS = " + IntegerToString(totalPos) + "\n";
      textComment += "SPREAD = " + IntegerToString(spreadPos) + "\n";
      textComment += "BE RATIO = " + DoubleToString(breakevenRatio,2) + "\n";
      textComment += "MA PERIOD = " + IntegerToString(MaPeriod) +  " | SHIFT = " + IntegerToString(MaShift) + " | TF = "  + (string)TimeFrame + "\n";
      textComment += "TSL BUFFER POINTS  = [ " + IntegerToString(TslOffsetPoints) + " ]\n";
      textComment += "TSL TIME FRAME  = [ " + IntegerToString(TimeFrame) + " ]\n";
      textComment += "POINTS TSL = [ " + IntegerToString(pointsTSL) + " ]\n";
      textComment += "---------EA SWITCHES----------------\n";
      textComment += "Auto BE  = [ " + IntegerToString(autoBreakEven) + " ]\n";
      textComment += "TSL Fra   = [ " + IntegerToString(fractalsTSL) + " ]\n";
      textComment += "TSL MA  = [ " + IntegerToString(movingAverageTSL) + " ]\n";
      textComment += "TSL TK  = [ " + IntegerToString(tenkansenTSL) + " ]\n";
      textComment += "TSL KJ  = [ " + IntegerToString(kijunsenTSL) + " ]\n";
      textComment += "CLOSE ON TK CLOSE  = [ " + IntegerToString(ClosePosTenkansen) + " ]\n";

      if(ClosePosMa)
        {
         textComment += "---------CLOSE ON CLOSE OVER MA SETTINGS----------------\n";
         textComment += "CLOSE ON CLOSE OVER MA  = [ " + IntegerToString(ClosePosMa) + " ]\n";
         textComment += "CLOSE MA PERIOD  = [ " + IntegerToString(ClosePosMaPeriod) + " ]\n";
         textComment += "CLOSE MA SHIFT  = [ " + IntegerToString(ClosePosMaShift) + " ]\n";
         textComment += "CLOSE MA METHOD  = [ " + IntegerToString(ClosePosMaMethod) + " ]\n";
         textComment += "CLOSE MA PRICE  = [ " + IntegerToString(ClosePosMaAppPrice) + " ]\n";
        }

      if(fractalsTSL)
        {
         textComment += "---------FRACTALS TSL -----------------------------------\n";
         textComment += "BAR COUNT FRACTAL = " + IntegerToString(barCountFractals) + "\n";
         textComment += "LOWER FRACTAL     = " + DoubleToString(mainLower, _Digits) + "\n";
         textComment += "UPPER FRACTAL     = " + DoubleToString(mainUpper, _Digits) + "\n";
        }
      textComment += "ALERT AUTO CLOSE ON TK CLOSE  = [ " + IntegerToString(AlertAutoClosePosition) + " ]\n";
      textComment += "ALERT NEW BAR  = [ " + IntegerToString(NewBarAlert) + " ]\n";
      textComment += "ALERT TKB TRADE SIGNAL  = [ " + IntegerToString(SignalTenkansenBreak) + " ]\n";


      textComment += "alertCloseLine      = [ " + IntegerToString(alertCloseLine) + " ]\n";
      textComment += "setAlarmCloseLine = [ " + IntegerToString(setAlarmCloseLine) + " ]\n";
      textComment += "manualBEToggle = [ " + IntegerToString(manualBEToggle) + " ]\n";






     } // autoPosMgmtToggle


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(showEAComment)
     {
      if(debuggingComments)
        {
         textComment += debugComment;
         debugComment="";
        }
      Comment(textComment);
      textComment="";
     }


//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- Handling PINBAR Alert ----------------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+
   if(pinbarAlert)
     {

      int bars = iBars(_Symbol, TimeFrame);
      if(barsTotal != bars) // New bar appeared on the chart
        {
         barsTotal = bars;

         //getting previous bar Close Open Low High values
         double closePrevBar = NormalizeDouble(iClose(_Symbol,TimeFrame,1),_Digits);
         double openPrevBar = NormalizeDouble(iOpen(_Symbol,TimeFrame,1),_Digits);
         double lowPrevBar = NormalizeDouble(iLow(_Symbol,TimeFrame,1),_Digits);
         double highPrevBar = NormalizeDouble(iHigh(_Symbol,TimeFrame,1),_Digits);

         double upperWickPrevBar = 0;
         double lowerWickPrevBar = 0;
         double bodyPrevBar = 0;

         if(closePrevBar > openPrevBar)  // Bullish bar
           {
            upperWickPrevBar = NormalizeDouble(highPrevBar - closePrevBar,_Digits);
            lowerWickPrevBar = NormalizeDouble(openPrevBar - lowPrevBar,_Digits);
            bodyPrevBar = NormalizeDouble(closePrevBar - openPrevBar,_Digits);

           }
         else
            if(closePrevBar < openPrevBar) // Bearish bar
              {
               upperWickPrevBar = NormalizeDouble(highPrevBar - openPrevBar,_Digits);
               lowerWickPrevBar = NormalizeDouble(closePrevBar - lowPrevBar,_Digits);
               bodyPrevBar = NormalizeDouble(openPrevBar - closePrevBar,_Digits);
              }


         if(lowerWickPrevBar > 2 * bodyPrevBar && upperWickPrevBar < 0.3 * lowerWickPrevBar)
           {
            Alert(_Symbol," === PINBAR ALERT === BULLISH");
           }

         else
            if(upperWickPrevBar > 2 * bodyPrevBar && lowerWickPrevBar < 0.5 * upperWickPrevBar)
              {
               Alert(_Symbol," === PINBAR ALERT === BEARISH");
              }

        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//|  ----- End of Handling PINBAR Alert ---------------------------- |
//|                                                                  |
//+------------------------------------------------------------------+




  }// OnTick

//+---------------------------------------------------------------------------------------+
//+---------------------------------------------------------------------------------------+
//|                              +++ DEFINED FUNCTIONS +++                                |
//+---------------------------------------------------------------------------------------+
//+---------------------------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      Get Order Data Function                     |
//+------------------------------------------------------------------+
bool CControlsDialog::GetOrderData()
  {
   posLots = CheckPositionVolume(NormalizeDouble(StringToDouble(m_LotsEdit.Text()),3));
   slPips = NormalizeDouble(StringToDouble(m_SlPipsEdit.Text()),2);
   RiskToReward = NormalizeDouble(StringToDouble(m_RiskToRewardRatioEdit.Text()),2);
   ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   slSell = NormalizeDouble(ask + slPips*_Point*10,_Digits);
   slBuy = NormalizeDouble(bid - slPips*_Point*10,_Digits);
   tpSell = NormalizeDouble(ask - RiskToReward * (slSell - ask),_Digits);
   tpBuy = NormalizeDouble(bid + RiskToReward * (bid - slBuy),_Digits);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::GetDataFromLines()
  {
   linePriceNew = NormalizeDouble(ObjectGetDouble(0,"priceLine",OBJPROP_PRICE),_Digits);
   lineSlNew =  NormalizeDouble(ObjectGetDouble(0,"stopLossLine",OBJPROP_PRICE),_Digits);
   lineTpNew =  NormalizeDouble(ObjectGetDouble(0,"takeProfitLine",OBJPROP_PRICE),_Digits);

   m_PriceEdit.Text(DoubleToString(linePriceNew,_Digits));
   m_SlEdit.Text(DoubleToString(lineSlNew,_Digits));
   m_TpEdit.Text(DoubleToString(lineTpNew,_Digits));
   return(true);
  }

//+------------------------------------------------------------------+
//|                          Market Order SELL                       |
//+------------------------------------------------------------------+
bool CControlsDialog::MarketSellOrder()
  {
   CTrade trade;
   if(m_LotsEdit.Text() != "" && m_SlPipsEdit.Text() != "" && m_RiskToRewardRatioEdit.Text() != "")
     {
      GetOrderData();

      Print("Lots = ",posLots," SL pips = ",slPips," RRR = ",RiskToReward, " SL Buy = ",slBuy, " Ask = ",bid," Ask - SL Buy = ",NormalizeDouble(bid-slBuy,_Digits),
            " TP = ", tpBuy, " TP - ask = ",NormalizeDouble(tpBuy - bid,_Digits));

      if(posLots > 0 && slPips > 0 && RiskToReward > 0)
        {
         string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " SELL MARKET";
         if(trade.Sell(posLots,_Symbol,bid,slSell,tpSell,tradeComment))
           {
            Print("Sold ",posLots," Lots of ",_Symbol," @ ",bid," SL = ",slSell, " TP = ",tpSell);
           }
        }
      else
        {
         Print("Incorrect input");
        }
     }
   else
     {
      Print("Not enough input");
     }
   return(true);
  }


//+------------------------------------------------------------------+
//|                          Market Order BUY                        |
//+------------------------------------------------------------------+
bool  CControlsDialog::MarketBuyOrder()
  {
   CTrade trade;

   if(m_LotsEdit.Text() != "" && m_SlPipsEdit.Text() != "" && m_RiskToRewardRatioEdit.Text() != "")
     {
      GetOrderData();

      Print("Lots = ",posLots," SL pips = ",slPips," RRR = ",RiskToReward, " SL Buy = ",slBuy, " Ask = ",ask," Ask - SL Buy = ",NormalizeDouble(ask-slBuy,_Digits),
            " TP = ", tpBuy, " TP - ask = ",NormalizeDouble(tpBuy - ask,_Digits));

      if(posLots > 0 && slPips > 0 && RiskToReward > 0)
        {
         string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " BUY MARKET";
         if(trade.Buy(posLots,_Symbol,ask,slBuy,tpBuy,tradeComment))
           {
            Print("Bought ",posLots," Lots of ",_Symbol," @ ",ask," SL = ",slBuy, " TP = ",tpBuy);
           }
        }
      else

        {
         Print("Incorrect input");
        }
     }
   else
     {
      Print("Not enough input");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                PendingSellStopOrder              |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingSellStopOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   if(lineSlNew > linePriceNew && (linePriceNew >= lineTpNew) && linePriceNew < ask)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " SELL STOP";
      if(trade.SellStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for SellStop operation");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingSellLimitOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   if(lineSlNew > linePriceNew && (linePriceNew >= lineTpNew) && linePriceNew > ask)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " SELL LIMIT";
      if(trade.SellLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for SellLimit operation");
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingBuyStopOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   if(lineSlNew < linePriceNew && (linePriceNew <= lineTpNew) && linePriceNew > bid)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " BUY STOP";
      if(trade.BuyStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for BuyStop operation");
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingBuyLimitOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   if(lineSlNew < linePriceNew && (linePriceNew <= lineTpNew) && linePriceNew < bid)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " BUY LIMIT";
      if(trade.BuyLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for BuyLimit operation");
     }
   return(true);
  }


//+------------------------------------------------------------------+
// Auxiliary functions for Double Orders button
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                          Market Order SELL Double                |
//+------------------------------------------------------------------+
bool CControlsDialog::MarketSellDoubleOrder()
  {
   CTrade trade;
   double beLevelLine = 0;
   if(m_LotsEdit.Text() != "" && m_SlPipsEdit.Text() != "" && m_RiskToRewardRatioEdit.Text() != "")
     {
      GetOrderData();

      tpSell =  slSell - 2*(slSell - bid);
      posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

      Print("Lots = ",posLots," SL pips = ",slPips," RRR = ",RiskToReward, " SL Buy = ",slBuy, " Ask = ",ask," Ask - SL Buy = ",NormalizeDouble(ask-slBuy,_Digits),
            " TP = ", tpBuy, " TP - ask = ",NormalizeDouble(tpBuy - ask,_Digits));


      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE MARKET SELL";

      if(posLots > 0 && slPips > 0 && RiskToReward > 0)
        {

         if(trade.Sell(posLots,_Symbol,bid,slSell,tpSell,tradeComment))
           {
            Print("Sold ",posLots," Lots of ",_Symbol," @ ",bid," SL = ",slSell, " TP = ",tpSell);
           }

         beLevelLine = tpSell;
         tpSell = 0;

         if(trade.Sell(posLots,_Symbol,bid,slSell,0,tradeComment))
           {
            Print("Sold ",posLots," Lots of ",_Symbol," @ ",bid," SL = ",slSell, " TP = ",tpSell);
           }
        }
      else
        {
         Print("Incorrect input");
        }
     }
   else
     {
      Print("Not enough input");
     }

// add breakeven line
   ObjectCreate(0,"alertCloseLine_2",OBJ_HLINE,0,0,beLevelLine);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrSilver);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_BACK, true);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_ZORDER, 0);



   return(true);
  }

//+------------------------------------------------------------------+
//|                          Market Order BUY Double                 |
//+------------------------------------------------------------------+
bool  CControlsDialog::MarketBuyDoubleOrder()
  {
   CTrade trade;
   double beLevelLine = 0;
   if(m_LotsEdit.Text() != "" && m_SlPipsEdit.Text() != "" && m_RiskToRewardRatioEdit.Text() != "")
     {
      GetOrderData();

      tpBuy =  ask + ask - slBuy;
      posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

      Print("Lots = ",posLots," SL pips = ",slPips," RRR = ",RiskToReward, " SL Buy = ",slBuy, " Ask = ",ask," Ask - SL Buy = ",NormalizeDouble(ask-slBuy,_Digits),
            " TP = ", tpBuy, " TP - ask = ",NormalizeDouble(tpBuy - ask,_Digits));

      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE MARKET BUY";

      if(posLots > 0 && slPips > 0 && RiskToReward > 0)
        {
         if(trade.Buy(posLots,_Symbol,ask,slBuy,tpBuy,tradeComment))
           {
            Print("Bought ",posLots," Lots of ",_Symbol," @ ",ask," SL = ",slBuy, " TP = ",tpBuy);
           }

         beLevelLine = tpBuy;
         tpBuy =  0;

         if(trade.Buy(posLots,_Symbol,ask,slBuy,tpBuy,tradeComment))
           {
            Print("Bought ",posLots," Lots of ",_Symbol," @ ",ask," SL = ",slBuy, " TP = ",tpBuy);
           }

        }
      else
        {
         Print("Incorrect input");
        }
     }
   else
     {
      Print("Not enough input");
     }

// add breakeven line
   Print("beLevelLine = ",beLevelLine);
   ObjectCreate(0,"alertCloseLine_1",OBJ_HLINE,0,0,beLevelLine);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrSilver);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_BACK, true);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_ZORDER, 0);



   return(true);
  }

//+------------------------------------------------------------------+
//|                          PendingSellStopDoubleOrder              |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingSellStopDoubleOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   lineTpNew = lineSlNew - 2*(lineSlNew - linePriceNew);
   posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

   string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE SELL STOP";

   if(lineSlNew > linePriceNew && (linePriceNew >= lineTpNew) && linePriceNew < ask)
     {
      if(trade.SellStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
      lineTpNew = 0;
      if(trade.SellStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for SellStop Double Order operation");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingSellLimitDoubleOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   lineTpNew = lineSlNew - 2*(lineSlNew - linePriceNew);
   posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

   if(lineSlNew > linePriceNew && (linePriceNew >= lineTpNew) && linePriceNew > ask)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE SELL LIMIT";
      if(trade.SellLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
      lineTpNew = 0;
      if(trade.SellLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("SellLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }

     }
   else
     {
      Print("Incorrect input parameters for SellLimit Double operation");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingBuyStopDoubleOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   lineTpNew = linePriceNew + linePriceNew - lineSlNew;
   posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

   if(lineSlNew < linePriceNew && (linePriceNew <= lineTpNew) && linePriceNew > bid)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE BUY STOP";
      if(trade.BuyStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
      lineTpNew = 0;
      if(trade.BuyStop(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyStop Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for BuyStop operation");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::PendingBuyLimitDoubleOrder()
  {
   CTrade trade;
   GetOrderData();
   GetDataFromLines();

   lineTpNew = linePriceNew + linePriceNew - lineSlNew;
   posLots = CheckPositionVolume(NormalizeDouble(0.5 * posLots,2));

   if(lineSlNew < linePriceNew && (linePriceNew <= lineTpNew) && linePriceNew < bid)
     {
      string tradeComment = StrategyStr[m_StrategySelectorCBox.Value()] + " " + IntegerToString(PeriodSeconds(PERIOD_CURRENT)/60) + " DOUBLE BUY LIMIT";
      if(trade.BuyLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
      lineTpNew = 0;
      if(trade.BuyLimit(posLots,linePriceNew,_Symbol,lineSlNew,lineTpNew,ORDER_TIME_GTC,0,tradeComment))
        {
         Print("BuyLimit Placed ",posLots," Lots of ",_Symbol," @ ",linePriceNew," SL = ",lineSlNew, " TP = ",lineTpNew);
        }
     }
   else
     {
      Print("Incorrect input parameters for BuyLimit Double operation");
     }
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CalculatePosition()
  {
   calcRRR = 0;

   long spreadLineInput = SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);

   Print("spreadLineInput = ",spreadLineInput);

   if(lineInput)
     {
      double percentRisk = NormalizeDouble(StringToDouble(m_RiskEdit.Text()),2);
      double AccountBalance = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE),2);
      double AmountToRisk = NormalizeDouble(AccountBalance*percentRisk/100,2);
      double ValuePp = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);

      if(pendingToggle)
        {
         inputPrice = NormalizeDouble(ObjectGetDouble(0,"priceLine",OBJPROP_PRICE),_Digits);
         string inputPriceStr = DoubleToString(inputPrice,4);
         m_PriceEdit.Text(inputPriceStr);
        }

      inputStopLoss = NormalizeDouble(ObjectGetDouble(0,"stopLossLine",OBJPROP_PRICE),_Digits);
      inputTakeProfit = NormalizeDouble(ObjectGetDouble(0,"takeProfitLine",OBJPROP_PRICE),_Digits);

      string inputStopLossStr = DoubleToString(inputStopLoss,_Digits);
      string inputTakeProfitStr = DoubleToString(inputTakeProfit,_Digits);

      m_SlEdit.Text(inputStopLossStr);
      m_TpEdit.Text(inputTakeProfitStr);

      if(pendingToggle)
        {
         calcTpPips = 0.1*MathAbs(inputTakeProfit - inputPrice)/_Point;
         calcSlPips = 0.1*MathAbs(inputStopLoss - inputPrice)/_Point;
        }
      else
         if(!pendingToggle)
           {
            if(sellToggle && !buyToggle) // SELL
              {
               calcSlPips = NormalizeDouble(0.1* (((inputStopLoss - ask)/_Point)),0);
               calcTpPips = NormalizeDouble(0.1*(((ask - inputTakeProfit)/_Point)),0);
              }
            else
               if(!sellToggle && buyToggle) // BUY
                 {
                  calcSlPips = NormalizeDouble(0.1*(((bid - inputStopLoss)/_Point)),0);
                  calcTpPips = NormalizeDouble(0.1*(((inputTakeProfit - bid)/_Point)),0);
                 }

            calcRRR = NormalizeDouble(calcTpPips/calcSlPips,2);
           }

      m_TpPipsEdit.Text(DoubleToString(NormalizeDouble(MathRound(calcTpPips),1),0));
      m_SlPipsEdit.Text(DoubleToString(NormalizeDouble(MathRound(calcSlPips),1),0));
      m_RiskToRewardRatioEdit.Text(DoubleToString(NormalizeDouble(calcRRR,1),1)); // RRR calculation

      double LotsCalculated = CheckPositionVolume((0.01 * NormalizeDouble(AmountToRisk/calcSlPips*10/ValuePp,2)));

      string LotsCalculatedStr = DoubleToString(LotsCalculated,2);

      m_LotsEdit.Text(DoubleToString(LotsCalculated,2));
      Print("SL Pips = ",calcSlPips);
      Print("Lots = ", LotsCalculated, " ",LotsCalculatedStr);
     }
   else
      if(!lineInput)
        {
         if(m_RiskEdit.Text() !="" && m_SlPipsEdit.Text() != "")
           {
            double percentRisk = NormalizeDouble(StringToDouble(m_RiskEdit.Text()),2);
            double AccountBalance = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE),2);
            double AmountToRisk = NormalizeDouble(AccountBalance*percentRisk/100,2);
            double ValuePp = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);

            double LotsCalculated = CheckPositionVolume((NormalizeDouble(AmountToRisk/(StringToDouble(m_SlPipsEdit.Text())*10)/ValuePp,2)));

            string LotsCalculatedStr = DoubleToString(LotsCalculated,2);

            if(
               percentRisk > 0 &&
               AccountBalance > 0 &&
               AmountToRisk  > 0 &&
               ValuePp > 0 &&
               LotsCalculated > 0
            )
              {
               m_LotsEdit.Text(DoubleToString(LotsCalculated,2));
              }
            else
              {
               Print("Incorrect Input...");
              }
           }
         else
           {
            Print("Not enough Input...");
           }
        }

   return(true);
  }



//+--------------------------------------------------------------------------------------------+
//|     Checking if position is greater than minimum lot size and if it is divisible by it     |
//+--------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CControlsDialog::CheckPositionVolume(double lotSize)
  {

   if(!DisplayInfo())
      Print(__FUNCTION__,"failed...");

   double MinLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double MaxLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double StepLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);

   int LotDigits = 0;

   if(MinLot == 0.001)
      LotDigits = 3;
   if(MinLot == 0.01)
      LotDigits = 2;
   if(MinLot == 0.1)
      LotDigits = 1;

   lotSize = NormalizeDouble(lotSize,LotDigits);

   if(lotSize < MinLot)
      lotSize = MinLot;

   if(lotSize > MaxLot)
      lotSize = MaxLot;

   double rate = 0;
   double price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   if(!OrderCalcMargin(ORDER_TYPE_BUY,_Symbol,lotSize,price,rate))
      Print("OrderCalcMargin Function Failed...");

   m_MarginRequiredDisplLbl.Text(DoubleToString(rate,2));


   if(rate > AccountFreeMargin)
     {
      ObjectSetInteger(0,ExtDialog.Name()+"MarginRequiredDisplLbl",OBJPROP_COLOR,clrRed);
      Print("Needed margin is larger than available free margin");
     }
   else
      if(rate < AccountFreeMargin)
         ObjectSetInteger(0,ExtDialog.Name()+"MarginRequiredDisplLbl",OBJPROP_COLOR,clrForestGreen);

   if(MathMod(lotSize,StepLot) != 0)
      lotSize = lotSize - MathMod(lotSize,StepLot);

   return(lotSize);
  }

//+------------------------------------------------------------------+
//| Function to display information on labels                        |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::DisplayInfo()
  {
   string spreadStr = IntegerToString(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
   datetime CandleCountDown_bar_Opened = iTime(_Symbol,PERIOD_CURRENT,0);
   datetime CandleCountDown_bar_Closed = PeriodSeconds(PERIOD_CURRENT);
   datetime CandleCountDown_counting   =  CandleCountDown_bar_Opened + CandleCountDown_bar_Closed - TimeCurrent();
   string timeTillCloseStr = TimeToString(CandleCountDown_counting, TIME_MINUTES|TIME_SECONDS);
   AccountFreeMargin = NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_FREE) * marginToBallancePercent/100,2);

   CControlsDialog::m_SpreadLbl.Text(spreadStr);
   CControlsDialog::m_TimeTillCandleCloseLbl.Text(timeTillCloseStr);
   CControlsDialog::m_MarginAvailableDisplLbl.Text(DoubleToString(AccountFreeMargin,2));

   return(true);
  }


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  Function that blocks signals for currency pairs which are symmetrical to the ones which already have open positions                                                                |
//+------------------------------------------------------------------+
bool SymmetricalPositionFilter(string pairName)
  {
   bool symmetry = false;
   StringReplace(pairName," ",NULL);

   if(!StringToUpper(pairName))
      Print(__FUNCTION__,"Error...");

   if(StringFind(pairName,"0") >= 0 ||
      StringFind(pairName,"1") >= 0 ||
      StringFind(pairName,"2") >= 0 ||
      StringFind(pairName,"3") >= 0 ||
      StringFind(pairName,"4") >= 0 ||
      StringFind(pairName,"5") >= 0 ||
      StringFind(pairName,"6") >= 0 ||
      StringFind(pairName,"7") >= 0 ||
      StringFind(pairName,"8") >= 0 ||
      StringFind(pairName,"9") >= 0)
     {
      return(symmetry);
     }
   else
     {
      int totalPos = PositionsTotal();

      string currency1 = StringSubstr(pairName,0,3);
      string currency2 = StringSubstr(pairName,3,3);

      for(int i = 0; i < totalPos; i++)
        {
         ulong posTicket = PositionGetTicket(i);

         if(PositionSelectByTicket(posTicket))
            if(
               StringFind(PositionGetString(POSITION_SYMBOL),currency1) != -1 ||
               StringFind(PositionGetString(POSITION_SYMBOL),currency2) != -1
            )
              {
               symmetry = true;
               return(symmetry);
              }
        }

      return(symmetry);

     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Function that blocks signals for instruments with open positions |
//+------------------------------------------------------------------+
bool OpenPositionFilter(string pairName)
  {
   bool posExists = false;

   int totalPos = PositionsTotal();

   for(int i = 0; i < totalPos; i++)
     {
      ulong posTicket = PositionGetTicket(i);

      if(PositionSelectByTicket(posTicket))
         if(PositionGetString(POSITION_SYMBOL) == pairName)
           {
            posExists = true;
            return(posExists);
           }
     }

   return(posExists);
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|        Calcualte total volume at risk                            |
//+------------------------------------------------------------------+
double calculateVaR()
  {
   int totalPos = PositionsTotal();
   double totalRisk = 0;
   double TotalRiskVolume = 0;
   string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   double accountBallance = AccountInfoDouble(ACCOUNT_BALANCE);
   double TotalStopLoss = 0;

   if(totalPos > 0)
     {
      for(int i = 0; i < totalPos; i++)
        {
         ulong posTicket = PositionGetTicket(i);

         if(PositionSelectByTicket(posTicket))
           {
            CTrade trade;
            string posSymbol = PositionGetString(POSITION_SYMBOL);
            int posDigits = (int)SymbolInfoInteger(posSymbol,SYMBOL_DIGITS);
            double posOpenPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),posDigits);
            double posSl = NormalizeDouble(PositionGetDouble(POSITION_SL),posDigits);
            double posVolume = NormalizeDouble(PositionGetDouble(POSITION_VOLUME),2);
            double posPoint = SymbolInfoDouble(posSymbol,SYMBOL_POINT);
            double tickValue = NormalizeDouble(SymbolInfoDouble(posSymbol,SYMBOL_TRADE_TICK_VALUE)/posPoint,posDigits);

            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)  // checking if the open position has type BUY
               if(posSl < posOpenPrice)
                 {
                  double riskVolume = NormalizeDouble((posOpenPrice - posSl)*posVolume*tickValue,2);
                  TotalRiskVolume += riskVolume;
                 }

            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)  // checking if the open position has type SELL
               if(posSl > posOpenPrice)
                 {
                  double riskVolume = NormalizeDouble((posSl - posOpenPrice)*posVolume*tickValue,2);
                  TotalRiskVolume += riskVolume;
                 }

           }

        }
     }

   return(TotalRiskVolume);

  } // end of calculate VaR
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|    Function that stops alerts if VaR is > than VaR limit         |
//+------------------------------------------------------------------+
bool VaRfilterGo(double riskLimit)
  {
   string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   double TotalRiskVolume = calculateVaR();
   double accountBallance = AccountInfoDouble(ACCOUNT_BALANCE);
   double percentAtRisk = 0;

   if(accountBallance > 0)
      percentAtRisk = NormalizeDouble(TotalRiskVolume / accountBallance * 100,2);
   else
      return(false);

   if(percentAtRisk < riskLimit)
      return(true);
   else
      return(false);

  }


//+------------------------------------------------------------------+
//|              Function to draw position rectangles                |
//+------------------------------------------------------------------+
bool CControlsDialog::DrawPositionRectangles()
  {
   int totalPos = PositionsTotal();

// Find number of open positions on current chart
   int totalPosCurrentChart = 0;
   for(int i=0; i<totalPos; i++)
     {
      ulong posTicket = PositionGetTicket(i);
      if(PositionSelectByTicket(posTicket))
        {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol)
           {
            totalPosCurrentChart += 1;
           }
        }
     }
// End Find number of open positions on current chart

   if(totalPosCurrentChart>0)
     {
      for(int i = 0; i < totalPos; i++)
        {
         ulong posTicket = PositionGetTicket(i);

         if(PositionSelectByTicket(posTicket))
           {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol)
              {
               long time1 = PositionGetInteger(POSITION_TIME);
               long time2 = time1+(PeriodSeconds(_Period)*15);
               double price1 = PositionGetDouble(POSITION_PRICE_OPEN);

               double price2 = PositionGetDouble(POSITION_SL);
               double price3 = PositionGetDouble(POSITION_TP);
               string posProfit = AccountInfoString(ACCOUNT_CURRENCY) + " " + DoubleToString(PositionGetDouble(POSITION_PROFIT),2);

               if(showProfitOnChart)
                 {
                  updateProfitOnchart = true;
                  ObjectCreate(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJ_TEXT,0,time1,price1);
                  ObjectSetString(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_TEXT,posProfit);
                  ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_COLOR,clrAqua);
                  ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_SELECTABLE,true);
                  ObjectSetInteger(0,"AR_PositionProfitLbl" + IntegerToString(i),OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
                 }

               if(price2 > 0)
                 {
                  ObjectCreate(0, "AR_SL_Rectangle_"+IntegerToString(i), OBJ_RECTANGLE, 0, time1, price1, time2, price2);
                  ObjectSetInteger(0,"AR_SL_Rectangle_"+IntegerToString(i),OBJPROP_COLOR,clrIndianRed);
                  ObjectSetInteger(0,"AR_SL_Rectangle_"+IntegerToString(i),OBJPROP_FILL,false);
                  ObjectSetInteger(0,"AR_SL_Rectangle_"+IntegerToString(i),OBJPROP_SELECTABLE,true);
                  ObjectSetInteger(0,"AR_SL_Rectangle_"+IntegerToString(i),OBJPROP_BACK,true);
                 }

               if(price3 > 0)
                 {

                  alertCloseLine = true;

                  ObjectCreate(0, "AR_TP_Rectangle_"+IntegerToString(i), OBJ_RECTANGLE, 0, time1, price1, time2, price3);
                  ObjectSetInteger(0,"AR_TP_Rectangle_"+IntegerToString(i),OBJPROP_COLOR, clrForestGreen);
                  ObjectSetInteger(0,"AR_TP_Rectangle_"+IntegerToString(i),OBJPROP_FILL,false);
                  ObjectSetInteger(0,"AR_TP_Rectangle_"+IntegerToString(i),OBJPROP_SELECTABLE,true);
                  ObjectSetInteger(0,"AR_TP_Rectangle_"+IntegerToString(i),OBJPROP_BACK,true);


                 }
              }
           }
        }
     }
   else
      if(totalPosCurrentChart == 0)
        {
         alertCloseLine = false;
         m_ManualBEBtn.Color(clrBlack);
         string Name;
         for(int i = ObjectsTotal(0,0) -1 ; i >= 0; i--)
           {
            Name = ObjectName(0,i);
            if(StringSubstr(Name, 0, 3) == "AR_")
               ObjectDelete(0,Name);
            if(StringSubstr(Name, 0, 10) == "alertClose")
               ObjectDelete(0,Name);
           }
        }
   return(true);
  }


//+------------------------------------------------------------------+
//|          Function to set Manual BE lines                         |
//+------------------------------------------------------------------+
bool CControlsDialog::SetManualBE()
  {

   if(alertCloseLine)
     {

      if(manualBEToggle)
         manualBEToggle = false;
      else
         if(!manualBEToggle)
            manualBEToggle = true;

      if(manualBEToggle)
        {
         m_ManualBEBtn.Color(clrRed);
         m_AlertCloseBtn.Color(clrBlack);
         setAlarmCloseLine = false;
         ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrDeepSkyBlue);
         ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrDeepSkyBlue);

         ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTED, false);
         ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTED, false);
        }
      else
         if(!manualBEToggle)
           {
            m_ManualBEBtn.Color(clrBlack);
            ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrSilver);
            ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrSilver);
           }

     }
   return(true);
  }


//+------------------------------------------------------------------+
//|      Function that draws boxes used for drawing sessions         |
//+------------------------------------------------------------------+
bool drawBox(string boxName, string boxTime1, string boxTime2, color boxColor)
  {
   datetime time1 = StringToTime(boxTime1);
   datetime time2 = StringToTime(boxTime2);
   int      time1_shift    = iBarShift(_Symbol,PERIOD_CURRENT,time1);
   int      time2_shift    = iBarShift(_Symbol,PERIOD_CURRENT,time2);
   int      bar_count   = time1_shift-time2_shift;
   int      high_shift  = iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,bar_count,time2_shift);
   int      low_shift   = iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,bar_count,time2_shift);
   double   price1        = iHigh(_Symbol,PERIOD_CURRENT,high_shift);
   double   price2         = iLow(_Symbol,PERIOD_CURRENT,low_shift);
   ObjectCreate(0, boxName, OBJ_RECTANGLE, 0, time1, price1, time2, price2);
   ObjectSetInteger(0,boxName,OBJPROP_COLOR,boxColor);
   ObjectSetInteger(0,boxName,OBJPROP_FILL,false);
   ObjectSetInteger(0,boxName,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,boxName,OBJPROP_STYLE,STYLE_DOT);
   return true;

  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                  fractalsTrendFilterBear                      |
//+------------------------------------------------------------------+
bool fractalsTrendFilterBear()
  {

   bool fractalsTrend = false;


   if(fractalTrendFilter)
     {
      double high_1 = 0;
      double high_2 = 0;
      double high_3 = 0;
      double high_4 = 0;
      double high_5 = 0;
      double upperFractals[];

      ArrayResize(upperFractals,3);
      ArrayInitialize(upperFractals,0);
      ArraySetAsSeries(upperFractals,true);

      int k = 0;
      for(int i=3; i<200; i++)
        {
         high_1 = iHigh(_Symbol,TimeFrame,i+2);
         high_2 = iHigh(_Symbol,TimeFrame,i+1);
         high_3 = iHigh(_Symbol,TimeFrame,i);
         high_4 = iHigh(_Symbol,TimeFrame,i-1);
         high_5 = iHigh(_Symbol,TimeFrame,i-2);

         if(high_3 > high_2 && high_3 > high_1 && high_3 > high_4 && high_3 > high_5)
            if(k<3)
              {
               upperFractals[k] = high_3;
               k+=1;
              }
        }


      if(upperFractals[0] < upperFractals[1] && upperFractals[1] < upperFractals[2])
         fractalsTrend = true;


      // Debugging
      debugComment += "======== "+ __FUNCTION__ " ===\n";
      debugComment += "|=> " + DoubleToString(upperFractals[0],_Digits) + " " + DoubleToString(upperFractals[1],_Digits) + " " + DoubleToString(upperFractals[2],_Digits) + " \n";
      debugComment += "|=> Bearish Trend = " + IntegerToString(fractalsTrend) + "\n";
     }
   else
      if(!fractalTrendFilter)
        {
         fractalsTrend = true;
         debugComment += "======== "+ __FUNCTION__ " ===\n";
         debugComment += "|=> Bearish Trend = " + IntegerToString(fractalsTrend) + "\n";
        }

   return fractalsTrend;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                  fractalsTrendFilterBull                         |
//+------------------------------------------------------------------+
bool fractalsTrendFilterBull()
  {

   bool fractalsTrend = false;

   if(fractalTrendFilter)
     {
      double low_1 = 0;
      double low_2 = 0;
      double low_3 = 0;
      double low_4 = 0;
      double low_5 = 0;
      double lowerFractals[];

      ArrayResize(lowerFractals,3);
      ArrayInitialize(lowerFractals,0);
      ArraySetAsSeries(lowerFractals,true);

      int l = 0;
      for(int i=3; i<200; i++)
        {
         low_1 = iLow(_Symbol,PERIOD_CURRENT,i+2);
         low_2 = iLow(_Symbol,PERIOD_CURRENT,i+1);
         low_3 = iLow(_Symbol,PERIOD_CURRENT,i);
         low_4 = iLow(_Symbol,PERIOD_CURRENT,i-1);
         low_5 = iLow(_Symbol,PERIOD_CURRENT,i-2);

         if(low_3 < low_2 && low_3 < low_1 && low_3 < low_4 && low_3 < low_5)
            if(l<3)
              {
               lowerFractals[l] = low_3;
               l+=1;
              }
        }


      if(lowerFractals[0] > lowerFractals[1] && lowerFractals[1] > lowerFractals[2])
         fractalsTrend = true;

      // Debugging
      debugComment += "======== "+ __FUNCTION__ " ===\n";
      debugComment += "|=> " + DoubleToString(lowerFractals[0],_Digits) + " " + DoubleToString(lowerFractals[1],_Digits) + " " + DoubleToString(lowerFractals[2],_Digits) + " \n";
      debugComment += "|=> Fractals Bullish Trend = " + IntegerToString(fractalsTrend) + "\n";
     }
   else
      if(!fractalTrendFilter)
        {
         fractalsTrend = true;
         debugComment += "======== "+ __FUNCTION__ " ===\n";
         debugComment += "|=> Bullish Trend = " + IntegerToString(fractalsTrend) + "\n";
        }

   return fractalsTrend;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  StochasticOscillatorFilterBull                  |
//+------------------------------------------------------------------+
bool StochasticOscillatorFilterBull()
  {

   bool stochasticOscillatorFilterBull = false;

   if(soFilter)
     {
      double main_buffer[];
      double signal_buffer[];

      if(CopyBuffer(handleSOFilter,MAIN_LINE,0,2,main_buffer)<0)
        {
         PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError());
         return false;
        }


      if(CopyBuffer(handleSOFilter,SIGNAL_LINE,0,2,signal_buffer)<0)
        {
         PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError());
         return false;
        }

      double soMainSignalDiff = main_buffer[1] - signal_buffer[1];

      //  if((signal_buffer[1] < 80 && signal_buffer[1] > 20) || (main_buffer[1] < 80 && main_buffer[1] > 20))
      if(soMainSignalDiff > soFilterStrength)
         stochasticOscillatorFilterBull = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING stochasticOscillatorFilterBear ===\n";
         debugComment += "|=> main_buffer[1] = " + DoubleToString(main_buffer[1],_Digits) + " signal_buffer[1] = " + DoubleToString(signal_buffer[1],_Digits) + " \n";
         debugComment += "|=> soMainSignalDiff = " + DoubleToString(soMainSignalDiff,_Digits) + " \n";
         debugComment += "|=> main_buffer[1] = " + IntegerToString(stochasticOscillatorFilterBull) + " \n";
        }

     }
   else
      if(!soFilter)
         stochasticOscillatorFilterBull = true;

   return stochasticOscillatorFilterBull;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  StochasticOscilatorFilterBear                   |
//+------------------------------------------------------------------+
bool StochasticOscillatorFilterBear()
  {

   bool stochasticOscillatorFilterBear = false;

   if(soFilter)
     {
      double main_buffer[];
      double signal_buffer[];

      if(CopyBuffer(handleSOFilter,MAIN_LINE,0,2,main_buffer)<0)
        {
         PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleSOFilter,SIGNAL_LINE,0,2,signal_buffer)<0)
        {
         PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError());
         return false;
        }

      double soMainSignalDiff = signal_buffer[1] - main_buffer[1];

      //   if((signal_buffer[1] < 80 && signal_buffer[1] > 20) || (main_buffer[1] < 80 && main_buffer[1] > 20))
      if(soMainSignalDiff > soFilterStrength)
         stochasticOscillatorFilterBear = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING stochasticOscillatorFilterBear ===\n";
         debugComment += "|=> main_buffer[1] = " + DoubleToString(main_buffer[1],_Digits) + " signal_buffer[1] = " + DoubleToString(signal_buffer[1],_Digits) + " \n";
         debugComment += "|=> soMainSignalDiff = " + DoubleToString(soMainSignalDiff,_Digits) + " \n";
         debugComment += "|=> main_buffer[1] = " + IntegerToString(stochasticOscillatorFilterBear) + " \n";
        }

     }
   else
      if(!soFilter)
         stochasticOscillatorFilterBear = true;

   return stochasticOscillatorFilterBear;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  RSI_MA_FilterBull                               |
//+------------------------------------------------------------------+
bool RSI_MA_FilterBull()
  {
   bool RSI_MA_BULL = false;
   if(rsiMAFilter)
     {
      double RSI_buffer[];
      double RSI_MA_buffer[];

      if(CopyBuffer(handleRSIFilter,0,0,3,RSI_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleRSIMAFilter,0,0,3,RSI_MA_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(RSI_buffer[1] > RSI_buffer[0] && RSI_buffer[1] > RSI_MA_buffer[1])
         RSI_MA_BULL = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING RSI_MA_FilterBull ===\n";
         debugComment += "|=> RSI_buffer[1] = " + DoubleToString(RSI_buffer[1],2) + " RSI_MA_buffer[1] = " + DoubleToString(RSI_MA_buffer[1],2) + " \n";
         debugComment += "|=> RSI_MA_BULL = " + IntegerToString(RSI_MA_BULL) + " \n";
        }

     }
   else
      if(!rsiMAFilter)
        {
         RSI_MA_BULL = true;
        }

   return RSI_MA_BULL;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  RSI_MA_FilterBear                               |
//+------------------------------------------------------------------+
bool RSI_MA_FilterBear()
  {
   bool RSI_MA_BEAR = false;
   if(rsiMAFilter)
     {
      double RSI_buffer[];
      double RSI_MA_buffer[];

      if(CopyBuffer(handleRSIFilter,0,0,3,RSI_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleRSIMAFilter,0,0,3,RSI_MA_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(RSI_buffer[1] < RSI_buffer[0] && RSI_buffer[1] < RSI_MA_buffer[1])
         RSI_MA_BEAR = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING RSI_MA_FilterBull ===\n";
         debugComment += "|=> RSI_buffer[1] = " + DoubleToString(RSI_buffer[1],2) + " RSI_MA_buffer[1] = " + DoubleToString(RSI_MA_buffer[1],2) + " \n";
         debugComment += "|=> RSI_MA_BEAR = " + IntegerToString(RSI_MA_BEAR) + " \n";
        }

     }

   else
      if(!rsiMAFilter)
        {
         RSI_MA_BEAR = true;
        }

   return RSI_MA_BEAR;
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                  MA_Filter Bull                                  |
//+------------------------------------------------------------------+
bool MA_FilterBull()
  {
   bool MA_BULL = false;
   if(useMAFilter)
     {
      double MA_buffer[];
      double LastClosePrice = iClose(_Symbol,TimeFrame,1);

      if(CopyBuffer(handleMAFilter,0,0,3,MA_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(LastClosePrice > MA_buffer[1])
         MA_BULL = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING MA Filter General BULL ===\n";
         debugComment += "|=> MA for LastClosePrice = " + DoubleToString(MA_buffer[1],_Digits) + " \n";
         debugComment += "|=> LastClosePrice = " + DoubleToString(LastClosePrice,_Digits) + " \n";
         debugComment += "|=> MA_BULL = " + IntegerToString(MA_BULL) + " \n";
        }

     }
   else
      if(!useMAFilter)
        {
         MA_BULL = true;
        }

   return MA_BULL;
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                  MA_Filter BEAR                                  |
//+------------------------------------------------------------------+
bool MA_FilterBear()
  {
   bool MA_BEAR = false;
   if(useMAFilter)
     {
      double MA_buffer[];
      double LastClosePrice = iClose(_Symbol,TimeFrame,1);

      if(CopyBuffer(handleMAFilter,0,0,3,MA_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(LastClosePrice < MA_buffer[1])
         MA_BEAR = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING MA Filter General BEAR ===\n";
         debugComment += "|=> MA for LastClosePrice = " + DoubleToString(MA_buffer[1],_Digits) + " \n";
         debugComment += "|=> LastClosePrice = " + DoubleToString(LastClosePrice,_Digits) + " \n";
         debugComment += "|=> MA_BEAR = " + IntegerToString(MA_BEAR) + " \n";
        }

     }
   else
      if(!useMAFilter)
        {
         MA_BEAR = true;
        }

   return MA_BEAR;
  }


//+------------------------------------------------------------------+
//|                  3xMA_Filter Bull                                |
//+------------------------------------------------------------------+
bool MAx3_FilterBull()
  {
   bool MAx3_BULL = false;
   if(use3xMAFilter)
     {
      double MA1_buffer[];
      double MA2_buffer[];
      double MA3_buffer[];
      double LastClosePrice = iClose(_Symbol,TimeFrame,1);

      if(CopyBuffer(handleMA1Filter,0,0,3,MA1_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleMA2Filter,0,0,3,MA2_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleMA3Filter,0,0,3,MA3_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if((LastClosePrice > MA3_buffer[1]) && (MA3_buffer[1] > MA2_buffer[1]) && (MA2_buffer[1] > MA1_buffer[1]))
         MAx3_BULL = true;

     }
   else
      if(!use3xMAFilter)
        {
         MAx3_BULL = true;
        }

   return MAx3_BULL;
  }

//+------------------------------------------------------------------+
//|                  3xMA_Filter BEAR                                |
//+------------------------------------------------------------------+
bool MAx3_FilterBear()
  {
   bool MAx3_BEAR = false;
   if(use3xMAFilter)
     {
      double MA1_buffer[];
      double MA2_buffer[];
      double MA3_buffer[];
      double LastClosePrice = iClose(_Symbol,TimeFrame,1);

      if(CopyBuffer(handleMA1Filter,0,0,3,MA1_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleMA2Filter,0,0,3,MA2_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleMA3Filter,0,0,3,MA3_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if((LastClosePrice < MA3_buffer[1]) && (MA3_buffer[1] < MA2_buffer[1]) && (MA2_buffer[1] < MA1_buffer[1]))
         MAx3_BEAR = true;

     }
   else
      if(!use3xMAFilter)
        {
         MAx3_BEAR = true;
        }

   return MAx3_BEAR;
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  AO_Filter Bull                                  |
//+------------------------------------------------------------------+
bool AO_FilterBull()
  {
   bool AO_BULL = false;
   if(useAOFilter)
     {
      double AO_buffer[];

      if(CopyBuffer(handleAOFilter,0,0,3,AO_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      ArraySetAsSeries(AO_buffer,true);

      // [0] = current bar
      // [1] = previous bar

      if(AO_buffer[0] > AO_buffer[1])
         AO_BULL = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING AO Filter General BULL ===\n";
         debugComment += "|=> AO_buffer[0] = " + DoubleToString(AO_buffer[0],_Digits) + " \n";
         debugComment += "|=> AO_buffer[1] = " + DoubleToString(AO_buffer[1],_Digits) + " \n";
         debugComment += "|=> AO_BULL = " + IntegerToString(AO_BULL) + " \n";
        }

     }
   else
      if(!useAOFilter)
        {
         AO_BULL = true;
        }

   return AO_BULL;
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                  AO_Filter Bear                                  |
//+------------------------------------------------------------------+
bool AO_FilterBear()
  {
   bool AO_BEAR = false;
   if(useAOFilter)
     {
      double AO_buffer[];

      if(CopyBuffer(handleAOFilter,0,0,3,AO_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      ArraySetAsSeries(AO_buffer,true);

      if(AO_buffer[0] < AO_buffer[1])
         AO_BEAR = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING AO Filter General BULL ===\n";
         debugComment += "|=> AO_buffer[0] = " + DoubleToString(AO_buffer[0],_Digits) + " \n";
         debugComment += "|=> AO_buffer[1] = " + DoubleToString(AO_buffer[1],_Digits) + " \n";
         debugComment += "|=> AO_BEAR = " + IntegerToString(AO_BEAR) + " \n";
        }

     }
   else
      if(!useAOFilter)
        {
         AO_BEAR = true;
        }

   return AO_BEAR;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  AO_Filter Bull                                  |
//+------------------------------------------------------------------+
bool AC_FilterBull()
  {
   bool AC_BULL = false;
   if(useACFilter)
     {
      double AC_buffer[];

      if(CopyBuffer(handleACFilter,0,0,3,AC_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      ArraySetAsSeries(AC_buffer,true);

      // [0] = current bar
      // [1] = previous bar

      if(AC_buffer[0] > AC_buffer[1])
         AC_BULL = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING AC Filter General BULL ===\n";
         debugComment += "|=> AC_buffer[0] = " + DoubleToString(AC_buffer[0],_Digits) + " \n";
         debugComment += "|=> AC_buffer[1] = " + DoubleToString(AC_buffer[1],_Digits) + " \n";
         debugComment += "|=> AC_BULL = " + IntegerToString(AC_BULL) + " \n";
        }

     }
   else
      if(!useACFilter)
        {
         AC_BULL = true;
        }

   return AC_BULL;
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                  AC_Filter Bear                                  |
//+------------------------------------------------------------------+
bool AC_FilterBear()
  {
   bool AC_BEAR = false;
   if(useACFilter)
     {
      double AC_buffer[];

      if(CopyBuffer(handleACFilter,0,0,3,AC_buffer)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      ArraySetAsSeries(AC_buffer,true);

      if(AC_buffer[0] < AC_buffer[1])
         AC_BEAR = true;

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING AC Filter General BULL ===\n";
         debugComment += "|=> AC_buffer[1] = " + DoubleToString(AC_buffer[1],_Digits) + " \n";
         debugComment += "|=> AC_buffer[0] = " + DoubleToString(AC_buffer[0],_Digits) + " \n";
         debugComment += "|=> AC_BEAR = " + IntegerToString(AC_BEAR) + " \n";
        }

     }
   else
      if(!useACFilter)
        {
         AC_BEAR = true;
        }

   return AC_BEAR;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  Alligator_Filter Bull                           |
//+------------------------------------------------------------------+
bool Alligator_FilterBull()
  {
   bool Alligator_BULL = false;
   if(useAlligatorFilter)
     {

      double alligatorLipsEndArr[];
      double alligatorTeethEndArr[];
      double alligatorJawEndArr[];

      ArraySetAsSeries(alligatorLipsEndArr,true);
      ArraySetAsSeries(alligatorTeethEndArr,true);
      ArraySetAsSeries(alligatorJawEndArr,true);

      ArrayInitialize(alligatorLipsEndArr,0);
      ArrayInitialize(alligatorTeethEndArr,0);
      ArrayInitialize(alligatorJawEndArr,0);

      if(CopyBuffer(handleAlligator,2,-4,8,alligatorLipsEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleAlligator,1,-6,8,alligatorTeethEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleAlligator,0,-9,8,alligatorJawEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }


      if(alligatorLipsEndArr[0] > alligatorTeethEndArr[0] && alligatorTeethEndArr[0] > alligatorJawEndArr[0])
        {
         Alligator_BULL = true;

        }

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING Alligator Filter BULL ===\n";
         debugComment += "|=> alligatorLipsEndArr[0] = " + DoubleToString(alligatorLipsEndArr[0],_Digits) + " \n";
         debugComment += "|=> alligatorTeethEndArr[0] = " + DoubleToString(alligatorTeethEndArr[0],_Digits) + " \n";
         debugComment += "|=> alligatorJawEndArr[0] = " + DoubleToString(alligatorJawEndArr[0],_Digits) + " \n";
         debugComment += "|=> Alligator_BULL = " + IntegerToString(Alligator_BULL) + " \n";
        }

     }
   else
      if(!useAlligatorFilter)
        {
         Alligator_BULL = true;
        }

   return Alligator_BULL;
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                  Alligator_Filter Bear                           |
//+------------------------------------------------------------------+
bool Alligator_FilterBear()
  {
   bool Alligator_BEAR = false;
   if(useAlligatorFilter)
     {

      double alligatorLipsEndArr[];
      double alligatorTeethEndArr[];
      double alligatorJawEndArr[];

      ArraySetAsSeries(alligatorLipsEndArr,true);
      ArraySetAsSeries(alligatorTeethEndArr,true);
      ArraySetAsSeries(alligatorJawEndArr,true);

      ArrayInitialize(alligatorLipsEndArr,0);
      ArrayInitialize(alligatorTeethEndArr,0);
      ArrayInitialize(alligatorJawEndArr,0);

      if(CopyBuffer(handleAlligator,2,-4,8,alligatorLipsEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleAlligator,1,-6,8,alligatorTeethEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }

      if(CopyBuffer(handleAlligator,0,-9,8,alligatorJawEndArr)<0)
        {
         PrintFormat("Failed to copy data, error code %d",GetLastError());
         return false;
        }


      if(alligatorLipsEndArr[0] < alligatorTeethEndArr[0] && alligatorTeethEndArr[0] < alligatorJawEndArr[0])
        {
         Alligator_BEAR = true;

        }

      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING Alligator Filter BEAR ===\n";
         debugComment += "|=> alligatorLipsEndArr[0] = " + DoubleToString(alligatorLipsEndArr[0],_Digits) + " \n";
         debugComment += "|=> alligatorTeethEndArr[0] = " + DoubleToString(alligatorTeethEndArr[0],_Digits) + " \n";
         debugComment += "|=> alligatorJawEndArr[0] = " + DoubleToString(alligatorJawEndArr[0],_Digits) + " \n";
         debugComment += "|=> Alligator_BEAR = " + IntegerToString(Alligator_BEAR) + " \n";
        }

     }
   else
      if(!useAlligatorFilter)
        {
         Alligator_BEAR = true;
        }

   return Alligator_BEAR;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|    Upper Fractal Calculation                                     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double UpperFractalCalculation()
  {
   double high_1 = 0;
   double high_2 = 0;
   double high_3 = 0;
   double high_4 = 0;
   double high_5 = 0;
   double upperFractal = 0;


   int k = 0;
   for(int i=3; i<200; i++)
     {
      high_1 = iHigh(_Symbol,_Period,i+2);
      high_2 = iHigh(_Symbol,_Period,i+1);
      high_3 = iHigh(_Symbol,_Period,i);
      high_4 = iHigh(_Symbol,_Period,i-1);
      high_5 = iHigh(_Symbol,_Period,i-2);

      if(high_3 > high_2 && high_3 > high_1 && high_3 > high_4 && high_3 > high_5)
         if(k<3)
           {
            upperFractal = NormalizeDouble(high_3,_Digits);
            return upperFractal;
           }
     }

   return upperFractal;

  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|    Lower Fractal Calculation                                     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LowerFractalCalculation()
  {
   double low_1 = 0;
   double low_2 = 0;
   double low_3 = 0;
   double low_4 = 0;
   double low_5 = 0;
   double lowerFractal = 0;


   int k = 0;
   for(int i=3; i<200; i++)
     {
      low_1 = iLow(_Symbol,_Period,i+2);
      low_2 = iLow(_Symbol,_Period,i+1);
      low_3 = iLow(_Symbol,_Period,i);
      low_4 = iLow(_Symbol,_Period,i-1);
      low_5 = iLow(_Symbol,_Period,i-2);

      if(low_3 < low_2 && low_3 < low_1 && low_3 < low_4 && low_3 < low_5)
         if(k<3)
           {
            lowerFractal = NormalizeDouble(low_3,_Digits);
            return lowerFractal;
           }
     }

   return lowerFractal;

  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  Ichimoku_Filter Bull                           |
//+------------------------------------------------------------------+
bool Ichimoku_FilterBull()
  {
   bool Ichimoku_BULL = false;
   if(useIchimokuFilter)
     {

      double ClosePrice_1 = iClose(_Symbol,TimeFrame,1);

      double TenkansenArr[];
      double KijunsenArr[];
      double SenkouspanAArr[];
      double SenkouspanBArr[];

      double ShiftedSenkouspanAArr[];
      double ShiftedSenkouspanBArr[];

      double ChikouspanArr[];

      double Bar26High = iHigh(_Symbol,TimeFrame,26);
      double Bar26Low = iLow(_Symbol,TimeFrame,26);
      double CurrentHigh = iHigh(_Symbol,TimeFrame,0);
      double CurrentLow = iLow(_Symbol,TimeFrame,0);

      CopyBuffer(handleIchimoku,0,1,1,TenkansenArr);
      CopyBuffer(handleIchimoku,1,1,1,KijunsenArr);
      CopyBuffer(handleIchimoku,2,1,1,SenkouspanAArr);
      CopyBuffer(handleIchimoku,3,1,1,SenkouspanBArr);

      CopyBuffer(handleIchimoku,2,-26,1,ShiftedSenkouspanAArr);
      CopyBuffer(handleIchimoku,3,-26,1,ShiftedSenkouspanBArr);

      CopyBuffer(handleIchimoku,4,26,1,ChikouspanArr);


      if(ClosePrice_1 > SenkouspanAArr[0] &&
         ClosePrice_1 > SenkouspanBArr[0] &&
         ClosePrice_1 > KijunsenArr[0] &&
         TenkansenArr[0] > KijunsenArr[0] &&
         ShiftedSenkouspanAArr[0] > ShiftedSenkouspanBArr[0] &&
         ChikouspanArr[0] > Bar26High)
        {
         Ichimoku_BULL = true;
        }



      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING Ichimoku Filter BULL ===\n";
         debugComment += "|=> ClosePrice_1 = " + DoubleToString(ClosePrice_1,_Digits) + " \n";
         debugComment += "|=> SenkouspanAArr[0] = " + DoubleToString(SenkouspanAArr[0],_Digits) + " \n";
         debugComment += "|=> SenkouspanBArr[0] = " + DoubleToString(SenkouspanBArr[0],_Digits) + " \n";
         debugComment += "|=> TenkansenArr[0] = " + DoubleToString(TenkansenArr[0],_Digits) + " \n";
         debugComment += "|=> KijunsenArr[0] = " + DoubleToString(KijunsenArr[0],_Digits) + " \n";
         debugComment += "|=> ShiftedSenkouspanAArr[0] = " + DoubleToString(ShiftedSenkouspanAArr[0],_Digits) + " \n";
         debugComment += "|=> ShiftedSenkouspanBArr[0] = " + DoubleToString(ShiftedSenkouspanBArr[0],_Digits) + " \n";
         debugComment += "|=> ChikouspanArr[0] = " + DoubleToString(ChikouspanArr[0],_Digits) + " \n";
         debugComment += "|=> Bar26High = " + DoubleToString(Bar26High,_Digits) + " \n";
         debugComment += "|=> Ichimoku_BULL = " + IntegerToString(Ichimoku_BULL) + " \n";
        }



     }
   else
      if(!useIchimokuFilter)
        {
         Ichimoku_BULL = true;
        }

   return Ichimoku_BULL;
  }


//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                  Ichimoku_Filter Bear                            |
//+------------------------------------------------------------------+
bool Ichimoku_FilterBear()
  {
   bool Ichimoku_BEAR = false;
   if(useIchimokuFilter)
     {

      double ClosePrice_1 = iClose(_Symbol,TimeFrame,1);

      double TenkansenArr[];
      double KijunsenArr[];
      double SenkouspanAArr[];
      double SenkouspanBArr[];

      double ShiftedSenkouspanAArr[];
      double ShiftedSenkouspanBArr[];

      double ChikouspanArr[];

      double Bar26High = iHigh(_Symbol,TimeFrame,26);
      double Bar26Low = iLow(_Symbol,TimeFrame,26);
      double CurrentHigh = iHigh(_Symbol,TimeFrame,0);
      double CurrentLow = iLow(_Symbol,TimeFrame,0);

      CopyBuffer(handleIchimoku,0,1,1,TenkansenArr);
      CopyBuffer(handleIchimoku,1,1,1,KijunsenArr);
      CopyBuffer(handleIchimoku,2,1,1,SenkouspanAArr);
      CopyBuffer(handleIchimoku,3,1,1,SenkouspanBArr);

      CopyBuffer(handleIchimoku,2,-26,1,ShiftedSenkouspanAArr);
      CopyBuffer(handleIchimoku,3,-26,1,ShiftedSenkouspanBArr);

      CopyBuffer(handleIchimoku,4,26,1,ChikouspanArr);


      if(ClosePrice_1 < SenkouspanAArr[0] &&
         ClosePrice_1 < SenkouspanBArr[0] &&
         ClosePrice_1 < KijunsenArr[0] &&
         TenkansenArr[0] < KijunsenArr[0] &&
         ShiftedSenkouspanAArr[0] < ShiftedSenkouspanBArr[0] &&
         ChikouspanArr[0] < Bar26High)
        {
         Ichimoku_BEAR = true;
        }


      if(debuggingComments)
        {
         debugComment += "======== DEBUGGING Ichimoku Filter BEAR ===\n";
         debugComment += "|=> ClosePrice_1 = " + DoubleToString(ClosePrice_1,_Digits) + " \n";
         debugComment += "|=> SenkouspanAArr[0] = " + DoubleToString(SenkouspanAArr[0],_Digits) + " \n";
         debugComment += "|=> SenkouspanBArr[0] = " + DoubleToString(SenkouspanBArr[0],_Digits) + " \n";
         debugComment += "|=> TenkansenArr[0] = " + DoubleToString(TenkansenArr[0],_Digits) + " \n";
         debugComment += "|=> KijunsenArr[0] = " + DoubleToString(KijunsenArr[0],_Digits) + " \n";
         debugComment += "|=> ShiftedSenkouspanAArr[0] = " + DoubleToString(ShiftedSenkouspanAArr[0],_Digits) + " \n";
         debugComment += "|=> ShiftedSenkouspanBArr[0] = " + DoubleToString(ShiftedSenkouspanBArr[0],_Digits) + " \n";
         debugComment += "|=> ChikouspanArr[0] = " + DoubleToString(ChikouspanArr[0],_Digits) + " \n";
         debugComment += "|=> Bar26High = " + DoubleToString(Bar26High,_Digits) + " \n";
         debugComment += "|=> Ichimoku_BEAR = " + IntegerToString(Ichimoku_BEAR) + " \n";
        }


     }
   else
      if(!useIchimokuFilter)
        {
         Ichimoku_BEAR = true;
        }

   return Ichimoku_BEAR;
  }



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                  Calc Profit                                     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Profit_Calculation()
  {
   int totalPos = PositionsTotal();
   double posProfit = 0;
   for(int i = 0; i < totalPos; i++)
     {
      ulong posTicket = PositionGetTicket(i);

      if(PositionSelectByTicket(posTicket))
        {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol)
           {
            posProfit += PositionGetDouble(POSITION_PROFIT);
           }
        }
     }
   posProfit = NormalizeDouble(posProfit,2);
   return posProfit;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::CreateAlertCloseLines()
  {
   ObjectCreate(0,"alertCloseLine_1",OBJ_HLINE,0,0,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK)+100*_Point,_Digits));
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_COLOR, clrSilver);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_BACK, true);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_SELECTED, true);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "alertCloseLine_1", OBJPROP_ZORDER, 0);

   ObjectCreate(0,"alertCloseLine_2",OBJ_HLINE,0,0,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID)-100*_Point,_Digits));
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_COLOR, clrSilver);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_BACK, true);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_SELECTED, true);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, "alertCloseLine_2", OBJPROP_ZORDER, 0);

   return true;
  }
//+------------------------------------------------------------------+
