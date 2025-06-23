//+------------------------------------------------------------------+
//|                                                 Darvas Boxes.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 RoyalBlue
#property indicator_color2 RoyalBlue
//----
double     ind_buffer1[];
double     ind_buffer2[];
//----
bool allow_buy;
bool allow_sell;
double price;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(0, ind_buffer1);
   //
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,2);
   SetIndexBuffer(1, ind_buffer2);
   //
   allow_buy=true;
   allow_sell=false;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//---- TODO: add your code here
   double box_top=0;
   double box_bottom=0;
   int state=1;
//----
   for(int i=Bars - 1; i > 0; i--)
     {
      if (state==1)
        {
         box_top=High[i];
        }
      else if (state==2)
           {
            if (box_top > High[i])
              {
              }
            else
              {
               box_top=High[i];
              }
           }
         else if (state==3)
              {
               if (box_top > High[i])
                 {
                  box_bottom=Low[i];
                 }
               else
                 {
                  box_top=High[i];
                 }
              }
            else if (state==4)
                 {
                  if (box_top > High[i])
                    {
                     if (box_bottom < Low[i])
                       {
                       }
                     else
                       {
                        box_bottom=Low[i];
                       }
                    }
                  else
                    {
                     box_top=High[i];
                    }
                 }
               else if (state==5)
                    {
                     if (box_top > High[i])
                       {
                        if (box_bottom < Low[i])
                          {
                          }
                        else
                          {
                           box_bottom=Low[i];
                          }
                       }
                     else
                       {
                        box_top=High[i];
                       }
                     state=0;
                    }
      ind_buffer1[i]=box_top;
      ind_buffer2[i]=box_bottom;
      state++;
     }
   ind_buffer1[0]=EMPTY_VALUE;
   ind_buffer2[0]=EMPTY_VALUE;
//----
   return(0);
  }
//+------------------------------------------------------------------+----+