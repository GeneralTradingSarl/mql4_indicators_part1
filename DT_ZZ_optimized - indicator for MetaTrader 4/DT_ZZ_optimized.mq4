//+------------------------------------------------------------------+
//|                                                        DT_ZZ.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, klot."
#property link      "klot@mail.ru"
// optimized by Rosh

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrGreen
#property indicator_color2 clrBlue
#property indicator_color3 clrRed
//---- indicator parameters
extern int ExtDepth=12;
extern int calculateLevel=2;
//---- indicator buffers
double zzL[];
double zzH[];
double zz[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//  IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexStyle(2,DRAW_ARROW);
//---
   SetIndexArrow(1,159);
   SetIndexArrow(2,159);

//---- indicator buffers mapping
   SetIndexBuffer(0,zz);
   SetIndexBuffer(1,zzH);
   SetIndexBuffer(2,zzL);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);

//---- indicator short name
   IndicatorShortName("DT_ZZ("+ExtDepth+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i,shift,pos,lasthighpos,lastlowpos,curhighpos,curlowpos;
   double curlow,curhigh,lasthigh,lastlow;
   double min,max;
   int counted_bars=IndicatorCounted();
   if(counted_bars==0)
     {
      ArrayInitialize(zz,0.0);
      ArrayInitialize(zzL,0.0);
      ArrayInitialize(zzH,0.0);

      lasthighpos=Bars; lastlowpos=Bars;
      lastlow=Low[Bars-1];lasthigh=High[Bars-1];
      Print("limit=",Bars-ExtDepth);
      for(shift=Bars-ExtDepth; shift>=0; shift--)
        {
         curlowpos=Lowest(NULL,0,MODE_LOW,ExtDepth,shift);
         curlow=Low[curlowpos];
         curhighpos=Highest(NULL,0,MODE_HIGH,ExtDepth,shift);
         curhigh=High[curhighpos];
         //------------------------------------------------
         if(curlow>=lastlow) { lastlow=curlow; }
         else
           {
            //идем вниз
            if(lasthighpos>curlowpos)
              {
               zzL[curlowpos]=curlow;
               ///*
               min=100000; pos=lasthighpos;
               for(i=lasthighpos-1; i>=curlowpos; i--)
                 {
                  if(zzL[i]==0.0) continue;
                  if(zzL[i]<min) { min=zzL[i]; pos=i; }
                  zz[i]=0.0;
                 }
               zz[pos]=min;
               //*/
              }
            lastlowpos=curlowpos;
            lastlow=curlow;
           }
         //--- high
         if(curhigh<=lasthigh) { lasthigh=curhigh;}
         else
           {
            // идем вверх
            if(lastlowpos>curhighpos)
              {
               zzH[curhighpos]=curhigh;
               ///*
               max=-100000; pos=lastlowpos;
               for(i=lastlowpos-1; i>=curhighpos; i--)
                 {
                  if(zzH[i]==0.0) continue;
                  if(zzH[i]>max) { max=zzH[i]; pos=i; }
                  zz[i]=0.0;
                 }
               zz[pos]=max;
               //*/     
              }
            lasthighpos=curhighpos;
            lasthigh=curhigh;
           }
         zz[0]=Close[0];
        }
      //----------------------------------------------------------------------
     }
   else
     {
      int pos2;
      i=0;
      while(pos2<calculateLevel && i<Bars-1)
        {
         if(zz[i]!=0 && (zzH[i]!=0 || zzL[i]!=0)) pos2++;
         i++;
        }
      pos2=i-1;
      for(i=pos2-1;i>=0;i--)
        {
         zzH[i]=0;
         zzL[i]=0;
         zz[i]=0;
        }
      if(zzH[pos2]!=0)
        {
         lasthighpos=pos2;
         lasthigh=High[pos2];
         lastlowpos=Lowest(NULL,0,MODE_LOW,ExtDepth,pos2);
         lastlow=Low[lastlowpos];
        }
      else
        {
         lastlowpos=pos2;
         lastlow=Low[pos2];
         lasthighpos=Highest(NULL,0,MODE_HIGH,ExtDepth,pos2);
         lasthigh=High[lasthighpos];
        }
      //------------------------- опсчитаем заново   
      Print("limit=",pos2-1);
      for(shift=pos2-1; shift>=0; shift--)
        {
         curlowpos=Lowest(NULL,0,MODE_LOW,ExtDepth,shift);
         curlow=Low[curlowpos];
         curhighpos=Highest(NULL,0,MODE_HIGH,ExtDepth,shift);
         curhigh=High[curhighpos];
         //------------------------------------------------
         if(curlow>=lastlow) { lastlow=curlow; }
         else
           {
            //идем вниз
            if(lasthighpos>curlowpos)
              {
               zzL[curlowpos]=curlow;
               ///*
               min=100000; pos=lasthighpos;
               for(i=lasthighpos-1; i>=curlowpos; i--)
                 {
                  if(zzL[i]==0.0) continue;
                  if(zzL[i]<min) { min=zzL[i]; pos=i; }
                  zz[i]=0.0;
                 }
               zz[pos]=min;
               //*/
              }
            lastlowpos=curlowpos;
            lastlow=curlow;
           }
         //--- high
         if(curhigh<=lasthigh) { lasthigh=curhigh;}
         else
           {
            // идем вверх
            if(lastlowpos>curhighpos)
              {
               zzH[curhighpos]=curhigh;
               ///*
               max=-100000; pos=lastlowpos;
               for(i=lastlowpos-1; i>=curhighpos; i--)
                 {
                  if(zzH[i]==0.0) continue;
                  if(zzH[i]>max) { max=zzH[i]; pos=i; }
                  zz[i]=0.0;
                 }
               zz[pos]=max;
               //*/     
              }
            lasthighpos=curhighpos;
            lasthigh=curhigh;
           }

        }
      //------------------------- опсчитаем заново         
      zz[0]=Close[0];
     }
   return(0);
  }
//+------------------------------------------------------------------+
