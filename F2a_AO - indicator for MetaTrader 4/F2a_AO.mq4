//+------------------------------------------------------------------+
//|                                                       F2a_AO.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
#property  link      "Alert by GOEN"

//+------------+-----------------------------------------------------+
//  Bookkeeper: Подправил немного по своему
//  Необходимо наличие NavelEMA.mq4
//  Presence NavelEMA.mq4 is necessary 
//+------------------------------------------------------------------+
#property  indicator_chart_window
#property  indicator_buffers 2
#property  indicator_color1  Lime
#property  indicator_color2  Red
extern int  MA_Filtr=3;
extern int  MA_Fast=13;
extern int  MA_Slow=144;
extern bool WithAlert=false;
extern bool WithComment=true;
double up_buffer[];
double dn_buffer[];
double ind_buffer[];
datetime lastalert=0, lastcomment=0;
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
  }
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_ARROW);//
   SetIndexStyle(1,DRAW_ARROW);//
   SetIndexArrow(0,233); 
   SetIndexArrow(1,234); 
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexDrawBegin(0,MA_Slow+2);
   SetIndexDrawBegin(1,MA_Slow+2);
   SetIndexBuffer(0,up_buffer);
   SetIndexBuffer(1,dn_buffer);
   SetIndexBuffer(2,ind_buffer);
   return(0);
  }
//+------------------------------------------------------------------+
//| Awesome Oscillator                                               |
//+------------------------------------------------------------------+
int start()
  {
   int    limit;
   int    counted_bars=IndicatorCounted();
   double prev, current;
   static datetime lastalert;
   if(counted_bars<0) return(-1);
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=3;
   for(int i=0; i<limit; i++)
      ind_buffer[i]=iCustom(NULL,0,"NavelEMA",MA_Fast,0,0,i)-
                    iCustom(NULL,0,"NavelEMA",MA_Slow,0,0,i);
   for(i=limit-1; i>=0; i--)
     {
      current=iCustom(NULL,0,"NavelEMA",MA_Filtr,0,0,i);
      prev=iCustom(NULL,0,"NavelEMA",MA_Filtr,0,0,i+1);
      if(ind_buffer[i]>ind_buffer[i+1] && current>=prev &&
         ind_buffer[i+1]<=ind_buffer[i+2])
            up_buffer[i]=Low[i]-Point*10;
      else up_buffer[i]=0.0;
      if(ind_buffer[i]<ind_buffer[i+1] && current<=prev &&
         ind_buffer[i+1]>=ind_buffer[i+2])
            dn_buffer[i]=High[i]+Point*10;
      else dn_buffer[i]=0.0;
     }
   if(WithAlert==true && lastalert!=Time[0])
   { 
      if (up_buffer[0]>Point)
      {  
         Alert("Buy " +Symbol()+"_"+Period()+" "+
               " "+DoubleToStr(MarketInfo(Symbol(),MODE_ASK),Digits)+
               " "+TimeToStr(TimeCurrent(),TIME_MINUTES));
         lastalert=Time[0];
      }
      if (dn_buffer[0]>Point)
      {  
         Alert("Sell " +Symbol()+"_"+Period()+
               " "+DoubleToStr(MarketInfo(Symbol(),MODE_BID),Digits)+
               " "+TimeToStr(TimeCurrent(),TIME_MINUTES));
         lastalert=Time[0];
      }
   }
   if(WithComment==true && lastcomment!=Time[0])
   { 
      if (up_buffer[0]>Point)
      {  
         lastcomment=Time[0];
         Comment("Buy ",Symbol(),"_",Period()," ",
               " "+DoubleToStr(Close[0],Digits));
      }
      if (dn_buffer[0]>Point)
      {  
         lastcomment=Time[0];
         Comment("Sell ",Symbol(),"_",Period(),
               " "+DoubleToStr(Close[0],Digits));
      }
   }
   return(0);
  }
//+------------------------------------------------------------------+