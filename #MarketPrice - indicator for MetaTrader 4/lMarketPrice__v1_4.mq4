//+------------------------------------------------------------------+
//|                                           #MarketPrice _v1_4.mq4 |
//|                                                       ServerUang |
//|                                    http://www.indofx-trader.net/ |
//+------------------------------------------------------------------+
#property copyright "ServerUang"
#property link      "http://www.indofx-trader.net/"

#property indicator_chart_window
extern string Settings_n_1 = "--------------------------";
extern int Side = 1;
extern int MP_Y = 0; 
extern int MP_X = 0;

//--------------------------------------------------------------------
extern string Settings_n_2 = "--------------------------";
extern string Colors_Setting ="Setting for Colors";
extern color Highest_Color          = Blue;
extern color Distance_from_Highest_Color = DodgerBlue;
extern color Lowest_Color           = Red;
extern color Distance_from_Lowest_Color  = OrangeRed;
extern color Hi_to_Lo_Color         = Peru;
extern color Daily_Av_Up_Color      = Blue;
extern color Daily_Av_Dn_Color      = Red;
extern color Time_n_Spread_Color    = LimeGreen;
extern color PipsToOpen_Up_Color    = Blue;
extern color PipsToOpen_Dn_Color    = Red;

//--------------------------------------------------------------------
extern string Settings_n_3 = "--------------------------";
extern string Signals_Settings = "Settings for Signals"; 
extern bool  Show_Signals      = true;

// BuySeLL Variable
extern string BuySeLL_Settings = "--------------------------";
extern int MAFast_Period = 1; 
extern int MAFast_Method = 0; 
extern int MAFast_Apply_To = 0;
extern int MAFast_Shift = 0;

extern int MASlow_Period = 4; 
extern int MASlow_Method = 0;
extern int MASlow_Apply_To = 1;
extern int MASlow_Shift = 0;

// Trend Variable
extern string TRend_Settings = "--------------------------";
extern int TMAFast_Period = 1; 
extern int TMAFast_Method = 0; 
extern int TMAFast_Apply_To = 0;
extern int TMAFast_Shift = 0;

extern int TMASlow_Period = 20; 
extern int TMASlow_Method = 0;
extern int TMASlow_Apply_To = 0;
extern int TMASlow_Shift = 0;

// Strength Variable
extern string Strength_Settings = "--------------------------";
extern int RSI_Period = 5;
extern int RSI_PRICE_TYPE = 0;

extern int CCI_Period = 20;
extern int CCI_PRICE_TYPE = 0;

extern int STOCH_K_Period = 5;
extern int STOCH_D_Period = 3;
extern int STOCH_Slowing = 3;
extern int STOCH_MA_MODE = 0;
extern int STOCH_Price_Field = 0;

//--------------------------------------------------------------------
extern string Settings_n_4 = "--------------------------";
extern color LegendColor = Gainsboro;
extern color PriceColor_Up = Blue;
extern color PriceColor_Dn = Red;
extern color NeutralColor = LightGray;

extern color Arrow_Up = Lime;
extern color Arrow_Dn = Gold;
extern color Arrow_Nt = White;

//===================================================================+
double vA, vB, vC, TFs, High_Lama, Low_Lama;
int TimeFrame, x, y, space, baris, fontsize, cTF, cCC, cX, cSTR, cTR;
string text, fontname, Teks_Menit, Teks_Detik;
string UpSymbol="ñ",  DnSymbol="ò", NtSymbol="«", SignalSymbol;
color SignalColor;

// --- variabel Daili_Av --------------------------------------------+
int    R1, R5, R10, R20, RAvg, n, i;
string Teks_ReRata = "", Teks_Rerata_Kemarin ="";
color  warna_ReRata, WarnaTeks;
//-------------------------------------------------------------------+

// --- Strength Variable ---
double v_RSI, v_Stoch, v_CCI;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
     for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       if(StringSubstr(label, 0, 4) != "MP14")
           continue;
       ObjectDelete(label);   
     }   //----
   return(0);
   
   //ObjectsDeleteAll(0,OBJ_HLINE);
   //ObjectsDeleteAll(0,OBJ_TEXT);
   //ObjectsDeleteAll(0,OBJ_LABEL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   // Price
   TimeFrame = 15;
   vA = iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
   vB = iMA(Symbol(), TimeFrame, MAFast_Period, MAFast_Shift, MAFast_Method, MAFast_Apply_To, 0);
   vC = iMA(Symbol(), TimeFrame, MASlow_Period, MASlow_Shift, MASlow_Method, MASlow_Apply_To, 0);
   Write("MP14001", Side, MP_X+9, MP_Y+22, DoubleToStr(vA,Digits), 34, "Arial", CheckColor(vB, vC, PriceColor_Up, PriceColor_Dn) );

   // Highest
   vB=iHigh(NULL,1440,0); text=DoubleToStr(vB, Digits);
   Write("MP14002", Side, MP_X+100, MP_Y+14, text, 10, "Tahoma Bold", Highest_Color);
   
   // Lowest
   vC=iLow(NULL,1440,0); text=DoubleToStr(vC, Digits);
   Write("MP14003", Side, MP_X+100, MP_Y+62, text, 10, "Tahoma Bold", Lowest_Color);
   
   //--- Distance from Highest ---
   text=DoubleToStr((vA-vB)/Point,0);
   Write("MP14004", Side, MP_X+56, MP_Y+14, text, 10, "Tahoma Bold", Distance_from_Highest_Color);
   
   //--- Distance from Lowest ---
   text=DoubleToStr((vA-vC)/Point,0);
   Write("MP14005", Side, MP_X+56, MP_Y+62, text, 10, "Tahoma Bold", Distance_from_Lowest_Color);
   
   //--- Hi to Lo ---
   text=DoubleToStr((vB-vC)/Point,0);
   Write("MP14006", Side, MP_X+10, MP_Y+14, text, 10, "Tahoma Bold", Hi_to_Lo_Color);
   
   //--- Daily Av ---
   R1=0; R5=0; R10=0; R20=0; RAvg=0; i=0;
   R1 =  (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   for(i=1;i<=5;i++)   
     R5  = R5  + (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=10;i++)
     R10 = R10 + (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=20;i++)
     R20 = R20 + (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;

   R5 = R5/5;
   R10 = R10/10;
   R20 = R20/20;
   RAvg  =  (R1+R5+R10+R20)/4;    
   
   Teks_ReRata = (DoubleToStr(RAvg,Digits-4));
   Teks_Rerata_Kemarin = (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   
   if (Teks_ReRata > Teks_Rerata_Kemarin) {warna_ReRata = Daily_Av_Up_Color;}
      else {warna_ReRata = Daily_Av_Dn_Color;}
      
   Write("MP14007", Side, MP_X+10, MP_Y+62, Teks_ReRata, 10, "Tahoma Bold", warna_ReRata);
   
   //--- Time for Next Candle ---
   vB = (Time[4]-Time[5])-MathMod(CurTime(),Time[4]-Time[5]);
   vA = vB/60;
   vB = (vA-MathFloor(vA))*60;
   vA = MathFloor(vA);
   Teks_Menit = DoubleToStr(vA,0);
   Teks_Detik = DoubleToStr(vB,0);
   text=Teks_Menit+":"+Teks_Detik;
   Write("MP14008", Side, MP_X+100, MP_Y+74, text, 10, "Tahoma Bold", Time_n_Spread_Color);
   
   // --- Spread ---
   vA = (Ask - Bid)/Point;
   text = (DoubleToStr(vA, Digits-4));
   Write("MP14009", Side, MP_X+56, MP_Y+74, text, 10, "Tahoma Bold", Time_n_Spread_Color);
   
   //--- Pips to Open ---
   vA = iOpen(NULL,1440,0);
   vB = iClose(NULL,1440,0);
   SignalColor=CheckColor(vB, vA, PipsToOpen_Up_Color, PipsToOpen_Dn_Color);
   text=DoubleToStr((vB-vA)/Point,0);
   Write("MP14010", Side, MP_X+10, MP_Y+74, text, 10, "Tahoma Bold", SignalColor);
   
   //--- Show_Signals ---
   if (Show_Signals)
      {
/*
       // Pair, Pair color depand to Trend
       vB = iMA(Symbol(), TimeFrame, TMAFast_Period, TMAFast_Shift, TMAFast_Method, TMAFast_Apply_To, 0);
       vC = iMA(Symbol(), TimeFrame, TMASlow_Period, TMASlow_Shift, TMASlow_Method, TMASlow_Apply_To, 0);
       Write("MP13001", Side, 85, 8, Symbol(), 16, "Arial Bold", CheckColor(vB, vC, PriceColor_Up, PriceColor_Dn) );
   
       // Price  color depand to Crossing MAfast and MAslow
       vA = iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
       vB = iMA(Symbol(), TimeFrame, MAFast_Period, MAFast_Shift, MAFast_Method, MAFast_Apply_To, 0);
       vC = iMA(Symbol(), TimeFrame, MASlow_Period, MASlow_Shift, MASlow_Method, MASlow_Apply_To, 0);
       Write("MP13002", Side, 5, 5, DoubleToStr(vA,Digits), 20, "Arial Bold", CheckColor(vB, vC, PriceColor_Up, PriceColor_Dn) );
       //Write("MP13002", Side, 10, 10, DoubleToStr(vA,Digits), 16, "Arial Bold", CheckColor(vB, vC, PriceColor_Up, PriceColor_Dn) );
*/   
       // Legend
       //cTF=MP_X+127; cCC=MP_X+99; cX=MP_X+81; cSTR=MP_X+53; cTR=MP_X+25; 
       cTF=MP_X+127; cCC=MP_X+99; cX=MP_X+76; cSTR=MP_X+40; cTR=MP_X+10; 
       Write("MP14011", Side, MP_X+cTF,  MP_Y+90, "TF", 10, "Arial", LegendColor); //152
       Write("MP14012", Side, MP_X+cCC,  MP_Y+90, "CC", 10, "Arial", LegendColor); //116
       Write("MP14013", Side, MP_X+cX-5, MP_Y+90, "BS", 10, "Arial", LegendColor);  //086
       Write("MP14014", Side, MP_X+cSTR, MP_Y+90, "Str", 10, "Arial", LegendColor); //048
       Write("MP14015", Side, MP_X+cTR,  MP_Y+90, "TR", 10, "Arial", LegendColor); //012
   
       x=cTF; //154
       y=MP_Y+106; space=12; fontname="Arial"; fontsize=8;
       Write("MP14016", Side, x, y+(00*space), "MN", fontsize, fontname, LegendColor);
       Write("MP14017", Side, x, y+(01*space), "W1", fontsize, fontname, LegendColor);
       Write("MP14018", Side, x, y+(02*space), "D1", fontsize, fontname, LegendColor);
   
       Write("MP14019", Side, x, y+(04*space), "H4", fontsize, fontname, LegendColor);
       Write("MP14020", Side, x, y+(05*space), "H1", fontsize, fontname, LegendColor);
       Write("MP14021", Side, x, y+(06*space), "M30", fontsize, fontname, LegendColor);
   
       Write("MP14022", Side, x, y+(08*space), "M15", fontsize, fontname, LegendColor);
       Write("MP14023", Side, x, y+(09*space), "M5", fontsize, fontname, LegendColor);
       Write("MP14024", Side, x, y+(10*space), "M1", fontsize, fontname, LegendColor);
   
       // LOOP
       n=1; y=MP_Y+106; space=12;
       while (n<=9)
             {
              switch (n)
                {
                 case 1: TFs = 43200;  baris=0;  break; 
                 case 2: TFs = 10080;  baris=1;  break;
                 case 3: TFs =  1440;  baris=2;  break; 
              
                 case 4: TFs =   240;  baris=4;  break; 
                 case 5: TFs =    60;  baris=5;  break; 
                 case 6: TFs =    30;  baris=6;  break; 
              
                 case 7: TFs =    15;  baris=8;  break; 
                 case 8: TFs =     5;  baris=9;  break; 
                 case 9: TFs =     1;  baris=10; break; 
                }//switch
             
                // Trend;
                vA = iMA(Symbol(),TFs, TMAFast_Period, TMAFast_Shift, TMAFast_Method, TMAFast_Apply_To, 0);
                vB = iMA(Symbol(),TFs, TMASlow_Period, TMASlow_Shift, TMASlow_Method, TMASlow_Apply_To, 0);
                if (vA>vB)
                   { SignalSymbol=UpSymbol; SignalColor=Arrow_Up; }
                else if  (vA<vB)
                   { SignalSymbol=DnSymbol; SignalColor=Arrow_Dn; }
                else {SignalSymbol=NtSymbol; SignalColor=Arrow_Nt; }
                Write("MP14025"+DoubleToStr(n,0), Side, cTR, y+(baris*space), SignalSymbol, 10, "Wingdings", SignalColor );
             
                // STR Signals 
                v_RSI   = iRSI(Symbol(), TFs, RSI_Period , RSI_PRICE_TYPE, 0);
                v_Stoch = iStochastic(Symbol(), TFs, STOCH_K_Period,STOCH_D_Period,STOCH_Slowing, STOCH_MA_MODE, STOCH_Price_Field, MODE_MAIN, 0);
                v_CCI   = iCCI(Symbol(), TFs,CCI_Period , CCI_PRICE_TYPE, 0);
                
                if ((v_RSI > 50) && (v_Stoch > 40) && (v_CCI > 0)) { SignalSymbol = UpSymbol; SignalColor = Arrow_Up ;} 
                else if ((v_RSI < 50) && (v_Stoch < 60) && (v_CCI < 0)) { SignalSymbol = DnSymbol; SignalColor = Arrow_Dn ;}
             
                //netral condition
                else if ((v_RSI < 50) && (v_Stoch > 40) && (v_CCI > 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
                else if ((v_RSI > 50) && (v_Stoch < 60) && (v_CCI < 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
                else if ((v_RSI < 50) && (v_Stoch > 40) && (v_CCI < 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
                else if ((v_RSI > 50) && (v_Stoch < 60) && (v_CCI > 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
                else if ((v_RSI > 50) && (v_Stoch > 40) && (v_CCI < 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
                else if ((v_RSI > 50) && (v_Stoch < 60) && (v_CCI < 0)) { SignalSymbol = NtSymbol;  SignalColor = Arrow_Nt; }
             
                Write("MP14026"+DoubleToStr(n,0), Side, cSTR, y+(baris*space), SignalSymbol, 10, "Wingdings", SignalColor );
             
             
                // BuySell Crossing
                vB = iMA(Symbol(), TFs, MAFast_Period, MAFast_Shift, MAFast_Method, MAFast_Apply_To, 0);
                vC = iMA(Symbol(), TFs, MASlow_Period, MASlow_Shift, MASlow_Method, MASlow_Apply_To, 0);
                if (vB>vC)
                   { SignalSymbol=UpSymbol; SignalColor=Arrow_Up; }
                else { SignalSymbol=DnSymbol; SignalColor=Arrow_Dn; }
                Write("MP14027"+DoubleToStr(n,0), Side, cX-3, y+(baris*space), SignalSymbol, 10, "Wingdings", SignalColor);
             
             
                // CandleColor
                vC = iClose( NULL , TFs, 0) - iOpen( NULL , TFs, 0);
                if ( vC > 0 ) 
                   { SignalColor = PriceColor_Up;  SignalSymbol="n"; }
                else if ( vC < 0 )  { SignalColor = PriceColor_Dn; SignalSymbol="n"; }
                else { SignalColor = NeutralColor; SignalSymbol="ª"; }
                Write("MP14028"+DoubleToStr(n,0), Side, cCC+2, y+(baris*space), SignalSymbol, 10, "Wingdings", SignalColor ); //x=120
                
                
                Write("MP14029", Side, cTR, y+((baris+1)*space), "Created by ServerUang", 7, "Tahoma Narrow", Gray);
             
                n++;
             } //end while
         
         }//Show
         else Write("MP14030", Side, MP_X+10, MP_Y+90, "Created by ServerUang", 7, "Tahoma Narrow", Gray);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

// Write Procedure
void Write(string LBL, double side, int pos_x, int pos_y, string text, int fontsize, string fontname, color Tcolor=CLR_NONE)
     {
       ObjectCreate(LBL, OBJ_LABEL, 0, 0, 0);
       ObjectSetText(LBL,text, fontsize, fontname, Tcolor);
       ObjectSet(LBL, OBJPROP_CORNER, side);
       ObjectSet(LBL, OBJPROP_XDISTANCE, pos_x);
       ObjectSet(LBL, OBJPROP_YDISTANCE, pos_y);
     }
     
     
// CheckColor Function

color CheckColor(double a, double b, color u, color d)
      {
        if (a>b) { return (u); } else { return (d); }
      }

//+------------------------------------------------------------------+