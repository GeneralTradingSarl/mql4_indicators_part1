//+------------------------------------------------------------------+
//|                        Adaptosctry.mq4 - let it be               |
//|                         Copyright © Telemah                      |
//|                        mailto:savemih@mail.ru                    |
//+------------------------------------------------------------------+
#property copyright "Copyright © Telemah"
#property link      "mailto:savemih@mail.ru"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 DarkTurquoise
#property indicator_color2 Red
#property indicator_color3 Yellow
//----
extern int CountBars=1000;
//extern double Po2=40; //Для вариантов с количеством движения
//extern double Po1=120;
extern int nExtr1=3;
extern int nExtr2=6;
//extern int nFract1=2;
//extern int nFract2=6;
//extern int stochD=3; //Для стохастика
//extern int stochslow=3;
//---- buffers
double Buf[];
double Buf1[];
double Buf2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,Buf);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Buf1);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Buf2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Ind                                                             |
//+------------------------------------------------------------------+
int start()
  {
   SetIndexDrawBegin(0,Bars-CountBars+101);
   SetIndexDrawBegin(1,Bars-CountBars+101);
   SetIndexDrawBegin(2,Bars-CountBars+101);
   int i,i1,i2,counted_bars=IndicatorCounted();
   double con1,con2,Pe1,Pe2;
   int iFlow[50],iFhigh[50],iEx[50],iExF[50],n,nl,nh,nf;
   double BufCus[1000],BufFUP[1000],BufFLO[1000],pEx[50],pF[50],
   pFhigh[50],pFlow[50],Fhigh[50],Flow[50],pEXhigh[50],pEXlow[50];
//----
   if(CountBars<=101) return(0);
//---- initial zero
   if(counted_bars<101)
     {
      for(i=1;i<=0;i++) Buf[CountBars-i]=0.0;
      for(i=1;i<=0;i++) Buf1[CountBars-i]=0.0;
      for(i=1;i<=0;i++) Buf2[CountBars-i]=0.0;
     }
//----
   i=CountBars-101-1;
   //   if(counted_bars>=101) i=Bars-counted_bars-1;
   while(i>=0)
     {
      //++++++++++++++++++++++++++++++++++++++++++++++
      //Для вариантов с количеством движения
/*
for (i1=1;i1<=100;i1++)
{
con1+=MathAbs(Close[i+i1]-Open[i+i1]);
if (con1>=Po1*Point) {Pe1=i1;break;} 
}
for (i2=1;i2<=100;i2++)
{
con2+=MathAbs(Close[i+i2]-Open[i+i2]);
if (con2>=Po2*Point) {Pe2=i2;break;} 
}
con1=0;
con2=0;
*/
      //+++++++++++++++++++++++++++++++++++++++++
      //Для вариантов с экстремумами
      BufCus[i]=iCustom(NULL,0,"FATL",CountBars,0,i);
      for(i1=1;i1<=100;i1++)
        {
         if ((BufCus[i+i1]>BufCus[i+i1+1] && BufCus[i+i1+1]<BufCus[i+i1+2]) ||
         (BufCus[i+i1]<BufCus[i+i1+1] && BufCus[i+i1+1]>BufCus[i+i1+2]))
           {
            n=n+1;iEx[n]=i1;pEx[n]=Close[i1];
            if (n==nExtr1) {Pe1=iEx[n];}
            if (n==nExtr2) {Pe2=iEx[n];}
           }
/*
+++++++++++++++++++++++++++++++++++++++++++++++
if (BufCus[i+i1]>BufCus[i+i1+1] && BufCus[i+i1+1]<BufCus[i+i1+2]) 
{nl=nl+1;Flow[nl]=BufCus[i+i1+1];iFlow[nl]=i1;
pEXlow[nl]=Close[i1];}

if (BufCus[i+i1]<BufCus[i+i1+1] && BufCus[i+i1+1]>BufCus[i+i1+2])  
{nh=nh+1;Fhigh[nh]=BufCus[i+i1+1];iFhigh[nh]=i1;
pEXhigh[nh]=Close[i1];}
+++++++++++++++++++++++++++++++++++++++++++++++
*/
        }
      n=0;
/*
+++++
nl=0;
nh=0;	
+++++
*/
      //++++++++++++++++++++++++++++++++++++++++
      //Варианты с количеством фракталов
/*
BufFUP[i]=iFractals(NULL,0,MODE_UPPER,i);
BufFLO[i]=iFractals(NULL,0,MODE_LOWER,i);
for (i1=3;i1<=103;i1++)
{
if (BufFUP[i+i1]!=0 || BufFLO[i+i1]!=0)
nf=nf+1;iExF[nf]=i1;pF[nf]=Close[i1]
if (nf==nFract1) {Pe1=iExF[nf];}
if (nf==nFract2) {Pe2=iExF[nf];}
}
nf=0;
*/
      //++++++++++++++++++++++++++++++++++++++++

      //Buf[i]=iCCI(NULL,0,Pe1,PRICE_CLOSE,i);
      //Buf1[i]=iCCI(NULL,0,Pe2,PRICE_CLOSE,i);
        Buf[i]=iRSI(NULL,0,Pe1,PRICE_CLOSE,i);
        Buf1[i]=iRSI(NULL,0,Pe2,PRICE_CLOSE,i);
      //Buf[i]=iStdDev(NULL,0,Pe1,MODE_SMA,0,PRICE_CLOSE,i);
      //Buf1[i]=iStdDev(NULL,0,Pe2,MODE_SMA,0,PRICE_CLOSE,i);
      //Buf[i]=iADX(NULL,0,Pe1,PRICE_CLOSE,MODE_MAIN,i);
      //Buf1[i]=iADX(NULL,0,Pe2,PRICE_CLOSE,MODE_MAIN,i);
      //Buf[i]=iStochastic(NULL,0,Pe1,stochD,stochslow,MODE_SMA,PRICE_CLOSE,MODE_MAIN,i);
      //Buf1[i]=iStochastic(NULL,0,Pe2,stochD,stochslow,MODE_SMA,PRICE_CLOSE,MODE_MAIN,i);
      //Buf[i]=iWPR(NULL,0,Pe1,i);
      //Buf1[i]=iWPR(NULL,0,Pe2,i);
      //Buf[i]=iForce(NULL,0,Pe1,MODE_SMA,PRICE_CLOSE,i);
      //Buf1[i]=iForce(NULL,0,Pe2,MODE_SMA,PRICE_CLOSE,i);
      //Buf[i]=iWPR(NULL,0,Pe1,i);
      //Buf1[i]=iWPR(NULL,0,Pe2,i);
      //Buf[i]=iRVI(NULL,0,Pe1,MODE_MAIN,i);
      //Buf1[i]=iRVI(NULL,0,Pe2,MODE_MAIN,i);
      //Buf[i]=iDeMarker(NULL,0,Pe1,i);
      //Buf1[i]=iDeMarker(NULL,0,Pe2,i);
      //Buf[i]=iMFI(NULL,0,Pe1,i);
      //Buf1[i]=iMFI(NULL,0,Pe2,i);
      //Buf[i]=iCustom(NULL,0,"J_TPO",Pe1,CountBars,0,i);
      //Buf1[i]=iCustom(NULL,0,"J_TPO",Pe2,CountBars,0,i);
      //Buf[i]=iCustom(NULL,0,"rsx",Pe1,0,i);
      //Buf1[i]=iCustom(NULL,0,"rsx",Pe2,0,i);
      Buf2[i]=(Buf[i]+Buf1[i])/2;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+