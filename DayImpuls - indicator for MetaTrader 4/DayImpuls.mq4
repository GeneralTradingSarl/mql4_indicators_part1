//+---------------------------------------------------------------------+
//| DayImpuls.mq4                                                       |
//|                                                                     | 
//| http://www.arkworldmarket.ru/forum/showthread.php?t=966&page=2&pp=10| 
//+---------------------------------------------------------------------+
#property copyright ""
#property link      "http://www.arkworldmarket.ru/forum/showthread.php?t=966&page=2&pp=10"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gold
//---- input parameters
extern int       per=14;
extern int       d=100;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
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
   int    counted_bars=IndicatorCounted();
   int  shift,i;
   double imp,mBar;
   //SetLoopCount(0);
   // loop from first bar to current bar (with shift=0)
   for( shift=Bars-1; shift>=0; shift--)
      //for shift=Bars-1 Downto 0
     {
      ExtMapBuffer1[shift]=1;
      ExtMapBuffer2[shift]=1;
      //SetIndexValue(shift,0);
      //SetIndexValue2(shift,0); 
     }
   mBar=d*per;
   //for shift=mBar downto per 
   for( shift=mBar; shift>=per; shift--)
     {
      imp=0;
      for( i=shift ;i>=shift-per; i--)
        {
         imp=imp+(Open[i]-Close[i]);
        }
      imp=MathRound(imp/Point);
      if (imp==0 )imp=0.0001;
      if (imp!=0 )
        {
         imp=-imp;
         ExtMapBuffer1[shift-per]=imp;
        }
     }
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+