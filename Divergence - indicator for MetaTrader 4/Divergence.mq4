//+------------------------------------------------------------------+
//|                                                   Divergence.mq4 |
//|                                    Copyright © 2005, Pavel Kulko |
//|                                                  polk@alba.dp.ua |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Pavel Kulko"
#property link      "polk@alba.dp.ua"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_color1 Aqua
#property indicator_color2 Red
//----
extern int ind=1;        //MACD=1,  RSI=2,  DMI=3,  Mom=4
extern int pds=10;       //indicator periods
extern int f=1;          //price field: Close=1, High/Low=2
extern double Ch=0;      //peak/trough depth minimum (0-1)
extern int shift=0;      //shift signals back to match divergences
extern int MaxBars=1000;
//----
double DivUpBuffer[],DivDnBuffer[];
double R1[],R2[],y[],xd[],xu[];
double fCh;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {
   IndicatorBuffers(7);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexBuffer(0,DivUpBuffer);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexBuffer(1,DivDnBuffer);
   SetIndexBuffer(2,R1);
   SetIndexBuffer(3,R2);
   SetIndexBuffer(4,y);
   SetIndexBuffer(5,xd);
   SetIndexBuffer(6,xu);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<MaxBars)
     {
      Print("Not enough bars => Reduce MaxBars. Exiting from start()");
      return(0);
     }
   int CNmb1,CNmb2,CNmb3,CNmb4;
   double Pkx1,Pkx2,Trx1,Trx2,Pky1,Pky2,Try1,Try2;
   bool Trx,Pkx,Try,Pky;
   fCh=Ch/100.0;
   int    counted_bars=IndicatorCounted();
   int limit=Bars-counted_bars-1;
   if(limit>MaxBars) limit=MaxBars;
   for(int i=limit; i>=0; i--)
     {
      DivUpBuffer[i]=Low[i];
      DivDnBuffer[i]=Low[i];
      switch(ind)
        {
         case 1: y[i]=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i); break;
         case 2: y[i]=iRSI(NULL,0,pds,PRICE_CLOSE,i); break;
         case 3: y[i]=iADX(NULL,0,pds,PRICE_CLOSE,MODE_MAIN,i); break;
         default : y[i]=iMomentum(NULL,0,pds,PRICE_CLOSE,i); break;
        }
      if(f==1) xu[i]=Close[i];
      else xu[i]=High[i];
      if(f==1) xd[i]=Close[i];
      else xd[i]=Low[i];
     }
   for(i=limit; i>=2; i--)
     {
      CNmb1=0; CNmb2=0; CNmb3=0; CNmb4=0;
      for(int j=i; j<MaxBars; j++)
        {
         Pkx=(xu[j]<xu[j-1]) && (xu[j-1]>xu[j-2]) && (xu[j-1]>=(xu[j]+xu[j-2])/2.0*(1.0+fCh));
         if(Pkx) CNmb1++;
         if(Pkx && CNmb1==1) Pkx1=xu[j-1];
         if(Pkx && CNmb1==2) Pkx2=xu[j-1];
         Trx=(xd[j]>xd[j-1]) && (xd[j-1]<xd[j-2]) && (xd[j-1]<=(xd[j]+xd[j-2])/2.0*(1.0-fCh));
         if(Trx) CNmb2++;
         if(Trx && CNmb2==1) Trx1=xd[j-1];
         if(Trx && CNmb2==2) Trx2=xd[j-1];
         Pky=(y[j]<y[j-1]) && (y[j-1]>y[j-2]) && (y[j-1]>=(y[j]+y[j-2])/2.0*(1.0+fCh));
         if(Pky) CNmb3++;
         if(Pky && CNmb3==1) Pky1=y[j-1];
         if(Pky && CNmb3==2) Pky2=y[j-1];
         Try=(y[j]>y[j-1]) && (y[j-1]<y[j-2]) && (y[j-1]<=(y[j]+y[j-2])/2.0*(1.0-fCh));
         if(Try) CNmb4++;
         if(Try && CNmb4==1) Try1=y[j-1];
         if(Try && CNmb4==2) Try2=y[j-1];
         if(CNmb1>=2 && CNmb2>=2 && CNmb3>=2 && CNmb4>=2) break;
        }
      Pkx=(xu[i] < xu[i-1]) && (xu[i-1] > xu[i-2]) && (xu[i-1]>=(xu[i]+xu[i-2])/2.0*(1.0+fCh));
      Trx=(xd[i] > xd[i-1]) && (xd[i-1] < xd[i-2]) && (xd[i-1]<=(xd[i]+xd[i-2])/2.0*(1.0-fCh));
      Pky=(y[i] < y[i-1]) && (y[i-1] > y[i-2]) && (y[i-1]>=(y[i]+y[i-2])/2.0*(1.0+fCh));
      Try=(y[i] > y[i-1]) && (y[i-1] < y[i-2]) && (y[i-1]<=(y[i]+y[i-2])/2.0*(1.0-fCh));
      R1[i]=0;
      if(Trx && Try && Trx1<Trx2 && Try1>Try2) R1[i]=1;
      R2[i]=0;
      if(Pkx && Pky && Pkx1>Pkx2 && Pky1<Pky2) R2[i]=1;
      if(R1[i+shift]-R2[i+shift]>0)
        {
         DivUpBuffer[i+shift]=High[i];
         DivDnBuffer[i+shift]=Low[i];
        }
      if(R1[i+shift]-R2[i+shift]<0)
        {
         DivDnBuffer[i]=High[i];
         DivUpBuffer[i]=Low[i];
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
