//+------------------------------------------------------------------+
//|                                          divergence_template.mq4 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|                                          Author: Yashar Seyyedin |
//|       Web Address: https://www.mql5.com/en/users/yashar.seyyedin |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_plots   1
//--- plot indicator
#property indicator_label1  "indicator"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrWhite
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         indicatorBuffer[];
double         PHBuffer[];
double         PLBuffer[];
double         bull_reg_divBuffer[];
double         bear_reg_divBuffer[];
double         bull_hid_divBuffer[];
double         bear_hid_divBuffer[];

//--- indicator statics/globals
static datetime lastBullRegAlert=NULL;
static datetime lastBearRegAlert=NULL;
static datetime lastBullHidAlert=NULL;
static datetime lastBearHidAlert=NULL;
color color_bull_reg=clrAqua; //color bullish regular
color color_bull_hid=clrOrangeRed; //color bullish hidden
color color_bear_reg=clrFuchsia; //color bearish regular
color color_bear_hid=clrGreen; //color bearish hidden

//--- indicator inputs
input int pivots_period=5; //period to find indicator pivots
input int alert_confirm_candles=1; //#candles for confirmation(0=disable alert)

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!VerifyInputs()) return INIT_FAILED;
   IndicatorShortName("divergence_template");
//--- indicator buffers mapping
   SetIndexBuffer(0,indicatorBuffer);
   SetIndexBuffer(1,PHBuffer);
   SetIndexBuffer(2,PLBuffer);
   SetIndexBuffer(3,bull_reg_divBuffer);
   SetIndexBuffer(4,bear_reg_divBuffer);
   SetIndexBuffer(5,bull_hid_divBuffer);
   SetIndexBuffer(6,bear_hid_divBuffer);

   SetIndexStyle(1, DRAW_NONE);  
   SetIndexStyle(2, DRAW_NONE);  
   SetIndexStyle(3, DRAW_NONE);  
   SetIndexStyle(4, DRAW_NONE);  
   SetIndexStyle(5, DRAW_NONE);  
   SetIndexStyle(6, DRAW_NONE);  
//---
   return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],
                const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[])
  {
   /////////////////////////////////////////////
   //Load indicator data into indicator buffer
   //You can easily replace RSI with any indicator you like
   int BARS=MathMax(rates_total-IndicatorCounted()-pivots_period,1);
   for(int i=BARS;i>=0;i--)
   {
      indicatorBuffer[i]=iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE, i);
   }
   //End of load indicator section
   /////////////////////////////////////////////

   BARS=MathMax(rates_total-IndicatorCounted()-pivots_period,pivots_period);
   for(int i=BARS;i>=0;i--)
   {
      PHBuffer[i]=pivothigh(indicatorBuffer, pivots_period, pivots_period, i);
      PLBuffer[i]=pivotlow(indicatorBuffer, pivots_period, pivots_period, i);
      bull_reg_divBuffer[i]=BullRegDiv(i);
      bear_reg_divBuffer[i]=BearRegDiv(i);
      bull_hid_divBuffer[i]=BullHidDiv(i);
      bear_hid_divBuffer[i]=BearHidDiv(i);
   }  
   GenerateAlerts();
   return(rates_total);
  }


double BullRegDiv(int i)
{
   if(PLBuffer[i]==EMPTY_VALUE) return EMPTY_VALUE;
   int second_pl_index = NextPL(i+1);      
   if(second_pl_index==-1) return EMPTY_VALUE;        

   bool div= indicatorBuffer[i]>indicatorBuffer[second_pl_index] && Low[i]<Low[second_pl_index];
   if(!div) return EMPTY_VALUE;

   int subwindow=ChartWindowFind(ChartID(), "divergence_template");
   string prefix="BullRegDiv";
   string indi_line_name=prefix+"IndicatorLine"+(string)Time[second_pl_index];
   ObjectDelete(ChartID(), indi_line_name);
   ObjectCreate(ChartID(), indi_line_name, OBJ_TREND, subwindow, Time[second_pl_index], indicatorBuffer[second_pl_index], Time[i], indicatorBuffer[i]);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_COLOR, color_bull_reg);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_SELECTABLE, false);

   string chart_line_name=prefix+"ChartLine"+(string)Time[second_pl_index];
   ObjectDelete(ChartID(), chart_line_name);
   ObjectCreate(ChartID(), chart_line_name, OBJ_TREND, 0, Time[second_pl_index], Low[second_pl_index], Time[i], Low[i]);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_COLOR, color_bull_reg);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_SELECTABLE, false);
  
   return indicatorBuffer[i];
}

double BearRegDiv(int i)
{
   if(PHBuffer[i]==EMPTY_VALUE) return EMPTY_VALUE;
   int second_ph_index = NextPH(i+1);      
   if(second_ph_index==-1) return EMPTY_VALUE;        
        
   bool div= indicatorBuffer[i]<indicatorBuffer[second_ph_index] && High[i]>High[second_ph_index];
   if(!div) return EMPTY_VALUE;

   int subwindow=ChartWindowFind(ChartID(), "divergence_template");
   string prefix="BearRegDiv";
   string indi_line_name=prefix+"IndicatorLine"+(string)Time[second_ph_index];
   ObjectDelete(ChartID(), indi_line_name);
   ObjectCreate(ChartID(), indi_line_name, OBJ_TREND, subwindow, Time[second_ph_index], indicatorBuffer[second_ph_index], Time[i], indicatorBuffer[i]);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_COLOR, color_bear_reg);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_SELECTABLE, false);

   string chart_line_name=prefix+"ChartLine"+(string)Time[second_ph_index];
   ObjectDelete(ChartID(), chart_line_name);
   ObjectCreate(ChartID(), chart_line_name, OBJ_TREND, 0, Time[second_ph_index], High[second_ph_index], Time[i], High[i]);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_COLOR, color_bear_reg);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_SELECTABLE, false);
  
   return indicatorBuffer[i];
}

double BullHidDiv(int i)
{
   if(PLBuffer[i]==EMPTY_VALUE) return EMPTY_VALUE;
   int second_pl_index = NextPL(i+1);      
   if(second_pl_index==-1) return EMPTY_VALUE;        
        
   bool div= indicatorBuffer[i]<indicatorBuffer[second_pl_index] && Low[i]>Low[second_pl_index];
   if(!div) return EMPTY_VALUE;

   int subwindow=ChartWindowFind(ChartID(), "divergence_template");
   string prefix="BullHidDiv";
   string indi_line_name=prefix+"IndicatorLine"+(string)Time[second_pl_index];
   ObjectDelete(ChartID(), indi_line_name);
   ObjectCreate(ChartID(), indi_line_name, OBJ_TREND, subwindow, Time[second_pl_index], indicatorBuffer[second_pl_index], Time[i], indicatorBuffer[i]);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_COLOR, color_bull_hid);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_SELECTABLE, false);

   string chart_line_name=prefix+"ChartLine"+(string)Time[second_pl_index];
   ObjectDelete(ChartID(), chart_line_name);
   ObjectCreate(ChartID(), chart_line_name, OBJ_TREND, 0, Time[second_pl_index], Low[second_pl_index], Time[i], Low[i]);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_COLOR, color_bull_hid);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_SELECTABLE, false);
  
   return indicatorBuffer[i];
}

double BearHidDiv(int i)
{
   if(PHBuffer[i]==EMPTY_VALUE) return EMPTY_VALUE;
   int second_ph_index = NextPH(i+1);      
   if(second_ph_index==-1) return EMPTY_VALUE;        
        
   bool div= indicatorBuffer[i]>indicatorBuffer[second_ph_index] && High[i]<High[second_ph_index];
   if(!div) return EMPTY_VALUE;

   int subwindow=ChartWindowFind(ChartID(), "divergence_template");
   string prefix="BearHidDiv";
   string indi_line_name=prefix+"IndicatorLine"+(string)Time[second_ph_index];
   ObjectDelete(ChartID(), indi_line_name);
   ObjectCreate(ChartID(), indi_line_name, OBJ_TREND, subwindow, Time[second_ph_index], indicatorBuffer[second_ph_index], Time[i], indicatorBuffer[i]);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_COLOR, color_bear_hid);
   ObjectSetInteger(ChartID(), indi_line_name, OBJPROP_SELECTABLE, false);

   string chart_line_name=prefix+"ChartLine"+(string)Time[second_ph_index];
   ObjectDelete(ChartID(), chart_line_name);
   ObjectCreate(ChartID(), chart_line_name, OBJ_TREND, 0, Time[second_ph_index], High[second_ph_index], Time[i], High[i]);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_COLOR, color_bear_hid);
   ObjectSetInteger(ChartID(), chart_line_name, OBJPROP_SELECTABLE, false);
  
   return indicatorBuffer[i];
}

double pivothigh(double &src[], int left, int right, int i)
{
   for(int j=i+1;j<i+1+left;j++)
   {
      if(j>Bars-1) break;
      if(src[j]>src[i])
         return EMPTY_VALUE;
   }
   for(int j=i-1;j>i-1-right;j--)
   {
      if(j<0) break;
      if(src[j]>src[i])
         return EMPTY_VALUE;
   }
   return src[i];
}

double pivotlow(const double &src[], int left, int right, int i)
{
   for(int j=i+1;j<i+1+left;j++)
   {
      if(j>Bars-1) break;
      if(src[j]<src[i])
         return EMPTY_VALUE;
   }
   for(int j=i-1;j>i-1-right;j--)
   {
      if(j<0) break;
      if(src[j]<src[i])
         return EMPTY_VALUE;
   }
   return src[i];
}

int NextPH(int index)
{
   while(index<Bars)
   {
     if(PHBuffer[index]!=EMPTY_VALUE) return index;
     index++;
   }
   return -1;
}

int NextPL(int index)
{
   while(index<Bars)
   {
     if(PLBuffer[index]!=EMPTY_VALUE) return index;
     index++;
   }
   return -1;
}

void GenerateAlerts()
{
   if(alert_confirm_candles==0) return;
   if(bull_reg_divBuffer[alert_confirm_candles]!=EMPTY_VALUE && lastBullRegAlert!=Time[0])
   {
      Alert(_Symbol +": Bullish Regular Divergence!");
      lastBullRegAlert=Time[0];
   }
   if(bear_reg_divBuffer[alert_confirm_candles]!=EMPTY_VALUE && lastBearRegAlert!=Time[0])
   {
      Alert(_Symbol +": Bearish Regular Divergence!");
      lastBearRegAlert=Time[0];
   }
   if(bull_hid_divBuffer[alert_confirm_candles]!=EMPTY_VALUE && lastBullHidAlert!=Time[0])
   {
      Alert(_Symbol +": Bullish Hidden Divergence!");
      lastBullHidAlert=Time[0];
   }
   if(bear_hid_divBuffer[alert_confirm_candles]!=EMPTY_VALUE && lastBearHidAlert!=Time[0])
   {
      Alert(_Symbol +": Bearish Hidden Divergence!");
      lastBearHidAlert=Time[0];
   }
}

void OnDeinit(const int reason)
  {
   int subwindow=ChartWindowFind(ChartID(), "divergence_template");
   ObjectsDeleteAll(ChartID(), "BullRegDiv", 0);
   ObjectsDeleteAll(ChartID(), "BearRegDiv", 0);
   ObjectsDeleteAll(ChartID(), "BullHidDiv", 0);
   ObjectsDeleteAll(ChartID(), "BearHidDiv", 0);
   ObjectsDeleteAll(ChartID(), "BullRegDiv", subwindow);
   ObjectsDeleteAll(ChartID(), "BearRegDiv", subwindow);
   ObjectsDeleteAll(ChartID(), "BullHidDiv", subwindow);
   ObjectsDeleteAll(ChartID(), "BearHidDiv", subwindow);
  }
  
bool VerifyInputs()
{
   if(pivots_period<2)
   {
      Print("pivots_period cannot be less than 2!");
      return false;
   }
   return true;
}  