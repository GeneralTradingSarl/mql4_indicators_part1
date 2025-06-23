
#property indicator_chart_window

#property strict

// ++++++++++++++++++++++++++++++++ START OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Spread
extern string SPREAD_OPTIONS; 
extern color  Spread_Color = DarkOrange;
extern int    Spread_Font_Size = 13;
extern string Spread_Font_Type = "Verdana";
extern int    Spread_Corner = 1;
extern int    Spread_X_distance = 120;
extern int    Spread_Y_distance = 15;
extern bool   Spread_HIDE=false;
extern bool   Spread_Normalize = false; //If true then spread normalized to traditional pips 
//extern string _;
extern string ASK_BID_OPTIONS;
extern color  Ask_Color = LimeGreen;
extern color  Bid_Color = Red;
extern int    Ask_Bid_Font_Size=13;
extern string Ask_Bid_Font_Type = "Verdana";
extern int    Ask_Bid_Corner = 1;
extern int    Ask_X_Distance = 20;
extern int    Bid_X_Distance = 20;
extern int    Ask_Y_Distance = 15;
extern int    Bid_Y_Distance = 40;
extern bool   Ask_HIDE = false;
extern bool   Bid_HIDE = false;
extern bool   Ask_Bid_HIDE = false;
// +++++++++++++++++++++++++++++++++++++ END OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

double Pointx;
int x_digits = 0;
double divider = 1;

int init(){
   
   //Spread: Check for 3 & 5 digit 
   if (Point == 0.00001) Pointx = 0.0001; //5 digits
   else if (Point == 0.001) Pointx = 0.01; //3 digits
   else Pointx = Point; //Normal
   
   if ((Pointx > Point) && (Spread_Normalize==true))
   {
      divider = 10.0;
      x_digits = 1;
   }
   
   double spread = MarketInfo(Symbol(), MODE_SPREAD);
 
   return(0);
}

int deinit(){
   // Spread: delets
   ObjectDelete("Spread");  
   // Market: Ask - Bid deletes
   ObjectDelete("Market_Bid_Label");
   ObjectDelete("Market_Ask_Label"); 
  
   return(0);
}

int start(){
   
   // Spread: refresh
   
   if(Spread_HIDE==false){
   RefreshRates();
   double spread = (Ask - Bid) / Point;
   ObjectCreate("Spread",OBJ_LABEL,0,0,0);
   ObjectSetText("Spread", " " + DoubleToStr(NormalizeDouble(spread / divider, 1), x_digits), Spread_Font_Size, Spread_Font_Type, Spread_Color);
   ObjectCreate("Spread", OBJ_LABEL, 0,0,0 );
   ObjectSet("Spread", OBJPROP_CORNER, Spread_Corner);
   ObjectSet("Spread", OBJPROP_XDISTANCE, Spread_X_distance);
   ObjectSet("Spread", OBJPROP_YDISTANCE, Spread_Y_distance);}
       
   // Prcie: Ask
   if(Ask_Bid_HIDE == false){
   if(Ask_HIDE == false){
   string Market_Ask = DoubleToStr(Ask, Digits);
   ObjectCreate("Market_Ask_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Ask_Label", Market_Ask, Ask_Bid_Font_Size, Ask_Bid_Font_Type, Ask_Color);
   ObjectSet("Market_Ask_Label", OBJPROP_CORNER, Ask_Bid_Corner);
   ObjectSet("Market_Ask_Label", OBJPROP_XDISTANCE, Ask_X_Distance);
   ObjectSet("Market_Ask_Label", OBJPROP_YDISTANCE, Ask_Y_Distance);}
    
   // Price: Bid
   if(Bid_HIDE == false){   
   string Market_Bid = DoubleToStr(Bid, Digits);  
   ObjectCreate("Market_Bid_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Bid_Label", Market_Bid, Ask_Bid_Font_Size, Ask_Bid_Font_Type, Bid_Color);
   ObjectSet("Market_Bid_Label", OBJPROP_CORNER, Ask_Bid_Corner);
   ObjectSet("Market_Bid_Label", OBJPROP_XDISTANCE, Bid_X_Distance);
   ObjectSet("Market_Bid_Label", OBJPROP_YDISTANCE, Bid_Y_Distance);}}
  
return(0);

}  

