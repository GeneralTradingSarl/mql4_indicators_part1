//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
/*------------------------------------------------------------------+
 |                                                BB_Support_Up.mq4 |
 |                                                 Copyright © 2010 |
 |                                             basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2010, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//-----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 White
#property indicator_color2 Yellow
#property indicator_color3 Blue
#property indicator_color4 Black
#property indicator_color5 White
#property indicator_color6 Yellow
#property indicator_color7 Blue
#property indicator_color8 Black
//-----
extern int        n0Period    = 20;
extern int        n0Deviation = 2;
extern int        n1Period    = 20;
extern int        n1Deviation = 2;
extern int        n2Period    = 20;
extern int        n2Deviation = 2;
extern int        n3Period    = 20;
extern int        n3Deviation = 2;
//-----
extern int        MaShift     = 0;
extern int        PRICE_Ma    = 6;
//-----
double U0[];
double U1[];
double U2[];
double U3[];
double D0[];
double D1[];
double D2[];
double D3[];
//+------------------------------------------------------------------+
int init()
  {
   SetIndexShift(0,MaShift);
   SetIndexShift(1,MaShift);
   SetIndexShift(2,MaShift);
   SetIndexShift(3,MaShift);
   SetIndexShift(4,MaShift);
   SetIndexShift(5,MaShift);
   SetIndexShift(6,MaShift);
   SetIndexShift(7,MaShift);
//-----
   SetIndexBuffer(0,U0);
   SetIndexBuffer(1,U1);
   SetIndexBuffer(2,U2);
   SetIndexBuffer(3,U3);
   SetIndexBuffer(4,D0);
   SetIndexBuffer(5,D1);
   SetIndexBuffer(6,D2);
   SetIndexBuffer(7,D3);
//-----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexStyle(7,DRAW_LINE);
//-----
   return(0);
  }
//+------------------------------------------------------------------+
void GetNextTF(int curTF, int &tf1, int &tf2, int &tf3)
  {
   switch(curTF)
     {
      case 1:
         tf1=5; tf2=15; tf3=30;
         break;
      case 5:
         tf1=15; tf2=30; tf3=60;
         break;
      case 15:
         tf1=30; tf2=60; tf3=240;
         break;
      case 30:
         tf1=60; tf2=240; tf3=1440;
         break;
      case 60:
         tf1=240; tf2=1440; tf3=10080;
         break;
      case 240:
         tf1=1440; tf2=10080; tf3=43200;
         break;
     }
  }
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
   int tf1 = 0;
   int tf2 = 0;
   int tf3 = 0;
   GetNextTF(Period(),tf1,tf2,tf3);
   Comment(tf1," Yellow  ","\n",tf2," Blue ","\n",tf3," Black");
   for(int i=0; i<limit; i++)
     {
      U0[i]=iBands(NULL,Period(),n0Period,n0Deviation,0,PRICE_Ma,MODE_UPPER,i);
      if(tf1!=0) U1[i]   = iBands(NULL, tf1, n1Period, n1Deviation, 0, PRICE_Ma, MODE_UPPER, i / (tf1 / Period()));
      if(tf2!=0) U2[i]   = iBands(NULL, tf2, n2Period, n2Deviation, 0, PRICE_Ma, MODE_UPPER, i / (tf2 / Period()));
      if(tf3!=0) U3[i]   = iBands(NULL, tf3, n3Period, n3Deviation, 0, PRICE_Ma, MODE_UPPER, i / (tf3 / Period()));
      //-----
      D0[i]  = iBands(NULL, Period(), n0Period, n0Deviation, 0, PRICE_Ma, MODE_LOWER, i);
      if(tf1!=0) D1[i]  = iBands(NULL, tf1, n1Period, n1Deviation, 0, PRICE_Ma, MODE_LOWER, i / (tf1 / Period()));
      if(tf2!=0) D2[i]  = iBands(NULL, tf2, n2Period, n2Deviation, 0, PRICE_Ma, MODE_LOWER, i / (tf2 / Period()));
      if(tf3!=0) D3[i]  = iBands(NULL, tf3, n3Period, n3Deviation, 0, PRICE_Ma, MODE_LOWER, i / (tf3 / Period()));
     }
//-----
   return(0);
  }
//+------------------------------------------------------------------+
