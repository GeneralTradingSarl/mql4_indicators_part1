//+------------------------------------------------------------------+
//|                                                     EMAAngle.mq4 |
//|                                                           jpkfox |
//|                                                                  |  
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "jpkfox"
#property  link      "http://www.strategybuilderfx.com/forums/showthread.php?t=15274&page=1&pp=8"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  clrLimeGreen
#property  indicator_color2  clrYellow
#property  indicator_color3  clrFireBrick
//---- indicator parameters
extern int EMAPeriod=34;
extern double AngleTreshold=0.2;
extern int StartEMAShift=6;
extern int EndEMAShift=0;
//---- indicator buffers
double UpBuffer[];
double DownBuffer[];
double ZeroBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2);
//----
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DownBuffer);
   SetIndexBuffer(2,ZeroBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("EMAAngleZero("+EMAPeriod+","+AngleTreshold+","+StartEMAShift+","+EndEMAShift+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| The angle for EMA                                                |
//+------------------------------------------------------------------+
int start()
  {
   double fEndMA,fStartMA;
   double fAngle,mFactor,dFactor;
   int nLimit,i;
   int nCountedBars;
   int ShiftDif;
//----
   if(EndEMAShift>=StartEMAShift)
     {
      Print("Error: EndEMAShift >= StartEMAShift");
      StartEMAShift=6;
      EndEMAShift=0;
     }
   nCountedBars=IndicatorCounted();
//---- check for possible errors
   if(nCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if(nCountedBars>0) nCountedBars--;
   nLimit=Bars-nCountedBars;
   if(nCountedBars==0) nLimit--;
//---
   dFactor=3.14159/180.0;
   mFactor=10000.0;
   if(Symbol()=="USDJPY") mFactor=100.0;
   ShiftDif=StartEMAShift-EndEMAShift;
   mFactor/=ShiftDif;
//---- main loop
   for(i=0; i<nLimit; i++)
     {
      fEndMA=iMA(NULL,0,EMAPeriod,0,MODE_EMA,PRICE_MEDIAN,i+EndEMAShift);
      fStartMA=iMA(NULL,0,EMAPeriod,0,MODE_EMA,PRICE_MEDIAN,i+StartEMAShift);
      // 10000.0 : Multiply by 10000 so that the fAngle is not too small
      // for the indicator Window.
      fAngle=mFactor *(fEndMA-fStartMA);
      //      fAngle = MathArctan(fAngle)/dFactor;
      DownBuffer[i]=0.0;
      UpBuffer[i]=0.0;
      ZeroBuffer[i]=0.0;
      //----
      if(fAngle>AngleTreshold)
         UpBuffer[i]=fAngle;
      else if(fAngle<-AngleTreshold)
         DownBuffer[i]=fAngle;
      else ZeroBuffer[i]=fAngle;
     }
   return(0);
  }
//+------------------------------------------------------------------+
