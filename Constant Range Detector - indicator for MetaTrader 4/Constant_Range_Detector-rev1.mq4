
#property copyright "Copyright © 2012, File45"
#property link      "http://codebase.mql4.com/en/author/file45"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| START OF DEFAULT OPTIONS                      
//+------------------------------------------------------------------+
extern string Text = "CR";
extern int Corner = 1;
extern int X_Distance = 25;
extern int Y_Distance = 100;
extern color Font_Color = Plum;
extern int Font_Size = 11;
extern string Font_Face = "Verdana Bold";
//+------------------------------------------------------------------+
//| END OF DEFAULT OPTIONS                      
//+------------------------------------------------------------------+
int Hist_Candle_Number = 8;
double Pointz;
//+------------------------------------------------------------------+
//| Init                       
//+------------------------------------------------------------------+
int init()
{
	Pointz = Point;
	// 1, 3 & 5 digits pricing
	if (Point == 0.1) Pointz =1;
   if ((Point == 0.00001) || (Point == 0.001)) Pointz *= 10;
   
   return(0);
}
//+------------------------------------------------------------------+
//| Deinit                   
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("CRD");
     
   return(0);
}
//+------------------------------------------------------------------+
//| Start                            
//+------------------------------------------------------------------+
int start()
{  
   string name, Constant_Range;
      
   int i;
      name = "CRD";
      Constant_Range = DoubleToStr(MathRound((High[i+Hist_Candle_Number] - Low[i+Hist_Candle_Number]) / Pointz), 0);
      if (ObjectFind(name) != -1) ObjectDelete(name);
      ObjectCreate(name,OBJ_LABEL,0,0,0);
      ObjectSetText(name, Text + " " + Constant_Range, Font_Size, Font_Face, Font_Color);
      ObjectCreate(name, OBJ_LABEL, 0,0,0 );
      ObjectSet(name, OBJPROP_CORNER, 1);
      ObjectSet(name, OBJPROP_XDISTANCE, X_Distance);
      ObjectSet(name, OBJPROP_YDISTANCE, Y_Distance );//}
      
  return(0);
}
//+------------------------------------------------------------------+