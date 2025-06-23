//+------------------------------------------------------------------+
//|                                                    channel20.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+

enum MODE_A{mode_high=1,mode_low};
double Channel20(const int  PeriodeChannel,int debut,MODE_A highlow) export
  {
   int i,j;
   i=debut;
   double channel;


   if(highlow==2)
     {
      channel=Low[debut+1];

      for(j=i+1; j<i+PeriodeChannel+1; j++)
        {
         double pb=Low[j];
         if(pb<channel)
            channel=pb;
        }
     }
   else if(highlow==1)
     {
      channel=High[debut+1];

      for(j=i+1; j<i+PeriodeChannel+1; j++)
        {
         double ph=High[j];
         if(ph>channel)
            channel=ph;
        }
     }
     return(channel);
   }
   
   
//+------------------------------------------------------------------+
