//+------------------------------------------------------------------+
//|                                                 #MarketPrice.mq4 |
//|                                                       ServerUang |
//|                                    http://www.indofx-trader.net/ |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                               BS_#MarketPrice.mq4|
//|                                    edited by masemus             |
//+------------------------------------------------------------------+
#property copyright "ServerUang"
#property link      "http://www.indofx-trader.net/"
#property indicator_separate_window
//----
extern string Indicator_Name="BS_#MarketPrice";
extern bool Right_Top=true;
extern int Shift_Y=0;
extern int Shift_X=0;
// Untuk menentukan Warna Harga sesuai arah Trend
extern string Price_Variable="Setting for Price Color";// change
extern color Price_color_Up               =clrBlue;
extern color Price_color_Dn               =clrRed;
extern int Time_Frame=15;
//----
extern int MA_Fast_Period=1;
extern int MA_Fast_Method=0;
extern int MA_Fast_Apply_To=0;
extern int MA_Fast_Shift=0;
//----
extern int MA_Slow_Period=4;
extern int MA_Slow_Method=0;
extern int MA_Slow_Apply_To=0;
extern int MA_Slow_Shift=0;
//----
extern string Value_Color="Setting for Value Color";
extern color Highest_Color                =clrWhite;
extern color Distance_from_Highest_Color  =clrGainsboro;
extern color Lowest_Color                 =clrYellow;
extern color Distance_from_Lowest_Color   =clrGold;
extern color Hi_to_Lo_Color               =clrWhite;
extern color Daily_Av_Up_Color            =clrLime;
extern color Daily_Av_Dn_Color            =clrOrange;
extern color Time_n_Spread_Color          =clrAqua;
extern color PipsToOpen_Up_Color          =clrLightSkyBlue;
extern color PipsToOpen_Dn_Color          =clrSalmon;
//----
extern string Xtra_Information="Setting for Extra information";
extern bool  Show_Xtra_Info=true;
//----
extern color Label_color                  =clrSilver;
extern color Text_Xtreme_Up_Color         =clrWhite;
extern color Text_Up_Color                =clrLightBlue;
extern color Text_Dn_Color                =clrOrange;
extern color Text_Xtreme_Dn_Color         =clrYellow;
// Untuk menentukan arah Trend
extern string Trend_Variable="Variable TRend Direction";// change
extern int   xMA_Fast_Period    =1;
extern int   xMA_Fast_Method    =0;
extern int   xMA_Fast_Apply_To  =0;
extern int   xMA_Fast_Shift     =0;
//----
extern int   xMA_Slow_Period    =20;
extern int   xMA_Slow_Method    =0;
extern int   xMA_Slow_Apply_To  =0;
extern int   xMA_Slow_Shift     =0;
extern color Trend_Up_Color               =clrBlue;
extern color Trend_Dn_Color               =clrRed;
//=================================================================================
string Label_Teks="",Huruf="",Teks="",nomor="";
double Nilai,x,y,d_A,d_B,TF,Range,bbP,bbMid,bbM,nilaiWarnaCandle;
color  WarnaHarga,WarnaTrend,WarnaCandle;
int    Ukuran,n,Kolom;
// --- variabel Daili_Av --------------------------------------------
int    R1,R5,R10,R20,RAvg,i;
string Teks_ReRata="",Teks_Rerata_Kemarin="",Nomor="";
color  Warna_ReRata;
// --- Variabel Time for next candle
string Teks_Menit,Teks_Detik;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0,OBJ_HLINE);
   ObjectsDeleteAll(0,OBJ_TEXT);
   ObjectsDeleteAll(0,OBJ_LABEL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int    counted_bars=IndicatorCounted();
//Menampilkan Harga
   Nilai=iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0); Teks=DoubleToStr(Nilai,Digits);
   Huruf="Arial"; Ukuran=18; x=5+Shift_X; y=5+Shift_Y;
// WarnaHarga=WarnaLampu pada trend TF 5 menit
   d_B=iMA(Symbol(),Time_Frame,MA_Fast_Period,MA_Fast_Shift,MA_Fast_Method,MA_Fast_Apply_To,0);
   d_A=iMA(Symbol(),Time_Frame,MA_Slow_Period,MA_Slow_Shift,MA_Slow_Method,MA_Slow_Apply_To,0);
   WarnaHarga=CheckWarna(d_B,d_A,Price_color_Up,Price_color_Dn);
   Tulis("MP01",Right_Top,x,y,Teks,Ukuran,Huruf,WarnaHarga);
//----
   Huruf="Tahoma Bold"; Ukuran=10;
   d_A=iHigh(NULL,1440,0); Teks=DoubleToStr(d_A, Digits);
   d_B=iLow(NULL,1440,0); Teks=DoubleToStr(d_B, Digits);
//--- Informasi Hi to Lo ---
   Teks=DoubleToStr((d_A-d_B)/Point,0);
   x=40+Shift_X; y=5+Shift_Y;
   Tulis("MP06",Right_Top,x,y,Teks,Ukuran,Huruf,Hi_to_Lo_Color);
   Tulis("MP22",Right_Top,x-11,y+0," Curr: ",7,Huruf,Label_color);
//--- Informasi Daily Av ---
   R1=0; R5=0; R10=0; R20=0; RAvg=0; i=0;
   R1= (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   for(i=1;i<=5;i++)
      R5=R5+(iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=10;i++)
      R10=R10+(iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=20;i++)
      R20=R20+(iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
//----
   R5=R5/5;
   R10=R10/10;
   R20=R20/20;
   RAvg=(R1+R5+R10+R20)/4;
//----
   Teks_ReRata=(DoubleToStr(RAvg,Digits-4));
   Teks_Rerata_Kemarin=(iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
//----
   if(Teks_ReRata>Teks_Rerata_Kemarin) {Warna_ReRata=Daily_Av_Up_Color;}
   else {Warna_ReRata=Daily_Av_Dn_Color;}
//----
   x=40+Shift_X; y=45+Shift_Y;
   Tulis("MP07",Right_Top,x,y,Teks_ReRata,Ukuran,Huruf,Warna_ReRata);
   Tulis("MP23",Right_Top,x-11,y+0," D.Av: ",7,Huruf,Label_color);
//Time for Next Candle
   d_B=(Time[4]-Time[5])-MathMod(CurTime(),Time[4]-Time[5]);
   d_A=d_B/60;
   d_B=(d_A-MathFloor(d_A))*60;
   d_A=MathFloor(d_A);
   Teks_Menit=DoubleToStr(d_A,0);
   Teks_Detik=DoubleToStr(d_B,0);
   Teks=Teks_Menit+":"+Teks_Detik;
   x=185+Shift_X; y=5+Shift_Y;
   Tulis("MP08",Right_Top,x,y,Teks,Ukuran,Huruf,Time_n_Spread_Color);
   Tulis("MP24",Right_Top,x-11,y+0," Time : ",7,Huruf,Label_color);
// --- Spread
   d_A=(Ask-Bid)/Point;
   Teks=(DoubleToStr(d_A,Digits-4));
   x=68+Shift_X; y=45+Shift_Y;
   Tulis("MP09",Right_Top,x,y,Teks,Ukuran,Huruf,Time_n_Spread_Color);
   Tulis("MP25",Right_Top,x-11,y+0," Sprd: ",7,Huruf,Label_color);
//--- Informasi from Pips to Open ---
   d_A=iOpen(NULL,1440,0);
   d_B=iClose(NULL,1440,0);
   WarnaHarga=CheckWarna(d_B,d_A,PipsToOpen_Up_Color,PipsToOpen_Dn_Color);
   Teks=DoubleToStr((d_B-d_A)/Point,0);
   x=68+Shift_X; y=5+Shift_Y;
   Tulis("MP10",Right_Top,x,y,Teks,Ukuran,Huruf,WarnaHarga);
   Tulis("MP26",Right_Top,x-11,y+0," To Op: ",7,Huruf,Label_color);
//--- Show_Xtra_Info ---
   if(Show_Xtra_Info)
     {//--- Info TRend ---
      Huruf="Trebucet"; Ukuran=7;
      if(Right_Top) {Teks="BS  TR";}
      else {Teks="TR  BS";}
      x=156+Shift_X; y=3+Shift_Y+4;
      Tulis("MP11",Right_Top,x,y,Teks,Ukuran,Huruf,Label_color);
      Tulis("MP12",Right_Top,x-66,y+32," 240 ",Ukuran,Huruf,Label_color);
      Tulis("MP13",Right_Top,x-55,y+32," 60 ",Ukuran,Huruf,Label_color);
      Tulis("MP14",Right_Top,x-44,y+32," 30 ",Ukuran,Huruf,Label_color);
      Tulis("MP15",Right_Top,x-33,y+32," 15 ",Ukuran,Huruf,Label_color);
      Tulis("MP16",Right_Top,x-22,y+32," 5 ",Ukuran,Huruf,Label_color);
      Tulis("MP17",Right_Top,x-11,y+32," 1 ",Ukuran,Huruf,Label_color);
      n=1;
      while(n<=6)
        {
         switch(n)
           {
            case  1: TF=   1;  Range=2; break;
            case  2: TF=   5;  Range=(Ask - Bid)/Point; break;
            case  3: TF=  15;  Range=(Ask - Bid)/Point; break;
            case  4: TF=  30;  Range=(Ask - Bid)/Point; break;
            case  5: TF=  60;  Range=(Ask - Bid)/Point; break;
            case  6: TF=  240;  Range=(Ask - Bid)/Point; break;
            //case 7: TF = 1440;  break;
           }//switch
         nomor=DoubleToStr(n,0); x=125+Shift_X; y=23+Shift_Y+5; Kolom=11;
         Huruf="Arial Bold"; Ukuran=40;
         d_B=iMA(Symbol(),TF, xMA_Fast_Period, xMA_Fast_Shift, xMA_Fast_Method, xMA_Fast_Apply_To,0);
         d_A=iMA(Symbol(),TF, xMA_Slow_Period, xMA_Slow_Shift, xMA_Slow_Method, xMA_Slow_Apply_To,0);
         WarnaTrend=CheckWarna(d_B,d_A,Trend_Up_Color,Trend_Dn_Color);
         Tulis("MP18"+nomor,Right_Top,x-(n*Kolom),y-23,"-",Ukuran,Huruf,WarnaTrend);
         //BuySeLL
         d_B=iMA(Symbol(),TF, 1, 0, 0, 0, 0);
         d_A=iMA(Symbol(),TF, 4, 0, 0, 0, 0);
         WarnaTrend=CheckWarna(d_B,d_A,Trend_Up_Color,Trend_Dn_Color);
         Tulis("MP19"+nomor,Right_Top,x-(n*Kolom),y-5,"-",Ukuran,Huruf,WarnaTrend);
         //Huruf="Tahoma Narrow"; Ukuran=7; x=10+Shift_X; y=88+Shift_Y+44;
         //Tulis("MP20", Right_Top, x, y, "Created by ServerUang", Ukuran, Huruf, Gray);
         n++;
        }//while
     }//Show
   else
     {
      Huruf="Tahoma Narrow"; Ukuran=7; x=10+Shift_X; y=88+Shift_Y+4;
      Tulis("MP21",Right_Top,x,y,"Created by ServerUang",Ukuran,Huruf,Gray);
     }
//----
   return(0);
  }
// Prosedur Tulis
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Tulis(string LBL,double sebelah,int pos_x,int pos_y,string teks,int ukuran_huruf,string nama_huruf,color warna=CLR_NONE)
  {
   Label_Teks=LBL;
   ObjectCreate(LBL,OBJ_LABEL,1,0,0);
   ObjectSetText(LBL,teks,ukuran_huruf,nama_huruf,warna);
   ObjectSet(LBL,OBJPROP_CORNER,sebelah);
   ObjectSet(LBL,OBJPROP_XDISTANCE,pos_y);
   ObjectSet(LBL,OBJPROP_YDISTANCE,pos_x);
  }
// Function CheckWarna
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color CheckWarna(double a,double b,color U,color D)
  {
   if(a>b) { return(U); } else { return(D); }
  }
//+------------------------------------------------------------------+
