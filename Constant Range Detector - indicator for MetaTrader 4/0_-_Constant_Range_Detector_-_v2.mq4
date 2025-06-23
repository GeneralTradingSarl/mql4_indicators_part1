#property copyright "Copyright © 2013, File45"
#property link      "http://codebase.mql4.com/en/author/file45"
 
#property indicator_chart_window
//+------------------------------------------------------------------+
//| START OF DEFAULT OPTIONS                      
//+------------------------------------------------------------------+
extern string Text = "CR";
extern color Font_Color = DodgerBlue;
extern int Font_Size = 11;
extern bool Font_Bold = true;
extern int Left_Right = 25;
extern int Up_Down = 150;
extern int Corner = 1;
//+------------------------------------------------------------------+
//| END OF DEFAULT OPTIONS                      
//+------------------------------------------------------------------+
string The_Font;
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
   
   if(Font_Bold == true)
   {
      The_Font = "Arial Bold";
   }
   else
   {
      The_Font = "Arial";
   }      
  
   return(0);
}
//+------------------------------------------------------------------+
//| Deinit                   
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("CR");
     
   return(0);
}
//+------------------------------------------------------------------+
//| Start                            
//+------------------------------------------------------------------+
int start()
{  
   string name_cr, Constant_Range;
   name_cr = "CR";
   Constant_Range = DoubleToStr(MathAbs((High[1] - Low[1]) / Pointz), 2);
      
   if (ObjectFind(name_cr) != -1) ObjectDelete(name_cr);
   ObjectCreate(name_cr,OBJ_LABEL,0,0,0);
   ObjectSetText(name_cr, Text + " " + Constant_Range, Font_Size, The_Font, Font_Color);
   ObjectCreate(name_cr, OBJ_LABEL, 0,0,0 );
   ObjectSet(name_cr, OBJPROP_CORNER, 1);
   ObjectSet(name_cr, OBJPROP_XDISTANCE, Left_Right);
   ObjectSet(name_cr, OBJPROP_YDISTANCE, Up_Down );//}
      
  return(0);
}

