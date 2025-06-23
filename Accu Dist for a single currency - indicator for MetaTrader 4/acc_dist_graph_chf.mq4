
#property copyright "Copyright © 2009, sHrung."
#property link      "http://www.something.com/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Orange

//---- input parameters
extern int MomPeriod=1000;
//---- buffers
//--- currencies 
double CHF[];

//--- 
double ac_usdchf[];
double ac_eurchf[], ac_chfjpy[];
double ac_gbpchf[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   //---- additional buffers used for counting.
  IndicatorBuffers(5);


//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,CHF);
   SetIndexBuffer(1,ac_usdchf);
   SetIndexBuffer(2,ac_gbpchf);
   SetIndexBuffer(3,ac_chfjpy);
   SetIndexBuffer(4,ac_eurchf);
   
   
   
//---- name for DataWindow and indicator subwindow label
   short_name="Accu/Dist Graph CHF ("+MomPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"CHF");
//----
   SetIndexDrawBegin(0,MomPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Four legs                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
   int a, b, c, d, e, f, g, h, ii, j;
//----
   if(Bars<=MomPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=MomPeriod;i++) CHF[Bars-i]=0.0;
//----

 
   int limid=Bars-counted_bars;
   if(counted_bars>1) limid++;
   for(d=0; d<MomPeriod; d++)
   ac_usdchf[d] = iAD("USDCHF",0,d);
     
   int limig=Bars-counted_bars;
   if(counted_bars>1) limig++;
   for(g=0; g<MomPeriod; g++)
   ac_eurchf[g] = iAD("EURCHF",0,g);
   
  
   int limii=Bars-counted_bars;
   if(counted_bars>1) limii++;
   for(ii=0; ii<MomPeriod; ii++)
   ac_chfjpy[ii] = iAD("CHFJPY",0,ii);
    
   int limij=Bars-counted_bars;
   if(counted_bars>1) limij++;
   for(j=0; j<MomPeriod; j++)
   ac_gbpchf[j] = iAD("GBPCHF",0,j);

//----
//----
   i=Bars-MomPeriod-1;
   if(counted_bars>=MomPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
CHF[i] =  ac_chfjpy[i] - ac_usdchf[i] - ac_eurchf[i] - ac_gbpchf[i];

    i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+