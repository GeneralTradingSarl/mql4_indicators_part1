//+------------------------------------------------------------------+
//|                                              CustomTimeframe.mq4 |
//|                                       when-money-makes-money.com |
//|                                       when-money-makes-money.com |
//+------------------------------------------------------------------+
#property copyright "when-money-makes-money.com"
#property link      "when-money-makes-money.com"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Black
#property indicator_color2 Black
#property indicator_color3 Red
#property indicator_color4 Blue
#property indicator_color5 Red
#property indicator_color6 Red
#property indicator_color7 Red
#property indicator_color8 Red
//---- buffers
double open[];
double close[];
double high[];
double low[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];

extern int MaxHistory=200;
extern int TimeInSeconds=1;

double a_open[];
double a_close[];
double a_high[];
double a_low[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,high);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,low);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,5);
   SetIndexBuffer(2,open);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,5);
   SetIndexBuffer(3,close);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,ExtMapBuffer8);
   ArrayResize(a_high,MaxHistory);
   ArrayResize(a_low,MaxHistory);
   ArrayResize(a_open,MaxHistory);
   ArrayResize(a_close,MaxHistory);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| redraw                                                           |
//+------------------------------------------------------------------+
void redraw(int max)
  {
   for(int i=max-1;i>=0;i--)
     {
      if(i==max-1)
        {
         open[i]=0;
         close[i]=0;
         high[i]=0;
         low[i]=0;
        }
      else
        {
         open[i]=a_open[i];
         close[i]=a_close[i];
         high[i]=a_high[i];
         low[i]=a_low[i];
        }
     }
  }
//+------------------------------------------------------------------+
//| shift                                                            |
//+------------------------------------------------------------------+
void shift(int max)
  {
   for(int i=max-1;i>0;i--)
     {
      a_open[i]=a_open[i-1];
      a_close[i]=a_close[i-1];
      a_high[i]=a_high[i-1];
      a_low[i]=a_low[i-1];
     }
  }

extern int sleep=100;
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<MaxHistory) return(0);
//----
   bool running=true;
   static double price=0;
   static int t=0;
   static datetime t_r=0;
   static bool updates=false;
//t=TimeCurrent();
//while(running){
   updates=false;
   if(TimeCurrent()>(t+TimeInSeconds))
     {
      shift(MaxHistory);
      if(a_open[1]==EMPTY || a_open[1]==EMPTY_VALUE || a_open[1]==0)
        {
         a_open[0]=Bid;
         a_close[0]=Bid;
         a_high[0]=Bid;
         a_low[0]=Bid;
           }else{
         a_open[0]=a_close[1];
         a_high[0]=a_close[1];
         a_low[0]=a_close[1];
         a_close[0]=a_close[1];
        }
      Print("shift "+a_open[0]+" - "+a_open[1]);
      updates=true;
      t=TimeCurrent();
     }
   if(price!=Bid)
     {
      price=Bid;
      a_close[0]=price;
      a_high[0]=MathMax(price,a_high[0]);
      a_low[0]=MathMin(price,a_low[0]);
      updates=true;
     }
   if(Time[0]!=t_r)
     {
      t_r=Time[0];
      redraw(MaxHistory);
        }else{
      if(updates)
        {
         redraw(MaxHistory);
        }
     }
   if(IsStopped()) running=false;
//   Sleep(sleep);
//}
//----
   return(0);
  }
//+------------------------------------------------------------------+
