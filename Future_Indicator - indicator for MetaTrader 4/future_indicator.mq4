//+------------------------------------------------------------------+
//|                                             Future_Indicator.mq4 |
//|                                                  Future_Capital  |
//|                     https://ru.tradingview.com/u/Future_Capital/ |
//+------------------------------------------------------------------+
#property copyright "Future_Capital "
#property link      "https://ru.tradingview.com/u/Future_Capital/"
#property version   "5.00"
#property indicator_chart_window
//----
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Blue
#property indicator_color5 Lime
#property indicator_color6 Magenta
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
//---- parameters
extern int MaPeriod=50;
extern int MaMetod =1;
extern int Step=0;
extern int CountBars=4000;
extern bool UseT3=true;
extern double b=0.88;
extern bool Alerts=false;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double UpArrow[];
double DnArrow[];
//----
double e1,e2,e3,e4,e5,e6;
double c1,c2,c3,c4;
double n,w1,w2,b2,b3;
//----
int ExtCountedBars=0;
static bool TurnedUp=false;
static bool TurnedDown=false;
datetime timeprev=0;

//----
int init()
  {
//---- indicators
   IndicatorBuffers(6);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3, ExtMapBuffer4);
   SetIndexBuffer(4, UpArrow);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,233);
   SetIndexBuffer(5,DnArrow);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,234);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,UpArrow);
   SetIndexBuffer(5,DnArrow);
//---- variable reset
   e1=0; e2=0; e3=0; e4=0; e5=0; e6=0;
   c1=0; c2=0; c3=0; c4=0;
   n=0;
   w1=0; w2=0;
   b2=0; b3=0;
   b2=b*b;
   b3=b2*b;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+b+b3);
   c4=(1+3*b+b3+3*b2);
   n=MaPeriod;
   if (n<1) n=1;
   n=1 + 0.5*(n-1);
   w1=2/(n + 1);
   w2=1 - w1;
   Comment ("Зайди сюда --> ru.tradingview.com/u/Future_Capital/");
   return(0);
  }

//----
int start()
  {
   if(timeprev<iTime(NULL,0,0)) {TurnedDown=false; TurnedUp=false;timeprev=iTime(NULL,0,0);}
   if (CountBars>Bars-1) CountBars=Bars-1;
   double maOpen, maClose, maLow, maHigh;
   double haOpen, haHigh, haLow, haClose;
   if(Bars<=10) return(0);
   //ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   //if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   //if (ExtCountedBars>0) ExtCountedBars--;
   int pos=CountBars;//-ExtCountedBars-1;
   while(pos>=0)
     {
      if (UseT3)
        {
         maOpen=CalcT3(Open[pos]);
         maClose=CalcT3(Close[pos]);
         maLow=CalcT3(Low[pos]);
         maHigh=CalcT3(High[pos]);
        }
      else
         if (!UseT3)
           {
            maOpen=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_OPEN,pos);
            maClose=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_CLOSE,pos);
            maLow=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_LOW,pos);
            maHigh=iMA(NULL,0,MaPeriod,0,MaMetod,PRICE_HIGH,pos);
           }
      haClose=(maOpen+maHigh+maLow+maClose)/4;
      //haClose=(maOpen+maClose)/2+(((maClose-maOpen)/(maHigh-maLow))*MathAbs((maClose-maOpen)/2));      
      haOpen=(ExtMapBuffer3[pos+1]+ExtMapBuffer4[pos+1])/2;
      haHigh=MathMax(maHigh, MathMax(haOpen, haClose));
      haLow=MathMin(maLow, MathMin(haOpen, haClose));
      if (haOpen<haClose)
        {
         ExtMapBuffer1[pos]=haLow;
         ExtMapBuffer2[pos]=haHigh;
        }
      else
        {
         ExtMapBuffer1[pos]=haHigh;
         ExtMapBuffer2[pos]=haLow;
        }
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;
      if (Step>0) if(MathAbs(ExtMapBuffer1[pos]-ExtMapBuffer1[pos+1]) < Step*Point)ExtMapBuffer1[pos]=ExtMapBuffer1[pos+1];
      if (Step>0) if(MathAbs(ExtMapBuffer2[pos]-ExtMapBuffer2[pos+1]) < Step*Point)ExtMapBuffer2[pos]=ExtMapBuffer2[pos+1];
      if (Step>0) if(MathAbs(ExtMapBuffer3[pos]-ExtMapBuffer3[pos+1]) < Step*Point)ExtMapBuffer3[pos]=ExtMapBuffer3[pos+1];
      if (Step>0) if(MathAbs(ExtMapBuffer4[pos]-ExtMapBuffer4[pos+1]) < Step*Point)ExtMapBuffer4[pos]=ExtMapBuffer4[pos+1];
      if (Alerts==true)
        {
         UpArrow[pos]=EMPTY_VALUE; DnArrow[pos]=EMPTY_VALUE;
         if (ExtMapBuffer3[pos]<ExtMapBuffer4[pos] && ExtMapBuffer4[pos+1]<ExtMapBuffer3[pos+1])
           {
            UpArrow[pos]=ExtMapBuffer4[pos+1]-(Ask-Bid);
            if (UpArrow[0]!=EMPTY_VALUE && TurnedUp==false)
              {
               Alert("HAMa  BUY:  ",Symbol()," - ",Period(),"  at  ", Close[0],"  -  ", TimeToStr(CurTime(),TIME_SECONDS));
               TurnedDown=false;
               TurnedUp=true;
              }
           }
         if (ExtMapBuffer3[pos]>ExtMapBuffer4[pos] && ExtMapBuffer4[pos+1]>ExtMapBuffer3[pos+1])
           {
            DnArrow[pos]=ExtMapBuffer4[pos+1]+(Ask-Bid);
            if (DnArrow[0]!=EMPTY_VALUE && TurnedDown==false)
              {
               Alert("HAMa SELL:  ",Symbol()," - ",Period(),"  at  ", Close[0],"  -  ", TimeToStr(CurTime(),TIME_SECONDS));
               TurnedUp=false;
               TurnedDown=true;
              }
           }
        }
      pos--;
     }
//----
   return(0);
  }

//----
double CalcT3(double CalcPrice)
  {
   e1=w1*CalcPrice+w2*e1;
   e2=w1*e1 + w2*e2;
   e3=w1*e2 + w2*e3;
   e4=w1*e3 + w2*e4;
   e5=w1*e4 + w2*e5;
   e6=w1*e5 + w2*e6;
   double T3=c1*e6 + c2*e5 + c3*e4 + c4*e3;
   return(T3);
  }
//----