//+------------------------------------------------------------------+
//|                                                CamarillaOnly.com |
//|                                                       Pivots.mq4 |
//+------------------------------------------------------------------+

/*
   Background:
                                                         
      I used to use the Standard Pivot Points calculations for a long
      time. But I was never satisfied with them because the pivot 
      lines were too far apart to be useful to me.
      
      Somehow I found a different set of Calculations for Pivot
      Points. They are called Camarilla Level Pivot Points.
      
      You will find the definitions for these Pivot Points Lines at:
      
http://www.mypivots.com/dictionary/definition/42/camarilla-pivot-points

      There is only 1 calculation that I think is wrong. That is the
      calculation of PP (Pivot Point). The calculation is the one used
      in calculating the Standard Pivot Point.
      
      Instead I will use: PP = (R1 + S1) / 2 because it places the pivot
      in the center of the other pivot points.
      
*/      

#property copyright "© 2014. Bill halliday"
#property link      "http://www.oneoleguy.com/metatrader/indicators"

#property indicator_chart_window

#property indicator_buffers 9

// Establish the Colors for the Pivot lines

// Color1 is for the Pivot Point Line
#property indicator_color1 Yellow 

// Colors 1 through 4 are for the Resistance Lines
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Red

// Colors 5 through 9 are for the Support Lines
#property indicator_color6 Aqua
#property indicator_color7 Aqua
#property indicator_color8 Aqua
#property indicator_color9 Aqua


// Set Buffers

double   Resistance4[],
         Resistance3[],
         Resistance2[],
         Resistance1[],
         
         PivotPoint[],

         Support1[],
         Support2[],
         Support3[],
         Support4[];
         
double   range;         
/*
string   Res4,
         Res3,
         Res2,
         Res1,
         
         Pivot,
         
         Sup1,
         Sup2,
         Sup3,
         Sup4;
*/         
int      WhichWindow=0,
         WhatTime=0, 
         WhatPrice=0;        

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
  {

   // Set up the Pivot Lines
   // Resistance Lines

   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(1,Resistance4);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(2,Resistance3);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(3,Resistance2);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(4,Resistance1);
   
   // Camarilla Pivot Point Line
   
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,PivotPoint);
   
   // Support Lines
   
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(5,Support1);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(6,Support2);
   SetIndexStyle(7,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(7,Support3);
   SetIndexStyle(8,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(8,Support4);

   return(0);
  }

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+

int deinit()
  {
  
      ObjectsRedraw();
   
   return(0);
  }

//+------------------------------------------------------------------+
//| Camarilla Level Indicator Iteration Function                              |
//+------------------------------------------------------------------+

int start()
{
   // Declare the variables to be used in getting the valuse for the lines

   int      change_day_hour=0,
            counted_bars=IndicatorCounted(),
            number_of_bars_to_use   =  Bars - counted_bars,
            cnt=720;
            
   double   yesterday_high,
            yesterday_low,
            yesterday_close;
                                
// Find out if there are enough Bars to perform a calculation
	if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;

// Bars in an internal value for the Number of bars in the current chart.

//---- 
   for(int i=number_of_bars_to_use; i>=0; i--)
      {

        
      if    (
            // Check to see if this record is the 1st of the day
            // then set the valuse for yesterday.
            
            TimeHour(Time[i]) == change_day_hour &&
            TimeMinute(Time[i]) == 0
            )
                      
            {
            // Calculate yesterday's High, Low and Close
            
            yesterday_close=  Close[i + 1];
            yesterday_high =  iHigh(Symbol(),PERIOD_D1,1);
            yesterday_low  =  iLow(Symbol(),PERIOD_D1,1);
            range          =  yesterday_high - yesterday_low;
           
            } // if
            
            //Comment(" ");
            /*Comment("Current bar for ", Symbol(), "Open : ",  iOpen(Symbol(),PERIOD_D1,1),", High : ",
                                      iHigh(Symbol(),PERIOD_D1,1),", Low : ",  iLow(Symbol(),PERIOD_D1,1),", Close : ",
                                      iClose(Symbol(),PERIOD_D1,1),", ", iVolume(Symbol(),PERIOD_D1,1));*/


        
        
        //----- Standard Pivot Calculation =====> NOT USED <=====
        //----- P[] = (yesterday_high + yesterday_low + yesterday_close)/3; 

        Resistance4[i] = yesterday_close + (range * 1.1 / 2);
        Resistance3[i] = yesterday_close + (range * 1.1 / 4);
        Resistance2[i] = yesterday_close + (range * 1.1 / 6);
        Resistance1[i] = yesterday_close + (range * 1.1 / 12);

        Support1[i] = yesterday_close - (range * 1.1 / 12);
        Support2[i] = yesterday_close - (range * 1.1 / 6);
        Support3[i] = yesterday_close - (range * 1.1 / 4);
        Support4[i] = yesterday_close - (range * 1.1 / 2);
        
        //----- My Carmarilla Pivot Calculation =====> USED <=====
        
        PivotPoint[i] = (Resistance1[i] + Support1[i]) / 2;
                
      } // if

      return(0);

} // start()
 //+------------------------------------------------------------------+