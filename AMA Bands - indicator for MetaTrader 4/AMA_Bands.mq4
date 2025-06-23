//+------------------------------------------------------------------+
//|                                                    AMA_Bands.mq4 |
//|                                      Copyright © 2006, Alexandre |
//|                                       mailto: a_g_j_@hotmail.com |
//+------------------------------------------------------------------+
//---- general properties
#property copyright "Copyright © 2006, Alexandre"
#property link      "mailto: a_g_j_@hotmail.com"
//---- indicator properties
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 DarkViolet  // 'line'  (main)
#property indicator_color2 DodgerBlue  // 'arrow' (up)
#property indicator_color3 OrangeRed   // 'arrow' (down)
#property indicator_color4 Silver      // 'arrow' (stop-symbol)
#property indicator_color5 Aqua        // 'line'  (inner BB upper band)
#property indicator_color6 Aqua        // 'line'  (inner BB lower band)
#property indicator_color7 Magenta     // 'line'  (outer BB upper band)
#property indicator_color8 Magenta     // 'line'  (outer BB lower band)
//---- defines
//---- input parameters
extern int    Range       = 9;
extern int SlowAMA        = 30;
extern int FastAMA        = 2;
extern double P_G         = 2.0;
extern double K_F         = 2.0;
extern bool InnerBandsOn  = true;
extern double BandsDevInn = 1.0;
extern bool OuterBandsOn  = true;
extern double BandsDevOut = 2.0;
extern bool LastBarOnly   = false;
//---- common buffers
//---- indicator buffers
double AMA_Buffer[];
double AMA_UpSig[];
double AMA_DwSig[];
double AMA_NlSig[];
double AMA_UppBufferL[];
double AMA_LowBufferL[];
double AMA_UppBufferH[];
double AMA_LowBufferH[];
//---- variables
double A=0.45; // quotation coefficient - value close to optimal 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexLabel(0,"Main Line");
   SetIndexBuffer(0,AMA_Buffer); // main line
   SetIndexDrawBegin(0,Range);
//
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexLabel(1,"Signal Up");
   SetIndexArrow(1,225);       // small arrow up
   SetIndexBuffer(1,AMA_UpSig);
   SetIndexDrawBegin(1,Range);
//
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexLabel(2,"Signal Down");
   SetIndexArrow(2,226);       // small arrow down
   SetIndexBuffer(2,AMA_DwSig);
   SetIndexDrawBegin(2,Range);
//
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexLabel(3,"Signal Stop");
   SetIndexArrow(3,251);       // small stop-symbol
   SetIndexBuffer(3,AMA_NlSig);
   SetIndexDrawBegin(3,Range);
//
   if(InnerBandsOn==true)
     {
      SetIndexStyle(4,DRAW_LINE);
      SetIndexLabel(4,"Inner BB Upper Line");
      SetIndexBuffer(4,AMA_UppBufferL); // inner BB upper line
      SetIndexDrawBegin(4,Range);
      //
      SetIndexStyle(5,DRAW_LINE);
      SetIndexLabel(5,"Inner BB Lower Line");
      SetIndexBuffer(5,AMA_LowBufferL); // inner BB lower line
      SetIndexDrawBegin(5,Range);
     }
//
   if(OuterBandsOn==true)
     {
      SetIndexStyle(6,DRAW_LINE);
      SetIndexLabel(6,"Outer BB Upper Line");
      SetIndexBuffer(6,AMA_UppBufferH); // outer BB upper line
      SetIndexDrawBegin(6,Range);
      //
      SetIndexStyle(7,DRAW_LINE);
      SetIndexLabel(7,"Outer BB Lower Line");
      SetIndexBuffer(7,AMA_LowBufferH); // outer BB lower line
      SetIndexDrawBegin(7,Range);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int Limit;
   int i,k;
   double d_f,old_val,new_val,sum,std_dev;
   static double v_prev,v_curr,ER_Low,ER_Upp;
//----
   if(counted_bars<0) { return(-1); }
   Limit=Bars-counted_bars;
//
   if(Limit>Range) // run once when getting started
     {
      k=Limit-Range-1;
      v_prev = Close[Limit-Range];
      ER_Low = 2.0 / (SlowAMA + 1); // lower Efficiency Ratio threshold
      ER_Upp = 2.0 / (FastAMA + 1); // upper Efficiency Ratio threshold
     }
   else // run elsewhere
     {
      if(LastBarOnly==false)
        {
         k=Limit; v_prev=AMA_Buffer[Limit+1];
        }
      else
        {
         k=0;
         v_prev=AMA_Buffer[1];
        }
     }
//
   for(i=k; i>=0; i--)
     {
      v_curr=GetAMAOneStep(v_prev,i,Range,ER_Low,ER_Upp,P_G,A);
      d_f=v_curr-v_prev;
      v_prev=v_curr;
      AMA_Buffer[i]=v_curr; // line
                            // signals - 1st derivative
      if((MathAbs(d_f)>(K_F*Point)) && (d_f>0.0)) // signal up
        {
         AMA_UpSig[i] = AMA_Buffer[i];
         AMA_DwSig[i] = EMPTY_VALUE;
         AMA_NlSig[i] = EMPTY_VALUE;
        }
      else if((MathAbs(d_f)>(K_F*Point)) && (d_f<0.0)) // signal down
        {
         AMA_UpSig[i] = EMPTY_VALUE;
         AMA_DwSig[i] = AMA_Buffer[i];
         AMA_NlSig[i] = EMPTY_VALUE;
        }
      else // signal stop
        {
         AMA_UpSig[i] = EMPTY_VALUE;
         AMA_DwSig[i] = EMPTY_VALUE;
         AMA_NlSig[i] = AMA_Buffer[i];
        }
     }
   if((InnerBandsOn==true) || (OuterBandsOn==true))
     {
      // calculate standard deviation
      i=Bars-Range;
      if(counted_bars>(Range-1)) { i=Bars-counted_bars-1; }
      while(i>=0)
        {
         sum=0.0;
         k=i+Range-1;
         old_val = AMA_Buffer[i];
         while(k>= i)
           {
            new_val=Close[k]-old_val;
            sum+=new_val*new_val;
            k--;
           }
         std_dev=MathSqrt(sum/Range);
         // complete BB's buffers
         if(InnerBandsOn==true)
           {
            AMA_UppBufferL[i] = old_val + BandsDevInn * std_dev;
            AMA_LowBufferL[i] = old_val - BandsDevInn * std_dev;
           }
         if(OuterBandsOn==true)
           {
            AMA_UppBufferH[i] = old_val + BandsDevOut * std_dev;
            AMA_LowBufferH[i] = old_val - BandsDevOut * std_dev;
           }
         i--;
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Close Prices Adaptive Smoothing - AMA One Step                   |
//+------------------------------------------------------------------+
double GetAMAOneStep(double v_prev,int n_bar,int range,double er_low,
                     double er_upp,double pow,double a)
  {
   double v_curr,noise,er,ssc;
//----
// calculate efficiency ratio & ssc
   noise=0.000000001;
   for(int i=n_bar+range-1; i>=n_bar; i--)
     {
      noise+=MathAbs(Close[i]-Close[i+1]);
     }
   er   = MathAbs(Close[n_bar] - Close[n_bar+range]) / noise;
   ssc  = er * er_upp + er_low;
   ssc  = MathPow(ssc, pow);
// calculate AMA one step, using explicit/implicit Euler Schema
   v_curr=(v_prev+ssc *(a *(Close[n_bar+1]-v_prev)+
           (1.0-a)*Close[n_bar]))/(1.0+(1.0-a)*ssc);
//----
   return(v_curr);
  }
//+------------------------------------------------------------------+
