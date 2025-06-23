//+---------------------------------+
//|        BREW_MissingData_Cht.mq4 |
//+---------------------------------+
#property  copyright "Copyright © 2010, Brewmanz"
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 5
#property  indicator_color1  Red
#property  indicator_color2  Red
#property  indicator_color3  Red
#property  indicator_color4  Red
#property  indicator_color5  Red
#property  indicator_width1 1
#property  indicator_width2 2
#property  indicator_width3 3
#property  indicator_width4 4
#property  indicator_width5 5
//---- input parameters
extern int AlertIfMissingPeriodsOver=10;
extern int AlertLimit=0;
extern int IconSize=indicator_width1;
//---- display buffers
double V1Buff[];
double V2Buff[];
double V3Buff[];
double V4Buff[];
double V5Buff[];
int AlertsToGo;
//+-------------------------------------------+
//| Custom indicator initialization function  |
//+-------------------------------------------+
int init()
  {
   AlertsToGo=AlertLimit;
//Print("Init() starting");
   string short_name;
   IndicatorBuffers(5);
//---- indicator line
//SetIndexStyle( 0,DRAW_LINE);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,indicator_width1,indicator_color1);
   SetIndexArrow(0,35);
   SetIndexBuffer(0,V1Buff);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,indicator_width2,indicator_color2);
   SetIndexArrow(1,35);
   SetIndexBuffer(1,V2Buff);
   SetIndexStyle(2,DRAW_ARROW,EMPTY,indicator_width3,indicator_color3);
   SetIndexArrow(2,35);
   SetIndexBuffer(2,V3Buff);
   SetIndexStyle(3,DRAW_ARROW,EMPTY,indicator_width4,indicator_color4);
   SetIndexArrow(3,35);
   SetIndexBuffer(3,V4Buff);
   SetIndexStyle(4,DRAW_ARROW,EMPTY,indicator_width5,indicator_color5);
   SetIndexArrow(4,35);
   SetIndexBuffer(4,V5Buff);

//---- name for DataWindow and indicator subwindow label
   short_name="BREW MissingData("+AlertIfMissingPeriodsOver+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"1 MissingBar");
   SetIndexLabel(1,"2-5 MissingBars");
   SetIndexLabel(2,"5-20 MissingBars");
   SetIndexLabel(3,"21-100 MissingBars");
   SetIndexLabel(4,">100 MissingBars");
//----
   SetIndexDrawBegin(0,1);
//----
//Print("Init() ending");
   return(0);
  }
//+--------------------------------------+
int start()
  {
   int ix,ixMax;

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   ixMax=Bars-counted_bars;
   if(counted_bars==0) ixMax-=1+1;

   for(ix=ixMax; ix>=0; ix--)
     {
      //if(ix > ixMax - TrailingBarsLength)//check if enough history to work
      //   continue;
      datetime dThis = Time[ix];
      datetime dPrev = Time[ix+1];
      int periodStep = (dThis - dPrev)/(Period()*60);
      // wait! if over weekend, deduct 'markets closed' time (49 hours)
      if(TimeDayOfWeek(dThis)<TimeDayOfWeek(dPrev))
         periodStep-=(49*60)/Period();
      int periodMissed=periodStep-1;
      V1Buff[ix] = EMPTY_VALUE;
      V2Buff[ix] = EMPTY_VALUE;
      V3Buff[ix] = EMPTY_VALUE;
      V4Buff[ix] = EMPTY_VALUE;
      V5Buff[ix] = EMPTY_VALUE;
      // is all okay?
      if(periodMissed<=0)
        {
         //V1Buff[ix] = EMPTY_VALUE;
         continue;
        }
      // oops. data is missing. could be weekend ...
      if(TimeDayOfWeek(dThis)<TimeDayOfWeek(dPrev))
        {
         if(periodMissed*Period()==49*60)
           {
            //V1Buff[ix] = EMPTY_VALUE;
            continue;
           }
        }

      Print(TimeToStr(dPrev),"-",TimeToStr(dThis)," Missing ",periodMissed," Periods of ",Period()," mins");
      if(periodMissed>AlertIfMissingPeriodsOver)
        {
         if(AlertsToGo>0)
           {
            AlertsToGo--;
            Alert(TimeToStr(dPrev),"-",TimeToStr(dThis)," Missing ",periodMissed," Periods of ",Period()," mins");
           }
        }
      if(periodMissed==1)
         V1Buff[ix]=(Close[ix]+Close[ix+1])/2.0;
      else if(periodMissed<=5)
                            V2Buff[ix]=(Close[ix]+Close[ix+1])/2.0;
      else if(periodMissed<=20)
                            V3Buff[ix]=(Close[ix]+Close[ix+1])/2.0;
      else if(periodMissed<=100)
                            V4Buff[ix]=(Close[ix]+Close[ix+1])/2.0;
      else
         V5Buff[ix]=(Close[ix]+Close[ix+1])/2.0;
     }
//---- plot any calced values
   return(0);
  }
//+------------------------------------+
