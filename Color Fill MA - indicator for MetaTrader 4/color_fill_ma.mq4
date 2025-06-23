//+------------------------------------------------------------------+
//|                                                Color Fill MA.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, File45"
#property link      "https://www.mql5.com/en/users/file45/publications"
#property version   "3.00"
#property description "Various options of color file between Price and MA1 and MA1 and MA2";
#property strict
#property indicator_chart_window
// ======================== DEFAULT PARAMETERS - START
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 SandyBrown
#property indicator_color2 Thistle
#property indicator_color3 SandyBrown
#property indicator_style3 STYLE_DOT
#property indicator_color4 Thistle
#property indicator_style4 STYLE_DOT

enum ma_cf
{
  a = 0, // Price <---> MA1
  b = 1, // Price <---> MA2
  c = 2, // MA1 <---> MA2
  d = 3 // No Fill
};
  
input ma_cf MA_Color_Fill_1_2_3_or_4=c;
input int MA1_Period = 50;
input int MA1_Shift = 0;
input ENUM_MA_METHOD MA1_Method = 1;
input ENUM_APPLIED_PRICE MA1_Price = 0;
input int MA2_Period = 100;
input int MA2_Shift = 0;
input ENUM_MA_METHOD MA2_Method = 1;
input ENUM_APPLIED_PRICE MA2_Price = 0;

input bool Show_MA1 = true;
input bool Show_MA2 = true;
input int Label_Size= 12;
input bool Label_Bold=false;
input color MA1_Label_Color = indicator_color1;
input color MA2_Label_Color = indicator_color2;
input int Label_Corner=3;
input int Label_Left_Right=20;
input int Label_Up_Down= 20;
input bool Show_Labels = false;
// ======================== DEFAULT PARAMRTERS - END

// ======================== indicator buffers
double ExtMapBuffer_1[];
double ExtMapBuffer_2[];
double ExtMapBuffer_A1[];
double ExtMapBuffer_B1[];

int Color_Fill_ma;
int ma_1_meth,ma_2_meth;
int draw_ma_1,draw_ma_2;
double Fill_A_Latch,Fill_B_Latch;
int ExtCountedBars=0;
int a_begin;

string Tcf;
string ObjLabMA1="labma1";
string ObjLabMA2="labma2";
string textma1;
string textma2;
string Font_Type;
string PLMA1, PLMA2;

int MA1_Price_Latch,MA2_Price_Latch;
double Y_Dist_MA1,Y_Dist_MA2;
double price;

int OnInit()
{
   // ======================== Fill Alert / Reset     
   switch(Period())
     {
      case 1:     Tcf = "M1";  break;
      case 5:     Tcf = "M5";  break;
      case 15:    Tcf = "H15"; break;
      case 30:    Tcf = "M30"; break;
      case 60:    Tcf = "H1";  break;
      case 240:   Tcf = "H4";  break;
      case 1440:  Tcf = "D1";  break;
      case 10080: Tcf = "W1";  break;
      case 43200: Tcf = "M4";  break;
     }

   switch(MA_Color_Fill_1_2_3_or_4)
     {
      case a: Color_Fill_ma = 1; break;
      case b: Color_Fill_ma = 2; break;
      case c: Color_Fill_ma = 3; break;
      case d: Color_Fill_ma = 4; break;
      default: Alert(Symbol()+" - "+Tcf+" : "+"MA_Color_Fill out of bouns, please enter 1, 2 , 3 or 4."); Color_Fill_ma=3;
     }
// ======================== Show / Hide MA1 / MA2

   switch(Show_MA1)
     {
      case 1: draw_ma_1 = DRAW_LINE; break;
      case 0: draw_ma_1 = DRAW_NONE;
     }

   switch(Show_MA2)
     {
      case 1: draw_ma_2 = DRAW_LINE; break;
      case 0: draw_ma_2 = DRAW_NONE;
     }

// ======================== MA1 Price Latch

   if(MA1_Price==0)
     {
      MA1_Price_Latch=0;
     }
   else if(MA1_Price==1)
     {
      MA1_Price_Latch=1;
     }
   else if(MA1_Price==2)
     {
      MA1_Price_Latch=2;
     }
   else if(MA1_Price==3)
     {
      MA1_Price_Latch=3;
     }
   else if(MA1_Price==4)
     {
      MA1_Price_Latch=4;
     }
   else if(MA1_Price<0 || MA1_Price>4)
     {
      Alert(Symbol()+" - "+Tcf+" : "+"MA1_Price out of bounds, please enter 0, 1, 2, 3 or 4.");
      MA1_Price_Latch=0;
     }

// ======================== MA2 Price Latch

   if(MA2_Price==0)
     {
      MA2_Price_Latch=0;
     }
   else if(MA2_Price==1)
     {
      MA2_Price_Latch=1;
     }
   else if(MA2_Price==2)
     {
      MA2_Price_Latch=2;
     }
   else if(MA2_Price==3)
     {
      MA2_Price_Latch=3;
     }
   else if(MA2_Price==4)
     {
      MA2_Price_Latch=4;
     }
   else if(MA2_Price<0 || MA2_Price>4)
     {
      Alert(Symbol()+" - "+Tcf+" : "+"MA2_Price out of bounds, please enter 0, 1, 2, 3 or 4.");
      MA2_Price_Latch=0;
     }

// ======================== Labek Bold   

   switch(Label_Bold)
   {
      case 1: Font_Type = "Arial Bold"; break;
      case 0: Font_Type = "Arial"; break;
   }

// ======================== Label Corner YDISTANCE

   if(Label_Corner==0 || Label_Corner==1)
   {
      Y_Dist_MA1 = Label_Up_Down;
      Y_Dist_MA2 = Label_Up_Down + Label_Size*1.7;
   }
   else
   {
      Y_Dist_MA1 = Label_Up_Down + Label_Size*1.7;
      Y_Dist_MA2 = Label_Up_Down;
   }

// ======================== drawing settings & buffers mapping

   SetIndexStyle(0,draw_ma_1);
   SetIndexBuffer(0,ExtMapBuffer_1);
   SetIndexDrawBegin(0,MA1_Period);
   SetIndexShift(0,MA1_Shift);

   SetIndexStyle(1,draw_ma_2);
   SetIndexBuffer(1,ExtMapBuffer_2);
   SetIndexDrawBegin(1,MA2_Period);
   SetIndexShift(1,MA2_Shift);

   a_begin=MA2_Period; if(a_begin<MA1_Period) a_begin=MA1_Period;
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,ExtMapBuffer_A1);
//SetIndexShift(2,0); 

   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,ExtMapBuffer_B1);
//SetIndexShift(3,0); 

   return(0);
  
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i;
   int counted_bars=IndicatorCounted();
   if(Bars<=MA1_Period) return(0);
   ExtCountedBars=IndicatorCounted();
// ======================== check for possible errors
   if(ExtCountedBars<0) return(-1);
// ======================== last counted bar will be recounted
   if(ExtCountedBars>0) ExtCountedBars--;

   switch(MA1_Method)
     {
      case 0 : sma_1();  break;
      case 1 : ema_1();  break;
      case 2 : smma_1(); break;
      case 3 : lwma_1(); break;
      default: Alert(Symbol() + " - " + Tcf + " : " + "MA1_Method out of bounds, please enter 0, 1, 2 or 3."); ema_1();break;
     }

   switch(MA2_Method)
     {
      case 0 : sma_2();  break;
      case 1 : ema_2();  break;
      case 2 : smma_2(); break;
      case 3 : lwma_2(); break;
      default: Alert(Symbol() + " - " + Tcf + " : " + "MA2_Method out of bounds, please enter 0, 1, 2 or 3."); ema_2();break;
     }

// ======================== FILL A

   i=Bars-a_begin+1;
   if(counted_bars>a_begin-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      if(Color_Fill_ma==1 || Color_Fill_ma==2)
        {
         Fill_A_Latch=Close[i];
        }
      else if(Color_Fill_ma==3)
        {
         Fill_A_Latch=ExtMapBuffer_1[i+MA1_Shift];
        }
      else if(Color_Fill_ma==4)
        {
         Fill_A_Latch=NULL;
        }

      ExtMapBuffer_A1[i]=Fill_A_Latch;

      if(Show_Labels==true && Show_MA1==true)
        {
         PLMA1=DoubleToStr(ExtMapBuffer_1[i],Digits);
         textma1="ma1 - ";
        }

      ObjectCreate(ObjLabMA1,OBJ_LABEL,0,0,0);
      ObjectSetText(ObjLabMA1,textma1+PLMA1,Label_Size,Font_Type,MA1_Label_Color);
      ObjectSet(ObjLabMA1,OBJPROP_CORNER,Label_Corner);
      ObjectSet(ObjLabMA1,OBJPROP_XDISTANCE,Label_Left_Right);
      ObjectSet(ObjLabMA1,OBJPROP_YDISTANCE,Y_Dist_MA1);

      i--;
     }

// ======================== FILL B

   i=Bars-0;
    counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MA1_Shift;
   i=limit;
   while(i>=0)
     {
      if(Color_Fill_ma==1)
        {
         Fill_B_Latch=ExtMapBuffer_1[i+MA1_Shift];
        }
      else if(Color_Fill_ma==2 || Color_Fill_ma==3)
        {
         Fill_B_Latch=ExtMapBuffer_2[i+MA2_Shift];
        }
      else if(Color_Fill_ma==4)
        {
         Fill_B_Latch=NULL;
        }

      ExtMapBuffer_B1[i]=Fill_B_Latch;

      if(Show_Labels==true && Show_MA2==true)
        {
         PLMA2=DoubleToStr(ExtMapBuffer_2[i],Digits);
         textma2="ma2 - ";
        }

      ObjectCreate(ObjLabMA2,OBJ_LABEL,0,0,0);
      ObjectSetText(ObjLabMA2,textma2+PLMA2,Label_Size,Font_Type,MA2_Label_Color);
      ObjectSet(ObjLabMA2,OBJPROP_CORNER,Label_Corner);
      ObjectSet(ObjLabMA2,OBJPROP_XDISTANCE,Label_Left_Right);
      ObjectSet(ObjLabMA2,OBJPROP_YDISTANCE,Y_Dist_MA2);

      i--;
     }
   return(rates_total);
}

int deinit()
  {
   ObjectDelete("Labma1");
   ObjectDelete("Labma2");
   
   return(0);
  }
// ======================== MA1 TYPES & PRICE

void sma_1()
  {
   double sum=0;
   int    i,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA1_Period) pos=MA1_Period;
     {
      for(i=1;i<MA1_Period;i++,pos--)
        {
         if(MA1_Price_Latch==0)
           {
            sum+=Close[pos];
           }
         else if(MA1_Price_Latch==1)
           {
            sum+=Open[pos];
           }
         else if(MA1_Price_Latch==2)
           {
            sum+=High[pos];
           }
         else if(MA1_Price_Latch==3)
           {
            sum+=Low[pos];
           }
         else if(MA1_Price_Latch==4)
           {
            sum+=0.5*High[pos]+0.5*Low[pos];
           }
        }
     }
// ======================== main calculation loop
   while(pos>=0)
     {
      if(MA1_Price_Latch==0)
        {
         sum+=Close[pos];
        }
      else if(MA1_Price_Latch==1)
        {
         sum+=Open[pos];
        }
      else if(MA1_Price_Latch==2)
        {
         sum+=High[pos];
        }
      else if(MA1_Price_Latch==3)
        {
         sum+=Low[pos];
        }
      else if(MA1_Price_Latch==4)
        {
         sum+=0.5*High[pos]+0.5*Low[pos];
        }

      ExtMapBuffer_1[pos]=sum/MA1_Period;
      if(MA1_Price_Latch==0)
        {
         sum-=Close[pos+MA1_Period-1];
        }
      else if(MA1_Price_Latch==1)
        {
         sum-=Open[pos+MA1_Period-1];
        }
      else if(MA1_Price_Latch==2)
        {
         sum-=High[pos+MA1_Period-1];
        }
      else if(MA1_Price_Latch==3)
        {
         sum-=Low[pos+MA1_Period-1];
        }
      else if(MA1_Price_Latch==4)
        {
         sum-=0.5*High[pos+MA1_Period-1]+0.5*Low[pos+MA1_Period-1];
        }
      pos--;
     }
// ======================== zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA1_Period;i++) ExtMapBuffer_1[Bars-i]=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ema_1()
  {
   double pr=2.0/(MA1_Period+1);
   int    pos=Bars-2;
   if(ExtCountedBars>2) pos=Bars-ExtCountedBars-1;
// ======================== main calculation loop
   while(pos>=0)
     {
      if(pos==Bars-2)
        {
         if(MA1_Price_Latch==0)
           {
            ExtMapBuffer_1[pos+1]=Close[pos+1];
           }
         else if(MA1_Price_Latch==1)
           {
            ExtMapBuffer_1[pos+1]=Open[pos+1];
           }
         else if(MA1_Price_Latch==2)
           {
            ExtMapBuffer_1[pos+1]=High[pos+1];
           }
         else if(MA1_Price_Latch==3)
           {
            ExtMapBuffer_1[pos+1]=Low[pos+1];
           }
         else if(MA1_Price_Latch==4)
           {
            ExtMapBuffer_1[pos+1]=0.5*High[pos+1]+0.5*Low[pos+1];
           }
        }

      if(MA1_Price_Latch==0)
        {
         ExtMapBuffer_1[pos]=Close[pos]*pr+ExtMapBuffer_1[pos+1]*(1-pr);
        }
      else if(MA1_Price_Latch==1)
        {
         ExtMapBuffer_1[pos]=Open[pos]*pr+ExtMapBuffer_1[pos+1]*(1-pr);
        }
      else if(MA1_Price_Latch==2)
        {
         ExtMapBuffer_1[pos]=High[pos]*pr+ExtMapBuffer_1[pos+1]*(1-pr);
        }
      else if(MA1_Price_Latch==3)
        {
         ExtMapBuffer_1[pos]=Low[pos]*pr+ExtMapBuffer_1[pos+1]*(1-pr);
        }
      else if(MA1_Price_Latch==4)
        {
         ExtMapBuffer_1[pos]=(0.5*High[pos]+0.5*Low[pos])*pr+ExtMapBuffer_1[pos+1]*(1-pr);
        }
      pos--;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void smma_1()
  {
   double sum=0;
   int    i,k,pos=Bars-ExtCountedBars+1;
// ======================== main calculation loop
   pos=Bars-MA1_Period;
   if(pos>Bars-ExtCountedBars) pos=Bars-ExtCountedBars;
     {
      while(pos>=0)
        {
         if(pos==Bars-MA1_Period)
           {
            // ======================== initial accumulation
            for(i=0,k=pos;i<MA1_Period;i++,k++)
              {
               if(MA1_Price_Latch==0)
                 {
                  sum+=Close[k];
                 }
               else if(MA1_Price_Latch==1)
                 {
                  sum+=Open[k];
                 }
               else if(MA1_Price_Latch==2)
                 {
                  sum+=High[k];
                 }
               else if(MA1_Price_Latch==3)
                 {
                  sum+=Low[k];
                 }
               else if(MA1_Price_Latch==4)
                 {
                  sum+=0.5*High[k]+0.5*Low[k];
                 }
               // ======================== zero initial bars
               ExtMapBuffer_1[k]=0;
              }
           }
         else
           {
            if(MA1_Price_Latch==0)
              {
               sum=ExtMapBuffer_1[pos+1]*(MA1_Period-1)+Close[pos];
              }
            else if(MA1_Price_Latch==1)
              {
               sum=ExtMapBuffer_1[pos+1]*(MA1_Period-1)+Open[pos];
              }
            else if(MA1_Price_Latch==2)
              {
               sum=ExtMapBuffer_1[pos+1]*(MA1_Period-1)+High[pos];
              }
            else if(MA1_Price_Latch==3)
              {
               sum=ExtMapBuffer_1[pos+1]*(MA1_Period-1)+Low[pos];
              }
            else if(MA1_Price_Latch==4)
              {
               sum=ExtMapBuffer_1[pos+1]*(MA1_Period-1)+(0.5*High[pos]+0.5*Low[pos]);
              }
           }
         ExtMapBuffer_1[pos]=sum/MA1_Period;
         pos--;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void lwma_1()
  {
   double sum=0.0,lsum=0.0;
   //double price;
   int    i,weight=0,pos=Bars-ExtCountedBars-1;
// ======================== initial accumulation
   if(pos<MA1_Period) pos=MA1_Period;
   for(i=1;i<=MA1_Period;i++,pos--)
     {
      if(MA1_Price_Latch==0)
        {
         price=Close[pos];
        }
      else if(MA1_Price_Latch==1)
        {
         price=Open[pos];
        }
      else if(MA1_Price_Latch==2)
        {
         price=High[pos];
        }
      else if(MA1_Price_Latch==3)
        {
         price=Low[pos];
        }
      else if(MA1_Price_Latch==4)
        {
         price=0.5*High[pos]+0.5*Low[pos];
        }

      sum+=price*i;
      lsum+=price;
      weight+=i;
     }
// ======================== main calculation loop
   pos++;
   i=pos+MA1_Period;
   while(pos>=0)
     {
      ExtMapBuffer_1[pos]=sum/weight;
      if(pos==0) break;
      pos--;
      i--;

      if(MA1_Price_Latch==0)
        {
         price=Close[pos];
        }
      else if(MA1_Price_Latch==1)
        {
         price=Open[pos];
        }
      else if(MA1_Price_Latch==2)
        {
         price=High[pos];
        }
      else if(MA1_Price_Latch==3)
        {
         price=Low[pos];
        }
      else if(MA1_Price_Latch==4)
        {
         price=0.5*High[pos]+0.5*Low[pos];
        }

      sum=sum-lsum+price*MA1_Period;
      if(MA1_Price_Latch==0)
        {
         lsum-=Close[i];
        }
      else if(MA1_Price_Latch==1)
        {
         lsum-=Open[i];
        }
      else if(MA1_Price_Latch==2)
        {
         lsum-=High[i];
        }
      else if(MA1_Price_Latch==3)
        {
         lsum-=Low[i];
        }
      else if(MA1_Price_Latch==4)
        {
         lsum-=0.5*High[i]+0.5*Low[i];
        }

      lsum+=price;
     }
// ======================== zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA1_Period;i++) ExtMapBuffer_1[Bars-i]=0;
  }
// ======================== MA2 TYPES & PRICE    
void sma_2()
  {
   double sum=0;
   int    i,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA2_Period) pos=MA2_Period;
   for(i=1;i<MA2_Period;i++,pos--)
      if(MA2_Price_Latch==0)
        {
         sum+=Close[pos];
        }
   else if(MA2_Price_Latch==1)
     {
      sum+=Open[pos];
     }
   else if(MA2_Price_Latch==2)
     {
      sum+=High[pos];
     }
   else if(MA2_Price_Latch==3)
     {
      sum+=Low[pos];
     }
   else if(MA2_Price_Latch==4)
     {
      sum+=0.5*High[pos]+0.5*Low[pos];
     }
// ======================== main calculation loop
   while(pos>=0)
     {
      if(MA2_Price_Latch==0)
        {
         sum+=Close[pos];
        }
      else if(MA2_Price_Latch==1)
        {
         sum+=Open[pos];
        }
      else if(MA2_Price_Latch==2)
        {
         sum+=High[pos];
        }
      else if(MA2_Price_Latch==3)
        {
         sum+=Low[pos];
        }
      else if(MA2_Price_Latch==4)
        {
         sum+=0.5*High[pos]+0.5*Low[pos];
        }

      ExtMapBuffer_2[pos]=sum/MA2_Period;
      if(MA2_Price_Latch==0)
        {
         sum-=Close[pos+MA2_Period-1];
        }
      else if(MA2_Price_Latch==1)
        {
         sum-=Open[pos+MA2_Period-1];
        }
      else if(MA2_Price_Latch==2)
        {
         sum-=High[pos+MA2_Period-1];
        }
      else if(MA2_Price_Latch==3)
        {
         sum-=Low[pos+MA2_Period-1];
        }
      else if(MA2_Price_Latch==4)
        {
         sum-=0.5*High[pos+MA2_Period-1]+0.5*Low[pos+MA2_Period-1];
        }
      pos--;
     }
// ======================== zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA2_Period;i++) ExtMapBuffer_2[Bars-i]=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ema_2()
  {
   double pr=2.0/(MA2_Period+1);
   int    pos=Bars-2;
   if(ExtCountedBars>2) pos=Bars-ExtCountedBars-1;
// ======================== main calculation loop
   while(pos>=0)
     {
      if(pos==Bars-2)
        {
         if(MA2_Price_Latch==0)
           {
            ExtMapBuffer_2[pos+1]=Close[pos+1];
           }
         else if(MA2_Price_Latch==1)
           {
            ExtMapBuffer_2[pos+1]=Open[pos+1];
           }
         else if(MA2_Price_Latch==2)
           {
            ExtMapBuffer_2[pos+1]=High[pos+1];
           }
         else if(MA2_Price_Latch==3)
           {
            ExtMapBuffer_2[pos+1]=Low[pos+1];
           }
         else if(MA2_Price_Latch==4)
           {
            ExtMapBuffer_2[pos+1]=0.5*High[pos+1]+0.5*Low[pos+1];
           }
        }

      if(MA2_Price_Latch==0)
        {
         ExtMapBuffer_2[pos]=Close[pos]*pr+ExtMapBuffer_2[pos+1]*(1-pr);
        }
      else if(MA2_Price_Latch==1)
        {
         ExtMapBuffer_2[pos]=Open[pos]*pr+ExtMapBuffer_2[pos+1]*(1-pr);
        }
      else if(MA2_Price_Latch==2)
        {
         ExtMapBuffer_2[pos]=High[pos]*pr+ExtMapBuffer_2[pos+1]*(1-pr);
        }
      else if(MA2_Price_Latch==3)
        {
         ExtMapBuffer_2[pos]=Low[pos]*pr+ExtMapBuffer_2[pos+1]*(1-pr);
        }
      else if(MA2_Price_Latch==4)
        {
         ExtMapBuffer_2[pos]=(0.5*High[pos]+0.5*Low[pos])*pr+ExtMapBuffer_2[pos+1]*(1-pr);
        }
      pos--;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void smma_2()
  {
   double sum=0;
   int    i,k,pos=Bars-ExtCountedBars+1;
// ======================== main calculation loop
   pos=Bars-MA2_Period;
   if(pos>Bars-ExtCountedBars) pos=Bars-ExtCountedBars;
     {
      while(pos>=0)
        {
         if(pos==Bars-MA2_Period)
           {
            //---- initial accumulation
            for(i=0,k=pos;i<MA2_Period;i++,k++)
              {
               if(MA2_Price_Latch==0)
                 {
                  sum+=Close[k];
                 }
               else if(MA2_Price_Latch==1)
                 {
                  sum+=Open[k];
                 }
               else if(MA2_Price_Latch==2)
                 {
                  sum+=High[k];
                 }
               else if(MA2_Price_Latch==3)
                 {
                  sum+=Low[k];
                 }
               else if(MA2_Price_Latch==4)
                 {
                  sum+=0.5*High[k]+0.5*Low[k];
                 }
               // ======================== zero initial bars
               ExtMapBuffer_2[k]=0;
              }
           }
         else
           {
            if(MA2_Price_Latch==0)
              {
               sum=ExtMapBuffer_2[pos+1]*(MA2_Period-1)+Close[pos];
              }
            else if(MA2_Price_Latch==1)
              {
               sum=ExtMapBuffer_2[pos+1]*(MA2_Period-1)+Open[pos];
              }
            else if(MA2_Price_Latch==2)
              {
               sum=ExtMapBuffer_2[pos+1]*(MA2_Period-1)+High[pos];
              }
            else if(MA2_Price_Latch==3)
              {
               sum=ExtMapBuffer_2[pos+1]*(MA2_Period-1)+Low[pos];
              }
            else if(MA2_Price_Latch==4)
              {
               sum=ExtMapBuffer_2[pos+1]*(MA2_Period-1)+(0.5*High[pos]+0.5*Low[pos]);
              }
           }
         ExtMapBuffer_2[pos]=sum/MA2_Period;
         pos--;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void lwma_2()
  {
   double sum=0.0,lsum=0.0;
   //double price;
   int    i,weight=0,pos=Bars-ExtCountedBars-1;
// ======================== initial accumulation
   if(pos<MA2_Period) pos=MA2_Period;
   for(i=1;i<=MA2_Period;i++,pos--)
     {
      if(MA2_Price_Latch==0)
        {
         price=Close[pos];
        }
      else if(MA2_Price_Latch==1)
        {
         price=Open[pos];
        }
      else if(MA2_Price_Latch==2)
        {
         price=High[pos];
        }
      else if(MA2_Price_Latch==3)
        {
         price=Low[pos];
        }
      else if(MA2_Price_Latch==4)
        {
         price=0.5*High[pos]+0.5*Low[pos];
        }

      sum+=price*i;
      lsum+=price;
      weight+=i;
     }
// ======================== main calculation loop
   pos++;
   i=pos+MA2_Period;
   while(pos>=0)
     {
      ExtMapBuffer_2[pos]=sum/weight;
      if(pos==0) break;
      pos--;
      i--;

      if(MA2_Price_Latch==0)
        {
         price=Close[pos];
        }
      else if(MA2_Price_Latch==1)
        {
         price=Open[pos];
        }
      else if(MA2_Price_Latch==2)
        {
         price=High[pos];
        }
      else if(MA2_Price_Latch==3)
        {
         price=Low[pos];
        }
      else if(MA2_Price_Latch==4)
        {
         price=0.5*High[pos]+0.5*Low[pos];
        }

      sum=sum-lsum+price*MA2_Period;
      if(MA2_Price_Latch==0)
        {
         lsum-=Close[i];
        }
      else if(MA2_Price_Latch==1)
        {
         lsum-=Open[i];
        }
      else if(MA2_Price_Latch==2)
        {
         lsum-=High[i];
        }
      else if(MA2_Price_Latch==3)
        {
         lsum-=Low[i];
        }
      else if(MA2_Price_Latch==4)
        {
         lsum-=0.5*High[i]+0.5*Low[i];
        }

      lsum+=price;
     }
// ======================== zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA2_Period;i++) ExtMapBuffer_2[Bars-i]=0;
  }
//+------------------------------------------------------------------+
 