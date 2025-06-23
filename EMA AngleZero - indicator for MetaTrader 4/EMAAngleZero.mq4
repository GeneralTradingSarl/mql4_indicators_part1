//+------------------------------------------------------------------+
//|                                                     EMAAngle.mq4 |
//|                                                           jpkfox |
//|                                                                  |
//| You can use this indicator to measure when the EMA angle is      |
//| "near zero". AngleTreshold determines when the angle for the     |
//| EMA is "about zero": This is when the value is between           |
//| [-AngleTreshold, AngleTreshold] (or when the histogram is red).  |
//|   EMAPeriod: EMA period                                          |
//|   AngleTreshold: The angle value is "about zero" when it is      |
//|     between the values [-AngleTreshold, AngleTreshold].          |      
//|   StartEMAShift: The starting point to calculate the             |   
//|     angle. This is a shift value to the left from the            |
//|     observation point. Should be StartEMAShift > EndEMAShift.    | 
//|   StartEMAShift: The ending point to calculate the               |
//|     angle. This is a shift value to the left from the            | 
//|     observation point. Should be StartEMAShift > EndEMAShift.    |
//|                                                                  |
//|   Modified by MrPip                                              |
//|       Red for down                                               |
//|       Yellow for near zero                                       |
//|       Green for up                                               |
//|  10/15/05  MrPip                                                 |
//|            Corrected problem with USDJPY and optimized code      |   
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "jpkfox"
#property  link      "http://www.strategybuilderfx.com/forums/showthread.php?t=15274&page=1&pp=8"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  LimeGreen
#property  indicator_color2  Yellow
#property  indicator_color3 FireBrick
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
   double fEndMA, fStartMA;
   double fAngle, mFactor, dFactor;
   int nLimit, i;
   int nCountedBars;
   double angle;
   int ShiftDif;
   if(EndEMAShift>=StartEMAShift)
     {
      Print("Error: EndEMAShift >= StartEMAShift");
      StartEMAShift=6;
      EndEMAShift=0;
     }
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   nLimit = Bars - counted_bars;
   if(counted_bars==0) nLimit-=1+MathMax(EndEMAShift,StartEMAShift);
   
//----   
   dFactor=3.14159/180.0;
   mFactor=10000.0;
   if (Symbol()=="USDJPY") mFactor=100.0;
   ShiftDif=StartEMAShift-EndEMAShift;
   mFactor/=ShiftDif;
//---- main loop
   for(i=0; i<nLimit; i++)
     {
      fEndMA=iMA(NULL,0,EMAPeriod,0,MODE_EMA,PRICE_MEDIAN,i+EndEMAShift);
      fStartMA=iMA(NULL,0,EMAPeriod,0,MODE_EMA,PRICE_MEDIAN,i+StartEMAShift);
      // 10000.0 : Multiply by 10000 so that the fAngle is not too small
      // for the indicator Window.
      fAngle=mFactor * (fEndMA - fStartMA);
      //      fAngle = MathArctan(fAngle)/dFactor;
      DownBuffer[i]=0.0;
      UpBuffer[i]=0.0;
      ZeroBuffer[i]=0.0;
//----
      if(fAngle > AngleTreshold)
         UpBuffer[i]=fAngle;
      else if (fAngle < -AngleTreshold)
            DownBuffer[i]=fAngle;
         else ZeroBuffer[i]=fAngle;
     }
   return(0);
  }
//+------------------------------------------------------------------+

