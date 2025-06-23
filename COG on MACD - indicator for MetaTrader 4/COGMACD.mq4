//+------------------------------------------------------------------+
//|                                                     COGMACD.mq4 |
//| Original Code from NG3110@latchess.com                           |                                    
//| Linuxser 2007 for TSD    http://www.forex-tsd.com/               |
//| Mod by Brooky @           Brooky-Indicators.com                  |
//+------------------------------------------------------------------+
#property  copyright "ANG3110@latchess.com"
//---------ang_pr (Din)--------------------
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 RoyalBlue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Orange
#property indicator_color5 LimeGreen
#property indicator_color6 Olive
#property indicator_color7 DarkBlue
#property indicator_color8 Tomato

#property indicator_level1 0
#property indicator_levelstyle 0
#property indicator_levelcolor DimGray

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 2
#property indicator_width7 2
#property indicator_width8 2

#property indicator_style1 0
#property indicator_style2 0
#property indicator_style3 0
#property indicator_style4 2
#property indicator_style5 2
#property indicator_style6 0
#property indicator_style7 0
#property indicator_style8 0
//-----------------------------------
extern int bars_back = 240;
extern int fma = 12;
extern int sma = 26;
extern int sigma = 9;
extern double fib_band = 0.618;

extern int m = 3;
extern int i = 0;
extern double kstd = 3.618;

//-----------------------
double fx[], sqh[], sql[], stdh[], stdl[], stochdata[],stochdata2[], stochsdata[];
double ai[10,10], b[10], x[10], sx[20];
double sum;
int    ip, p, n, f;
double qq, mm, tt;
int    ii, jj, kk, ll, nn;
double sq, std;
//*******************************************
int init()
{
   IndicatorShortName("COGMACD: Mod by Brooky-Indicators.com");
   
   SetIndexBuffer(0, fx);SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(1, sqh);
   SetIndexBuffer(2, sql);
   SetIndexBuffer(3, stdh);
   SetIndexBuffer(4, stdl);
   SetIndexBuffer(5, stochdata);SetIndexStyle(5, DRAW_HISTOGRAM);
   SetIndexBuffer(6, stochsdata);SetIndexStyle(6, DRAW_LINE);
   SetIndexBuffer(7, stochdata2);SetIndexStyle(7, DRAW_HISTOGRAM);
   p = MathRound(bars_back);
   
   nn = m + 1;

   return(0);
}
//----------------------------------------------------------
int deinit()
{
   
}
//**********************************************************************************************
int start()
{
   int mi;
//-------------------------------------------------------------------------------------------
   
   p = bars_back; 
   sx[1] = p + 1;
   SetIndexDrawBegin(0, Bars - p - 1);
   SetIndexDrawBegin(1, Bars - p - 1);
   SetIndexDrawBegin(2, Bars - p - 1);
   SetIndexDrawBegin(3, Bars - p - 1);
   SetIndexDrawBegin(4, Bars - p - 1); 
//----------------------sx-------------------------------------------------------------------

     int rlimit;
     int rcounted_bars=IndicatorCounted();
  //---- check for possible errors
     if(rcounted_bars<0) return(-1);
  //---- the last counted bar will be recounted
     if(rcounted_bars>0) rcounted_bars--;
     rlimit=Bars-rcounted_bars;
  //---- main loop
     for(int ri=0; ri<rlimit; ri++)
       {
       if(iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,ri)>0)stochdata[ri]= iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,ri);
       else stochdata2[ri]= iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,ri);
       stochdata[ri]= iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,ri);//iStochastic(NULL,0,fma,sma,sigma,MODE_SMA,0,MODE_MAIN,ri);
       stochsdata[ri]= iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_SIGNAL,ri);//iStochastic(NULL,0,fma,sma,sigma,MODE_SMA,0,MODE_SIGNAL,ri);
       }


   for(mi = 1; mi <= nn * 2 - 2; mi++)
   {
      sum = 0;
      for(n = i; n <= i + p; n++)
      {
         sum += MathPow(n, mi);
      }
      sx[mi + 1] = sum;
   }  
//----------------------syx-----------
   for(mi = 1; mi <= nn; mi++)
   {
   
      sum = 0.00000;
      for(n = i; n <= i + p; n++)
      {
      
      
         if(mi == 1)
            sum += ((iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,n)+iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_SIGNAL,n))+0.0000001)/2;//rsi_period  iRSI(NULL,0,rsi_period,prICE_CLOSE,n)
         else
            sum += (((iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,n)+iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_SIGNAL,n))+0.0000001)/2) * MathPow(n, mi - 1);
      }
      b[mi] = sum;
   } 
//===============Matrix=======================================================================================================
   for(jj = 1; jj <= nn; jj++)
   {
      for(ii = 1; ii <= nn; ii++)
      {
         kk = ii + jj - 1;
         ai[ii, jj] = sx[kk];
      }
   }  
//===============Gauss========================================================================================================
   for(kk = 1; kk <= nn - 1; kk++)
   {
      ll = 0; mm = 0;
      for(ii = kk; ii <= nn; ii++)
      {
         if(MathAbs(ai[ii, kk]) > mm)
         {
            mm = MathAbs(ai[ii, kk]);
            ll = ii;
         }
      }
      if(ll == 0)
         return(0);   

      if(ll != kk)
      {
         for(jj = 1; jj <= nn; jj++)
         {
            tt = ai[kk, jj];
            ai[kk, jj] = ai[ll, jj];
            ai[ll, jj] = tt;
         }
         tt = b[kk]; b[kk] = b[ll]; b[ll] = tt;
      }  
      for(ii = kk + 1; ii <= nn; ii++)
      {
         qq = ai[ii, kk] / ai[kk, kk];
         for(jj = 1; jj <= nn; jj++)
         {
            if(jj == kk)
               ai[ii, jj] = 0;
            else
               ai[ii, jj] = ai[ii, jj] - qq * ai[kk, jj];
         }
         b[ii] = b[ii] - qq * b[kk];
      }
   }  
   x[nn] = b[nn] / ai[nn, nn];
   for(ii = nn - 1; ii >= 1; ii--)
   {
      tt = 0;
      for(jj = 1; jj <= nn - ii; jj++)
      {
         tt = tt + ai[ii, ii + jj] * x[ii + jj];
         x[ii] = (1 / ai[ii, ii]) * (b[ii] - tt);
      }
   } 
//===========================================================================================================================
   for(n = i; n <= i + p; n++)
   {
      sum = 0;
      for(kk = 1; kk <= m; kk++)
      {
         sum += x[kk + 1] * MathPow(n, kk);
      }
      fx[n] = x[1] + sum;
   } 
//-----------------------------------Std-----------------------------------------------------------------------------------
   sq = 0.0;
   for(n = i; n <= i + p; n++)
   {
      sq += MathPow((((iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_MAIN,n)+iMACD(NULL,0,fma,sma,sigma,PRICE_CLOSE,MODE_SIGNAL,n))+0.0000001)/2) - fx[n], 2);
   }
   sq = MathSqrt(sq / (p + 1)) * kstd;
   std = iStdDevOnArray(stochdata,0,p,0,MODE_SMA,i) * kstd;
   for(n = i; n <= i + p; n++)
   {
      sqh[n] = fx[n] + sq;
      sql[n] = fx[n] - sq;
      stdh[n] = fx[n] + (fib_band*std);
      stdl[n] = fx[n] - (fib_band*std);
   } 
//-------------------------------------------------------------------------------
   //ObjectMove("sstart" + sName, 0, Time[p], fx[p]);
//----------------------------------------------------------------------------------------------------------------------------
   return(0);
}
//==========================================================================================================================   

