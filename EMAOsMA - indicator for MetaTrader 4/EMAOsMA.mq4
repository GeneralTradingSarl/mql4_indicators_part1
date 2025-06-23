//+------------------------------------------------------------------+
//|                                                      EMAOsMA.mq4 |
//|                                                         Mohammed |
//|                                         http://www.forex-tsd.com |
//+------------------------------------------------------------------+
#property copyright "Mohammed"
#property link      "http://www.forex-tsd.com"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrRed
//----
extern int EmaPeriod=12;
extern color UpCross=Gold;
extern color DownCross=clrDarkGreen;
extern int ArrowCode1=233;
extern int ArrowCode2=234;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   int I=WindowsTotal();
   for(int count=0; count<WindowsTotal(); count++)
     {
      int nObjects=ObjectsTotal();
      for(int i=nObjects; i>=0; i--)
        {
         string objName=ObjectName(i);
         if(StringFind(objName,"acustom",0)>=0)
            ObjectDelete(objName);
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   int I=WindowsTotal();
   for(int count=0; count<WindowsTotal(); count++)
     {
      int nObjects=ObjectsTotal();
      for(int i=nObjects; i>=0; i--)
        {
         string objName=ObjectName(i);
         if(StringFind(objName,"acustom",0)>=0)
            ObjectDelete(objName);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawArrow(int bar,double value,int trend)
  {
   static int cnt=0;
   cnt++;
   string crossing="acustom_"+cnt;
//----
   ObjectCreate(crossing,OBJ_ARROW,0,Time[bar],value);
//----
   if(trend==1)
     {
      ObjectSet(crossing,OBJPROP_ARROWCODE,ArrowCode1);
      ObjectSet(crossing,OBJPROP_COLOR,UpCross);
     }
   if(trend==2)
     {
      ObjectSet(crossing,OBJPROP_ARROWCODE,ArrowCode2);
      ObjectSet(crossing,OBJPROP_COLOR,DownCross);
     }
   ObjectSet(crossing,OBJPROP_WIDTH,1);
   ObjectsRedraw();
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-IndicatorCounted();
   if(counted_bars==0)limit-=2;
//----
   double marray[];
//----
   ArrayResize(marray,limit);
   ArraySetAsSeries(marray,true);
//----
   for(i=0; i<limit; i++)
     {
      marray[i]=iOsMA(NULL,0,10,26,9,PRICE_CLOSE,i);
      ExtMapBuffer1[i]=marray[i];
     }
   for(i=0; i<limit; i++)
     {
      ExtMapBuffer1[i]=iMAOnArray(marray,limit,EmaPeriod,0,MODE_EMA,i);
     }
   while(limit>0)
     {
      if(ExtMapBuffer1[limit]>0 && ExtMapBuffer1[limit+1]<0)
         DrawArrow(limit,Low[limit]-1*Point,1);
      if(ExtMapBuffer1[limit]<0 && ExtMapBuffer1[limit+1]>0)
         DrawArrow(limit,High[limit]+5*Point,2);
      limit--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
