//+------------------------------------------------------------------+
//|                                                   DiverStoch.mq4 |
//|                                                            ViDan |
//|                                                vi_dancom@mail.ru |
//+------------------------------------------------------------------+
#property copyright "ViDan"
#property link      "vi_dancom@mail.ru"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Gray
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_width1 1
#property indicator_width2 2
#property indicator_width3 2
#define arrowsDisplacement 0.0001
extern color  ColorBull = Blue;
extern color  ColorBear = Red;
extern bool   displayAlert=false;//true;
extern bool   English=false;
//Для MACD
extern int i_fastEMA = 12;
extern int i_slowEMA = 26;
extern int i_signalMA= 9;
extern bool DrawPriceLines=false;
extern bool DrawArrows=true;
extern bool drawDivergenceLines=true;
//---- buffers
double MACDLineBuffer[];
double bullishDivergence[];
double bearishDivergence[];
double MACDDiv[];
//---- variables
//////
static datetime lastAlertTime;
static string   indicatorName;
static bool b_first=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,0);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,0);
   SetIndexStyle(2,DRAW_ARROW,STYLE_SOLID,0);
   SetIndexStyle(3,DRAW_NONE);
//----   
   SetIndexBuffer(0,MACDLineBuffer);
   SetIndexBuffer(1,bullishDivergence);
   SetIndexBuffer(2,bearishDivergence);
   SetIndexBuffer(3,MACDDiv);
//----   
   SetIndexArrow(1,233);
   SetIndexArrow(2,234);
//----
   IndicatorDigits(Digits+2);
   indicatorName=("MACD("+i_fastEMA+","+i_slowEMA+","+i_signalMA+")");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string label=ObjectName(i);
      if(StringSubstr(label,0,19)!="MACD_DivergenceLine")
         continue;
      ObjectDelete(label);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(i_fastEMA,i_slowEMA);

   CalculateIndicator(limit);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateIndicator(int countedBars)
  {
   for(int i=countedBars; i>=0; i--)
     {
      CalculateMACD(i);
      CatchBullishDivergence(i+2,countedBars);
      CatchBearishDivergence(i+2,countedBars);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateMACD(int i)
  {
   MACDLineBuffer[i]=iMACD(NULL,0,i_fastEMA,i_slowEMA,i_signalMA,PRICE_CLOSE,MODE_MAIN,i);
   MACDDiv[i]=MACDLineBuffer[i];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBullishDivergence(int shift,int maxind)
  {
   if(IsIndicatorTrough(shift)==false)
      return;
   int currentTrough=shift;
   int lastTrough=GetIndicatorLastTrough(shift,maxind);

   if(currentTrough==-1) return;
   if(lastTrough==-1) return;

   if(MACDDiv[currentTrough]>MACDDiv[lastTrough] && Low[currentTrough]<Low[lastTrough])
     {
      bullishDivergence[currentTrough]=MACDDiv[currentTrough];
      if(drawDivergenceLines==true)
        {
         DrawPriceTrendLine(Time[currentTrough],Time[lastTrough],Low[currentTrough],
                            Low[lastTrough],Green,STYLE_SOLID);
         DrawIndicatorTrendLine(Time[currentTrough],Time[lastTrough],MACDDiv[currentTrough],
                                MACDDiv[lastTrough],Green,STYLE_SOLID,drawDivergenceLines);
        }
      if(displayAlert==true)
         DisplayAlert("Classical bullish divergence on: ",currentTrough);
     }
   if(MACDDiv[currentTrough]<MACDDiv[lastTrough] && Low[currentTrough]>Low[lastTrough])
     {
      bullishDivergence[currentTrough]=MACDDiv[currentTrough];
      if(drawDivergenceLines==true)
        {
         DrawPriceTrendLine(Time[currentTrough],Time[lastTrough],Low[currentTrough],
                            Low[lastTrough],Green,STYLE_DOT);
         DrawIndicatorTrendLine(Time[currentTrough],Time[lastTrough],MACDDiv[currentTrough],
                                MACDDiv[lastTrough],Green,STYLE_DOT,drawDivergenceLines);
        }
      if(displayAlert==true)
         DisplayAlert("Reverse bullish divergence on: ",currentTrough);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBearishDivergence(int shift,int maxind)
  {
   if(IsIndicatorPeak(shift)==false)
      return;
   int currentPeak=shift;
   int lastPeak=GetIndicatorLastPeak(shift,maxind);

   if(currentPeak==-1) return;
   if(lastPeak==-1) return;

   if(MACDDiv[currentPeak]<MACDDiv[lastPeak] && High[currentPeak]>High[lastPeak])
     {
      bearishDivergence[currentPeak]=MACDDiv[currentPeak];
      if(drawDivergenceLines==true)
        {
         DrawPriceTrendLine(Time[currentPeak],Time[lastPeak],High[currentPeak],
                            High[lastPeak],Red,STYLE_SOLID);
         DrawIndicatorTrendLine(Time[currentPeak],Time[lastPeak],MACDDiv[currentPeak],
                                MACDDiv[lastPeak],Red,STYLE_SOLID,drawDivergenceLines);
        }
      if(displayAlert==true)
         DisplayAlert("Classical bearish divergence on: ",currentPeak);
     }
   if(MACDDiv[currentPeak]>MACDDiv[lastPeak] && High[currentPeak]<High[lastPeak])
     {
      bearishDivergence[currentPeak]=MACDDiv[currentPeak];
      if(drawDivergenceLines==true)
        {
         DrawPriceTrendLine(Time[currentPeak],Time[lastPeak],High[currentPeak],
                            High[lastPeak],Red,STYLE_DOT);
         DrawIndicatorTrendLine(Time[currentPeak],Time[lastPeak],MACDDiv[currentPeak],
                                MACDDiv[lastPeak],Red,STYLE_DOT,drawDivergenceLines);
        }
      if(displayAlert==true)
         DisplayAlert("Reverse bearish divergence on: ",currentPeak);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorPeak(int shift)
  {
   if(MACDDiv[shift]>=MACDDiv[shift+1] && MACDDiv[shift]>MACDDiv[shift+2] && 
      MACDDiv[shift]>MACDDiv[shift-1])
      return(true);
   else
      return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorTrough(int shift)
  {
   if(MACDDiv[shift]<=MACDDiv[shift+1] && MACDDiv[shift]<MACDDiv[shift+2] && 
      MACDDiv[shift]<MACDDiv[shift-1])
      return(true);
   else
      return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastPeak(int shift,int maxind)
  {
   for(int i=shift+5; i<maxind-2; i++)
     {
      if(MACDLineBuffer[i] >= MACDLineBuffer[i+1] && MACDLineBuffer[i] >= MACDLineBuffer[i+2] &&
         MACDLineBuffer[i] >= MACDLineBuffer[i-1] && MACDLineBuffer[i] >= MACDLineBuffer[i-2])
        {
         for(int j=i; j<maxind-2; j++)
           {
            if(MACDDiv[j] >= MACDDiv[j+1] && MACDDiv[j] > MACDDiv[j+2] &&
               MACDDiv[j] >= MACDDiv[j-1] && MACDDiv[j] > MACDDiv[j-2])
               return(j);
           }
        }
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastTrough(int shift,int maxind)
  {
   for(int i=shift+5; i<maxind-2; i++)
     {
      if(MACDLineBuffer[i] <= MACDLineBuffer[i+1] && MACDLineBuffer[i] <= MACDLineBuffer[i+2] &&
         MACDLineBuffer[i] <= MACDLineBuffer[i-1] && MACDLineBuffer[i] <= MACDLineBuffer[i-2])
        {
         for(int j=i; j<maxind-2; j++)
           {
            if(MACDDiv[j] <= MACDDiv[j+1] && MACDDiv[j] < MACDDiv[j+2] &&
               MACDDiv[j] <= MACDDiv[j-1] && MACDDiv[j] < MACDDiv[j-2])
               return(j);
           }
        }
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayAlert(string message,int shift)
  {
   if(shift<=2 && Time[shift]!=lastAlertTime)
     {
      lastAlertTime=Time[shift];
      Alert(message,Symbol()," , ",s_GetPeriod(Period()));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawPriceTrendLine(datetime x1,datetime x2,double y1,
                        double y2,color lineColor,double style)
  {
   string label="MACD_DivergenceLine.0# "+DoubleToStr(x1,0);
   ObjectDelete(label);
   ObjectCreate(label,OBJ_TREND,0,x1,y1,x2,y2,0,0);
   ObjectSet(label,OBJPROP_RAY,0);
   ObjectSet(label,OBJPROP_COLOR,lineColor);
   ObjectSet(label,OBJPROP_STYLE,style);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void DrawIndicatorTrendLine(datetime x1,datetime x2,double y1,
                            double y2,color lineColor,double style,bool bullishDivergence)
  {
   int indicatorWindow=WindowFind(indicatorName);
   if(indicatorWindow<0) return;
   string label="MACD_DivergenceLine - "+DoubleToStr(x1,0);
   ObjectDelete(label);
   ObjectCreate(label,OBJ_TREND,indicatorWindow,x1,y1,x2,y2,0,0);
   ObjectSet(label,OBJPROP_RAY,0);
   ObjectSet(label,OBJPROP_COLOR,lineColor);
   ObjectSet(label,OBJPROP_STYLE,style);

/*   string label="MACD_DivergenceLine - "+DoubleToStr(x1,0);
   string labelArrow="StochD"+DoubleToStr(x1,0)+"-"+DoubleToStr(y1,0);
   ObjectDelete(label);
   ObjectDelete(labelArrow);
   ObjectCreate(label,OBJ_TREND,indicatorWindow,x1,y1,x2,y2,
                0,0);
   ObjectSet(label,OBJPROP_RAY,0);
   ObjectSet(label,OBJPROP_COLOR,lineColor);
   ObjectSet(label,OBJPROP_STYLE,style);
   if(DrawArrows)
     {
      if(bullishDivergence)
        {
         ObjectCreate(labelArrow,OBJ_ARROW,indicatorWindow,x1,y1-1,0,0);
         ObjectSet(labelArrow,OBJPROP_COLOR,lineColor);
         ObjectSet(labelArrow,OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
        }
      else
        {
         ObjectCreate(labelArrow,OBJ_ARROW,indicatorWindow,x1,y1+11);
         ObjectSet(labelArrow,OBJPROP_COLOR,lineColor);
         ObjectSet(labelArrow,OBJPROP_ARROWCODE,SYMBOL_ARROWDOWN);
        }
     }
*/
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void DrawIndicatorTrendLine(datetime x1, datetime x2, double y1, 
                            double y2, color lineColor, double style)
  {
   int indicatorWindow = WindowFind(indicatorName);
   if(indicatorWindow < 0)
       return;
   string label = "MACD_DivergenceLine - " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 
                0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }
*/
//+------------------------------------------------------------------+
////Функция возвращает параметры стандартного MACD, если он присутствует на графике
string s_isMACD()
  {
   for(int j=1; j<=24; j++)
     {
      for(int i=1; i<=44; i++)
        {
         for(int k=1; k<=24; k++)
           {
            if(WindowFind("MACD("+DoubleToStr(j,0)+","+DoubleToStr(i,0)+","
               +DoubleToStr(k,0)+")")!=-1) return(DoubleToStr(j,0)+","+DoubleToStr(i,0)
               +","+DoubleToStr(k,0));
           }
        }
     }
  }
//+------------------------------------------------------------------+
////Выделяет переменную из перечисления с разделителем razD
string s_GetPer(string s_stRoka,string s_razD,int i_pozPer)
  {
   string s_vrPer = s_stRoka + s_razD;
   string s_mnk1S = "", s_mnk1;
   int i_mnk = 0;
   for(int j = 0; j <= StringLen(s_vrPer)-1;j++)
     {
      s_mnk1=StringSubstr(s_vrPer,j,1);
      if(s_mnk1==s_razD)
        {
         i_mnk++;
         if(i_mnk<i_pozPer) s_mnk1S="";
        }
      else
        {
         s_mnk1S=s_mnk1S+s_mnk1;
        }
      if(i_mnk==i_pozPer) return(s_mnk1S);
     }
  }
///Возвращает период графика в виде строки
string s_GetPeriod(int i_per)
  {
   switch(i_per)
     {
      case 1:            return("M1 ");
      case 5:            return("M5 ");
      case 15:           return("M15");
      case 30:           return("M30");
      case 60:           return("H1 ");
      case 240:          return("H4 ");
      case 1440:         return("D1 ");
      case 10080:        return("W1 ");
      case 43200:        return("MN1");
     }
  }
//+------------------------------------------------------------------+
