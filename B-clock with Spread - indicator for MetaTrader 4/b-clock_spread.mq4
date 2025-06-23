//+------------------------------------------------------------------+
//|                                                      b-clock.mq4 |
//|                                     Core time code by Nick Bilak |
//|        http://metatrader.50webs.com/         beluck[at]gmail.com |
//|            custom font size color and spread modified by tembox  | 
//+------------------------------------------------------------------+

#property copyright "Copyright © 2005, Nick Bilak"
#property link      "http://metatrader.50webs.com/"

#property indicator_chart_window

extern string FontName   = "Trebuchet MS";
extern int    FontSize   = 12;
extern color  FontColor  = Aqua;
extern bool   ShowSpread = True;
extern int    Distance   = 10;


//---- buffers
double s1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
    return(0);   
  }
  
int deinit()
  {
    ObjectDelete("time");   
    return(0);   
  }
  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
	 double i;
    int m, s, k, h;
    string ss;

   m = Time[0]+Period()*60-CurTime();
   i = m /60.0;
   s = m % 60;
   m = (m - m % 60) / 60;
   h = i / 60;
   k = m -(h*60);
    
   // Comment( h + " hours " + k + " minutes " + s + " seconds left to bar end");
    ObjectDelete("time");   
//----
    if(ObjectFind("time") != 0)
      { 
        if (Period()<=60) { ss = "< " + DoubleToStr(k,0) + ":" + DoubleToStr(s,0); }
        else { ss = "< " + DoubleToStr(h,0) + ":"+ DoubleToStr(k,0) + ":" + DoubleToStr(s,0); }
        
        if (ShowSpread) 
            { ss = ss +" ("+(Ask-Bid)/Point+")"; }
        
        ObjectCreate("time", OBJ_TEXT, 0, Time[0]+(Distance* PeriodSeconds(PERIOD_CURRENT)), (High[0]+Close[0])/2 ); 
        ObjectSetText("time", ss, FontSize, FontName, FontColor);
      }
    else
      {
        ObjectMove("time", 0, Time[0]+(Distance* PeriodSeconds(PERIOD_CURRENT)), (High[0]+Close[0])/2);
      }
    return(0);
  }
//+------------------------------------------------------------------+


