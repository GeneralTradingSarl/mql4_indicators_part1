//+------------------------------------------------------------------+
//|                                             ang_AutoCh_HL-v1.mq4 |
//|                           Copyright © 2006, ANG3110@latchess.com |
//+------------------------------------------------------------------+

#property  copyright "ANG3110@latchess.com"
//----------------------------------
#property indicator_chart_window
//----------------------------------
extern int Hours = 24;
extern color col = Blue;
//------------------
double lr, lr0, lrp;
double sx, sy, sxy, sx2, aa, bb;
int p, sName, fs;
int f, f0, f1;
double dh, dl, dh_1, dl_1, dh_2, dl_2;
int ai_1, ai_2, bi_1, bi_2; 
double hai, lai, dhi, dli, dhm, dlm, ha0, hap, la0, lap;
double price_p1, price_p0, price_p2, price_01, price_00, price_02;
int p1, p0, p2, fp;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {
   p = Hours*60 / Period();
   if(fs == 0) 
     {
       sName = CurTime();
       fs = 1;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() 
  {
   ObjectDelete("1" + sName);
   ObjectDelete("0" + sName);
   ObjectDelete("2" + sName); 
  }
//+------------------------------------------------------------------+
//| Custom indicator start function                                  |
//+------------------------------------------------------------------+
int start() 
  {
   int i, n;
//----
   if(f == 1) 
     { 
       p1 = iBarShift(Symbol(), Period(), ObjectGet("1" + sName, OBJPROP_TIME1));
       p0 = iBarShift(Symbol(), Period(), ObjectGet("0" + sName, OBJPROP_TIME1));
       p2 = iBarShift(Symbol(), Period(), ObjectGet("2" + sName, OBJPROP_TIME1));
       if(fp == 0 && p != p1) 
         {
           p = p1; 
           fp = 1;
         }
       if(fp == 0 && p != p0) 
         {
           p = p0; 
           fp = 1;
         }
       if(fp == 0 && p != p2) 
         {
           p = p2; 
           fp = 1;
         }
     }
   sx = 0; sy = 0; sxy = 0; sx2 = 0; 
//----
   for(n = 0; n <= p; n++) 
     {
       sx += n; 
       sy += Close[n]; 
       sxy += n*Close[n]; 
       sx2 += MathPow(n, 2);
     }   
   aa = (sx*sy - (p + 1)*sxy) / (MathPow(sx, 2) - (p + 1)*sx2); 
   bb = (sy - aa*sx) / (p + 1);
//----
   for(i = 0; i <= p; i++) 
     {
       lr = bb + aa*i;
       dh = High[i] - lr; 
       dl = Low[i] - lr;
       //----
       if(i < p / 2) 
         {
           if(i == 0) 
             {
               dh_1 = 0.0; 
               dl_1 = 0.0; 
               ai_1 = i; 
               bi_1 = i;
             } 
           //----
           if(dh >= dh_1) 
             {
               dh_1 = dh; 
               ai_1 = i;
             }
           //----
           if(dl <= dl_1) 
             {
               dl_1 = dl; 
               bi_1 = i;
             }
         }  
       //----
       if(i >= p / 2) 
         {
           if(i == p / 2) 
             {
               dh_2 = 0.0; 
               dl_2 = 0.0; 
               ai_2 = i; 
               bi_2 = i;
             } 
           if(dh >= dh_2) 
             {
               dh_2 = dh; 
               ai_2 = i;
             }
           if(dl <= dl_2) 
             {
               dl_2 = dl; 
               bi_2 = i;
             }
         }
     } 
   lr0 = bb; 
   lrp = bb + aa*(i + p);
//----
   if(MathAbs(ai_1 - ai_2) > MathAbs(bi_1 - bi_2)) 
       f=1;
//----
   if(MathAbs(ai_1 - ai_2) < MathAbs(bi_1 - bi_2)) 
       f=2;
//----
   if(MathAbs(ai_1 - ai_2) == MathAbs(bi_1 - bi_2)) 
     {
       if(MathAbs(dh_1 - dh_2) < MathAbs(dl_1 - dl_2)) 
           f=1; 
       //----
       if(MathAbs(dh_1 - dh_2) >= MathAbs(dl_1 - dl_2)) 
           f=2;
     } 
//----
   if(f == 1) 
     {
       for(n = 0; n <= 20; n++) 
         { 
           f1 = 0;
           //----
           for(i = 0; i <= p; i++) 
             {
               hai = High[ai_1]*(i - ai_2) / (ai_1 - ai_2) + High[ai_2]*(i - ai_1) / 
                     (ai_2 - ai_1);  
               //----
               if(i == 0 || i == p / 2) 
                   dhm = 0.0; 
               //----
               if(High[i] - hai > dhm && i < p / 2) 
                 {
                   ai_1 = i; 
                   f1 = 1;
                 }
               //----
               if(High[i] - hai > dhm && i >= p / 2) 
                 {
                   ai_2 = i; 
                   f1 = 1;
                 } 
             }
           //----
           if(f == 0) 
               break;
         } 
       //----
       for(i = 0; i <= p; i++) 
         {
           hai = High[ai_1]*(i - ai_2) / (ai_1 - ai_2) + High[ai_2]*(i - ai_1) / 
                 (ai_2 - ai_1);  
           dli = Low[i] - hai; 
           if(i == 0) 
               dlm=0.0; 
           if(dli < dlm) 
               dlm = dli;
         }   
       ha0 = High[ai_1]*(0 - ai_2) / (ai_1 - ai_2) + High[ai_2]*(0 - ai_1) / (ai_2 - ai_1); 
       hap = High[ai_1]*(p - ai_2) / (ai_1 - ai_2) + High[ai_2]*(p - ai_1) / (ai_2 - ai_1);
       price_p1 = hap;
       price_p0 = hap + dlm / 2;
       price_p2 = hap + dlm;
       price_01 = ha0;
       price_00 = ha0 + dlm / 2;
       price_02 = ha0 + dlm;
     }
   if(f == 2) 
     {
       for(n = 0; n <= 20; n++) 
         { 
           f1 = 0;
           for(i = 0; i <= p; i++) 
             {
               lai = Low[bi_1]*(i - bi_2) / (bi_1 - bi_2) + Low[bi_2]*(i - bi_1) / 
                     (bi_2 - bi_1); 
               if(i == 0 || i == p / 2) 
                   dlm = 0.0; 
               if(Low[i] - lai < dlm && i < p / 2) 
                 {
                   bi_1 = i; 
                   f1 = 1;
                 }
               if(Low[i] - lai < dlm && i >= p / 2) 
                 {
                   bi_2 = i; 
                   f1 = 1;
                 }
             } 
           if(f == 0) 
               break;
         }
       //----
       for(i = 0; i <= p; i++) 
         {
           lai = Low[bi_1]*(i - bi_2) / (bi_1 - bi_2) + Low[bi_2]*(i - bi_1) / (bi_2 - bi_1); 
           dhi = High[i] - lai;
           if(i == 0) 
               dhm = 0.0; 
           if(dhi > dhm) 
               dhm = dhi;
         }   
       la0 = Low[bi_1]*(0 - bi_2) / (bi_1 - bi_2) + Low[bi_2]*(0 - bi_1) / (bi_2 - bi_1); 
       lap = Low[bi_1]*(p - bi_2) / (bi_1 - bi_2) + Low[bi_2]*(p - bi_1) / (bi_2 - bi_1);
       price_p1 = lap;
       price_p0 = lap + dhm / 2;
       price_p2 = lap + dhm;
       price_01 = la0;
       price_00 = la0 + dhm / 2;
       price_02 = la0 + dhm;
     }
   ObjectCreate("1" + sName, 2, 0, Time[p], price_p1, Time[0], price_01);
   ObjectCreate("0" + sName, 2, 0, Time[p], price_p0, Time[0], price_00);
   ObjectCreate("2" + sName, 2, 0, Time[p], price_p2, Time[0], price_02);
   ObjectSet("1" + sName, OBJPROP_COLOR, col);
   ObjectSet("0" + sName, OBJPROP_COLOR, col);
   ObjectSet("0" + sName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("2" + sName, OBJPROP_COLOR, col);
   ObjectSet("1" + sName, OBJPROP_TIME1, Time[p]);
   ObjectSet("1" + sName, OBJPROP_PRICE1, price_p1);
   ObjectSet("1" + sName, OBJPROP_TIME2, Time[0]);
   ObjectSet("1" + sName, OBJPROP_PRICE2, price_01);
   ObjectSet("0" + sName, OBJPROP_TIME1, Time[p]);
   ObjectSet("0" + sName, OBJPROP_PRICE1, price_p0);
   ObjectSet("0" + sName, OBJPROP_TIME2, Time[0]);
   ObjectSet("0" + sName, OBJPROP_PRICE2, price_00);
   ObjectSet("2" + sName, OBJPROP_TIME1, Time[p]);
   ObjectSet("2" + sName, OBJPROP_PRICE1, price_p2);
   ObjectSet("2" + sName, OBJPROP_TIME2, Time[0]);
   ObjectSet("2" + sName, OBJPROP_PRICE2, price_02);
   f = 1; p1 = p; p0 = p; p2 = p; fp = 0; 
   return(0);
  }
//+------------------------------------------------------------------+

