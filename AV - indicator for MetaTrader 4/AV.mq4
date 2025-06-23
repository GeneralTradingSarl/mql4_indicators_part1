//+------------------------------------------------------------------+
//|                                                           AV.mq4 |
//|                                        Copyright © 2006, Mistral |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Mistral, 2006"
#property link      ""

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 LavenderBlush
#property indicator_color2 OrangeRed
#property indicator_color3 SpringGreen
#property indicator_color4 LavenderBlush
#property indicator_color5 OrangeRed
#property indicator_color6 SpringGreen
//---- input parameters
extern int Acc=0;
extern int Wide=2;
//---- buffers
double AIB1[];
double AIB2[];
double AIB3[];
double VIB1[];
double VIB2[];
double VIB3[];
//+------------------------------------------------------------------+
//| AVc indicator initialization function                            |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string short_name;
   if(Acc==0)
     {
      SetIndexStyle(0,DRAW_NONE);
      SetIndexStyle(1,DRAW_NONE);
      SetIndexStyle(2,DRAW_NONE);
      SetIndexStyle(3,DRAW_LINE);
      SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
      SetIndexStyle(5,DRAW_LINE,STYLE_DOT);
      short_name="VI("+Wide+")";
     }
   if(Acc==1)
     {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
      SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
      SetIndexStyle(3,DRAW_NONE);
      SetIndexStyle(4,DRAW_NONE);
      SetIndexStyle(5,DRAW_NONE);
      short_name="AI("+Wide+")";
     }
   SetIndexBuffer(0,AIB1);
   SetIndexBuffer(1,AIB2);
   SetIndexBuffer(2,AIB3);
   SetIndexBuffer(3,VIB1);
   SetIndexBuffer(4,VIB2);
   SetIndexBuffer(5,VIB3);
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name+"M");
   SetIndexLabel(1,short_name+"L");
   SetIndexLabel(2,short_name+"H");
   SetIndexLabel(3,short_name+"M");
   SetIndexLabel(4,short_name+"L");
   SetIndexLabel(5,short_name+"H");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| AV indicator deinitialization function                           |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| AV indicator iteration function                                  |
//+------------------------------------------------------------------+
int start()
  {
   int      i,j,counted_bars=IndicatorCounted();
   double   mp1,mp2;
//----
   if(Bars<=(Wide*2)) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=(Wide*2);i++)
        {
         AIB1[Bars-i]=0.0;
         AIB2[Bars-i]=0.0;
         AIB3[Bars-i]=0.0;
         VIB1[Bars-i]=0.0;
         VIB2[Bars-i]=0.0;
         VIB3[Bars-i]=0.0;
        }
//----
   i=Bars-Wide-1;
   if(counted_bars>=Wide) i=Bars-counted_bars-1;
   j=i-Wide;
   while(i>=0)
     {
      mp1=High[i]-(High[i]-Low[i])/2;
      mp2=High[i+Wide]-(High[i+Wide]-Low[i+Wide])/2;
      VIB1[i]=(mp1-mp2)*100/Wide;
      VIB2[i]=(Low[i]-Low[i+Wide])*100/Wide;
      VIB3[i]=(High[i]-High[i+Wide])*100/Wide;
      if(i==0) VIB1[i]=(Bid-mp2)*100/Wide;
      if(i<=j) AIB1[i]=(VIB1[i]-VIB1[i+Wide])/Wide;
      AIB2[i]=(VIB2[i]-VIB2[i+Wide])/Wide;
      AIB3[i]=(VIB3[i]-VIB3[i+Wide])/Wide;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+
