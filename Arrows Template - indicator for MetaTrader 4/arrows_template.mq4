//+------------------------------------------------------------------+
//|                                              arrows_template.mq4 |
//|                                         Copyright 2016, eevviill |
//|                                      http://alievtm.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "eevviill"
#property link      "http://alievtm.blogspot.com"
#property version   "1.55"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 clrLightBlue
#property indicator_color2 clrRed
#property indicator_width1 1
#property indicator_width2 1

extern string arr_set="Arrow settings";
extern int arrow_indent=22;
extern int up_arrow_code=233;
extern int down_arrow_code=234;

extern string emp1="///////////////////////////////////////";
extern string al_set="Alerts settings";
extern bool use_alert=false;
extern string up_alert="UP";
extern string down_alert="DOWN";

double up_arr[];
double down_arr[];
int prev_bars;
/////////////////////////////////////////////////////////////////
int OnInit()
  {
   SetIndexBuffer(0,up_arr);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,up_arrow_code);
   SetIndexLabel(0,"UP arrow");

   SetIndexBuffer(1,down_arr);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,down_arrow_code);
   SetIndexLabel(1,"DOWN arrow");

   return(INIT_SUCCEEDED);
  }
//////////////////////////////////////////////////////////////////
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],
                const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[])
  {
//no bars
   if(Bars<20) return(rates_total);

//history update
   int all=rates_total;
   int counted=prev_calculated;
   if(all-counted>1)
     {
      ArrayInitialize(up_arr,EMPTY_VALUE);
      ArrayInitialize(down_arr,EMPTY_VALUE);
      counted=0;
     }

//main
   for(int i=all-counted;i>=0;i--)
     {
      if(i>Bars-20) i=Bars-20;

      if(i==0)
        {
         up_arr[i]=EMPTY_VALUE;
         down_arr[i]=EMPTY_VALUE;
        }

      if(Close[i]>Close[i+1]) up_arr[i]=Low[i]-arrow_indent*Point; //up arrow
      if(Close[i]<Close[i+1]) down_arr[i]=High[i]+arrow_indent*Point; //down arrow
     }

//new bar
   if(Bars==prev_bars) return(rates_total);
   prev_bars=Bars;

//Alerts
   if(use_alert)
     {
      if(up_arr[1]!=EMPTY_VALUE) Alert(Symbol()," ",Period()," ",up_alert);
      if(down_arr[1]!=EMPTY_VALUE) Alert(Symbol()," ",Period()," ",down_alert);
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
