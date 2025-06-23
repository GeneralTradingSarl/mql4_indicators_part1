//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//|    For a price I can code for you any strategy you have          |
//|    in mind into EA, I can code any indicator you have in mind    |
//|                                                                  |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|        This indicator shows how the lines of Highs, Lows, Opens, |
//|          and Closes can interact                                 |
//+------------------------------------------------------------------+


#property copyright "Copyright © 2009, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 AliceBlue
#property indicator_color2 DodgerBlue
#property indicator_color3 LightPink
#property indicator_color4 Seashell
//---- input parameters
extern int FLPeriod=1;
//---- buffers
double HighBuffer[];
double OpenBuffer[];
double CloseBuffer[];
double LowBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,HighBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,OpenBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,CloseBuffer);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,LowBuffer);
   
   
//---- name for DataWindow and indicator subwindow label
   short_name="Four legs by mt-coder@hotmail.com ("+FLPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"High");
   SetIndexLabel(1,"Open");
   SetIndexLabel(2,"Close");
   SetIndexLabel(3,"Low");
//----
   SetIndexDrawBegin(0,FLPeriod);
      SetIndexDrawBegin(1,FLPeriod);
         SetIndexDrawBegin(2,FLPeriod);
            SetIndexDrawBegin(3,FLPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Four legs                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=FLPeriod) return(0);

//----
   i=Bars-FLPeriod-1;
   if(counted_bars>=FLPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      
      HighBuffer[i]=High[i];
      OpenBuffer[i]=Open[i];
      CloseBuffer[i]=Close[i];
      LowBuffer[i]=Low[i];
      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+