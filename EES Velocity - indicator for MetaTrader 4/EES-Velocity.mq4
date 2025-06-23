//+------------------------------------------------------------------+
//|                                                 EES-Velocity.mq4 |
//|                             Copyright © 2011, Elite E Services   |
//|  http://www.eliteeservices.net          http://www.getfxnow.com  |      
//|                                                                  |
//|Support:  http://www.eesfx.com  Group:  http://www.forexcoding.com| 
//|Elite E Services (646)837-0059                                    |
//|1201 Main Street  Columbia, SC 29201    Suite 1980                |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2011, Elite E Services"
#property link      "http://www.eesfx.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Gold

extern int
   Time_Input      = 0; //0= Seconds,1=Minute,2=hours,3=Day
   //Instructions:  Copy to /indicators folder and load onto chart.  Time frame does not matter as time is defined by time input setting.
 
double VBuff[];
double VTBuff[];

int MyDigits;
double MyPoint;
   string short_name;
int BARS;   
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
  if(Digits==5)MyDigits=4;
  else if(Digits==3)MyDigits=2;
  else MyDigits = Digits; 
  if (Point == 0.00001) MyPoint = 0.0001; //6 digits
  else if (Point == 0.001) MyPoint = 0.01; //3 digits (for Yen based pairs)
  else MyPoint = Point; //Normal
//---- indicators

//---- 1 additional buffer used for counting.
   IndicatorBuffers(3);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,VBuff);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,VTBuff);

//---- name for DataWindow and indicator subwindow label
   string type = "Seconds";
   if(Time_Input == 1)type = "Minutes";
   if(Time_Input == 2)type = "Hours";
   if(Time_Input == 3)type = "Days";
   short_name="EES Velocity("+type+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Volatility("+type+")");
   SetIndexLabel(1,"VTick");
//----
   SetIndexDrawBegin(0,10);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll( 0, OBJ_TEXT); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   if(Bars<=5) return(0);
   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
     
   for(i=0; i<limit; i++)
   {
      double TIME = iTime(Symbol(),0,i)-iTime(Symbol(),0,i+1);
      if(i==0)TIME = TimeCurrent()-iTime(Symbol(),0,0);
      if(Time_Input==1)TIME = TIME/60;
      if(Time_Input==2)TIME = TIME/(60*60);
      if(Time_Input==3)TIME = TIME/(60*1440);
      if(i==0)Print("TIME= "+TIME);
      VBuff[i]=((High[i]-Low[i])/TIME)/Point;
      VTBuff[i]=((High[i]-Low[i])/Volume[i])/Point;
   }
   return(0);
  }
//+------------------------------------------------------------------+

