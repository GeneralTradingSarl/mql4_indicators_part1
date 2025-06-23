//+------------------------------------------------------------------+
//|                                                         CADX.mq4 |
//|                      Copyright © 2005, FXTEAM                    |
//|               versiyon.1.1                                       |
//+------------------------------------------------------------------+
#property copyright "FXTEAM"
#property link      "FXTEAM Turkey"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 YellowGreen
#property indicator_color2 Wheat
#property indicator_color3 White
//---- input parameters
extern int DMIPeriod=14;
extern int Smooth=10;
//---- buffers
double PlusSdiBuffer[];
double MinusSdiBuffer[];
double ADXs[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
   SetIndexBuffer(0,PlusSdiBuffer);
   SetIndexBuffer(1,MinusSdiBuffer);
   SetIndexBuffer(2,ADXs);
   IndicatorShortName("FXDI("+DMIPeriod+")");
//----
   SetIndexLabel(0,"+DI");
   SetIndexLabel(1,"-DI");
   SetIndexLabel(2,"ADX");
//----
   SetIndexDrawBegin(0,DMIPeriod);
   SetIndexDrawBegin(1,DMIPeriod);
   SetIndexDrawBegin(2,DMIPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Directional Movement Index                               |
//+------------------------------------------------------------------+
int start()
  {
   double pdm,mdm,tr,xx,yy,ss,mm;
   double price_high,price_low;
   double sabit,toplam,MA,PREP,PREN,PRETR;
   double PD;
   double ND,Buff;
   double ADX,PREADX;
   int    starti,i,j,n,counted_bars=IndicatorCounted();
//----
   if(Bars<=DMIPeriod) return(0);
//---- initial zero
   for(i=0;i<=Bars-2;i++)
     {
      PlusSdiBuffer[i]=0.0;
      MinusSdiBuffer[i]=0.0;
      ADXs[i]=0.0;
     }
   i=Bars;
//----
   PREP=0.0;
   PREN=0.0;
   PRETR=0.0;
   ADX=0.0;
   PREADX=0.0;
   i=Bars-2;
//----
   while(i>=0)
     {
      if(High[i]>High[i+1] && (High[i]-High[i+1])>(Low[i+1]-Low[i]))
        {
         xx=High[i]-High[i+1];
        }
      else
        {
         xx=0.0;
        }
      PD=(((DMIPeriod-1.0)*PREP)+xx)/(DMIPeriod);
//----
      if(Low[i]<Low[i+1] && (Low[i+1]-Low[i])>(High[i]-High[i+1]))
        {
         xx=Low[i+1]-Low[i];
        }
      else
        {
        xx=0.0;}
      ND=(((DMIPeriod-1.0)*PREN)+xx)/(DMIPeriod);
      //***
      Buff=MathAbs(PD-ND);
        if (Buff==0) 
        {
         ADX=(((Smooth-1.0)*PREADX))/Smooth;
        }
        else{
        ADX=(((Smooth-1.0)*PREADX)+  (MathAbs(PD-ND)/(PD+ND)))/Smooth;}
      //**
      PREN=ND;
      PREP=PD;
      PREADX=ADX;
//----
      double num1=MathAbs(price_high-price_low);
      double num2=MathAbs(price_high-Close[i+1]);
      double num3=MathAbs(Close[i+1]-price_low);
//----
      tr=MathMax(num1,num2);
      tr=MathMax(tr,num3);
//----
      tr=(((DMIPeriod-1.0)*PRETR)+tr)/DMIPeriod;
      PRETR=tr;
      PlusSdiBuffer[i]=100000*(PD/tr);
      MinusSdiBuffer[i]=100000*(ND/tr);
      ADXs[i]=100*ADX;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+