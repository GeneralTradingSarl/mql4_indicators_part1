//+------------------------------------------------------------------+
//|                        ^X_ParabolicRegression_StopAndReverse.mq4 |
//|                                                      Version 1.1 |
//|                     Copyright © 2007, Mr.WT, Senior Linux Hacker |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Mr.WT, Senior Linux Hacker"
#property link      "http://www.metaquotes.net/"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Orange
#property indicator_color3 DeepSkyBlue
#property indicator_color4 Red
//----
extern int _RegressionDegree=2;
extern double _K_DeviationChannel=2;
extern color _TrendLineColor=Gold;
extern color _ResLineColor = OrangeRed;
extern color _SupLineColor = DeepSkyBlue;
extern color _RegressionColor1 = Yellow;
extern color _RegressionColor2 = Lime;
extern color _RegressionColor3 = Red;
extern color _RegressionColor4 = RoyalBlue;
//----
double _K_Fibo1 = 1.618;
double _K_Fibo2 = 2.618;
//----
double fx,fx1;
double a[10,10],b[10],x[10],sx[20];
double sum,sum1,sq;
int p,nn,kt;
//----
int i0,ip,pn,i0n,ipn;
long t0,tp,te,te1;
long _N_Time,_Cur_Period;
//---- buffers
double Support1[];
double Support2[];
double Resist1[];
double Resist2[];
bool objects_initialized=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,159);
   SetIndexBuffer(0,Support1);
//----
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,Resist1);
//----
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,159);
   SetIndexBuffer(2,Support2);
//----
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,159);
   SetIndexBuffer(3,Resist2);
//----
   SetIndexDrawBegin(0,p);
   SetIndexDrawBegin(1,p);
   SetIndexDrawBegin(2,p);
   SetIndexDrawBegin(3,p);
//----
   SetIndexLabel(0,"1-st Level Stop/Reverse");
   SetIndexLabel(1,"1-st Level Stop/Reverse");
   SetIndexLabel(2,"2-nd Level Stop/Reverse");
   SetIndexLabel(3,"2-nd Level Stop/Reverse");
//----   
   IndicatorShortName("Stop And Reverse");
//----
   if(Period()==PERIOD_MN1)
     {
      p=13;
     }
   else
     {
      if(Period()==PERIOD_W1)
        {
         p=21;
        }
      else
        {
         if(Period()==PERIOD_D1)
           {
            p=89;
           }
         else
           {
            if(Period()==PERIOD_H4)
              {
               p=144;
              }
            else
               p=233;
           }
        }
     }
   _N_Time=0;
   _Cur_Period=0;
   objects_initialized=false;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ObjectsInitialize()
  {
//--- too small history
   if(p>Bars)
     {
      Comment("\n\n                    ERROR - TOO SMALL HISTORY, RETURN NOW!");
      return(false);  // then exit
     }
//  ar
   kt = Period()*60;
   nn = _RegressionDegree + 1;
//----
   t0 = Time[0];
   i0 = iBarShift(Symbol(), Period(), t0);
   ip = i0 + p;
   tp = Time[ip];
   pn = p;
//  ar
   for(int j=-p/2; j<p; j++)
     {
      if(i0+j>=0)
        {
         ObjectCreate("ar"+(string)j,2,0,Time[i0+1+j],0,Time[i0+j],0);
         ObjectSet("ar"+(string)j,OBJPROP_RAY,0);
         ObjectCreate("arH"+(string)j,2,0,Time[i0+1+j],0,Time[i0+j],0);
         ObjectSet("arH"+(string)j,OBJPROP_RAY,0);
         ObjectCreate("arL"+(string)j,2,0,Time[i0+1+j],0,Time[i0+j],0);
         ObjectSet("arL"+(string)j,OBJPROP_RAY,0);
        }
     }
//  LR
   ObjectCreate("LR",OBJ_TREND,0,Time[0],0,Time[0],0);
   ObjectSet("LR",OBJPROP_COLOR,_TrendLineColor);
   ObjectSet("LR",OBJPROP_RAY,1);
   ObjectSet("LR",OBJPROP_STYLE,STYLE_DASH);
//----
   ObjectCreate("2-nd Level ResLine",OBJ_TREND,0,Time[0],0,
                Time[0],0);
   ObjectSet("2-nd Level ResLine",OBJPROP_COLOR,_ResLineColor);
   ObjectSet("2-nd Level ResLine",OBJPROP_RAY,1);
   ObjectSet("2-nd Level ResLine",OBJPROP_STYLE,STYLE_DASH);
//----
   ObjectCreate("2-nd Level SupLine",OBJ_TREND,0,Time[0],0,
                Time[0],0);
   ObjectSet("2-nd Level SupLine",OBJPROP_COLOR,_SupLineColor);
   ObjectSet("2-nd Level SupLine",OBJPROP_RAY,1);
   ObjectSet("2-nd Level SupLine",OBJPROP_STYLE,STYLE_DASH);
//----  
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int j=p; j>=-p/2; j--)
     {
      ObjectDelete("ar"+(string)j);
      ObjectDelete("arH"+(string)j);
      ObjectDelete("arL"+(string)j);
     }
   ObjectDelete("LR");
   ObjectDelete("2-nd Level ResLine");
   ObjectDelete("2-nd Level SupLine");
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(!objects_initialized)
      objects_initialized=ObjectsInitialize();

   if(_N_Time!=Time[0] || _Cur_Period!=Period())
     {
      int i,n,k;
      //---- 
      if(i0n!=i0 || ipn!=ip)
        {
         p=ip-i0;
         i0n = ip;
         ipn = ip;
         //----
         if(pn<p)
           {
            for(int j=pn; j<=p; j++)
              {
               ObjectCreate("ar"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("ar"+(string)j,OBJPROP_RAY,0);
               ObjectCreate("arH"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("arH"+(string)j,OBJPROP_RAY,0);
               ObjectCreate("arL"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("arL"+(string)j,OBJPROP_RAY,0);
              }
            //----
            for(j=-pn/2; j>=-p/2; j--)
              {
               ObjectCreate("ar"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("ar"+(string)j,OBJPROP_RAY,0);
               ObjectCreate("arH"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("arH"+(string)j,OBJPROP_RAY,0);
               ObjectCreate("arL"+(string)j,2,0,Time[i0+1+j],0,
                            Time[i0+j],0);
               ObjectSet("arL"+(string)j,OBJPROP_RAY,0);
              }
            pn=p;
           }
         if(pn>p)
           {
            for(j=pn; j>=p; j--)
              {
               ObjectDelete("ar"+(string)j);
               ObjectDelete("arH"+(string)j);
               ObjectDelete("arL"+(string)j);
              }
            for(j=-p/2; j>=-pn/2; j--)
              {
               ObjectDelete("ar"+(string)j);
               ObjectDelete("arH"+(string)j);
               ObjectDelete("arL"+(string)j);
              }
            pn=p;
           }
        }
      //  PR
      sx[1]=p+1;
      //  sx
      for(i=1; i<=nn*2-2; i++)
        {
         sum=0.0;
         for(n=i0; n<=i0+p; n++)
            sum+= MathPow(n,i);
         sx[i+1]= sum;
        }
      //  syx
      for(i=1; i<=nn; i++)
        {
         sum=0.0;
         for(n=i0; n<=i0+p; n++)
           {
            if(i==1)
               sum+=Close[n];
            else
               sum+=Close[n]*MathPow(n,i-1);
           }
         b[i]=sum;
        }
      //  Matrix
      for(j=1; j<=nn; j++)
        {
         for(i=1; i<=nn; i++)
           {
            k=i+j-1;
            a[i,j]=sx[k];
           }
        }
      // Gauss
      Print("nn=",nn);
      af_Gauss(nn,a,b,x);
      //  SQ
      sq=0.0;
      for(n=p; n>=0; n--)
        {
         sum=0.0;
         for(k=1; k<=_RegressionDegree; k++)
           {
            sum+=x[k+1]*MathPow(i0+n,k);
            sum1+=x[k+1]*MathPow(i0+n+1,k);
           }
         fx = x[1]+ sum;
         sq+= MathPow(Close[n+i0] - fx,2);
        }
      sq=_K_DeviationChannel*MathSqrt(sq/(p+1));
      //----
      for(n=p; n>=-p/2; n--)
        {
         sum=0.0;
         sum1=0.0;
         //----
         for(k=1; k<=_RegressionDegree; k++)
           {
            sum+=x[k+1]*MathPow(i0+n,k);
            sum1+=x[k+1]*MathPow(i0+n+1,k);
           }
         fx=x[1]+sum;
         fx1=x[1]+sum1;
         //----
         if(n>=0 && n<p)
           {
            ObjectMove("ar"+(string)n,0,Time[n+i0+1],fx1);
            ObjectMove("ar"+(string)n,1,Time[n+i0],fx);
            ObjectMove("arH"+(string)n,0,Time[n+i0+1],fx1+sq);
            ObjectMove("arH"+(string)n,1,Time[n+i0],fx+sq);
            ObjectMove("arL"+(string)n,0,Time[n+i0+1],fx1-sq);
            ObjectMove("arL"+(string)n,1,Time[n+i0],fx-sq);
            //----
            if(fx>fx1)
              {
               ObjectSet("ar"+(string)n,OBJPROP_COLOR,_RegressionColor1);
               ObjectSet("arH"+(string)n,OBJPROP_COLOR,_RegressionColor1);
               ObjectSet("arL"+(string)n,OBJPROP_COLOR,_RegressionColor1);
              }
            //----
            if(fx<fx1)
              {
               ObjectSet("ar"+(string)n,OBJPROP_COLOR,_RegressionColor2);
               ObjectSet("arH"+(string)n,OBJPROP_COLOR,_RegressionColor2);
               ObjectSet("arL"+(string)n,OBJPROP_COLOR,_RegressionColor2);
              }
           }
         if(n<0)
           {
            if((n+i0)>=0)
              {
               ObjectMove("ar"+(string)n,0,Time[n+i0+1],fx1);
               ObjectMove("ar"+(string)n,1,Time[n+i0],fx);
               ObjectMove("arH"+(string)n,0,Time[n+i0+1],fx1+sq);
               ObjectMove("arH"+(string)n,1,Time[n+i0],fx+sq);
               ObjectMove("arL"+(string)n,0,Time[n+i0+1],fx1-sq);
               ObjectMove("arL"+(string)n,1,Time[n+i0],fx-sq);
              }
            if((n+i0)<0)
              {
               te=Time[0]-(n+i0)*kt;
               te1=Time[0]-(n+i0+1)*kt;
               ObjectMove("ar"+(string)n,0,te1,fx1);
               ObjectMove("ar"+(string)n,1,te,fx);
               ObjectMove("arH"+(string)n,0,te1,fx1+sq);
               ObjectMove("arH"+(string)n,1,te,fx+sq);
               ObjectMove("arL"+(string)n,0,te1,fx1-sq);
               ObjectMove("arL"+(string)n,1,te,fx-sq);
              }
            if(fx>fx1)
              {
               ObjectSet("ar"+(string)n,OBJPROP_COLOR,_RegressionColor3);
               ObjectSet("arH"+(string)n,OBJPROP_COLOR,_RegressionColor3);
               ObjectSet("arL"+(string)n,OBJPROP_COLOR,_RegressionColor3);
              }
            if(fx<fx1)
              {
               ObjectSet("ar"+(string)n,OBJPROP_COLOR,_RegressionColor4);
               ObjectSet("arH"+(string)n,OBJPROP_COLOR,_RegressionColor4);
               ObjectSet("arL"+(string)n,OBJPROP_COLOR,_RegressionColor4);
              }
           }
        }
      // regression calculation
      int end_bar=1,start_bar=p+1,q=p;
      // calculate price values
      double xvalue,aa,bb,cc,sumy=0.0,sumx=0.0,sumxy=0.0,sumx2=0.0;
      for(int xx=0; xx<q; xx++)
        {
         xvalue=Close[end_bar+xx];
         sumy+=xvalue;
         sumxy+= xvalue*xx;
         sumx += xx;
         sumx2+= xx*xx;
        }
      cc=sumx2*q-sumx*sumx;
      if(cc==0.0)
         //return;
         return(0);
      bb = (sumxy*q - sumx*sumy) / cc;
      aa = (sumy - sumx*bb) / q;
      double LR_price_2 = aa;
      double LR_price_1 = aa + bb*q;
      //--- deviation
      double AvgRange=0.0,sumq=0.0,std_dev;
      for(xx=end_bar; xx<start_bar; xx++)
        {
         AvgRange+=(High[xx]-Low[xx])*(High[xx]-Low[xx]);
         sumq+=(High[xx]-Low[xx]);
        }
      std_dev=AvgRange/sumq;
      ObjectMove("LR",0,Time[start_bar],LR_price_1);
      ObjectMove("LR",1,Time[end_bar],LR_price_2);
      ObjectMove("2-nd Level ResLine",0,Time[start_bar],
                 LR_price_1+_K_Fibo2*std_dev);
      ObjectMove("2-nd Level ResLine",1,Time[end_bar],
                 LR_price_2+_K_Fibo2*std_dev);
      ObjectMove("2-nd Level SupLine",0,Time[start_bar],
                 LR_price_1-_K_Fibo2*std_dev);
      ObjectMove("2-nd Level SupLine",1,Time[end_bar],
                 LR_price_2-_K_Fibo2*std_dev);
      // stop-reverse calculation
      if(Point==0.01)
         std_dev/=100;
      int trend=0,trend2=0;
      if(LR_price_1<LR_price_2)
        {
         Support1[start_bar-1] = LR_price_1 - _K_Fibo1*std_dev;
         Support2[start_bar-1] = LR_price_1 - _K_Fibo2*std_dev;
         Resist1[start_bar-1] = 0.0;
         Resist2[start_bar-1] = 0.0;
         trend=1;
         trend2=1;
        }
      else
        {
         Resist1[start_bar-1] = LR_price_1 + _K_Fibo1*std_dev;
         Resist2[start_bar-1] = LR_price_1 + _K_Fibo2*std_dev;
         Support1[start_bar-1] = 0.0;
         Support2[start_bar-1] = 0.0;
         trend=-1;
         trend2=-1;
        }
      double value,price=ObjectGetValueByShift("LR",start_bar-2),
      value2,price2=price;
      for(xx=start_bar-2; xx>0; xx--)
        {
         // First Stop-Reverse
         if(trend>0)
           {
            if(Close[xx]>price)
               price=Close[xx];
            value=price *(1-_K_Fibo1*std_dev);
            if(Close[xx]<value)
              {
               price = Close[xx];
               value = price * (1 + _K_Fibo1*std_dev);
               trend = -1;
              }
           }
         else
         if(trend<0)
           {
            if(Close[xx]<price)
               price=Close[xx];
            value=price *(1+_K_Fibo1*std_dev);
            if(Close[xx]>value)
              {
               price = Close[xx];
               value = price * (1 - _K_Fibo1*std_dev);
               trend = 1;
              }
           }
         // Second Stop-Reverse
         if(trend2>0)
           {
            if(Close[xx]>price2)
               price2=Close[xx];
            value2=price2 *(1-_K_Fibo2*std_dev);
            if(Close[xx]<value2)
              {
               price2 = Close[xx];
               value2 = price2 * (1 + _K_Fibo2*std_dev);
               trend2 = -1;
              }
           }
         else
         if(trend2<0)
           {
            if(Close[xx]<price2)
               price2=Close[xx];
            value2=price2 *(1+_K_Fibo2*std_dev);
            if(Close[xx]>value2)
              {
               price2 = Close[xx];
               value2 = price2 * (1 - _K_Fibo2*std_dev);
               trend2 = 1;
              }
           }
         //  Show me a Picture please
         if(trend==1)
           {
            Support1[xx]= value;
            Resist1[xx] = 0.0;
           }
         else
         if(trend==-1)
           {
            Resist1[xx]=value;
            Support1[xx]=0.0;
           }
         if(trend2==1)
           {
            Support2[xx]= value2;
            Resist2[xx] = 0.0;
           }
         else
         if(trend2==-1)
           {
            Resist2[xx]=value2;
            Support2[xx]=0.0;
           }
        }
      Support1[0]= Support1[1];
      Resist1[0] = Resist1[1];
      Support2[0]= Support2[1];
      Resist2[0] = Resist2[1];
      _N_Time=Time[0];
      _Cur_Period=Period();
     }//main if()
   return(0);
  }//end of program
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void af_Gauss(int n,double &a_[][],double &b_[],double &x_[])
  {
   int i,j,k,l;
   double q,m,t;
//----
   for(k=1; k<=n-1; k++)
     {
      l = 0;
      m = 0;
      for(i=k; i<=n; i++)
        {
         if(MathAbs(a_[i,k])>m)
           {
            m = MathAbs(a_[i,k]);
            l = i;
           }
        }
      if(l==0)
         //return(0);   
         return;
      if(l!=k)
        {
         for(j=1; j<=n; j++)
           {
            t=a_[k,j];
            a_[k,j] = a_[l,j];
            a_[l,j] = t;
           }
         t=b_[k];
         b_[k] = b_[l];
         b_[l] = t;
        }
      //---
      for(i=k+1; i<=n; i++)
        {
         q=a_[i,k]/a_[k,k];
         for(j=1; j<=n; j++)
           {
            if(j==k)
               a_[i,j]=0;
            else
               a_[i,j]=a_[i,j]-q*a_[k,j];
           }
         b_[i]=b_[i]-q*b_[k];
        }
     }
   x_[n]=b_[n]/a_[n,n];
//---
   for(i=n-1; i>=1; i--)
     {
      t=0;
      for(j=1; j<=n-i; j++)
        {
         t=t+a_[i,i+j]*x_[i+j];
         x_[i]=(1/a_[i,i])*(b_[i]-t);
        }
     }
//---     
  }
//+------------------------------------------------------------------+
