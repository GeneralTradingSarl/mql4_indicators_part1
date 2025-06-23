//+------------------------------------------------------------------+
//|                                              ang_PR (Din)-v1.mq4 |
//|                           Copyright © 2006, ANG3110@latchess.com |
//+------------------------------------------------------------------+

#property  copyright "ANG3110@latchess.com"
//---------ang_PR (Din)--------------------
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
//----
extern double hours = 24;
extern int m = 2;
extern int i = 0;
//----
double fx[];
double ai[10,10], b[10], x[10], sx[20];
double sum; 
int p, n, f, sName, fs;
double qq, mm, tt;
int ii, jj, kk, ll, nn;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {
   IndicatorShortName("at_PR (Din)");
   SetIndexStyle(0, DRAW_LINE, 0, 2);
   SetIndexBuffer(0, fx);
   if(fs == 0) 
     {
       sName = CurTime(); 
       fs = 1;
     }
   p = hours*60 / Period(); 
   nn = m + 1; 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |                                                                 |
//+------------------------------------------------------------------+
int deinit() 
  {
    ObjectDelete("pr" + sName);
  }
//+------------------------------------------------------------------+
//| Custom indicator start function                                  |
//+------------------------------------------------------------------+
int start()
  { 
   int mi;
//----
   if(f == 1) 
     { 
       p = iBarShift(Symbol(), Period(), ObjectGet("pr" + sName, OBJPROP_TIME1));
     } 
   sx[1] = p + 1;
   SetIndexDrawBegin(0, Bars - p - 1); 
//---- sx
   for(mi = 1; mi <= nn*2 - 2; mi++) 
     {
       sum = 0; 
       //----
       for(n = i; n <= i + p; n++) 
         {
           sum += MathPow(n, mi);
         } 
       sx[mi+1] = sum;
     }  
//---- syx
   for(mi = 1; mi <= nn; mi++) 
     {
       sum=0.00000; 
       //----
       for(n = i; n <= i + p; n++) 
         {
           if(mi == 1) 
               sum += Close[n]; 
           else 
               sum += Close[n]*MathPow(n, mi - 1);
         } 
       b[mi] = sum;
     } 
//---- Matrix
   for(jj = 1; jj <= nn; jj++) 
     {
       for(ii = 1; ii <= nn; ii++) 
         {
           kk = ii + jj - 1; 
           ai[ii,jj] = sx[kk];
         }
     }  
//---- Gauss
   for(kk = 1; kk <= nn - 1; kk++) 
     {
       ll = 0; mm = 0; 
       //----
       for(ii = kk; ii <= nn; ii++) 
         {
           if(MathAbs(ai[ii,kk]) > mm) 
             {
               mm = MathAbs(ai[ii,kk]); 
               ll = ii;
             }
         } 
       //----
       if(ll == 0) 
           return(0);   
       //----
       if(ll != kk) 
         {
           for(jj = 1; jj <= nn; jj++) 
             {
               tt = ai[kk,jj]; 
               ai[kk,jj] = ai[ll,jj]; 
               ai[ll,jj] = tt;
             } 
           tt = b[kk]; 
           b[kk] = b[ll]; 
           b[ll] = tt;
         }  
       //----
       for(ii = kk + 1; ii <= nn; ii++) 
         {
           qq = ai[ii,kk] / ai[kk,kk]; 
           //----
           for(jj = 1; jj <= nn; jj++) 
             {
               if(jj==kk) 
                   ai[ii,jj]=0; 
               else 
                   ai[ii,jj]=ai[ii,jj]-qq*ai[kk,jj];
             } 
           b[ii]=b[ii]-qq*b[kk];
         }
     }  
   x[nn] = b[nn] / ai[nn,nn]; 
   //----
   for(ii = nn - 1; ii >= 1; ii--) 
     {
       tt = 0; 
       //----
       for(jj = 1; jj <= nn - ii; jj++) 
         {
           tt = tt + ai[ii,ii+jj]*x[ii+jj]; 
           x[ii] = (1 / ai[ii,ii])*(b[ii] - tt);
         }
     } 
   //----
   for(n = i; n <= i + p; n++) 
     {
       sum = 0; 
       for(kk = 1; kk <= m; kk++) 
         {
           sum += x[kk+1]*MathPow(n,kk);
         } 
       fx[n]=x[1]+sum;
     } 
   ObjectCreate("pr" + sName, 22, 0, Time[p], fx[p]);
   ObjectSet("pr" + sName, 14, 159);
   ObjectSet("pr" + sName, OBJPROP_TIME1, Time[p]);
   ObjectSet("pr" + sName, OBJPROP_PRICE1, fx[p]);
   f = 1;
//----
   return(0);
  }
//+------------------------------------------------------------------+


