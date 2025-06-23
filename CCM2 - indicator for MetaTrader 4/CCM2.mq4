//+------------------------------------------------------------------+
//| CCM2.mq4                                                         |
//| Ramdass - Conversion only                                        |
//+------------------------------------------------------------------+
#property  copyright "Author := Keny"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 SteelBlue
#property indicator_color2 Green
#property indicator_color3 Red
//---- input parameters
extern int n=10;
extern int len=9;
extern double StdUp=0.5;
extern double StdDown=-0.5;
extern int CountBars=200;
//---- buffers
double SigL[];
double Up[];
double Dw[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(3);
   SetIndexBuffer(0,SigL);
   SetIndexBuffer(1,Up);
   SetIndexBuffer(2,Dw);
   SetIndexStyle(0,DRAW_LINE,0,1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| CCM + Digi                                                       |
//+------------------------------------------------------------------+
int start()
  {
   if (CountBars>=Bars) CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars+39);
   SetIndexDrawBegin(1,Bars-CountBars+39);
   SetIndexDrawBegin(2,Bars-CountBars+39);
   int shift,i,i2,cnt,len1,k;
   int counted_bars=IndicatorCounted();
   double value1,value3,M1,M2,M3,Hi1,Lo1,price,code;
   double b1,b2,u1,u2,l1,l2,V0,V1,V2,V3;
   double xOC,xHMOC,xMOCL,EMA0,EMAcode,cci;
   double code1[61],OC[61],HMOC[61],MOCL[61],MAxOC[61],MAxHMOC[61],MAxMOCL[61];
//----
   if(Bars<=60) return(0);
   len1=len;
   if (len1>60) len1=60;
//---- initial zero
   if(counted_bars<60)
     {
      for(i=1;i<=0;i++) SigL[CountBars-i]=0.0;
      for(i=1;i<=0;i++) Up[CountBars-i]=0.0;
      for(i=1;i<=0;i++) Dw[CountBars-i]=0.0;
     }
//----
   shift=CountBars-1;
   while(shift>=0)
     {
      for(i=len1-1; i>=1; i--)
        { //переписываем массивы - для боллинджера
         OC[i]=OC[i-1];
         HMOC[i]=HMOC[i-1];
         MOCL[i]=MOCL[i-1];
         MAxOC[i]=MAxOC[i-1];
         MAxHMOC[i]=MAxHMOC[i-1];
         MAxMOCL[i]=MAxMOCL[i-1];
        }
      for(i=38; i>=1; i--)
        {
         code1[i]=code1[i-1];
        }
      EMA0=EMAcode;
      OC[0]=MathAbs(Open[shift]-Close[shift]);
      HMOC[0]=High[0]-MathMax(Open[shift],Close[shift]);
      MOCL[0]=MathMin(Open[shift],Close[shift])-Low[shift];
      MAxOC[0]=(MAxOC[1]-OC[len1-1])+OC[0];
      MAxHMOC[0]=MAxHMOC[1]-HMOC[len-1]+HMOC[0];
      MAxMOCL[0]=MAxMOCL[1]-MOCL[len1-1]+MOCL[0];
      xOC=MAxOC[0]/len1;
      xHMOC=MAxHMOC[0]/len1;
      xMOCL=MAxMOCL[0]/len1;
      V1=0;
      V2=0;
      V3=0;
      for(i=0; i<=len1-1; i++)
        {
         V0=OC[i]-xOC;
         V0=V0*V0;
         V1=V1+V0;
         V0=HMOC[i]-xHMOC;
         V0=V0*V0;
         V2=V2+V0;
         V0=MOCL[i]-xMOCL;
         V0=V0*V0;
         V3=V3+V0;
        }
      V1=V1/len1;
      V1=MathSqrt(V1);
      V2=V2/len1;
      V2=MathSqrt(V2);
      V3=V3/len1;
      V3=MathSqrt(V3);
      b1=xOC+StdDown*V1; //b1,b2-BB для тел
      b2=xOC+StdUp*V1;
      u1=xHMOC+StdDown*V2;//u1,u2-BB для верхней тени
      u2=xHMOC+StdUp*V2;
      l1=xMOCL+StdDown*V3;//l1,l2-BB для нижней тени
      l2=xMOCL+StdUp*V3;
      code1[0]=0.0;
      for(i=0; i<=n-1; i++) //кодируем свечу
        {
         Hi1=High[shift]; Lo1=Low[shift];
         for(k=shift; k<=shift+n-1; k++)
           {
            price=High[k];
            if(Hi1<=price) Hi1=price;
            price=Low[k];
            if(Lo1>price)  Lo1=price;
           }
         code=0;
         if (Open[shift+i]<Close[shift]) code=64;
         if (Close[shift]==Open[shift+i])
           {
            if(Hi1-MathMax(Close[shift],Open[shift+i])>=MathMin(Close[shift],Open[shift+i])-Lo1)code=64;
           }
         if (code>=64)
           {
            //if (Open[shift+i]==Close[shift]) code=code;
            if((MathAbs(Open[shift+i]-Close[shift+i])<b1) && (MathAbs(Open[shift+i]-Close[shift])>0))code=code+16;
            if((MathAbs(Open[shift+i]-Close[shift])>=b1) && ((MathAbs(Open[shift+i]-Close[shift])<b2)))code=code+32;
            if (MathAbs(Open[shift+i]-Close[shift])>=b2) code=code+48;
           }
         if (code<64)
           {
            if (Open[shift+i]==Close[shift]) code=code+48;
            if((MathAbs(Open[shift+i]-Close[shift])<b1) && (MathAbs(Open[shift+i]-Close[shift])>0))code=code+32;
            if((MathAbs(Open[shift+i]-Close[shift])>=b1) && ((MathAbs(Open[shift+i]-Close[shift+i])<b2)))code=code+16;
            //if (MathAbs(Open[shift+i]-Close[shift])>=b2) code=code;
           }
         if(((Hi1-MathMax(Open[shift+i],Close[shift]))<u1) && ((Hi1-MathMax(Open[shift+i],Close[shift]))>0))code=code+4;
         if(((Hi1-MathMax(Open[shift+i],Close[shift]))>=u1) && ((Hi1-MathMax(Open[shift+i],Close[shift]))<u2))code=code+8;
         if(((Hi1-MathMax(Open[shift+i],Close[shift]))>=u2))code=code+12;
         M3=MathMin(Open[shift+i],Close[shift])-Lo1;
         if (M3==0) code=code+3;
         if (M3<l1 && M3>0) code=code+2;
         if (M3>=l1 && M3<l2) code=code+2;
         code1[0]=code1[0]+code-63;
        }
      code1[0]=code1[0]/n;
      code1[0]=code1[1]+2*(code1[0]-code1[1])/(n+1);
      cnt=cnt+1;
      if (cnt>38) //сглаживаем с помощью FATL от Finvare
        {
         SigL[shift]=
         0.4360409450*code1[0]
         +0.3658689069*code1[1]
         +0.2460452079*code1[2]
         +0.1104506886*code1[3]
         -0.0054034585*code1[4]
         -0.0760367731*code1[5]
         -0.0933058722*code1[6]
         -0.0670110374*code1[7]
         -0.0190795053*code1[8]
         +0.0259609206*code1[9]
         +0.0502044896*code1[10]
         +0.0477818607*code1[11]
         +0.0249252327*code1[12]
         -0.0047706151*code1[13]
         -0.0272432537*code1[14]
         -0.0338917071*code1[15]
         -0.0244141482*code1[16]
         -0.0055774838*code1[17]
         +0.0128149838*code1[18]
         +0.0226522218*code1[19]
         +0.0208778257*code1[20]
         +0.0100299086*code1[21]
         -0.0036771622*code1[22]
         -0.0136744850*code1[23]
         -0.0160483392*code1[24]
         -0.0108597376*code1[25]
         -0.0016060704*code1[26]
         +0.0069480557*code1[27]
         +0.0110573605*code1[28]
         +0.0095711419*code1[29]
         +0.0040444064*code1[30]
         -0.0023824623*code1[31]
         -0.0067093714*code1[32]
         -0.0072003400*code1[33]
         -0.0047717710*code1[34]
         +0.0005541115*code1[35]
         +0.0007860160*code1[36]
         +0.0130129076*code1[37]
         +0.0040364019*code1[38];
        }
      Up[shift]=0.0; Dw[shift]=0.0;
      if (code1[0]>=code1[1]) {Up[shift]=code1[0];} else {Dw[shift]=code1[0];}
      shift--;
     }
   return(0);
  }
//+------------------------------------------------------------------+