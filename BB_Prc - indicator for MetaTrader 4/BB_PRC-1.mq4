//+------------------------------------------------------------------+
//|                                                       BB_PRC.mq4 |
//|                                                          Kalenzo |
//|                                      bartlomiej.gorski@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Kalenzo"
#property link      "bartlomiej.gorski@gmail.com"
#property indicator_color1 Red
#property indicator_color2 Gold
#property indicator_buffers 2

double bol[];
double ma[];
extern int bPer=20,bDev=2,maPer=50,maMeth=MODE_EMA;
extern bool useAlerts=true;
extern int alertBar=1;
extern int alertSleep=1800;//in seconds
int lastAlert;
#property indicator_separate_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,bol);
   SetIndexStyle(0,DRAW_LINE,EMPTY,2);

   SetIndexBuffer(1,ma);
   SetIndexStyle(1,DRAW_LINE,EMPTY,1);

   IndicatorShortName("BB PRC RANGE v1");
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
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) counted_bars=0;
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-bPer;

   for(int i=0; i<=limit;i++)
     {
      double bandL=iBands(Symbol(),0,bPer,bDev,0,PRICE_CLOSE,MODE_MINUSDI,i);
      double bandH=iBands(Symbol(),0,bPer,bDev,0,PRICE_CLOSE,MODE_PLUSDI,i);
      bol[i]=((Close[i]-bandL)/(bandH-bandL));

      if((Close[i]-bandL)==0 || (bandH-bandL)==0)
         Print(i," ",(Close[i]-bandL)," ",(bandH-bandL));
     }

   for(int j=0; j<=limit;j++)
     {
      ma[j]=iMAOnArray(bol,0,maPer,0,maMeth,j);
     }

   if(useAlerts)
     {
      if(ma[alertBar]>=bol[alertBar] && CurTime()>lastAlert && (bol[2+alertBar]>=bol[1+alertBar]) && (bol[1+alertBar] < bol[alertBar]))
        {
         Alert("BB PRC MADE LOW "+ Symbol() + " on the " +  Period() + " minute chart.");
         lastAlert=CurTime()+alertSleep;
        }

      if(ma[alertBar]<=bol[alertBar] && CurTime()>lastAlert && (bol[2+alertBar]<=bol[1+alertBar]) && (bol[1+alertBar] > bol[alertBar]))
        {
         Alert("BB PRC MADE HIGH "+ Symbol() + " on the " +  Period() + " minute chart.");
         lastAlert=CurTime()+alertSleep;
        }

      if(CurTime()>lastAlert && bol[alertBar+1]>=ma[alertBar+1] && bol[alertBar] < ma[alertBar])
        {
         Alert("BB PRC CROSSED MA FOR SELL "+ Symbol() + " on the " +  Period() + " minute chart.");
         lastAlert=CurTime()+alertSleep;
        }

      if(CurTime()>lastAlert && bol[alertBar+1]<=ma[alertBar+1] && bol[alertBar] > ma[alertBar])
        {
         Alert("BB PRC CROSSED MA FOR BUY "+ Symbol() + " on the " +  Period() + " minute chart.");
         lastAlert=CurTime()+alertSleep;
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+