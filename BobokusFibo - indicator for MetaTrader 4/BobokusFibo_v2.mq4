//+------------------------------------------------------------------+
//| #BobokusFibo.mq4 modified from                                   |
//| #SpudFibo.mq4                                                    |
//| http://www.forexfactory.com/showthread.php?t=50767               |
//+------------------------------------------------------------------+
#property link "Modified by cja"
#property indicator_buffers 3
#property  indicator_chart_window
//----
extern int TimeFrame =60;
extern int Fibo_Num=12345;
extern color Intra_color=RoyalBlue;
extern color Upper_color=Blue;
extern color Lower_color=DodgerBlue;
//----
double HiPrice, LoPrice, Range;
datetime StartTime;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("LongFibo"+Fibo_Num+"");
   ObjectDelete("ShortFibo"+Fibo_Num+"");
   ObjectDelete("IntradayFibo"+Fibo_Num+"");
   ObjectDelete("Fibo"+Fibo_Num+""); ObjectDelete("Fibo1"+Fibo_Num+"");
   return(0);
  }
//+------------------------------------------------------------------+
//| Draw Fibo
//+------------------------------------------------------------------+
int DrawFibo()
  {  
   string TF="",TF2="";
   if(TimeFrame==1){return(-1);}
   if(TimeFrame==5){return(-1);}
   if(TimeFrame==15){return(-1);}
   if(TimeFrame==30){return(-1);}
   if(TimeFrame==60){TF="H1";}
   if(TimeFrame==240){TF="H4";}
   if(TimeFrame==1440){TF="Daily";}
   if(TimeFrame==10080){TF="Weekly";}
   if(TimeFrame==43200){TF="Monthly";}
   if(TimeFrame==60){TF2="1 Hourly";}
   if(TimeFrame==240){TF2="4 Hourly";}
   if(TimeFrame==1440){TF2="IntraDay";}
   if(TimeFrame==10080){TF2="IntraWeek";}
   if(TimeFrame==43200){TF2="IntraMonth";}
   if(ObjectFind("LongFibo"+Fibo_Num+"")==-1)
      ObjectCreate("LongFibo"+Fibo_Num+"",OBJ_FIBO,0,StartTime,HiPrice+Range,StartTime,HiPrice);
   else
     {
      ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_TIME2, StartTime);
      ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_TIME1, StartTime);
      ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_PRICE1,HiPrice+Range);
      ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_PRICE2,HiPrice);
     }
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_LEVELCOLOR,Upper_color);
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_FIBOLEVELS,4);
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+0,0.34);   ObjectSetFiboDescription("LongFibo"+Fibo_Num+"",0,""+TF+" Long Target 1 -  %$");
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+1,0.55);   ObjectSetFiboDescription("LongFibo"+Fibo_Num+"",1,""+TF+" Long Target 2 -  %$");
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+2,0.764);   ObjectSetFiboDescription("LongFibo"+Fibo_Num+"",2,""+TF+" Long Target 3 -  %$");
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+3,1.764);   ObjectSetFiboDescription("LongFibo"+Fibo_Num+"",3,""+TF+" Long Target 4 -  %$");
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_RAY,true);
   ObjectSet("LongFibo"+Fibo_Num+"",OBJPROP_BACK,true);
   if(ObjectFind("ShortFibo"+Fibo_Num+"")==-1)
      ObjectCreate("ShortFibo"+Fibo_Num+"",OBJ_FIBO,0,StartTime,LoPrice-Range,StartTime,LoPrice);
   else
     {
      ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_TIME2, StartTime);
      ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_TIME1, StartTime);
      ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_PRICE1,LoPrice-Range);
      ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_PRICE2,LoPrice);
     }
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_LEVELCOLOR,Lower_color);
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_FIBOLEVELS,4);
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+0,0.34);   ObjectSetFiboDescription("ShortFibo"+Fibo_Num+"",0,""+TF+" Short Target 1 -  %$");
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+1,0.55);   ObjectSetFiboDescription("ShortFibo"+Fibo_Num+"",1,""+TF+" Short Target 2 -  %$");
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+2,0.764);   ObjectSetFiboDescription("ShortFibo"+Fibo_Num+"",2,""+TF+" Short Target 3 -  %$");
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+3,1.764);   ObjectSetFiboDescription("ShortFibo"+Fibo_Num+"",3,""+TF+" Short Target 4 -  %$");
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_RAY,true);
   ObjectSet("ShortFibo"+Fibo_Num+"",OBJPROP_BACK,true);
   if(ObjectFind("IntradayFibo"+Fibo_Num+"")==-1)
      ObjectCreate("IntradayFibo"+Fibo_Num+"",OBJ_FIBO,0,StartTime,HiPrice,StartTime+TimeFrame*60,LoPrice);
   else
     {
      ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_TIME2, StartTime);
      ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_TIME1, StartTime+TimeFrame*60);
      ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_PRICE1,HiPrice);
      ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_PRICE2,LoPrice);
     }
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_LEVELCOLOR,Intra_color);
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIBOLEVELS,7);
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+0,0.0);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",0,""+TF2+" Low -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+1,0.191);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",1,""+TF2+" S1 -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+2,0.382);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",2,""+TF2+" Short -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+3,0.500);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",3,""+TF2+" Pivot -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+4,0.618);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",4,""+TF2+" Long -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+5,0.809);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",5,""+TF2+" R1 -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_FIRSTLEVEL+6,1.000);   ObjectSetFiboDescription("IntradayFibo"+Fibo_Num+"",6,""+TF2+" High -  %$");
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_RAY,true);
   ObjectSet("IntradayFibo"+Fibo_Num+"",OBJPROP_BACK,true);
  }
//+------------------------------------------------------------------+
//| Indicator start function
//+------------------------------------------------------------------+
int start()
  {
   int shift  =iBarShift(NULL,TimeFrame,Time[0]) + 1;   // yesterday
   HiPrice     =iHigh(NULL,TimeFrame,shift);
   LoPrice     =iLow (NULL,TimeFrame,shift);
   StartTime  =iTime(NULL,TimeFrame,shift);
   if(TimeDayOfWeek(StartTime)==0/*Sunday*/)
     {//Add fridays high and low
      HiPrice=MathMax(HiPrice,iHigh(NULL,TimeFrame,shift+1));
      LoPrice=MathMin(LoPrice,iLow(NULL,TimeFrame,shift+1));
     }
   Range=HiPrice-LoPrice;
   DrawFibo();
//----
   string Caution="",Caution2="";
   if(TimeFrame==1){Caution="ERROR: Incorrect Fibo TimeFrame";Caution2="Use only H1/H4/D1/W1/MN1";}
   if(TimeFrame==5){Caution="ERROR: Incorrect Fibo TimeFrame";Caution2="Use only H1/H4/D1/W1/MN1";}
   if(TimeFrame==15){Caution="ERROR: Incorrect Fibo TimeFrame";Caution2="Use only H1/H4/D1/W1/MN1";}
   if(TimeFrame==30){Caution="ERROR: Incorrect Fibo TimeFrame";Caution2="Use only H1/H4/D1/W1/MN1";}
//----
   ObjectDelete("Fibo"+Fibo_Num+"");
   ObjectCreate("Fibo"+Fibo_Num+"", OBJ_LABEL,0, 0, 0);
   ObjectSetText("Fibo"+Fibo_Num+"",Caution,20, "Verdana",Intra_color);
   ObjectSet("Fibo"+Fibo_Num+"", OBJPROP_CORNER, 1);
   ObjectSet("Fibo"+Fibo_Num+"", OBJPROP_XDISTANCE, 20);
   ObjectSet("Fibo"+Fibo_Num+"", OBJPROP_YDISTANCE, 36);
//----
   ObjectDelete("Fibo1"+Fibo_Num+"");
   ObjectCreate("Fibo1"+Fibo_Num+"", OBJ_LABEL,0, 0, 0);
   ObjectSetText("Fibo1"+Fibo_Num+"",Caution2,20, "Verdana",Intra_color);
   ObjectSet("Fibo1"+Fibo_Num+"", OBJPROP_CORNER, 1);
   ObjectSet("Fibo1"+Fibo_Num+"", OBJPROP_XDISTANCE, 20);
   ObjectSet("Fibo1"+Fibo_Num+"", OBJPROP_YDISTANCE, 66);
//----
   return(0);
  }
//+------------------------------------------------------------------+

