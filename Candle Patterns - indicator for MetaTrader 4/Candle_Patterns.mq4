//+------------------------------------------------------------------+
//|                                              Candle Patterns.mq4 |
//|                                         Copyright © 2008, sx ted |
//|                                           tedhirsch@talktalk.net |
//|                                                       2008.12.16 |
//| Purpose..: Visual and Audio alerts when reversal or continuation |
//|            candle patterns occur.                                |
//| Based On.: Many many thanks to:                                  |
//|            1) Japanese Candlesticks http://www.candlesticker.com |
//|            2) CandleCode by Victor Likhovidov, references to be  |
//|               found at http://www.forexschool.ru                 |
//| Thank you: Big thank you CodersGuru at http://www.forex-tsd.com  |
//|            for coding the gSpeak() function so as to have audio  |
//|            signals.                                              |
//| Setup....: Place files into the following subdirectories:        |
//|                Candle Patterns.mq4 into "\experts\indicators",   |
//|                Candle Patterns.csv into "\experts\files",        |
//|                Candle Patterns.rtd into "\experts\files",        |
//|                Symbols_.csv        into "\experts\files",        |
//|                gSpeak.mqh          into "\experts\include",      |
//|                speak.dll           into "\experts\libraries",    |
//|                candle patterns.tpl into "\templates".            |
//|            Close and then re-start MetaTrader for it to find the |
//|            new files.                                            |
//|            Select "Indicators" -> "Custom" -> "Candle Patterns". |
//|            The "Custom Indicator" window is displayed, select    |
//|            "Common" and enable "Allow DLL imports".              |
//|            "Inputs" are described in file "Candle Patterns.rtd", |
//|            alternatively right click on the chart and select     |
//|            "candle patterns.tpl" from "Templates".               |
//| Note 1...: While testing, the indicator has not yet encountered  |
//|            patterns comprised of four or five candles, please let|
//|            me know on which broker's chart and time frame seen   |
//|            and publish it on the forum as a .GIF image would be  |
//|            super.                                                |
//| Note 2...: Delete the Candle Patterns indicator from the chart   |
//|            before changing the period.                           |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, sx ted"
#property link      "tedhirsch@talktalk.net"

//+------------------------------------------------------------------+
//| indicator setup                                                  |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2                                       // helps improve memory

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
#include <gSpeak.mqh>

//+------------------------------------------------------------------+
//| input parameters:                                                |
//+-----------0---+----1----+----2----+----3]------------------------+
extern int           MaxBarsToScanForPatterns = 1;                  //  0: display visible patterns only
                                                                    //  1: display pattern of bar 1 only
                                                                    // >1: display patterns up to MaxBars
extern bool                    ConfirmPattern = true;
extern bool                MoveTextOneRowDown = true;
extern bool                           AudioON = true;
extern color                ColorSingleCandle = Aqua;
extern color                ColorMultiCandles = DeepSkyBlue;
extern color       AlternateColorSingleCandle = Yellow;
extern color       AlternateColorMultiCandles = Gold;
extern color                   ColorArrowDown = DarkOrange;
extern color                     ColorArrowUp = Lime;
extern color                        ColorText = LemonChiffon;
extern int                VerticalTextAdjustX = 1;                  // adjust co-ord x of vertical text
extern int               VerticalTextFontSize = 8;                  // for zoom level 3
extern int                     TrendMA_Period = 13;                 // Averaging period for calculation
extern int                      TrendMA_Shift = 15;                 // Shift relative to the current bar
                                                                    // to compare the averages so as to
                                                                    // determine the trend

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define CALC_ALL                                          -9        // calculate all flag
#define MAX_CANDLES                                        5        // max candles in a pattern
#define ERR_0                                              0.00001  // avoid divide by zero factor
//-------------------------------------------------------------------- Candle and shadow sizes:
#define CandleBodyCount                                    0        // Candle Body Count if size > 0
#define CandleBodyTotal                                    1        // Candle Body aggregate
#define SmallCandleBody                                    2        // Candle Body Small (top threshold)
#define LongCandleBody                                     3        // Candle Body Long (bottom threshold)
#define UpperShadowCount                                   4        // Upper Shadow Count if size > 0
#define UpperShadowTotal                                   5        // Upper Shadow aggregate
#define SmallUpperShadow                                   6        // Upper Shadow Small (top threshold)
#define LongUpperShadow                                    7        // Upper Shadow Long (bottom threshold)
#define BottomShadowCount                                  8        // Lower Shadow Count if size > 0
#define BottomShadowTotal                                  9        // Lower Shadow aggregate
#define SmallBottomShadow                                 10        // Lower Shadow Small (top threshold)
#define LongBottomShadow                                  11        // Lower Shadow Long (bottom threshold)
#define SIZE_CNT                                          12        // array dSize count of elements
#define LT_FACTOR                                          0.31     // Lower Threshold Factor
//-------------------------------------------------------------------- Base Candles:
#define FourPriceDoji                                      0        // 0
#define Umbrella_1                                         1        // 1
#define Umbrella_2                                         2        // 2
#define Doji                                               3        // 3
#define DojiSN                                             4        // 4 Doji with small/normal legs
#define DojiSNL                                            5        // 5 Doji with all kinds of legs
#define InvertedUmbrella_6                                 6        // 6
#define InvertedUmbrella_7                                 7        // 7
#define LongLeggedDoji_8                                   8        // 8   
#define LongLeggedDoji_9                                   9        // 9   
#define SmallBlackCandle                                  10        // A
#define HighWave                                          11        // B     
#define BlackSpinningTop                                  12        // C
#define BlackCandle                                       13        // D
#define BlackCandleDay4LadderBottom                       14        // E
#define BlackDay3ConcealBabySwallow                       15        // F
#define BlackMarubozu                                     16        // G   
#define BlackOpeningMarubozu                              17        // H  
#define BlackOpeningMarubozuLongshadow                    18        // I
#define BlackClosingMarubozu                              19        // J  
#define LongBlackCandle                                   20        // K
#define SmallWhiteCandle                                  21        // L
#define WhiteSpinningTop                                  22        // M  
#define WhiteCandle                                       23        // N
#define WhiteMarubozu                                     24        // O   
#define WhiteClosingMarubozu                              25        // P  
#define WhiteOpeningMarubozu                              26        // Q  
#define LongWhiteCandle                                   27        // R  
#define BlackHammerOrHangingMan                           28        // S  
#define WhiteHammerOrHangingMan                           29        // T              
#define InvertedUmbrella_U                                30        // U   
#define InvertedUmbrella_V                                31        // V
#define BlackInvertedHammerOrStar                         32        // W 
#define WhiteInvertedHammerOrStar                         33        // X                      
//-------------------------------------------------------------------- sPattern: specs & name
#define P_DISPLAY    0 // Display flag:        1=Display,     0=Hide
#define P_TYP        1 // pattern Type:        R=Reversal,    C=Continuation,  X=Reversal/Continuation
#define P_REE        2 // pattern Relevance:   D=Bearish,     U=Bullish,       I=Indecision
#define P_PRV        3 // Previous trend:      D=Bearish,     U=Bullish        X=N/A
#define P_NUM        4 // Number of candles
#define P_CHK        5 // confirmation Check:  refer to ConfirmPattern para
#define P_LEN        6 // Length of name
#define P_NAM        7 // pattern Name
//-------------------------------------------------------------------- arrow shapes:
#define C_DN       "ê" // -22 was 234 for identifying font "Wingdings" character Arrow Down
#define C_UP       "é" // -23 was 233 for identifying font "Wingdings" character Arrow Up
//-------------------------------------------------------------------- Text to Audio:
#define M_BUY      "Buy"
#define M_DN       "Pattern confirmed down"
#define M_REV_DN   "Pattern confirmed reverse down"
#define M_REV_UP   "Pattern confirmed reverse up"
#define M_UP       "Pattern confirmed up"
#define M_SELL     "Sell"
#define M_NULL     ""
//-------------------------------------------------------------------- Trade Type:
#define TT_BUY         0 // Buy
#define TT_SELL        1 // Sell
#define TT_NO_PATTERN -1 // No Pattern found
#define TT_WAIT       -2 // cater for Reversal/Continuation and wait for confirmation
//-------------------------------------------------------------------- font:
#define V_TXT_FONT_SIZE 8 // original font size used while scaling vertical text 

//+------------------------------------------------------------------+
//| global variables to program:                                     |
//+------------------------------------------------------------------+
bool     bAlternateColorMulti,
         bAlternateColorSingle,
         TrendDn,
         TrendUp;
datetime tPreviousTime;
double   dSize[SIZE_CNT],                                           // candle sizes
         dPipsFactor,                                               // price to pips conversion factor
         O[MAX_CANDLES],                                            // Open
         H[MAX_CANDLES],                                            // High
         L[MAX_CANDLES],                                            // Low
         C[MAX_CANDLES],                                            // Close
         B[MAX_CANDLES],                                            // candle body bottom
         T[MAX_CANDLES];                                            // candle body top
int      candle[MAX_CANDLES],                                       // candle code
         iBarsToScan,
         iPattern,                                                  // candle Pattern number         
         iPeriod,      
         iScaleAdjustX,                                             // used for vertical text alignment
         iScaleAdjustX_MN,                                          // PERIOD MN1 basis for pro rata calc              
         iScaleAdjustY,
         iVeryNear,
         iVerySmallBody;
string   sBoxObj,
         sMsg,
         sAudio,
         sPRV,                                                      // Previous Trend Confirmation arrow
         sREE,                                                      // Relevance Confirmation arrow
         sSymbol;
/*-------------------------------------------------------------------- Base Candles:
                             Dec,Base candle code number             , p,c, b , u, l */ 
int      iBaseCandle[96][2]={  0,FourPriceDoji,                     // 0,0,000,00,00         
                               3,Umbrella_1,                        // 0,0,000,00,11           
                               4,InvertedUmbrella_U,                // 0,0,000,01,00          
                               5,Doji,                              // 0,0,000,01,01
                               6,DojiSN,                            // 0,0,000,01,10
                               7,DojiSNL,                           // 0,0,000,01,11
                               8,InvertedUmbrella_V,                // 0,0,000,10,00          
                               9,DojiSN,                            // 0,0,000,10,01
                              10,DojiSN,                            // 0,0,000,10,10
                              11,DojiSNL,                           // 0,0,000,10,11
                              12,InvertedUmbrella_6,                // 0,0,000,11,00          
                              13,DojiSNL,                           // 0,0,000,11,01
                              14,DojiSNL,                           // 0,0,000,11,10
                              15,LongLeggedDoji_8,                  // 0,0,000,11,11         
                              19,Umbrella_2,                        // 0,0,001,00,11           
                              21,DojiSN,                            // 0,0,001,01,01
                              22,DojiSN,                            // 0,0,001,01,10
                              23,DojiSNL,                           // 0,0,001,01,11
                              25,DojiSN,                            // 0,0,001,10,01
                              26,DojiSN,                            // 0,0,001,10,10
                              27,DojiSNL,                           // 0,0,001,10,11
                              28,InvertedUmbrella_7,                // 0,0,001,11,00          
                              29,DojiSNL,                           // 0,0,001,11,01
                              30,DojiSNL,                           // 0,0,001,11,10
                              31,LongLeggedDoji_9,                  // 0,0,001,11,11         
                              39,HighWave,                          // 0,0,010,01,11          
                              43,HighWave,                          // 0,0,010,10,11          
                              45,HighWave,                          // 0,0,010,11,01          
                              46,HighWave,                          // 0,0,010,11,10          
                              47,HighWave,                          // 0,0,010,11,11          
                              56,BlackCandleDay4LadderBottom,       // 0,0,011,10,00 
                              60,BlackDay3ConcealBabySwallow,       // 0,0,011,11,00
                              64,BlackMarubozu,                     // 0,0,100,00,00          
                              65,BlackOpeningMarubozu,              // 0,0,100,00,01         
                              66,BlackOpeningMarubozu,              // 0,0,100,00,10         
                              67,BlackOpeningMarubozuLongshadow,    // 0,0,100,00,11     
                              68,BlackClosingMarubozu,              // 0,0,100,01,00         
                              69,LongBlackCandle,                   // 0,0,100,01,01         
                              70,LongBlackCandle,                   // 0,0,100,01,10         
                              71,LongBlackCandle,                   // 0,0,100,01,11         
                              72,BlackClosingMarubozu,              // 0,0,100,10,00         
                              73,LongBlackCandle,                   // 0,0,100,10,01         
                              74,LongBlackCandle,                   // 0,0,100,10,10         
                              75,LongBlackCandle,                   // 0,0,100,10,11         
                              76,BlackClosingMarubozu,              // 0,0,100,11,00         
                              77,LongBlackCandle,                   // 0,0,100,11,01         
                              78,LongBlackCandle,                   // 0,0,100,11,10         
                              79,LongBlackCandle,                   // 0,0,100,11,11         
                             147,Umbrella_2,                        // 0,1,001,00,11           
                             149,DojiSN,                            // 0,1,001,01,01
                             150,DojiSN,                            // 0,1,001,01,10
                             151,DojiSNL,                           // 0,1,001,01,11
                             153,DojiSN,                            // 0,1,001,10,01
                             154,DojiSN,                            // 0,1,001,10,10
                             155,DojiSNL,                           // 0,1,001,10,11
                             156,InvertedUmbrella_7,                // 0,1,001,11,00          
                             157,DojiSNL,                           // 0,1,001,11,01
                             158,DojiSNL,                           // 0,1,001,11,10
                             159,LongLeggedDoji_9,                  // 0,1,001,11,11         
                             167,HighWave,                          // 0,1,010,01,11          
                             171,HighWave,                          // 0,1,010,10,11          
                             173,HighWave,                          // 0,1,010,11,01          
                             174,HighWave,                          // 0,1,010,11,10          
                             175,HighWave,                          // 0,1,010,11,11          
                             192,WhiteMarubozu,                     // 0,1,100,00,00          
                             193,WhiteClosingMarubozu,              // 0,1,100,00,01         
                             194,WhiteClosingMarubozu,              // 0,1,100,00,10         
                             195,WhiteClosingMarubozu,              // 0,1,100,00,11         
                             196,WhiteOpeningMarubozu,              // 0,1,100,01,00         
                             197,LongWhiteCandle,                   // 0,1,100,01,01         
                             198,LongWhiteCandle,                   // 0,1,100,01,10         
                             199,LongWhiteCandle,                   // 0,1,100,01,11         
                             200,WhiteOpeningMarubozu,              // 0,1,100,10,00         
                             201,LongWhiteCandle,                   // 0,1,100,10,01         
                             202,LongWhiteCandle,                   // 0,1,100,10,10         
                             203,LongWhiteCandle,                   // 0,1,100,10,11         
                             204,WhiteOpeningMarubozu,              // 0,1,100,11,00         
                             205,LongWhiteCandle,                   // 0,1,100,11,01         
                             206,LongWhiteCandle,                   // 0,1,100,11,10         
                             207,LongWhiteCandle,                   // 0,1,100,11,11         
                             291,BlackHammerOrHangingMan,           // 1,0,010,00,11         
                             293,SmallBlackCandle,                  // 1,0,010,01,01         
                             298,BlackSpinningTop,                  // 1,0,010,10,10         
                             299,BlackSpinningTop,                  // 1,0,010,10,11         
                             300,BlackInvertedHammerOrStar,         // 1,0,010,11,00        
                             302,BlackSpinningTop,                  // 1,0,010,11,10         
                             303,BlackSpinningTop,                  // 1,0,010,11,11         
                             309,BlackCandle,                       // 1,0,011,01,01          
                             419,WhiteHammerOrHangingMan,           // 1,1,010,00,11         
                             421,SmallWhiteCandle,                  // 1,1,010,01,01         
                             426,WhiteSpinningTop,                  // 1,1,010,10,10         
                             427,WhiteSpinningTop,                  // 1,1,010,10,11         
                             428,WhiteInvertedHammerOrStar,         // 1,1,010,11,00        
                             430,WhiteSpinningTop,                  // 1,1,010,11,10         
                             431,WhiteSpinningTop,                  // 1,1,010,11,11         
                             437,WhiteCandle                        // 1,1,011,01,01         
                            }; 
//-------------------------------------------------------------------- Candle Patterns:
string sPattern[91][8];
                     
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  //                     Period    ,TextSize,ChartHeight,
  int iTextRatios[9][3]={PERIOD_M1 ,       5,         20,           // TextSize based on Pattern number
                         PERIOD_M5 ,      21,         70,           // 40 and scaled using the Crosshair
                         PERIOD_M15,      32,        110,           // and custom indicator CP_TextSize.
                         PERIOD_M30,      35,        120,           // 
                         PERIOD_H1 ,      35,        120,           // ChartHeight is the height of chart
                         PERIOD_H4 ,     139,        470,           // in points, with no sub-windows,
                         PERIOD_D1 ,     285,        960,           // when Pattern 40 was scaled,
                         PERIOD_W1 ,     552,       1864,           // corresponds to PriceMaxVisible()
                         PERIOD_MN1,    1729,       5850            // minus PriceMinVisible().
                        },
      i, x;
              
  ObjectsDeletePrefixed("CP_");
  candle[0]=CALC_ALL;                                               // load all flag
  dPipsFactor=MathPow(10, Digits);
  dSize[0]=CALC_ALL;                                                // calculate average for all bars flag
  iPattern=TT_NO_PATTERN;
  iPeriod=Period();
  sBoxObj="";
  sMsg="";
  sAudio="";
  sPRV="";
  sREE="";   
  sSymbol=Symbol();
  tPreviousTime=D'01.01.2008';
  
  if(StringArrayLoad("Candle Patterns.csv", sPattern, 8)<1)
    sMsg=StringConcatenate(sMsg,"Error "+GetLastError()+" reading file Candle Patterns.csv\n");  
  
  if(AudioON) {
    if(IsDllsAllowed()==false) sMsg=StringConcatenate(sMsg,"Check \"Allow DLL imports\" to enable program\n");
    string sSymbols[][2];
    x=StringArrayLoad("Symbols_.csv", sSymbols, 2);
    if(x<1) sMsg=StringConcatenate(sMsg,"Error "+GetLastError()+" reading file Symbols_.csv\n");  
    for(i=0; i<x; i++) {
      if(sSymbols[i][0]==sSymbol) break;
    }
    if(i<x) sAudio=sSymbols[i][1];
    else    sMsg=StringConcatenate(sMsg,"Symbol not found\n");
    string sPeriods[9][2]={   "1", "1 minute",
                              "5", "5 minutes",
                             "15", "15 minutes",
                             "30", "30 minutes",
                             "60", "1 hour",
                            "240", "4 hour",
                           "1440", "Daily",
                          "10080", "Weekly",
                          "43200", "Monthly"
                         }; 
    for(i=0; i<9; i++)  {
      if(sPeriods[i][0]==DoubleToStr(iPeriod,0)) break;
    }
    if(i<9) sAudio=StringConcatenate(sAudio," ",sPeriods[i][1]," ");
    else    sMsg=StringConcatenate(sMsg,"Period not found\n");
  }
    
  if(MaxBarsToScanForPatterns == 1) {
    CreateLabelObject("CP_CONFIRM_PRIOR_TREND", 1, 76, MoveTextOneRowDown*10);
    CreateLabelObject("CP_CONFIRM_RELEVANCE"  , 1, 61, MoveTextOneRowDown*10);
    CreateLabelObject("CP_TYPE"               , 1, 46, MoveTextOneRowDown*10);
    CreateLabelObject("CP_PRIOR_TREND"        , 1, 31, MoveTextOneRowDown*10);
    CreateLabelObject("CP_RELEVANCE"          , 1, 16, MoveTextOneRowDown*10);
    CreateLabelObject("CP_CONFIRMATION"       , 1,  1, MoveTextOneRowDown*10);
    CreateLabelObject("CP_NAME"               , 0,  0, MoveTextOneRowDown*10);
  }
  else {
    if(WindowsTotal() > 1) Alert("Labels may overwrite candles if sub-windows open!");
    // determine factors for adjustment of vertical text so that labels
    // do not overlay candles, if possible, as MT4 co-ordinates refer
    // to the center of label object's (horizontal by design)
    iScaleAdjustX=-1;
    iScaleAdjustX_MN=-1;
    for(i=0; i<9; i++) {                                            // for all chart timeframe's
      if(iTextRatios[i][0] == iPeriod) {
        iScaleAdjustX=iTextRatios[i][1];
        iScaleAdjustY=iTextRatios[i][2];
      }
      if(iTextRatios[i][0] == PERIOD_MN1) iScaleAdjustX_MN=iTextRatios[i][1];
    }
    if(iScaleAdjustX == -1 || iScaleAdjustX_MN == -1) sMsg=StringConcatenate(sMsg,"Period not found\n");
    iBarsToScan=MathMin(Bars-MAX_CANDLES,MathMax(MaxBarsToScanForPatterns,WindowBarsPerChart()));
    if(iBarsToScan < MAX_CANDLES+1) sMsg=StringConcatenate(sMsg,"Bars < ",MAX_CANDLES+1,"\n");
    for(i=iBarsToScan; i>1; i--) {
      iPattern=Pattern(i);
      if((iPattern >= 0) && (sPattern[iPattern][P_DISPLAY] == "1")) DisplayPatterns(iPattern, i);
    }
  }
  if(sMsg!="") Alert(sMsg);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
  ObjectsDeletePrefixed("CP_");
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start() {
  color  cColor=ColorArrowUp;
  int    i, x;
  string sChr=C_UP, obj;
  
  if(sMsg!="") return;
  
  if((MaxBarsToScanForPatterns != 1) && (Bars > WindowFirstVisibleBar())) { // Bars > WndLeft
    // Wait for tick and redraw all visible vertical text as chart may have changed height
    i=1;
    int    iWndLeft=WindowFirstVisibleBar();
    double dWndTop=WindowPriceMax(),
           dWndBot=WindowPriceMin(),
           dPriceMax=PriceMaxVisible(),
           dPriceMin=PriceMinVisible();
    if(dPriceMax > dWndTop) dWndTop=dPriceMax;
    if(dPriceMin < dWndBot) dWndBot=dPriceMin;
    while(i <= iWndLeft) {
      obj="CP_"+Time[i];
      if((ObjectFind(obj) >= 0) && (ObjectType(obj) == OBJ_TEXT)) MoveLabel(obj, dWndTop, dWndBot, dPriceMax, dPriceMin);
      i++;
    }
    WindowRedraw(); // force redraw of current chart after moving of objects
  }
  
  if(tPreviousTime == Time[0]) return; // only start analysis on complete bars
  if(Bars < MAX_CANDLES+1) return;

  if(MaxBarsToScanForPatterns == 1) {
    // switch off any previous confirming arrows
    DisplayLabelObject("CP_CONFIRM_PRIOR_TREND", " ", ColorText);
    DisplayLabelObject("CP_CONFIRM_RELEVANCE"  , " ", ColorText);
    
    // remember last pattern number for confirmation of previous candle pattern
    x=iPattern;
  
    // check if newly formed bar 1 matches a candle pattern   
    iPattern=Pattern(1);
    
    PatternConfirm(x);
    
    // delete hilite of previous pattern
    ObjectDelete("CP_BOX");
    // check if a new candle pattern has been found
    if((iPattern >= 0) && (sPattern[iPattern][P_DISPLAY] == "1")) {
      DisplayPattern1(iPattern, 1);
      // display indication of current trend with arrow Up or arrow Down
      if(TrendDn) {
        sChr=C_DN;
        cColor=ColorArrowDown;
      }
      DisplayLabelObject("CP_PRIOR_TREND", sChr, cColor);
      sPRV=sChr;

      /* 
      display indication of Relevance (new direction):
      TYP |REE| PRV | Action
      ----+---+-----+---------------------------------
       C  | D |  D  | Sell                                 
       C  | U |  U  | Buy                                  
       R  | D |  U  | Sell                                 
       R  | D |  X  | Sell                                 
       R  | I |  Xup| Sell Patterns 1/2/3/4                
       R  | I |  Xdn| Buy  Patterns 1/2/3/4                
       R  | U |  D  | Buy                                  
       R  | U |  X  | Buy  Pattern 51                      
       X  | D |  X  | Sell Patterns 46-49 on Relevance     
       X  | I |  X  | Wait                                 
       X  | U |  X  | Buy  Patterns 85-88 on Relevance
      */     
      if((sPattern[iPattern][P_REE] == "U") || (sPattern[iPattern][P_REE] == "I" && sPattern[iPattern][P_TYP] == "R" && TrendDn)) {
        sMsg=M_BUY;
        sChr=C_UP;
        cColor=ColorArrowUp;
      }
      else if((sPattern[iPattern][P_REE] == "D") || (sPattern[iPattern][P_REE] == "I" && sPattern[iPattern][P_TYP] == "R" && TrendUp)) {
        sMsg=M_SELL;
        sChr=C_DN;
        cColor=ColorArrowDown;
      }
      else sChr=sPattern[iPattern][P_REE]; // "I" (Indecision)
      DisplayLabelObject("CP_RELEVANCE", sChr, cColor);
      sREE=sChr;

      // display indication of Pattern Type: R=Reversal, C=Continuation, X=Reversal/Continuation
      DisplayLabelObject("CP_TYPE", sPattern[iPattern][P_TYP], cColor);
      // display Confirmation required: Pattern Type R/C=_Q, X=_S
      if(sPattern[iPattern][P_TYP] == "X") sChr=" ";
      else                                 sChr="?";
      DisplayLabelObject("CP_CONFIRMATION", sChr, cColor);
      sMsg=StringConcatenate(sPattern[iPattern][P_NAM]," ",sMsg);
      if(AudioON) gSpeak(StringConcatenate(sAudio,sPattern[iPattern][P_NAM]));
    }
    else {                                                          // pattern not found
      sMsg=" ";
      sPRV=" ";
      sREE=" ";
      DisplayLabelObject("CP_TYPE"        , " ", ColorArrowDown);
      DisplayLabelObject("CP_PRIOR_TREND" , " ", ColorArrowDown);
      DisplayLabelObject("CP_RELEVANCE"   , " ", ColorArrowDown);
      DisplayLabelObject("CP_CONFIRMATION", " ", ColorArrowDown);
    }
    // display Pattern Name & stats
    ObjectSetText("CP_NAME",sMsg,11,"Verdana",ColorText);
  }
  else {
          
    // delete objects beyond range requested by <iBarsToScan>
    obj="CP_"+Time[iBarsToScan];
    if(ObjectFind(obj) >= 0) ObjectDelete(obj);
    obj="CP_B"+Time[iBarsToScan];
    if(ObjectFind(obj) >= 0) ObjectDelete(obj);
      
    // remember last pattern number for confirmation of previous candle pattern
    x=iPattern;
  
    // check if newly formed bar 1 matches a candle pattern   
    iPattern=Pattern(1);
    
    PatternConfirm(x);
  
    if((iPattern >= 0) && (sPattern[iPattern][P_DISPLAY] == "1")) {
      DisplayPatterns(iPattern, 1);
      if(AudioON) gSpeak(StringConcatenate(sAudio,sPattern[iPattern][P_NAM]));
    }
  }
  tPreviousTime=Time[0];
  sMsg="";
}

//+------------------------------------------------------------------+
//| CreateLabelObject                                                |
//+------------------------------------------------------------------+
void CreateLabelObject(string obj, int iCorner, int x, int y) {
  ObjectCreate(obj, OBJ_LABEL, 0, 0, 0);
  ObjectSet(obj, OBJPROP_CORNER   , iCorner);
  ObjectSet(obj, OBJPROP_XDISTANCE, x      );
  ObjectSet(obj, OBJPROP_YDISTANCE, y      );
}

//+------------------------------------------------------------------+
//| DisplayLabelObject                                               |
//+------------------------------------------------------------------+
void DisplayLabelObject(string obj, string sChr, color cColor) {
  int y=1, iFontSize=14;
  string sFont="Verdana";
  if(sChr == "?" ) { y=0; iFontSize=15; sFont="Verdana"  ; }
  if(sChr == C_DN) { y=5; iFontSize=13; sFont="Wingdings"; }
  if(sChr == C_UP) { y=1; iFontSize=13; sFont="Wingdings"; }
  ObjectSet(obj, OBJPROP_YDISTANCE, MoveTextOneRowDown*10+y);
  ObjectSetText(obj, sChr, iFontSize, sFont, cColor);
}

//+------------------------------------------------------------------+
//| Display Pattern formed at Bar 1                                  |
//+------------------------------------------------------------------+
void DisplayPattern1(int iPattern, int iBar) {
  double dPadY, h,l;
  int    iCandles, x, y;
  
  // determine number of candles found in pattern
  iCandles=StrToInteger(sPattern[iPattern][P_NUM]);
    
  // find position of highest price in the candle pattern
  y=ArrayMaximum(H,iCandles);
  // find position of lowest price in the candle pattern
  x=ArrayMinimum(L,iCandles);
  // convert pip values back to prices for drawing object on chart
  h=H[y]/(ERR_0+dPipsFactor);
  l=L[x]/(ERR_0+dPipsFactor);
  // calculate some padding between the candle pattern and the rectangular box that will hilite it
  dPadY=(PriceMaxVisible() - PriceMinVisible()) * MathPow(10, Digits) / 30 * Point;
    
  // Hilite the candles forming the pattern in coloured box
  ObjectCreate("CP_BOX",OBJ_RECTANGLE,0,Time[iBar+iCandles],h+dPadY,Time[iBar-1],l-dPadY);
  ObjectSet("CP_BOX",OBJPROP_COLOR,AlternateColorSingleCandle);
  // set background drawing flag for object, so as to only draw perimeter
  ObjectSet("CP_BOX",OBJPROP_BACK,false);
}

//+------------------------------------------------------------------+
//| DisplayPatterns()                                                |
//+------------------------------------------------------------------+
void DisplayPatterns(int iPattern, int iBar) {
  color    cColor=ColorSingleCandle;
  datetime t;
  double   dWndTop=WindowPriceMax(),
           dWndBot=WindowPriceMin(),
           dChartHeight=dWndTop-dWndBot,   
           dPriceMax=PriceMaxVisible(),
           dPriceMin=PriceMinVisible(), dPadY, dY, h, l;
  string   obj;
  int      i, iLen, iCandles, x, y;

  if(dPriceMax > dWndTop) dWndTop=dPriceMax;
  if(dPriceMin < dWndBot) dWndBot=dPriceMin;
  // determine number of candles found in pattern
  iCandles=StrToInteger(sPattern[iPattern][P_NUM]);
  // find position of highest price in the candle pattern
  y=ArrayMaximum(H,iCandles);
  // find position of lowest price in the candle pattern
  x=ArrayMinimum(L,iCandles);
  // convert pip values back to prices for drawing object on chart
  h=H[y]/(ERR_0+dPipsFactor);
  l=L[x]/(ERR_0+dPipsFactor);
  // calculate some padding between the candle pattern and the rectangular box that will hilite it
  dPadY=(dPriceMax - dPriceMin) * MathPow(10, Digits) / 30 * Point;
  if(iCandles == 1) {
    bAlternateColorSingle=!bAlternateColorSingle;
    if(bAlternateColorSingle) cColor=AlternateColorSingleCandle;
  }
  else {
    bAlternateColorMulti=!bAlternateColorMulti;
    if(bAlternateColorMulti) cColor=AlternateColorMultiCandles;
    else                     cColor=ColorMultiCandles;
    sBoxObj="CP_B"+Time[iBar];
    // Hilite the candles forming the pattern in colored box
    ObjectCreate(sBoxObj,OBJ_RECTANGLE,0,Time[iBar+iCandles],h+dPadY,Time[iBar-1],l-dPadY);
    ObjectSet(sBoxObj,OBJPROP_COLOR,cColor);
    // set background drawing flag for object, so as to only draw perimeter
    ObjectSet(sBoxObj,OBJPROP_BACK,false);
  }
  // calculate x and y co-ordinates of middle of the string to feed to MT4 ObjectCreate(),
  // only "Arial" font can be used for vertical text in MT4 at present.
  iLen=StrToInteger(sPattern[iPattern][P_LEN]);
  if(dPriceMax-High[iBar] > Low[iBar]-dPriceMin)
    dY=High[iBar]+NormalizeDouble(VerticalTextFontSize/V_TXT_FONT_SIZE*iLen*iScaleAdjustX/iScaleAdjustX_MN*dChartHeight/iScaleAdjustY/2, Digits);
  else
    dY=Low[iBar]-NormalizeDouble(VerticalTextFontSize/V_TXT_FONT_SIZE*iLen*iScaleAdjustX/iScaleAdjustX_MN*dChartHeight/iScaleAdjustY/2, Digits);
  obj="CP_"+Time[iBar];
  // display the text vertically
  ObjectCreate(obj, OBJ_TEXT, 0, Time[iBar+VerticalTextAdjustX], dY);
  ObjectSetText(obj, sPattern[iPattern][P_NAM], VerticalTextFontSize, "Arial", cColor);
  ObjectSet(obj, OBJPROP_ANGLE, 90);
  // keep track of label text width for refresh by storing it in unused OBJECT PROPERTY TIME2 slot
  ObjectSet(obj, OBJPROP_TIME2, iLen);
  // verify that current single pattern is not on right side of just completed box (done on previous bar)
  if(iCandles == 1 && sBoxObj != "") {
    if(ObjectGet(sBoxObj,OBJPROP_TIME2) == Time[iBar]) {
      // keep track of box y co-ordinates for moving label on right
      // hand side out of box if possible for more readable output
      ObjectSet(obj, OBJPROP_PRICE2, ObjectGet(sBoxObj, OBJPROP_PRICE1));
      ObjectSet(obj, OBJPROP_PRICE3, ObjectGet(sBoxObj, OBJPROP_PRICE2));
      // move label on right border of just completed box (on previous bar) if required
      MoveLabel(obj, dWndTop, dWndBot, dPriceMax, dPriceMin);
      WindowRedraw(); // force redraw of current chart after moving of objects
      sBoxObj="";
    }
  }
  else if(iCandles > 1) {
    // keep track of box y co-ordinates for moving labels out of box if possible for more readable output
    i=iBar;
    while(true) {
      obj="CP_"+Time[i];
      if(ObjectFind(obj) < 0 || ObjectGet(obj,OBJPROP_TIME1) < Time[iBar+iCandles+VerticalTextAdjustX])
        break;
      if(ObjectType(obj) == OBJ_TEXT) {
        if(h+dPadY > ObjectGet(obj,OBJPROP_PRICE2))
          ObjectSet(obj, OBJPROP_PRICE2, h+dPadY);
        if(l-dPadY < ObjectGet(obj,OBJPROP_PRICE3) || ObjectGet(obj,OBJPROP_PRICE3) == 0)
          ObjectSet(obj, OBJPROP_PRICE3, l-dPadY);
        MoveLabel(obj, dWndTop, dWndBot, dPriceMax, dPriceMin);
      }
      i++;
    }
    WindowRedraw(); // force redraw of current chart after moving of objects
  }
}

//+------------------------------------------------------------------+
//| Function..: MoveLabel                                            |
//| Purpose...: Move labels out of box if possible (if present) or   |
//|             above or below candles for more readable output.     |
//+------------------------------------------------------------------+
void MoveLabel(string obj, double dWndTop, double dWndBot, double dPriceMax, double dPriceMin) {
  int    x   =iBarShift(sSymbol,iPeriod,ObjectGet(obj,OBJPROP_TIME1))-VerticalTextAdjustX;
  double dHi =ObjectGet(obj,OBJPROP_PRICE2),
         dLo =ObjectGet(obj,OBJPROP_PRICE3),
         dLen=NormalizeDouble(VerticalTextFontSize/V_TXT_FONT_SIZE*ObjectGet(obj,OBJPROP_TIME2)*
              iScaleAdjustX/iScaleAdjustX_MN*(dWndTop-dWndBot)/iScaleAdjustY, Digits),
         dY;
         
  if(dHi != 0) {
    if(High[x] > dHi && High[x]+dLen < dPriceMax)
      dY=High[x]+dLen/2.0;
    else if(Low[x] < dLo && Low[x]-dLen > dPriceMin)
      dY=Low[x]-dLen/2.0;
    else if(dHi+dLen < dPriceMax)
      dY=dHi+dLen/2.0;
    else if(dLo-dLen > dPriceMin)
      dY=dLo-dLen/2.0;
  }         
  if(dY == 0) {
    if(dPriceMax-High[x] > Low[x]-dPriceMin)
      dY=High[x]+dLen/2.0;
    else
      dY=Low[x]-dLen/2.0;
  }
  ObjectMove(obj,0,Time[x+VerticalTextAdjustX],dY);          
}

//+------------------------------------------------------------------+
//| ObjectsDeletePrefixed                                            |
//+------------------------------------------------------------------+
void ObjectsDeletePrefixed(string sPrefix) {
  for(int i=ObjectsTotal()-1; i>=0; i--) {
    if(StringFind(ObjectName(i),sPrefix)==0) ObjectDelete(ObjectName(i));
  }
  Comment("");  
}

//+------------------------------------------------------------------+
//| Candle Pattern                                                   |
//+------------------------------------------------------------------+
int Pattern(int iBar) {
  double b, u, l;
  int    x=1, y=1, i, iPos;
    
  //------------------------------------------------------------------ Candle sizes:
  if(dSize[0]==CALC_ALL) {                                          // calculate average of all bars flag
    ArrayInitialize(dSize,0);
    x=2;
    y=iBars(sSymbol,iPeriod) - 2;
  } 
  for(i=x; i <= y; i++) {
    // Candle Body size
    b=MathAbs(iClose(sSymbol,iPeriod,i)-iOpen(sSymbol,iPeriod,i))*dPipsFactor;
    if(b > 0) {
      dSize[CandleBodyCount]+=1;
      dSize[CandleBodyTotal]+=b;
    }
    // Upper Shadow size
    b=(iHigh(sSymbol,iPeriod,i)-MathMax(iClose(sSymbol,iPeriod,i),iOpen(sSymbol,iPeriod,i)))*dPipsFactor;
    if(b > 0) {
      dSize[UpperShadowCount]+=1;
      dSize[UpperShadowTotal]+=b;
    }
    // Bottom Shadow size 
    b=(MathMin(iClose(sSymbol,iPeriod,i),iOpen(sSymbol,iPeriod,i))-iLow(sSymbol,iPeriod,i))*dPipsFactor;
    if(b > 0) {
      dSize[BottomShadowCount]+=1;
      dSize[BottomShadowTotal]+=b;
    }
  }
  // set Lower & Upper Thresholds of Candle Body
  if(dSize[CandleBodyCount] > 0) {
    // Candle Body Small (top threshold)
    dSize[SmallCandleBody]=dSize[CandleBodyTotal]*2/dSize[CandleBodyCount]*LT_FACTOR;
    // Candle Body Long (bottom threshold)
    dSize[LongCandleBody]=dSize[SmallCandleBody]*(1-LT_FACTOR)/LT_FACTOR;
  }
  // set Lower & Upper Thresholds of Upper Candle Shadows
  if(dSize[UpperShadowCount] > 0) {
    // Upper Shadow Small (top threshold)
    dSize[SmallUpperShadow]=dSize[UpperShadowTotal]*2/dSize[UpperShadowCount]*LT_FACTOR;
    // Upper Shadow Long (bottom threshold)
    dSize[LongUpperShadow]=dSize[SmallUpperShadow]*(1-LT_FACTOR)/LT_FACTOR;
  }
  // set Lower & Upper Thresholds of Lower Candle Shadows
  if(dSize[BottomShadowCount] > 0) {
    // Bottom Shadow Small (top threshold)
    dSize[SmallBottomShadow]=dSize[BottomShadowTotal]*2/dSize[BottomShadowCount]*LT_FACTOR;
    // Bottom Shadow Long (bottom threshold)
    dSize[LongBottomShadow]=dSize[SmallBottomShadow]*(1-LT_FACTOR)/LT_FACTOR;
  }
  // Determine what is "Very Near" for Candle Comparisons
  if(dSize[SmallCandleBody] > 30) iVeryNear=1; else iVeryNear=0;
  // state definition of "Very small" body
  if(dSize[SmallCandleBody] > 30) iVerySmallBody=1; else iVerySmallBody=0;
  //------------------------------------------------------------------ shuffle array elements down
  for(i=MAX_CANDLES-1; i>0; i--) {                                  // by 1 and save re-calculating
    O[i]=O[i-1];
    H[i]=H[i-1];
    L[i]=L[i-1];
    C[i]=C[i-1];
    B[i]=B[i-1];
    T[i]=T[i-1];
    candle[i]=candle[i-1];
  }
  //------------------------------------------------------------------ Load Prices converted to pips:
  if(candle[0]==CALC_ALL) y=MAX_CANDLES;                            // load all flag
  else                    y=1;
  for(i=0; i < y; i++) {
    O[i]=iOpen(sSymbol,iPeriod,iBar+i)*dPipsFactor;                 // Open
    H[i]=iHigh(sSymbol,iPeriod,iBar+i)*dPipsFactor;                 // High
    L[i]=iLow(sSymbol,iPeriod,iBar+i)*dPipsFactor;                  // Low
    C[i]=iClose(sSymbol,iPeriod,iBar+i)*dPipsFactor;                // Close
    B[i]=MathMin(O[i],C[i]);                                        // Bottom of candle body
    T[i]=MathMax(O[i],C[i]);                                        // Top of candle body
  }
  /*------------------------------------------------------------------ Determine base candle code number:
    |   H    H=High of candle
    |u       u=upper shadow size 
  *-*-* T    T=Top of candle body     Max(O, C) O=Open of candle, C=Close of candle
  |   |b     b=candle body size
  *-*-* B    B=Bottom of candle body  Min(O, C)
    |l       l=lower shadow size
    |   L    L=Low of candle
  */
    
  // candle body size
  b=T[0]-B[0];
  
  // upper shadow size
  u=H[0]-T[0];
  
  // lower shadow size                                                                                                                                                                                                                                                   
  l=B[0]-L[0];
    
  /* Determine binary code for each candle:

  | Bit 8             |    7   | 6 | 5 | 4 |   3   |   2  |   1  |   0   |
  *-------------------+--------+---*---*---+-------*------+------*-------*
  | Candle Check Type | Colour |    Body   | Upper Shadow | Lower Shadow | */

  // bit 8: two different checks are made to determine candle:
  // when bit8=0 then b/u/l (body, upper shadow or lower shadow) are defined by size & variable x is used,
  // when bit8=1 then b is defined by size, u & l are defined by comparison codes & variable y is used
  y=256;
  
  // bit 7: colour of the candle: 0=black/Doji, 1=white
  if(C[0] > O[0]) x=128;
  else            x=0;
  
  // bits 6-4: candle body code: 000=No body, 001=Very small, 010=Small, 011=Normal, 100=Long
  if(b >= dSize[LongCandleBody])       x+=64;
  else if(b >= dSize[SmallCandleBody]) x+=48;
  else if(b > iVerySmallBody)          x+=32;
  else if(b > 0)                       x+=16;
  
  // bits 3-2: upper shadow to Body relation: 01: 0 < u <= b, 10: b < u < 2b, 11: u >= 2b
  if(u >= 2*b)   y+=12;
  else if(u > b) y+= 8;
  else if(u > 0) y+= 4;
        
  // bits 1-0: lower shadow to Body relation: 01: 0 < l <= b, 10: b < l < 2b, 11: l >= 2b
  if(l >= 2*b)   y+=3;
  else if(l > b) y+=2;
  else if(l > 0) y+=1;
  
  // check if candle with bit8=1 matches
  iPos=ArrayBsearch(iBaseCandle,x+y);
  if(iBaseCandle[iPos][0] != x+y) {
    // bits 3-2: upper shadow size: 00=No shadow, 01=Small, 10=Normal, 11=Long
    if(u >= dSize[LongUpperShadow])        x+=12;
    else if(u >= dSize[SmallUpperShadow])  x+= 8;
    else if(u > 0)                         x+= 4;
    // bits 1-0: lower shadow size: 00=No shadow, 01=Small, 10=Normal, 11=Long
    if(l >= dSize[LongBottomShadow])       x+=3;
    else if(l >= dSize[SmallBottomShadow]) x+=2;
    else if(l > 0)                         x+=1;
    // check if candle with bit8=0 matches
    iPos=ArrayBsearch(iBaseCandle,x);
    if(iBaseCandle[iPos][0] != x) {
      candle[0]=TT_NO_PATTERN;
      return(TT_NO_PATTERN);
    }
  }
  candle[0]=iBaseCandle[iPos][1];
  //------------------------------------------------------------------ Determine trend:
  TrendUp=(iMA(sSymbol,iPeriod,TrendMA_Period,0,MODE_SMA,PRICE_CLOSE,iBar)-
           iMA(sSymbol,iPeriod,TrendMA_Period,0,MODE_SMA,PRICE_CLOSE,iBar+TrendMA_Shift)>0);
  TrendDn=!TrendUp;  
  //------------------------------------------------------------------ Candle pattern:
  switch(candle[0]) {
    case SmallBlackCandle:                                          // A
         // Bullish Homing Pigeon (2 candles)
         if(TrendDn && (candle[1]==LongBlackCandle) && (B[1]<B[0]) && (T[1]>T[0])) return(65);
         // Bearish Harami (2 candles)
         if(TrendUp && (candle[1]==LongWhiteCandle) && (T[1]>T[0]) && (B[1]<B[0])) return(36);
         // Small Black Candle (1 candle)
         return(9);
    case SmallWhiteCandle:                                          // L
         if(TrendDn) {
           // Bullish Unique 3 River Bottom (3 candles)
           if((candle[2]==LongBlackCandle) && (candle[1]==BlackHammerOrHangingMan) &&
             (L[1]<L[2]) && (T[1]<T[2]) && (B[1]>B[2]) && (T[0]<B[1])) return(71);
           // Bullish Harami (2 candles)
           if((candle[1]==LongBlackCandle) && (T[1]>T[0]) && (B[1]<B[0])) return(77);
           // Bearish In Neck (2 candles)
           if((candle[1]==LongBlackCandle) && (T[0]==B[1] || T[0]<=B[1]+iVeryNear)) return(38);
           // Bearish On Neck (2 candles)
           if((candle[1]==LongBlackCandle) && (T[0]==L[1] || T[0]==L[1]-iVeryNear)) return(39);
         }
         // Bearish Deliberation (3 candles)
         if(TrendUp && (candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) &&
           (T[1]>T[2]) && (B[0]>=T[1])) return(29);
         // Small White Candle (1 candle)
         return(8);
    case BlackCandle:                                               // D
         if(TrendUp) {
           // Bullish Upside Gap 3 Methods (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) && (T[2]<B[1]) &&
             (O[0]<T[1]) && (O[0]>B[1]) && (B[0]<T[2]) && (B[0]>B[2])) return(81);
           // Bullish Upside Tasuki Gap (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) && (T[2]<B[1]) &&
             (O[0]<T[1]) && (O[0]>B[1]) && (B[0]<B[1]) && (B[0]>B[2])) return(82);
           // Bearish Abandoned Baby (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==Doji || candle[1]==DojiSN || candle[1]==DojiSNL) &&
             (H[2]<L[1]) && (L[1]>T[0])) return(14);
           // Bearish Evening Star (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==SmallBlackCandle || candle[1]==SmallWhiteCandle) &&
             (T[2]<B[1]) && (T[0]<B[1]) && (C[0]<T[2]) && (C[0]>B[2])) return(15);
           // Bearish Evening Doji Star (3 candles)
           if((candle[2]==WhiteCandle) && (candle[1]==Doji || candle[1]==DojiSN || candle[1]==DojiSNL) &&
             (T[2]<B[1]) && (B[1]>T[0]) && (B[0]<T[2]) && (B[0]>B[2])) return(16);
           // Bearish 3 Inside Down (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==SmallBlackCandle) && (T[2]>T[1]) &&
             (B[2]<B[1]) && (B[0]<B[2])) return(18);
           // Bearish 3 Outside Down (3 candles)
           if((candle[2]==Doji || candle[2]==DojiSN || candle[2]==DojiSNL || candle[2]==SmallWhiteCandle) &&
             (candle[1]==LongBlackCandle) && (T[1]>T[2]) && (B[1]<B[2]) && (B[0]<B[1])) return(19);
           // Bearish Upside Gap 2 Crows (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==BlackCandle) && (B[1]>T[2]) &&
             (T[0]>T[1]) && (B[0]<B[1]) && (B[0]>T[2])) return(20);
           // Bearish 2 Crows (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==BlackCandle) && (B[1]>T[2]) &&
             (T[0]<T[1]) && (T[0]>B[1]) && (B[0]<T[2]) && (B[0]>B[2])) return(31);
           // Bearish Dark Cloud Cover (2 candles)
           if((candle[1]==LongWhiteCandle) && (T[1]<T[0]) && (B[0]<(T[1]+B[1])/2) && (B[0]>B[1])) return(12);
         }
         // Bullish Matching Low (2 candles)
         if(TrendDn && (candle[1]==LongBlackCandle) && ((B[0]==B[1]-iVeryNear) ||
           (B[0]==B[1]) || (B[0]==B[1]+iVeryNear))) return(66);
         // Black Candle (1 candle)
         return(11);
    case WhiteCandle:                                               // N
         if(TrendDn) {
           // Bullish Ladder Bottom (5 candles)
           if((candle[4]==LongBlackCandle) && (candle[3]==LongBlackCandle) &&
             (candle[2]==LongBlackCandle) && (candle[1]==BlackCandleDay4LadderBottom) &&
             (O[4]>O[3]) && (C[4]>C[3]) && (O[3]>O[2]) && (C[3]>C[2]) &&
             (B[2]>B[1]) && (T[1]<B[0])) return(73);
           // Bullish Abandoned Baby (3 candles)
           if((candle[2]==LongBlackCandle) && (O[1]==C[1]) && (L[2]>H[1]) && (H[1]<L[0])) return(52);
           // Bullish Morning Doji Star (3 candles)
           if((candle[2]==LongBlackCandle) && (O[1]==C[1]) &&
             (B[2]>T[1]) && (T[1]<B[0]) && (T[0]>B[2]) && (T[0]<T[2])) return(53);
           // Bullish Morning Star (3 candles)
           if((candle[2]==LongBlackCandle) &&
             ((candle[1]==SmallBlackCandle) || (candle[1]==SmallWhiteCandle)) &&
             (B[2]>T[1]) && (T[1]<B[0]) && (T[0]>B[2]) && (T[0]<T[2])) return(54);
           // Bullish 3 Inside Up (3 candles)
           if((candle[2]==LongBlackCandle) && (candle[1]==SmallWhiteCandle) &&
             (B[2]<B[1]) && (T[2]>T[1]) && (B[1]<B[0]) && (T[0]>T[2])) return(55);
           // Bullish 3 Outside Up (3 candles)
           if(((candle[2]==Doji) || (candle[2]==DojiSN) || (candle[2]==DojiSNL) ||
             (candle[2]==SmallBlackCandle)) && (candle[1]==LongWhiteCandle) &&
             (B[2]>B[1]) && (T[2]<T[1]) && (T[0]>T[1])) return(56);
           // Bearish Downside Gap 3 Methods (3 candles)
           if((candle[2]==LongBlackCandle) && (candle[1]==LongBlackCandle) &&
             (T[1]<B[2]) && (T[0]>B[2]) && (B[0]<T[1])) return(40);
           // Bearish Downside Tasuki Gap (3 candles)
           if((candle[2]==LongBlackCandle) && (candle[1]==LongBlackCandle) &&
             (B[2]>T[1]) && (B[0]<T[1] && B[0]>B[1]) && (T[0]>T[1] && T[0]<B[2])) return(41);
           // Bearish Side By Side White Lines (3 candles)
           if((candle[2]==BlackCandle) && (candle[1]==WhiteCandle) &&
             (B[2]>T[1]) && (B[0]<=B[1]+iVeryNear && B[0]>=B[1]-iVeryNear)) return(42);
           // Bearish Thrusting (2 candles)
           if((candle[1]==BlackCandle || candle[1]==LongBlackCandle) &&
             (B[0]<B[1]) && (T[0]>B[1] && T[0]<(T[1]+B[1])/2)) return(44);
         }
         if(TrendUp) {
           // Bullish Mat Hold (5 candles)
           if((candle[4]==LongWhiteCandle) &&
             ((candle[3]==SmallBlackCandle) || (candle[3]==SmallWhiteCandle)) &&
             ((candle[2]==SmallBlackCandle) || (candle[2]==SmallWhiteCandle)) &&
             ((candle[1]==SmallBlackCandle) || (candle[1]==SmallWhiteCandle)) &&
             (T[4]<B[3]) && (B[4]<B[2]) && (B[4]<B[1]) && (B[1]<B[0]) &&
             (B[3]>B[2]) && (B[2]>B[1]) && (H[4]<H[0]) && (H[3]<H[0]) &&
             (H[2]<H[0]) && (H[1]<H[0])) return(79);
           // Bullish Side By Side White Lines (3 candles)
           if((candle[2]==WhiteCandle) && (candle[1]==WhiteCandle) &&
             (T[2]<B[1]) && (T[1]==T[0]) && (B[1]==B[0])) return(78);
         }
         // White Candle (1 candle)
         return(10);
    case LongBlackCandle:                                           // K
         if(TrendUp) {
           // Bearish Breakaway (5 candles)
           if((candle[4]==LongWhiteCandle) && (candle[3]==WhiteCandle) &&
             (candle[2]==BlackCandle || candle[2]==WhiteCandle) && (candle[1]==WhiteCandle) &&
             (B[3]>T[4]) && (T[2]>T[3]) && (T[1]>T[2]) && (B[0]<B[3]) && (B[0]>T[4])) return(32);
           // Bullish 3 Line Strike (4 candles)
           if((candle[3]==LongWhiteCandle) && (candle[2]==LongWhiteCandle) &&
             (candle[1]==LongWhiteCandle) && (T[3]<T[2]) && (T[2]<T[1]) &&
             (T[1]<T[0]) && (B[0]<B[3])) return(84);
           // Bearish 3 Black Crows (3 candles)
           if((candle[2]==LongBlackCandle) && (candle[1]==LongBlackCandle) && (B[1]<B[2]) &&
             (B[0]<B[1]) && (T[1]<T[2]) && (T[1]>B[2]) && (T[0]<T[1]) && (T[0]>B[1])) return(17);
           // Bearish Dark Cloud Cover (2 candles)
           if((candle[1]==LongWhiteCandle) && (T[1]<T[0]) && (B[0]<(T[1]+B[1])/2) && (B[0]>B[1])) return(12);
           // Bearish Engulfing (2 candles)
           if((candle[1]==Doji || candle[1]==DojiSN || candle[1]==DojiSNL || candle[1]==SmallWhiteCandle) &&
             (T[0]>T[1]) && (B[0]<B[1])) return(23);
           // Bearish Meeting Lines (2 candles)
           if((candle[1]==LongWhiteCandle) && (B[0]<=T[1]+iVeryNear && B[0]>=T[1]-iVeryNear)) return(27);
         }
         // Bearish Falling 3 Methods (5 candles)
         if(TrendDn && (candle[4]==LongBlackCandle) &&
           (candle[3]==SmallBlackCandle || candle[3]==SmallWhiteCandle) &&
           (candle[2]==SmallBlackCandle || candle[2]==SmallWhiteCandle) && 
           (candle[1]==SmallBlackCandle || candle[1]==SmallWhiteCandle) &&
           (T[3]>B[4]) && (T[3]<T[4]) && (T[2]>B[4]) && (T[2]<T[4]) &&
           (T[1]>B[4]) && (T[1]<T[4]) && (T[2]>T[3]) && (T[1]>T[2]) &&
           (T[0]<T[1]) && (T[0]>B[1]) && (B[0]<B[4])) return(37);
         // Long Black Candle (1 candle)
         return(46);
    case LongWhiteCandle:                                           // R
         if(TrendDn) {
           // Bullish Breakaway (5 candles)
           if((candle[4]==LongBlackCandle) && (candle[3]==BlackCandle) &&
             ((candle[2]==BlackCandle) || (candle[2]==WhiteCandle)) && (candle[1]==BlackCandle) &&
             (B[4]>T[3]) && (T[3]>T[2]) && (B[3]>B[2]) && (T[2]>T[1]) &&
             (B[2]>B[1]) && (B[1]<B[0]) && (T[0]>T[3]) && (T[0]<B[4])) return(72);
           // Bearish 3 Line Strike (4 candles)
           if((candle[3]==LongBlackCandle) && (candle[2]==LongBlackCandle) &&
             (candle[1]==LongBlackCandle) && (B[3]>B[2]) && (B[2]>B[1]) &&
             (B[1]>B[0]) && (T[0]>T[3])) return(45);
           // Bullish 3 White Soldiers (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) &&
             (T[2]<T[1]) && (B[2]<B[1]) && (T[2]>B[1]) && (T[1]<T[0]) &&
             (B[1]<B[0]) && (T[1]>B[0])) return(57);
           // Bullish Piercing Line (2 candles)
           if((candle[1]==LongBlackCandle) && (B[0]<L[1]) &&
             (((B[1]+T[1])/2 < T[0]) && (T[0] < T[1]))) return(50);
           // Bullish Engulfing (2 candles)
           if(((candle[1]==Doji) || (candle[1]==DojiSN) || (candle[1]==DojiSNL) ||
             (candle[1]==SmallBlackCandle)) && (B[1]>B[0]) && (T[1]<T[0])) return(61);
           // Bullish Meeting Lines (2 candles)
           if((candle[1]==LongBlackCandle) && ((T[0]==B[1]-iVeryNear) ||
             (T[0]==B[1]) || (T[0]==B[1]+iVeryNear))) return(67);
           // Bearish Thrusting (2 candles)
           if((candle[1]==BlackCandle || candle[1]==LongBlackCandle) &&
             (B[0]<B[1]) && (T[0]>B[1] && T[0]<(T[1]+B[1])/2)) return(44);
         }
         if(TrendUp) {
           // Bullish Rising 3 Methods (5 candles)
           if((candle[4]==LongWhiteCandle) &&
             ((candle[3]==SmallBlackCandle) || (candle[3]==SmallWhiteCandle)) &&
             ((candle[2]==SmallBlackCandle) || (candle[2]==SmallWhiteCandle)) &&
             ((candle[1]==SmallBlackCandle) || (candle[1]==SmallWhiteCandle)) &&
             (L[4]<L[3]) && (L[4]<L[2]) && (L[4]<L[1]) && (B[3]>B[2]) &&
             (B[2]>B[1]) && (B[1]<B[0]) && (T[4]<T[0]) && (T[3]<T[2]) &&
             (T[2]<T[0]) && (T[1]<T[0])) return(80);
           // Bearish Advance Block (3 candles)
           if((candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) && (T[1]>T[2]) &&
             (T[0]>T[1]) && (B[1]>B[2]) && (B[1]<T[2]) && (B[0]>B[1]) && (B[0]<T[1]) &&
             ((T[2]-B[2])>(T[1]-B[1])) && ((T[1]-B[1])>(T[0]-B[0]))) return(28);
         }
         // Long White Candle (1 candle)
         return(85);
    case FourPriceDoji:                                             // 0
         return(0);
    case Umbrella_1:                                                // 1
         // Bullish Dragonfly Doji (1 candle)
         if(TrendDn) return(59);
         // Bearish Dragonfly Doji (1 candle)
         if(TrendUp) return(21);
         // Umbrella (1 candle)
         return(3);
    case Umbrella_2:                                                // 2
         // Umbrella (1 candle)
         return(3);
    case Doji:                                                      // 3
    case DojiSN:                                                    // 4
         if(TrendDn) {
           // Bullish Tri Star (3 candles)
           if(((candle[2]==Doji) || (candle[2]==DojiSN) || (candle[2]==DojiSNL)) &&
             ((candle[1]==Doji) || (candle[1]==DojiSN)) && (T[1]<B[2]) && (T[1]<B[0])) return(70);
           // Bullish Harami Cross (2 candles)
           if((candle[1]==LongBlackCandle) && (B[1]<B[0]) && (T[1]>T[0])) return(64);
           // Bullish Doji Star (2 candles)
           if((candle[0]!=DojiSNL) && (candle[1]==LongBlackCandle) && (B[1]>T[0])) return(63);
         }
         if(TrendUp) {
           // Bearish Tri Star (3 candles)
           if((candle[2]==Doji || candle[2]==DojiSN || candle[2]==DojiSNL) &&
             (candle[1]==Doji || candle[1]==DojiSN || candle[1]==DojiSNL) &&
             (B[1]>T[2]) && (B[1]>T[0])) return(30); 
           // Bearish Doji Star (2 candles)
           if((candle[1]==LongWhiteCandle) && (B[0]>T[1])) return(25);
           // Bearish Harami Cross (2 candles)
           if((candle[1]==LongWhiteCandle) && (T[1]>T[0]) && (B[1]<B[0])) return(26);
         }
         // Doji (1 candle)
         return(5);
    case DojiSNL:                                                   // 5
         if(TrendDn) {
           // Bullish Tri Star (3 candles)
           if(((candle[2]==Doji) || (candle[2]==DojiSN) || (candle[2]==DojiSNL)) &&
             ((candle[1]==Doji) || (candle[1]==DojiSN)) && (T[1]<B[2]) && (T[1]<B[0])) return(70);
           // Bullish Harami Cross (2 candles)
           if((candle[1]==LongBlackCandle) && (B[1]<B[0]) && (T[1]>T[0])) return(64);
           // Bullish Doji Star (2 candles)
           if((candle[0]!=DojiSNL) && (candle[1]==LongBlackCandle) && (B[1]>T[0])) return(63);
         }
         if(TrendUp) {
           // Bearish Tri Star (3 candles)
           if((candle[2]==Doji || candle[2]==DojiSN || candle[2]==DojiSNL) &&
             (candle[1]==Doji || candle[1]==DojiSN || candle[1]==DojiSNL) &&
             (B[1]>T[2]) && (B[1]>T[0])) return(30);
           // Bearish Harami Cross (2 candles)
           if((candle[1]==LongWhiteCandle) && (T[1]>T[0]) && (B[1]<B[0])) return(26);
         }
         // Doji (1 candle)
         return(5);
    case InvertedUmbrella_6:                                        // 6
         // Bullish Gravestone Doji (2 candles)
         if(TrendDn && (candle[1]==BlackCandle) && (B[2]>B[1]) && (T[1]>T[0])) return(62);
         // Bearish Gravestone Doji (2 candles)
         if(TrendUp && (candle[1]==WhiteCandle) && (T[1]>T[2]) && (B[0]>T[1])) return(24);
         // Inverted Umbrella (1 candle)
         return(4);   
    case InvertedUmbrella_U:                                        // U
    case InvertedUmbrella_V:                                        // V
         // Bullish Gravestone Doji (2 candles)
         if(TrendDn && (candle[1]==BlackCandle) && (B[2]>B[1]) && (T[1]>T[0])) return(62);
         break;
    case InvertedUmbrella_7:                                        // 7
         // Inverted Umbrella (1 candle)
         return(4);
    case LongLeggedDoji_8:                                          // 8
    case LongLeggedDoji_9:                                          // 9
         // Bullish Long Legged Doji (1 candle)
         if(TrendDn && (T[0]<B[1])) return(60);
         // Bearish Long Legged Doji (1 candle)
         if(TrendUp && (B[0]>T[1])) return(22);
         // Long Legged Doji (1 candle)
         return(2);
    case HighWave:                                                  // B
         return(1);
    case BlackSpinningTop:                                          // C
         return(7);
    case BlackCandleDay4LadderBottom:                               // E
    case BlackDay3ConcealBabySwallow:                               // F
         // Black Candle (1 candle)
         return(11);
    case BlackMarubozu:                                             // G
         // Bullish Concealing Baby Swallow (4 candles)
         if(TrendDn && (candle[3]==BlackMarubozu) && (candle[2]==BlackMarubozu) &&
           (candle[1]==BlackDay3ConcealBabySwallow) && (B[3]>B[2]) &&
           (B[2]>T[1]) && (H[1]>B[2]) && (H[1]<T[2]) && (B[0]<L[1]) && (T[0]>H[1])) return(58);
         // Bullish 3 Star in the South (3 candles)
         if(TrendDn && (candle[2]==BlackOpeningMarubozuLongshadow) &&
           (candle[1]==BlackOpeningMarubozu) && (O[1]>C[2]) &&
           (L[1]>L[2]) && (H[0]<H[1]) && (L[0]>L[1])) return(69);
         // Bearish Kicking Pattern (2 candles)
         if((candle[1]==WhiteMarubozu) && (B[1]>T[0])) return(13);
         // Black Marubozu (1 candle)
         return(47);
    case BlackOpeningMarubozu:                                      // H
    case BlackOpeningMarubozuLongshadow:                            // I
         // Bearish Seperating Lines (2 candles)
         if(TrendDn && (candle[1]==LongWhiteCandle) &&
           (T[0]<=B[1]+iVeryNear && T[0]>=B[1]-iVeryNear)) return(43);
         // Bearish Belt Hold (1 candle)
         if(TrendUp && (B[0]>T[1])) return(33);
         // Black Opening Marubozu (1 candle)
         return(49);
    case BlackClosingMarubozu:                                      // J
         // Bullish Stick Sandwich (3 candles) 
         if(TrendDn && (candle[2]==BlackClosingMarubozu) && (candle[1]==WhiteCandle) &&
           (B[2]<B[1]) && (B[0]==B[2])) return(68);
         // Black Closing Marubozu (1 candle)
         return(48);
    case WhiteSpinningTop:                                          // M
         // Bearish Deliberation (3 candles)
         if(TrendUp && (candle[2]==LongWhiteCandle) && (candle[1]==LongWhiteCandle) &&
           (T[1]>T[2]) && (B[0]>=T[1])) return(29);
         // White Spinning Top (1 candle)
         return(6);
    case WhiteMarubozu:                                             // O
         // Bullish Kicking Pattern (2 candles)
         if((candle[1]==BlackMarubozu) && (H[1]<L[0])) return(51);
         // White Marubozu (1 candle)
         return(86);   
    case WhiteClosingMarubozu:                                      // P
         // White Closing Marubozu (1 candle)
         return(87); 
    case WhiteOpeningMarubozu:                                      // Q
         // Bullish Seperating Lines (2 candles)
         if(TrendUp && (candle[1]==LongBlackCandle) && 
           (B[0]<=T[1]+iVeryNear && B[0]>=T[1]-iVeryNear)) return(83);
         // Bullish Belt Hold (1 candle)
         if(TrendDn && (B[1]>T[0])) return(74);
         // White Opening Marubozu (1 candle)
         return(88);
    case BlackHammerOrHangingMan:                                   // S
    case WhiteHammerOrHangingMan:                                   // T
         // Bullish Hammer (1 candle)
         if(TrendDn && (B[1]>T[0])) return(75);
         // Bearish Hanging Man (1 candle)
         if(TrendUp && (B[0]>T[1])) return(34);
         break;              
    case BlackInvertedHammerOrStar:                                 // W
    case WhiteInvertedHammerOrStar:                                 // X
         // Bullish Inverted Hammer (2 candles)
         if(TrendDn && (candle[1]==BlackCandle) && (B[1]>T[0])) return(76);
         // Bearish Shooting Star (2 candles)
         if(TrendUp && (candle[1]==WhiteCandle) && (B[0]>T[1])) return(35);
         break;
    default: break; 
  }
  return(TT_NO_PATTERN);
}  

//+------------------------------------------------------------------+
//| PatternConfirm(iPreviousPatternNumber)                           |
//+------------------------------------------------------------------+
void PatternConfirm(int x) {
  string sMsg="";
  
  // check if previous pattern trend forecast can be confirmed
  if(ConfirmPattern && (x != TT_NO_PATTERN) && (sPattern[x][P_DISPLAY] == "1")) {
    if(sPattern[x][P_CHK] == "0") sMsg=M_NULL;
    // check 1: Lower Close
    else if(sPattern[x][P_CHK] == "1" && (C[0] < C[1])) sMsg=M_DN;
    // check 2: Black Candle or Lower Close
    else if(sPattern[x][P_CHK] == "2" && (C[0] < O[0] || C[0] < C[1])) sMsg=M_DN;
    //check 3: Black Candle && Lower Close
    else if(sPattern[x][P_CHK] == "3" && (C[0] < O[0] && C[0] < C[1])) sMsg=M_DN;
    //check 4: Lower Open OR Black Candle && Lower Close
    else if(sPattern[x][P_CHK] == "4" && (O[0] < O[1] || (C[0] < O[0] && C[0] < C[1]))) sMsg=M_DN;
    // check 5: White Candle or Higher Close
    else if(sPattern[x][P_CHK] == "5" && (C[0] > O[0] || C[0] > C[1])) sMsg=M_UP;
    // check 6: White Candle && Higher Close
    else if(sPattern[x][P_CHK] == "6" && (C[0] > O[0] && C[0] > C[1])) sMsg=M_UP;
    // check 7: Higher Open OR White Candle && Higher Close
    else if(sPattern[x][P_CHK] == "7" && (O[0] > O[1] || (C[0] > O[0] && C[0] > C[1]))) sMsg=M_UP;
    // check 8: Opposite move to the one which occured on the previous day, trend up then reverse down
    else if(sPattern[x][P_CHK] == "8" && (C[1] > O[1] && C[0] < O[0])) sMsg=M_REV_DN;
    // check 8: Opposite move to the one which occured on the previous day, trend down then reverse up      
    else if(sPattern[x][P_CHK] == "8" && (C[1] < O[1] && C[0] > O[0])) sMsg=M_REV_UP;
    else sMsg=M_NULL;
    if((sMsg != M_NULL) && (MaxBarsToScanForPatterns == 1)) {
      DisplayLabelObject("CP_CONFIRM_PRIOR_TREND", sPRV, ColorText);
      DisplayLabelObject("CP_CONFIRM_RELEVANCE"  , sREE, ColorText);
    }
    if(sMsg != M_NULL && AudioON) gSpeak(StringConcatenate(sAudio,sPattern[iPattern][P_NAM]," ",sMsg));
  }
}

//+------------------------------------------------------------------+
//| PriceMaxVisible()                                                |
//+------------------------------------------------------------------+
double PriceMaxVisible() {
  int iCount=WindowBarsPerChart(),
      iStart=MathMax(WindowFirstVisibleBar()-iCount,1),
      iPriceMax=iHighest(NULL,0,MODE_HIGH,iCount,iStart);
  return(High[iPriceMax]);
}

//+------------------------------------------------------------------+
//| PriceMinVisible()                                                |
//+------------------------------------------------------------------+
double PriceMinVisible() {
  int iCount=WindowBarsPerChart(),
      iStart=MathMax(WindowFirstVisibleBar()-iCount,1),
      iPriceMin=iLowest(NULL,0,MODE_LOW,iCount,iStart);
  return(Low[iPriceMin]);
}

//+------------------------------------------------------------------+
//| StringArrayLoad()                                                |
//+------------------------------------------------------------------+
int StringArrayLoad(string sFile, string& A[][], int iColumns) 
  {
    int handle = FileOpen(sFile, FILE_CSV|FILE_READ, ";"), i, iStart, iPos;
//----
    if(handle < 1) 
      {
        Alert("File:", sFile, " error "+GetLastError());
        return(-1);
      }
    string sLine;
    int iRows = ArrayRange(A,0), iLinesRead = 0;
//----
    while(FileIsEnding(handle) == false) 
      {
        sLine = FileReadString(handle);
        iStart = StringLen(sLine);
        //----
        if(iStart < 1 || StringSubstr(sLine,0,2) == "//") 
            continue; // empty strings or comment lines dropped
        //----
        if(iLinesRead >= iRows) 
          {
            if(ArrayResize(A,iRows+1) == 0 ) 
              {
                Alert("StringArrayLoad() error ", GetLastError());
                return(-1);
              }
            iRows += 1;
          }
        //----
        if(StringFind(sLine, ",,", 0) >= 0 || StringSubstr(sLine, iStart - 1, 1) == ",") 
          {
            Alert("File:", sFile, " Line:", iLinesRead, " NULL value");
            break;
          }
        sLine = sLine + ",";
        iStart = 0;
        //----
        for(i = 0; i < iColumns; i++) 
          {
            iPos = StringFind(sLine, ",", iStart);
            A[iLinesRead][i] = StringSubstr(sLine, iStart, iPos - iStart);
            iStart = iPos + 1;
          }
        iLinesRead++;
      }
    FileClose(handle);
    return (iLinesRead);
  }
//+------------------------------------------------------------------+

