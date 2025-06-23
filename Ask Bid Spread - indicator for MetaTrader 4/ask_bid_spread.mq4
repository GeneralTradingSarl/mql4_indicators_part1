//+---------------------------------------------------------------------+
//|                                                  Ask Bid Spread.mq4 |
//|                           Copyright 2015, MetaQuotes Software Corp. |
//|                                               https://www.mql5.com  |
//| Indicator : Ask Bid Spread v-3                                      |
//| Author : file45 - https://www.mql5.com/en/users/file45/publications |
//+---------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "3.00"
#property strict
#property indicator_chart_window

enum DDS
{
   SS,  // Spread
   AS,  // Ask + Spread
   BS,  // Bid + Spread
   ABS  // Ask + Bid + Spread
  
};   

enum CRN
{
   a = 0, // Left Upper Corner 
   b = 1, // Right Upper Corner
   c = 2, // Left Lower Corner
   d = 3 // Right Lower Corner
};   

input DDS   DD_Selection = ABS; // Dropdown Selection 
input color Ask_Color = MediumSeaGreen; // Ask Color
input color Bid_Color = Red; // Bid Color
input color Spread_Color = DarkOrange; // Spread Color
input int   Font_Size = 12; // Font Size
input bool  Fonts_Bold = true; // Font Bold
input CRN   Cornerp = b; // Corner
input int   X_Dist = 20; // Left - Right
input int   Y_Dist = 20; // Up - Down


//input bool   Spread_HIDE=false;
bool   Spread_Normalize = true; //If true then spread normalized to traditional pips 

bool ap, bp, sp;
int FSp;
double fs;

double Pointx;
double divider = 1;
int x_digits = 0;
int Y1, Y2, y3, sp_Dist, ap_Dist, bp_Dist;
string FT;

int OnInit()
{ 
   FSp = Font_Size;
   
   if(Cornerp == 0 || Cornerp == 1)
   {
      switch(DD_Selection)
      {
         case SS: ap = false; bp = false; sp = true; sp_Dist = Y_Dist; break;
         case AS: ap = true; bp = false; sp = true; ap_Dist = Y_Dist; sp_Dist = Y_Dist + 2*FSp; break;
         case BS: ap = false; bp = true; sp = true; bp_Dist = Y_Dist; sp_Dist = Y_Dist + 2*FSp; break;
         case ABS: ap = true; bp = true; sp = true; ap_Dist = Y_Dist; bp_Dist = Y_Dist + 2*FSp; sp_Dist = Y_Dist + 4*FSp; break;
      }
   }
   else
   {
      switch(DD_Selection)
      {
         case SS: ap = false; bp = false; sp = true; sp_Dist = Y_Dist; break;
         case AS: ap = true; bp = false; sp = true; ap_Dist = Y_Dist + 2*FSp; sp_Dist = Y_Dist; break;
         case BS: ap = false; bp = true; sp = true; bp_Dist = Y_Dist + 2*FSp; sp_Dist = Y_Dist; break;
         case ABS: ap = true; bp = true; sp = true; ap_Dist = Y_Dist + 4*FSp; bp_Dist = Y_Dist + 2*FSp; sp_Dist = Y_Dist; break;
      }   
  }  
   //Spread: Check for 3 & 5 digit 
   if (Point == 0.00001) 
   {
      Pointx = 0.0001; //5 digits
   }
   else if (Point == 0.001) 
   {
      Pointx = 0.01; //3 digits
   }    
   else 
   {
      Pointx = Point; //Normal
   }
   
  // if ((Pointx > Point) && (Spread_Normalize==true))
 /* if (Spread_Normalize==true)
  {
      divider = 10.0;
      x_digits = 1;
  }
  else
  {
      divider = 1.0;
      x_digits = 0;
  }    */
     
  double spread = MarketInfo(Symbol(), MODE_SPREAD);
 
   switch(Fonts_Bold)
   {
      case 0: FT = "Arial"; break;
      case 1: FT = "Arial Bold";
   }
   
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
   if(sp == true)
   {
      double spreadx = (Ask - Bid) / Point;
      ObjectCreate("Spread",OBJ_LABEL,0,0,0);
      ObjectSetText("Spread", DoubleToStr(NormalizeDouble(spreadx / divider, 1), x_digits), Font_Size, FT, Spread_Color);
      ObjectCreate("Spread", OBJ_LABEL, 0,0,0 );
      ObjectSet("Spread", OBJPROP_XDISTANCE, X_Dist);
      ObjectSet("Spread", OBJPROP_YDISTANCE, sp_Dist);
      ObjectSet("Spread", OBJPROP_CORNER, Cornerp);
   }
       
   if(ap == true)
   {
      string Market_Ask = DoubleToStr(Ask, Digits);
      ObjectCreate("Market_Ask_Label", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Market_Ask_Label", Market_Ask, Font_Size, FT, Ask_Color);
      ObjectSet("Market_Ask_Label", OBJPROP_XDISTANCE, X_Dist);
      ObjectSet("Market_Ask_Label", OBJPROP_YDISTANCE, ap_Dist);
      ObjectSet("Market_Ask_Label", OBJPROP_CORNER, Cornerp);
   }
   
   if(bp == true)
   {   
      string Market_Bid = DoubleToStr(Bid, Digits);  
      ObjectCreate("Market_Bid_Label", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Market_Bid_Label", Market_Bid, Font_Size, FT, Bid_Color);
      ObjectSet("Market_Bid_Label", OBJPROP_XDISTANCE, X_Dist);
      ObjectSet("Market_Bid_Label", OBJPROP_YDISTANCE, bp_Dist);
      ObjectSet("Market_Bid_Label", OBJPROP_CORNER, Cornerp);
   }
  
   return(rates_total);
}

int deinit()
{
   ObjectDelete("Spread");  
   ObjectDelete("Market_Bid_Label");
   ObjectDelete("Market_Ask_Label"); 
  
   return(0);
}