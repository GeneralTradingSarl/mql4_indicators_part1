//+--------------------------------------------------------------------+
//| 4Hour Vegas Model - Weekly Chart Direction Calculator              |
//|                                                           Spiggy   |
//|                                                                    |
//|Mod by F DCG (20050924):                                            |
//|  - Added PERIOD_W1 to the calc of the MA to get to the proper      |
//|    week figures instead of using the 4h avg.                       |
//|  - Changed some of the variables names to more incurr more meaning |
//+--------------------------------------------------------------------+
#property copyright "Spiggy"
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Green
#property indicator_color3 Red
//---- input parameters
//---- buffers
double _maDiff[];
double _upTrend[];
double _downTrend[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,_maDiff);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,_upTrend);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,_downTrend);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
  int    limit, weekIndex;
  double EMA21;
  double SMA5;
  double EMA21Prev;
  double SMA5Prev;
  string ValueIndex;
  string Direction;  
  // Always prepare all of the information for the other indicators
  limit=Bars;
  //---- main loop
  for(int i=limit; i>=0; i--) 
  {
  	weekIndex=i/30;	
    //---- Calculate the current weekly trend
    EMA21=iMA(Symbol(), PERIOD_W1, 21, 0, MODE_EMA, PRICE_MEDIAN, weekIndex);
    SMA5 =iMA(Symbol(), PERIOD_W1, 5, 0, MODE_SMA, PRICE_MEDIAN, weekIndex);
    //---- Calculate the previous weekly trend
    EMA21Prev=iMA(Symbol(), PERIOD_W1, 21, 0, MODE_EMA, PRICE_MEDIAN, weekIndex+1);
    SMA5Prev =iMA(Symbol(), PERIOD_W1, 5, 0, MODE_SMA, PRICE_MEDIAN, weekIndex+1);
    // Calculate the difference of the MAs
    _maDiff[i] = SMA5-EMA21;
    // Calculate the difference of the MAs
    if (((SMA5-EMA21) - (SMA5Prev-EMA21Prev)) > 0.0 ) 
    {
      _upTrend[i] = (SMA5-EMA21)- (SMA5Prev-EMA21Prev);
      _downTrend[i] = 0.0;
      Direction = "UP";
     }
      else if (((SMA5-EMA21) - (SMA5Prev-EMA21Prev)) < 0.0 ) 
     {
      _upTrend[i] = 0.0;
      _downTrend[i] = (SMA5-EMA21) - (SMA5Prev-EMA21Prev);
      Direction = "DOWN";
    }
    // Calculate the start of the week and publish the value in a global variable
    // Publish this with the previous Sunday as the index
    ValueIndex = TimeToStr(Time[i]-TimeDayOfWeek(Time[i]),TIME_DATE);
    Comment(Symbol() + "-ThisWeekDirection-" + ValueIndex + "\n" + Direction + ":(" + ((SMA5-EMA21) - (SMA5Prev-EMA21Prev)) + ")");
    GlobalVariableSet(Symbol() + "-ThisWeekDirection-" + ValueIndex, ((SMA5-EMA21) - (SMA5Prev-EMA21Prev)));
  }      
   return(0);
  }
//+------------------------------------------------------------------+