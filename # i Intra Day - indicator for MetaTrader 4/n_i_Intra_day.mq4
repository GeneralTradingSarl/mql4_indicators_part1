//+------------------------------------------------------------------+
//|                                                    Intra_Day.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, klot."
#property link      "klot@mail.ru"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 LightSkyBlue
#property indicator_color3 Blue
#property indicator_color4 Blue
//---- indicator parameters
extern int Hour_Begin_Day=21;
extern int Asian_end_hour=7;
extern int Europa_end_hour=15;
extern int ExtDepth=9;
extern int perATR=50;
extern int m=1;
int i0=0;
extern double kkk=0.88;
//---- indicator buffers
int begin,end;
datetime begin_time,end_time,asia_t,amer_t;
double low_asia,high_asia,low_day,high_day,atr;
double zzL[];
double zzH[];
double zz[];
//-----------------------
double fx[];
double fxH[];
double fxL[];
double a[10,10],b[10],x[10],sx[20];
double sum;
int pp;
int nn;
int bar;
//*******************************************
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
//---- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
//---- indicator buffers mapping
   SetIndexBuffer(0,zz);
   SetIndexBuffer(4,zzH);
   SetIndexBuffer(5,zzL);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
//-------------------------
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,fx);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,fxH);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,fxL);
   nn=m+1;
//---- indicator short name
   IndicatorShortName("Intra_Day");
//---- initialization done

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int deinit()
  {
//----
   obje_del();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    asia_b,i;
   if(Bars<(1440/Period()))return(0);

   datetime _cur_time=iTime(NULL,0,0);
   int      _nbar_day=iBarShift(NULL,PERIOD_D1,_cur_time);

   begin_time=iTime(NULL,PERIOD_D1,_nbar_day)-(24-Hour_Begin_Day)*3600;
   begin=iBarShift(NULL,0,begin_time);
   asia_t=iTime(NULL,PERIOD_D1,_nbar_day)+(Asian_end_hour*3600);
   amer_t=iTime(NULL,PERIOD_D1,_nbar_day)+(Europa_end_hour*3600);
   end_time=iTime(NULL,PERIOD_D1,_nbar_day)+(Hour_Begin_Day*3600);
   asia_b=iBarShift(NULL,0,asia_t);
   end=iBarShift(NULL,0,end_time);
   //atr=iATR(NULL,PERIOD_D1,perATR,_nbar_day+1);
   atr=0;
   for(i=perATR; i>=1; i--)
     {
      atr+=iHigh(NULL,PERIOD_D1,_nbar_day+i)-iLow(NULL,PERIOD_D1,_nbar_day+i);
     }
   atr=atr/perATR;

   low_asia=Low[Lowest(NULL,0,MODE_LOW,(begin-asia_b),asia_b+1)];
   high_asia=High[Highest(NULL,0,MODE_HIGH,(begin-asia_b),asia_b+1)];

   low_day=High[Highest(NULL,0,MODE_HIGH,begin,0)]-atr;
   high_day=Low[Lowest(NULL,0,MODE_LOW,begin,0)]+atr;

   _ZigZag(begin);
   _reg_cannel(begin);
   obje_del();
   obje_creat();

   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void obje_del()
  {
   ObjectDelete("Begin");
   ObjectDelete("Asian");
   ObjectDelete("End");
   ObjectDelete("Amer");
   ObjectDelete("Open");
   ObjectDelete("High_asian");
   ObjectDelete("Low_asian");
   ObjectDelete("low_day");
   ObjectDelete("high_day");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void obje_creat()
  {
   ObjectCreate("Begin",OBJ_VLINE,0,begin_time,0);
   ObjectCreate("Asian",OBJ_VLINE,0,asia_t,0);
   ObjectCreate("Amer",OBJ_VLINE,0,amer_t,0);
   ObjectCreate("End",OBJ_VLINE,0,end_time,0);
//---------------------
   ObjectCreate("Open",OBJ_TREND,0,begin_time,Open[begin],Time[0],Open[begin]);
   ObjectSet("Open",OBJPROP_RAY,false);
   ObjectSet("Open",OBJPROP_STYLE,STYLE_DOT);

   ObjectCreate("High_asian",OBJ_TREND,0,begin_time,high_asia,Time[0],high_asia);
   ObjectSet("High_asian",OBJPROP_RAY,false);
   ObjectSet("High_asian",OBJPROP_STYLE,STYLE_DASH);
   ObjectSet("High_asian",OBJPROP_COLOR,DarkOrange);

   ObjectCreate("Low_asian",OBJ_TREND,0,begin_time,low_asia,Time[0],low_asia);
   ObjectSet("Low_asian",OBJPROP_RAY,false);
   ObjectSet("Low_asian",OBJPROP_STYLE,STYLE_DASH);
   ObjectSet("Low_asian",OBJPROP_COLOR,DarkOrange);

   ObjectCreate("low_day",OBJ_TREND,0,Time[0]-900*Period(),low_day,Time[0]+900*Period(),low_day);
   ObjectSet("low_day",OBJPROP_RAY,false);
   ObjectSet("low_day",OBJPROP_COLOR,Yellow);

   ObjectCreate("high_day",OBJ_TREND,0,Time[0]-900*Period(),high_day,Time[0]+900*Period(),high_day);
   ObjectSet("high_day",OBJPROP_RAY,false);
   ObjectSet("high_day",OBJPROP_COLOR,Yellow);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _ZigZag(int nbar)
  {
   int    i,shift,pos,lasthighpos,lastlowpos,curhighpos,curlowpos;
   double curlow,curhigh,lasthigh,lastlow,waveH,waveL;
   double min, max;
   ArrayInitialize(zz,0.0);
   ArrayInitialize(zzL,0.0);
   ArrayInitialize(zzH,0.0);

   lasthighpos=nbar; lastlowpos=nbar;
   lastlow=Low[lastlowpos];lasthigh=High[lasthighpos];
   zz[lastlowpos]=lastlow; zz[lasthighpos]=lasthigh;

   for(shift=nbar-ExtDepth; shift>=0; shift--)
     {
      curlowpos=Lowest(NULL,0,MODE_LOW,ExtDepth,shift);
      curlow=Low[curlowpos];
      curhighpos=Highest(NULL,0,MODE_HIGH,ExtDepth,shift);
      curhigh=High[curhighpos];
      //------------------------------------------------
      if(curlow>=lastlow){ lastlow=curlow; }
      else
        {
         //идем вниз
         if(lasthighpos>curlowpos )
           {
            zzL[curlowpos]=curlow;
            ///*
            min=100000; pos=lasthighpos;
            for(i=lasthighpos; i>=curlowpos; i--)
              {
               if (zzL[i]==0.0) continue;
               if (zzL[i]<min) { min=zzL[i]; pos=i; }
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
            for(i=lastlowpos; i>=curhighpos; i--)
              {
               if (zzH[i]==0.0) continue;
               if (zzH[i]>max) { max=zzH[i]; pos=i; }
               zz[i]=0.0;
              }
            zz[pos]=max;
            //*/     
           }
         lasthighpos=curhighpos;
         lasthigh=curhigh;
        }
      //----------------------------------------------------------------------
     }
   return(0);
  }
//+------------------------------------------------------------------+
void _reg_cannel(int p)
  {
   int i,n,k;
   //**********************************************************
   double val0,val1,val2,val3,val4;
   int kk;

   //**********************************************************

   sx[1]=p+1;
   SetIndexDrawBegin(1,Bars-p);
   SetIndexDrawBegin(2,Bars-p);
   SetIndexDrawBegin(3,Bars-p);
//----------------------sx---------------------
   for(i=1; i<=nn*2-2; i++)
     {
      sum=0.0;
      for(n=i0; n<=i0+p; n++) {sum+=MathPow(n,i);}
      sx[i+1]=sum;
     }
//----------------------syx--------------------
   for(i=1; i<=nn; i++)
     {
      sum=0.0;
      for(n=i0; n<=i0+p; n++)
        {
         if (i==1) sum+=Close[n];
         else
            sum+=Close[n]*MathPow(n,i-1);
        }
      b[i]=sum;
     }
   //===============Matrix========================
   for(int j=1; j<=nn; j++)
     {
      for(i=1; i<=nn; i++)
        {
         k=i+j-1;
         a[i,j]=sx[k];
        }
     }
   //===============Gauss=========================
   af_Gauss(nn,a,b,x);
   //=============================================
   for(i=i0; i<=i0+p; i++)
     {
      sum=0;
      for(k=1; k<=m; k++) sum+=x[k+1]*MathPow(i,k);
      fx[i]=x[1]+sum;
     }
//-------------------------------------------------------------
   //*************************************************************
   for(i=i0; i<=i0+p; i++)
     {
      if(fx[p]>fx[0])
        {
         val1=0; val2=0; val3=0; val4=0;
         for(kk=i0;kk<=i0+p;kk++)
           {
            val3=fx[kk]-iClose(NULL,0,kk);
            val1=iClose(NULL,0,kk)-fx[kk];
            val2=MathMax(val2,val1);
            val4=MathMax(val4,val3);
           }
        }
      if(fx[p]<=fx[0])
        {
         val1=0; val2=0; val3=0; val4=0;
         for(kk=i0;kk<=i0+p;kk++)
           {
            val1=iClose(NULL,0,kk)-fx[kk];
            val3=fx[kk]-iClose(NULL,0,kk);
            val2=MathMax(val2,val1);
            val4=MathMax(val4,val3);
           }

        }
      val0=MathMin(val2,val4);
      fxH[i]=fx[i]+val0*kkk;
      fxL[i]=fx[i]-val0*kkk;
     }
//-------------------------------------------------------------
   //*************************************************************
   //  Comment( " p = ",p,"  pp = ",pp);
   return(0);
  }
//*************************************************************** 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void af_Gauss(int n, double& a[][],double& b[], double& x[])
  {
   int i,j,k,l;
   double q,m,t;

   for(k=1; k<=n-1; k++)
     {
      l=0;
      m=0;
      for(i=k; i<=n; i++)
        {
         if (MathAbs(a[i,k])>m) {m=MathAbs(a[i,k]); l=i;}
        }
      if (l==0) return(0);

      if (l!=k)
        {
         for(j=1; j<=n; j++)
           {
            t=a[k,j];
            a[k,j]=a[l,j];
            a[l,j]=t;
           }
         t=b[k];
         b[k]=b[l];
         b[l]=t;
        }

      for(i=k+1;i<=n;i++)
        {
         q=a[i,k]/a[k,k];
         for(j=1;j<=n;j++)
           {
            if (j==k) a[i,j]=0;
            else
               a[i,j]=a[i,j]-q*a[k,j];
           }
         b[i]=b[i]-q*b[k];
        }
     }

   x[n]=b[n]/a[n,n];

   for(i=n-1;i>=1;i--)
     {
      t=0;
      for(j=1;j<=n-i;j++)
        {
         t=t+a[i,i+j]*x[i+j];
         x[i]=(1/a[i,i])*(b[i]-t);
        }
     }
   return;
  }
//********************************************************************** 

//+------------------------------------------------------------------+
