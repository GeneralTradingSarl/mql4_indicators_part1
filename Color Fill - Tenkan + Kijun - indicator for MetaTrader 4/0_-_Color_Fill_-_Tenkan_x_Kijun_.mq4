//+------------------------------------------------------------------+
//|                                                     Ichimoku.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net  |
//| Color Fill - Tenkan + Kijun: Author - File45, 2013               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 CornflowerBlue
#property indicator_style3 STYLE_DOT
#property indicator_color4 HotPink
#property indicator_style4 STYLE_DOT

// ======================== input parameters

extern int Color_Fill_1_2_3_or_4=3;
extern int Tenkan_sen_Period=50;
extern int Kijun_sen_Period=100;

extern int Label_Size=12;
extern bool Label_Bold=false;
extern color TS_Label_Color = indicator_color1;
extern color KS_Label_Color = indicator_color2;

extern int Label_Corner=3;
extern int Label_Left_Right=10;
extern int Label_Up_Down=20;

extern bool Show_Tenkan_sen=true;
extern bool Show_Kijun_sen=true;
extern bool Show_Labels=true;

//---- buffers
double Tenkan_Buffer[];
double Kijun_Buffer[];
double Fill_A_Buffer[];
double Fill_B_Buffer[];

int a_begin;
int Color_Fill_tsks;

double Fill_A_Switch;
double Fill_B_Switch;

string Ttk;
string ObjLab_TS="labts";
string ObjLab_KS="labks";
string text_ts;
string text_ks;
string Font_Type;

int Y_Dist_TS;
int Y_Dist_KS;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   switch(Period())
     {
      case 1:     Ttk = "M1";  break;
      case 5:     Ttk = "M5";  break;
      case 15:    Ttk = "H15"; break;
      case 30:    Ttk = "M30"; break;
      case 60:    Ttk = "H1";  break;
      case 240:   Ttk = "H4";  break;
      case 1440:  Ttk = "D1";  break;
      case 10080: Ttk = "W1";  break;
      case 43200: Ttk = "M4";  break;
     }

   switch(Color_Fill_1_2_3_or_4)
     {
      case 1: Color_Fill_tsks = 1; break;
      case 2: Color_Fill_tsks = 2; break;
      case 3: Color_Fill_tsks = 3; break;
      case 4: Color_Fill_tsks = 4; break;
      default: Alert(Symbol()+" - "+Ttk+" : "+"Color_Fill out of bounds, please enter 1, 2 , 3 or 4."); Color_Fill_tsks=3;
     }

// ======================== Label Corner YDISTANCE

   if(Label_Corner==0 || Label_Corner==1)
     {
      Y_Dist_TS = Label_Up_Down;
      Y_Dist_KS = Label_Up_Down + Label_Size*1.7;
     }
   else
     {
      Y_Dist_TS = Label_Up_Down + Label_Size*1.7;
      Y_Dist_KS = Label_Up_Down;
     }

// ======================== Labek Bold   

   switch(Label_Bold)
     {
      case 1: Font_Type = "Arial Bold"; break;
      case 0: Font_Type = "Arial"; break;
     }

// ======================== drawing settings & buffers mapping

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Tenkan_Buffer);
   SetIndexDrawBegin(0,Tenkan_sen_Period-1);
//SetIndexLabel(0,"Tenkan_sen_Period Sen");

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Kijun_Buffer);
   SetIndexDrawBegin(1,Kijun_sen_Period-1);
//SetIndexLabel(1,"Kijun_sen_Period Sen");

   a_begin=Kijun_sen_Period; if(a_begin<Tenkan_sen_Period) a_begin=Tenkan_sen_Period;
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,Fill_A_Buffer);
   SetIndexLabel(2,NULL);

   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,Fill_B_Buffer);
//SetIndexLabel(3,NULL);

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   double high,low,price;

//if(Bars<=Tenkan_sen_Period || Bars<=Kijun_sen_Period || Bars<=Senkou);
   if(Bars<=Tenkan_sen_Period || Bars<=Kijun_sen_Period) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(Tenkan_sen_Period,Kijun_sen_Period);

// ======================== initial zero
//   if(counted_bars<1)
//   {
//    for(i=1;i<=Tenkan_sen_Period;i++)    
//       Tenkan_Buffer[Bars-i]=0;
//    for(i=1;i<=Kijun_sen_Period;i++)     
//       Kijun_Buffer[Bars-i]=0;
//    for(i=1;i<=a_begin;i++) 
//       {Fill_A_Buffer[Bars-i]=0; /*SpanA2_Buffer[Bars-i]=0;*/ }
//    for(i=1;i<=0;i++)  
//       { Fill_B_Buffer[Bars-i]=0; /*SpanB2_Buffer[Bars-i]=0;*/ }
//   }
// ======================== Tenkan_sen_Period Sen
   i=limit;
   while(i>=0)
     {
      if(Show_Tenkan_sen==true)
        {
         high=High[i]; low=Low[i]; k=i-1+Tenkan_sen_Period;
         while(k>=i)
           {
            price=High[k];
            if(high<price) high=price;
            price=Low[k];
            if(low>price) low=price;
            k--;
           }
         Tenkan_Buffer[i]=(high+low)/2;
        }
      else
        {
         Tenkan_Buffer[i]=NULL;
        }
      i--;
     }
// ======================== kijun Sen
   i=limit;
   while(i>=0)
     {
      if(Show_Kijun_sen==true)
        {
         high=High[i]; low=Low[i]; k=i-1+Kijun_sen_Period;
         while(k>=i)
           {
            price=High[k];
            if(high<price) high=price;
            price=Low[k];
            if(low>price) low=price;
            k--;
           }
         Kijun_Buffer[i]=(high+low)/2;
        }
      else
        {
         Kijun_Buffer[i]=NULL;
        }
      i--;
     }
// ======================== Color Fill A
   i=limit;
   while(i>=0)
     {
      if(Color_Fill_tsks==1 || Color_Fill_tsks==2)
        {
         Fill_A_Switch=Close[i];
        }
      else if(Color_Fill_tsks==3)
        {
         high=High[i]; low=Low[i]; k=i-1+Tenkan_sen_Period;
         while(k>=i)
           {
            price=High[k];
            if(high<price) high=price;
            price=Low[k];
            if(low>price) low=price;
            k--;
           }
         Fill_A_Switch=(high+low)/2;
        }
      else if(Color_Fill_tsks==4)
        {
         Fill_A_Switch=NULL;
        }

      Fill_A_Buffer[i]=Fill_A_Switch;

      // ======================== TS Label

      if(Show_Labels==true && Show_Tenkan_sen==true)
        {
         string TS=DoubleToStr(Tenkan_Buffer[i],Digits);
         text_ts="TS - ";
        }

      ObjectCreate(ObjLab_TS,OBJ_LABEL,0,0,0);
      ObjectSetText(ObjLab_TS,text_ts+TS,Label_Size,Font_Type,TS_Label_Color);
      ObjectSet(ObjLab_TS,OBJPROP_CORNER,Label_Corner);
      ObjectSet(ObjLab_TS,OBJPROP_XDISTANCE,Label_Left_Right);
      ObjectSet(ObjLab_TS,OBJPROP_YDISTANCE,Y_Dist_TS);

      i--;
     }
// ======================== Color Fill B
   i=limit;
   while(i>=0)
     {
      if(Color_Fill_tsks==1)
        {
         high=High[i]; low=Low[i]; k=i-1+Tenkan_sen_Period;
         while(k>=i)
           {
            price=High[k];
            if(high<price) high=price;
            price=Low[k];
            if(low>price) low=price;
            k--;
           }
         Fill_B_Switch=(high+low)/2;
        }
      else if(Color_Fill_tsks==2 || Color_Fill_tsks==3)
        {
         high=High[i]; low=Low[i]; k=i-1+Kijun_sen_Period;
         while(k>=i)
           {
            price=High[k];
            if(high<price) high=price;
            price=Low[k];
            if(low>price) low=price;
            k--;
           }
         Fill_B_Switch=(high+low)/2;
        }
      else if(Color_Fill_tsks==4)
        {
         Fill_B_Switch=NULL;
        }
      Fill_B_Buffer[i]=Fill_B_Switch;

      // ======================== KS Label      

      if(Show_Labels==true && Show_Kijun_sen==true)
        {
         string KS=DoubleToStr(Kijun_Buffer[i],Digits);
         text_ks="KS - ";
        }

      ObjectCreate(ObjLab_KS,OBJ_LABEL,0,0,0);
      ObjectSetText(ObjLab_KS,text_ks+KS,Label_Size,Font_Type,KS_Label_Color);
      ObjectSet(ObjLab_KS,OBJPROP_CORNER,Label_Corner);
      ObjectSet(ObjLab_KS,OBJPROP_XDISTANCE,Label_Left_Right);
      ObjectSet(ObjLab_KS,OBJPROP_YDISTANCE,Y_Dist_KS);
      i--;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("labts");
   ObjectDelete("labks");
  }   
//+------------------------------------------------------------------+
