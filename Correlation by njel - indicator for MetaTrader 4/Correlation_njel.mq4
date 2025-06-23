#property copyright "Copyright © 2007, njel [andrew opeyda]"
#property link      "www.signalslab.com [andrew.opeyda@gmail.com] %)"

#property indicator_separate_window


#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_width1 1
#property indicator_color2 SkyBlue
#property indicator_width2 2
#property indicator_color3 Green
#property indicator_width3 1


#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT

#property indicator_maximum 1
#property indicator_minimum 0


double buff1[];
double buff2[];
double buff3[];


extern int BarsForShortTF=7; //количество баров дл€ расчета коррел€ции на коротком периоде
int SortMode=2;       // режим сортировки 1- по возрастанию, 2 - по убыванию

extern int HistoryBars=200;
extern string Base="EURUSD";
string iname ="";
int win_idx;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
  
//---- indicators
IndicatorBuffers(8); 
	
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,buff1);
   SetIndexEmptyValue(0,0); 
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,buff2);
   SetIndexEmptyValue(1,EMPTY_VALUE); 
   SetIndexLabel(1," оррел€ци€ за "+BarsForShortTF+" баров");

   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,buff3);
   SetIndexEmptyValue(2,0); 
   iname = "Correlation "+Base;
   IndicatorShortName(iname);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
   win_idx=WindowFind(iname);
   //Alert(win_idx+" name "+iname);
   ObjectsDeleteAll(win_idx);
   
   
   int i;
   int periods[10];
   periods[0] = 10;
   periods[1] = 15;
   periods[2] = 25;
   periods[3] = 50;
   periods[4] = 75;
   periods[5] = 100;
   periods[6] = 125;
   periods[7] = 150;
   periods[8] = 200;
   periods[9] = 250;

   
   double x = 1.0;
   for (int p = 0; p<10; p++)
   {
      for(i=HistoryBars;i>=0;i--)
      {
       double RS=Rcalc(Symbol(),periods[p],i);
       //buff2[i]=RS;
       double a = (RS+1)/2;
       AddObj(i,x,fromRGB(255-(a*255),a*255,0));
       //AddObj(i,x,fromRGB(a*255,a*255,a*255));
      }
      
      x = x-0.1;
   }


//----
   return(0);
  }
//+------------------------------------------------------------------+

double Rcalc(string symb,int Bars_,int shift)
{
         int currday=iBarShift(NULL,Period(),iTime(NULL,Period(),shift));
      double avgBase=iMA(Base,Period(),Bars_,0,MODE_SMA,PRICE_CLOSE,currday);
      double avgSmb=iMA(symb,Period(),Bars_,0,MODE_SMA,PRICE_CLOSE,currday);
      
      double E=0;
      double D=0;
      double F=0;
      
      for(int i=currday;i<=currday+Bars_;i++)
      {
       E+=((iClose(Base,Period(),i))-avgBase)*((iClose(symb,Period(),i))-avgSmb);
       D+=MathPow(((iClose(Base,Period(),i))-avgBase),2);
       F+=MathPow(((iClose(symb,Period(),i))-avgSmb),2);
      }
      D=MathSqrt(D);
      F=MathSqrt(F);
      double G=D*F;
      double R=E/G;
return(R);
}
//--------------------------------------------------------------------+
void AddObj(int t, double price, color c)
{

   //debug
   if (c==Black) return;
   string name = ObjectsTotal()+"level";
   //ObjectCreate(name,OBJ_TREND,1,Time[t],price,Time[t],price);
   ObjectCreate(name,OBJ_ARROW,win_idx,Time[t],price,Time[t],price);
   ObjectSet(name,OBJPROP_ARROWCODE,110);
   ObjectSet(name,OBJPROP_COLOR,c);
   ObjectSet(name,OBJPROP_WIDTH,0);
   ObjectSet(name,OBJPROP_RAY,false);
}
//+------------------------------------------------------------------+
color fromRGB(int R, int G, int B)
{
   return (R+(G<<8)+(B<<16));
}
//+------------------------------------------------------------------+




