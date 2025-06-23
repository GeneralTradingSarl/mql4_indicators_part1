//+------------------------------------------------------------------+
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//| account_info_horizontal 4.01                                     |
//| File45: https://www.mql5.com/en/users/file45/publications        |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, file45."
#property link      "https://www.mql5.com"
#property version   "4.01"
#property description "Places account information on the chart in horizontal sequence." 
#property description " "
#property description  "Hide account info: Click anywhere on account text."
#property description  "Show account info: Click on text - 'Account Info'."
#property description " "
#property description  "Show Profit only option."
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum spacing_x
  {
   a=8, // 1
   b=9, // 2
   c=10,// 3
  };
//+------------------------------------------------------------------+
input bool Show_only_Profit= false; // Show Profit only
input ENUM_BASE_CORNER Ch   = 3;    // Corner
int    Left_Right_H_S;
input int    Up_Down        = 2;    // Up <-> Down
input int    Left_Right_P   = 15;   // Left <-> Right 
input spacing_x Spacing=b; // Acount Header spacing
input color  Font_Color     = SlateGray; // Info Color
input color  Color_Profit   = LimeGreen; // Profit Color
input color  Color_Loss     = Red;       // Loss Color
input int    Font_Size_h=8;   // Font Size
input bool   Font_Bold=false;     // Font Bold

color  Color_PnL_Closed=Font_Color;
bool switchh=false;
color PnL_Color;
string Acc_F,TM,Hide_Show_h,ML_Perc;
int PC,Up_Down_h,Font_Size;
double Spacing_h;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   switch(Font_Bold)
     {
      case 1: Acc_F = "Arial Bold"; break;
      case 0: Acc_F = "Arial";      break;
     }

   Hide_Show_h=" ";

   if(Font_Size_h<6)
     {
      Font_Size=6;
     }
   else
     {
      Font_Size=Font_Size_h;
     }

   if(Show_only_Profit==false)
     {
      ObjectCreate(0,"Acc_ML_h",OBJ_LABEL,0,0,0);
      ObjectCreate(0,"Acc_M_h",OBJ_LABEL,0,0,0);
      ObjectCreate(0,"Acc_FM_h",OBJ_LABEL,0,0,0);
      ObjectCreate(0,"Acc_E_h",OBJ_LABEL,0,0,0);
      ObjectCreate(0,"Acc_B_h",OBJ_LABEL,0,0,0);
     }
   ObjectCreate(0,"Acc_P_h",OBJ_LABEL,0,0,0);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete("Acc_H_S_h");
   ObjectDelete("Acc_ML_h");
   ObjectDelete("Acc_M_h");
   ObjectDelete("Acc_FM_h");
   ObjectDelete("Acc_E_h");
   ObjectDelete("Acc_B_h");
   ObjectDelete("Acc_P_h");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
   Up_Down_h=Up_Down;

   if((Ch==0 || Ch==1) && Up_Down<20)
     {
      Up_Down_h=20;
     }

   ObjectCreate(0,"Acc_H_S_h",OBJ_LABEL,0,0,0);
   ObjectSetText("Acc_H_S_h",Hide_Show_h,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_H_S_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_H_S_h",OBJPROP_XDISTANCE,15);
   ObjectSet("Acc_H_S_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_H_S_h",OBJPROP_SELECTABLE,false);

   double Spacer_Mult=Font_Size*(Spacing*0.1);

   string Acc_P_Header=" Profit: ";
   string Acc_Curr=AccountCurrency();
   string Acc_gap_P=" ";
   string Acc_P_hs=formatDouble(AccountProfit(),2);
   int StLenP=StringLen(Acc_P_Header+Acc_Curr+Acc_gap_P+Acc_P_hs);

   string Acc_B_Header=" Balance: ";
   string Acc_B_hs=formatDouble(AccountBalance(),2);
//string Acc_B_Test = "123,456,789.00";
   int StLenB=StringLen(Acc_B_Header+Acc_B_hs);

   string Acc_E_Header=" Equity: ";
   string Acc_E_hs=formatDouble(AccountEquity(),2);
//string Acc_E_Test = "123,456,789.00";
   int StLenE=StringLen(Acc_E_Header+Acc_E_hs);

   string Acc_FM_Header=" Free Margin: ";
   string Acc_FM_hs=formatDouble(AccountFreeMargin(),2);
//string Acc_FM_Test = "123,456,789.00";
   int StLenFM=StringLen(Acc_FM_Header+Acc_FM_hs);

   string Acc_M_Header=" Margin: ";
   string Acc_M_hs=formatDouble(AccountMargin(),2);
//string Acc_M_Test = "123,456,789.00";
   int StLenM=StringLen(Acc_M_Header+Acc_M_hs);

   string Acc_ML_Header="Margin Level: ";
   string Acc_ML_hs=formatDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2);
//string Acc_ML_Test = "123,456,789.00";
   ML_Perc=" % ";

   ObjectSetText("Acc_ML_h",Acc_ML_Header+Acc_ML_hs+ML_Perc,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_ML_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_ML_h",OBJPROP_XDISTANCE,(StLenP+StLenB+StLenE+StLenFM+StLenM)*Spacer_Mult+Left_Right_P);
   ObjectSet("Acc_ML_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_ML_h",OBJPROP_SELECTABLE,false);

   ObjectSetText("Acc_M_h",Acc_M_Header+Acc_M_hs,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_M_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_M_h",OBJPROP_XDISTANCE,(StLenP+StLenB+StLenE+StLenFM)*Spacer_Mult+Left_Right_P);
   ObjectSet("Acc_M_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_M_h",OBJPROP_SELECTABLE,false);

   ObjectSetText("Acc_FM_h",Acc_FM_Header+Acc_FM_hs,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_FM_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_FM_h",OBJPROP_XDISTANCE,(StLenP+StLenB+StLenE)*Spacer_Mult+Left_Right_P);
   ObjectSet("Acc_FM_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_FM_h",OBJPROP_SELECTABLE,false);

   ObjectSetText("Acc_E_h",Acc_E_Header+Acc_E_hs,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_E_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_E_h",OBJPROP_XDISTANCE,(StLenP+StLenB)*Spacer_Mult+Left_Right_P);
   ObjectSet("Acc_E_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_E_h",OBJPROP_SELECTABLE,false);

   ObjectSetText("Acc_B_h",Acc_B_Header+Acc_B_hs,Font_Size,Acc_F,Font_Color);
   ObjectSet("Acc_B_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_B_h",OBJPROP_XDISTANCE,StLenP*Spacer_Mult+Left_Right_P);
   ObjectSet("Acc_B_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_B_h",OBJPROP_SELECTABLE,false);

   if(AccountProfit()>=0.01)
     {
      PnL_Color=Color_Profit;
     }
   else if(AccountProfit()<=-0.01)
     {
      PnL_Color=Color_Loss;
     }
   else
     {
      PnL_Color=Color_PnL_Closed;
     }

   ObjectSetText("Acc_P_h",Acc_P_Header+Acc_Curr+Acc_gap_P+Acc_P_hs,Font_Size,Acc_F,PnL_Color);
   ObjectSet("Acc_P_h",OBJPROP_CORNER,Ch);
   ObjectSet("Acc_P_h",OBJPROP_XDISTANCE,Left_Right_P);
   ObjectSet("Acc_P_h",OBJPROP_YDISTANCE,Up_Down_h);
   ObjectSet("Acc_P_h",OBJPROP_SELECTABLE,false);

   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier  
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
   if(id==CHARTEVENT_OBJECT_CLICK && (sparam=="Acc_H_S_h" || sparam=="Acc_ML_h" || sparam=="Acc_M_h"
      || sparam=="Acc_FM_h" || sparam=="Acc_E_h" || sparam=="Acc_B_h" || sparam=="Acc_P_h"))
     {
      switchh=!switchh;

      switch(switchh)
        {
         case 0: Hide_Show_h=" ";
         if(Show_only_Profit==false)
           {
            ObjectCreate(0,"Acc_ML_h",OBJ_LABEL,0,0,0);
            ObjectCreate(0,"Acc_M_h",OBJ_LABEL,0,0,0);
            ObjectCreate(0,"Acc_FM_h",OBJ_LABEL,0,0,0);
            ObjectCreate(0,"Acc_E_h",OBJ_LABEL,0,0,0);
            ObjectCreate(0,"Acc_B_h",OBJ_LABEL,0,0,0);
           }
         ObjectCreate(0,"Acc_P_h",OBJ_LABEL,0,0,0);
         break;
         case 1: Hide_Show_h=" Account Info ";
         if(Show_only_Profit==false)
           {
            ObjectDelete("Acc_ML_h");
            ObjectDelete("Acc_M_h");
            ObjectDelete("Acc_FM_h");
            ObjectDelete("Acc_E_h");
            ObjectDelete("Acc_B_h");
           }
         ObjectDelete("Acc_P_h");
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string formatDouble(double number,int precision,string pcomma=",",string ppoint=".")
  {
   string snum     = DoubleToStr(number, precision);
   int    decp     = StringFind(snum, ".", 0);
   string sright   = StringSubstr(snum, decp + 1, precision);
   string sleft    = StringSubstr(snum, 0, decp);
   string formated = "";
   string comma    = "";

   while(StringLen(sleft)>3)
     {
      int    length = StringLen(sleft);
      string part   = StringSubstr(sleft, length - 3, 0);
      formated = part + comma + formated;
      comma    = pcomma;
      sleft    = StringSubstr(sleft, 0, length - 3);
     }
   if(sleft=="-")
      comma="";              // this line missing previously
   if(sleft!="")
      formated=sleft+comma+formated;
   if(precision>0)
      formated=formated+ppoint+sright;
   return(formated);
  }
//+------------------------------------------------------------------+
