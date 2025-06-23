//+------------------------------------------------------------------+
//|                                                    DI NAPOLI.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

#define FIBNODE_01 0.328
#define FIBNODE_02 0.500
#define FIBNODE_03 0.618
#define FIBNODE_04 1.000
#define FIBNODE_06 1.328
#define FIBNODE_07 1.500
#define FIBNODE_08 1.618

extern string Note00a = " From which bar back start to ";
extern string Note00b = " calculate fractals. If 0, from current.";

extern int  FracsFromBar =  61;

extern int FibFractals01 =  121;
extern int FibFractals02 =  221;
extern int FibFractals03 =  321;
extern int FibFractals04 =  455;


extern string Note01 = " T/F Show Comments or Not.";
extern bool CommentsOn = false;

double ArrowDist = 0.0021;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- Averaged Values For all 3 nodes, for all ranges
   ObjectCreate("Range01Medium",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("Range01Medium", OBJPROP_COLOR, LightBlue);
   //ObjectCreate("Arrow01_up" , OBJ_ARROW, 0, 0, 0);
   //ObjectCreate("Arrow01_dn" , OBJ_ARROW, 0, 0, 0);
   
   ObjectCreate("Range02Medium",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("Range02Medium", OBJPROP_COLOR, SteelBlue);
   //ObjectCreate("Arrow02_up" , OBJ_ARROW, 0, 0, 0);
   //ObjectCreate("Arrow02_dn" , OBJ_ARROW, 0, 0, 0);
   
   ObjectCreate("Range03Medium",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("Range03Medium", OBJPROP_COLOR, RoyalBlue);
   //ObjectCreate("Arrow03_up" , OBJ_ARROW, 0, 0, 0);
   //ObjectCreate("Arrow03_dn" , OBJ_ARROW, 0, 0, 0);

   ObjectCreate("Range04Medium",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("Range04Medium", OBJPROP_COLOR, Blue);
   //ObjectCreate("Arrow04_up" , OBJ_ARROW, 0, 0, 0);
   //ObjectCreate("Arrow04_dn" , OBJ_ARROW, 0, 0, 0);

// op, cop, xop FIRST range
   // op dn
   ObjectCreate("op01_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op01_dn", OBJPROP_COLOR, Pink);
   ObjectSet("op01_dn", OBJPROP_STYLE, STYLE_DOT);
   // op up
   ObjectCreate("op01_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op01_up", OBJPROP_COLOR, Pink);
   ObjectSet("op01_up", OBJPROP_STYLE, STYLE_DOT);
   // dn cop
   ObjectCreate("cop01_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop01_dn", OBJPROP_COLOR, LightPink);
   ObjectSet("cop01_dn", OBJPROP_STYLE, STYLE_DOT);
   // up cop
   ObjectCreate("cop01_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop01_up", OBJPROP_COLOR, LightPink);
   ObjectSet("cop01_up", OBJPROP_STYLE, STYLE_DOT);
   // dn xop
   ObjectCreate("xop01_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop01_dn", OBJPROP_COLOR, Red);
   ObjectSet("xop01_dn", OBJPROP_STYLE, STYLE_DOT);
   // up 
   ObjectCreate("xop01_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop01_up", OBJPROP_COLOR, Red);
   ObjectSet("xop01_up", OBJPROP_STYLE, STYLE_DOT);
   
// op, cop, xop SECOND range
   // op dn
   ObjectCreate("op02_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op02_dn", OBJPROP_COLOR, Plum);
   ObjectSet("op02_dn", OBJPROP_STYLE, STYLE_DASH);
   // op up
   ObjectCreate("op02_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op02_up", OBJPROP_COLOR, Plum);
   ObjectSet("op02_up", OBJPROP_STYLE, STYLE_DASH);
   // dn cop
   ObjectCreate("cop02_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop02_dn", OBJPROP_COLOR, Salmon);
   ObjectSet("cop02_dn", OBJPROP_STYLE, STYLE_DASH);
   // up cop
   ObjectCreate("cop02_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop02_up", OBJPROP_COLOR, Salmon);
   ObjectSet("cop02_up", OBJPROP_STYLE, STYLE_DASH);
   // dn xop
   ObjectCreate("xop02_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop02_dn", OBJPROP_COLOR, BlueViolet);
   ObjectSet("xop02_dn", OBJPROP_STYLE, STYLE_DASH);
   // up xop
   ObjectCreate("xop02_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop02_up", OBJPROP_COLOR, BlueViolet);
   ObjectSet("xop02_up", OBJPROP_STYLE, STYLE_DASH);
   
// op, cop, xop Third range
   // op dn
   ObjectCreate("op03_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op03_dn", OBJPROP_COLOR, Tomato);
   // op up
   ObjectCreate("op03_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("op03_up", OBJPROP_COLOR, Tomato);
   // dn cop
   ObjectCreate("cop03_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop03_dn", OBJPROP_COLOR, Brown);
   // up cop
   ObjectCreate("cop03_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("cop03_up", OBJPROP_COLOR, Brown);
   // dn xop
   ObjectCreate("xop03_dn",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop03_dn", OBJPROP_COLOR, Maroon);
   // up xop
   ObjectCreate("xop03_up",OBJ_HLINE,0,0,0,0,0);
   ObjectSet("xop03_up", OBJPROP_COLOR, Maroon);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("Range01Medium");  ObjectDelete("Arrow01_up");    ObjectDelete("Arrow03_up");
   ObjectDelete("Range02Medium");  ObjectDelete("Arrow01_dn");    ObjectDelete("Arrow03_dn");
   ObjectDelete("Range03Medium");  ObjectDelete("Arrow02_up");    ObjectDelete("Arrow04_up");
   ObjectDelete("Range04Medium");  ObjectDelete("Arrow02_dn");    ObjectDelete("Arrow04_dn");

// op, cop, xop FIRST range        SECOND                          THIRD
   ObjectDelete("op01_dn");        ObjectDelete("op02_dn");        ObjectDelete("op03_dn");
   // op up 
   ObjectDelete("op01_up");        ObjectDelete("op02_up");        ObjectDelete("op03_up");
   // dn cop
   ObjectDelete("cop01_dn");       ObjectDelete("cop02_dn");       ObjectDelete("cop03_dn");
   // up cop
   ObjectDelete("cop01_up");       ObjectDelete("cop02_up");       ObjectDelete("cop03_up");
   // dn xop
   ObjectDelete("xop01_dn");       ObjectDelete("xop02_dn");       ObjectDelete("xop03_dn");
   // up xop
   ObjectDelete("xop01_up");       ObjectDelete("xop02_up");       ObjectDelete("xop03_up");
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
   if(CommentsOn == true) 
   {
      string ScreenText = StringConcatenate("\n    ----------------------------",
                                         "\n    - Blue Lines Light-Dark",
                                         "\n    - are medium values of",
                                         "\n    - .328 .500 .618 Fib levels",
                                         "\n    ----------------------------",
                                         "\n    - Brown, Pink, Red, Violet",
                                         "\n    - lines, are Objective Points;",
                                         "\n    - doted for shorter range",
                                         "\n    - dashed mid range and solid",
                                         "\n    - long range taken",
                                         "\n    - from fractals specified.",
                                         "\n    ----------------------------",
                                         "\n    - Red dots shows, which H/L are used.",
                                         "\n    - AND REMEMBER TO WATCH FOR REPOS !");
   }
   else ScreenText = "";
                                         
   Comment(ScreenText); 

   int shiftFU1 = iHighest(NULL,0,MODE_UPPER,FibFractals01,FracsFromBar);
   int shiftFD1 =  iLowest(NULL,0,MODE_LOWER,FibFractals01,FracsFromBar);
   
   double FU1 = High[shiftFU1];
   double FD1 =  Low[shiftFD1];
   
   double diff01 = FU1 - FD1;
   
   double n11 = diff01*FIBNODE_01 + FD1;
   double n12 = diff01*FIBNODE_02 + FD1;
   double n13 = diff01*FIBNODE_03 + FD1;
   
   double medium01 = (n11 + n12 + n13)/3;
   
   int shiftFU2 = iHighest(NULL,0,MODE_UPPER,FibFractals02,FracsFromBar);
   int shiftFD2 =  iLowest(NULL,0,MODE_LOWER,FibFractals02,FracsFromBar);
   
   double FU2 = High[shiftFU2];
   double FD2 =  Low[shiftFD2];
   
   double diff02 = FU2 - FD2;
   
   double n21 = diff02*FIBNODE_01 + FD2;
   double n22 = diff02*FIBNODE_02 + FD2;
   double n23 = diff02*FIBNODE_03 + FD2;
   
   double medium02 = (n21 + n22 + n23)/3;
   
   int shiftFU3 = iHighest(NULL,0,MODE_UPPER,FibFractals03,FracsFromBar);
   int shiftFD3 =  iLowest(NULL,0,MODE_LOWER,FibFractals03,FracsFromBar);
   
   double FU3 = High[shiftFU3];
   double FD3 =  Low[shiftFD3];
   
   double diff03 = FU3 - FD3;
   
   double n31 = diff03*FIBNODE_01 + FD3;
   double n32 = diff03*FIBNODE_01 + FD3;
   double n33 = diff03*FIBNODE_01 + FD3;
   
   double medium03 = (n31 + n32 + n33)/3;
   
   int shiftFU4 = iHighest(NULL,0,MODE_UPPER,FibFractals04,FracsFromBar);
   int shiftFD4 =  iLowest(NULL,0,MODE_LOWER,FibFractals04,FracsFromBar);
   
   double FU4 = High[shiftFU4];
   double FD4 =  Low[shiftFD4];
   
   double diff04 = FU4 - FD4;
   
   double n41 = diff04*FIBNODE_01 + FD4;
   double n42 = diff04*FIBNODE_01 + FD4;
   double n43 = diff04*FIBNODE_01 + FD4;
   
   double medium04 = (n41 + n42 + n43)/3;
   
//---- Calculating Di Napoli OP, COP, XOP:

//-- First Range  
   double op01_dn = FU2 - FD1 + FU1;
   double op01_up = FD2 - FU1 + FD1;
   
   double cop01_dn = FIBNODE_03*(FU2 - FD1) + FU1;
   double cop01_up = FIBNODE_03*(FD2 - FU1) + FD1;
   
   double xop01_dn = FIBNODE_08*(FU2 - FD1) + FU1;
   double xop01_up = FIBNODE_08*(FD2 - FU1) + FD1;

//-- Second Range  
   double op02_dn = FU3 - FD2 + FU2;
   double op02_up = FD3 - FU2 + FD2;
   
   double cop02_dn = FIBNODE_03*(FU3 - FD2) + FU2;
   double cop02_up = FIBNODE_03*(FD3 - FU2) + FD2;
   
   double xop02_dn = FIBNODE_08*(FU3 - FD2) + FU2;
   double xop02_up = FIBNODE_08*(FD3 - FU2) + FD2;   

//-- Third Range
   double op03_dn = FU4 - FD3 + FU3;
   double op03_up = FD4 - FU3 + FD3;
   
   double cop03_dn = FIBNODE_03*(FU4 - FD3) + FU3;
   double cop03_up = FIBNODE_03*(FD4 - FU3) + FD3;
   
   double xop03_dn = FIBNODE_08*(FU4 - FD3) + FU3;
   double xop03_up = FIBNODE_08*(FD4 - FU3) + FD3;
   
//------ Setting Values For Lines
//-- Averaged Levels Lines
  ObjectSet("Range01Medium", OBJPROP_PRICE1, medium01);
  /*ObjectSet("Arrow01_up", 14, 159);
  ObjectSet("Arrow01_dn", 14, 159);
  ObjectSet("Arrow01_up", OBJPROP_TIME1, Time[shiftFU1]);
  ObjectSet("Arrow01_dn", OBJPROP_TIME1, Time[shiftFD1]);
  ObjectSet("Arrow01_up", OBJPROP_PRICE1, FU1 + ArrowDist);
  ObjectSet("Arrow01_dn", OBJPROP_PRICE1, FD1 - ArrowDist);*/
  
  ObjectSet("Range02Medium", OBJPROP_PRICE1, medium02);
  /*ObjectSet("Arrow02_up", 14, 159);
  ObjectSet("Arrow02_dn", 14, 159);
  ObjectSet("Arrow02_up", OBJPROP_TIME1, Time[shiftFU2]);
  ObjectSet("Arrow02_dn", OBJPROP_TIME1, Time[shiftFD2]);
  ObjectSet("Arrow02_up", OBJPROP_PRICE1, FU2 + ArrowDist);
  ObjectSet("Arrow02_dn", OBJPROP_PRICE1, FD2 - ArrowDist);*/
  
  ObjectSet("Range03Medium", OBJPROP_PRICE1, medium03);
  /*ObjectSet("Arrow03_up", 14, 159);
  ObjectSet("Arrow03_dn", 14, 159);
  ObjectSet("Arrow03_up", OBJPROP_TIME1, Time[shiftFU3]);
  ObjectSet("Arrow03_dn", OBJPROP_TIME1, Time[shiftFD3]);
  ObjectSet("Arrow03_up", OBJPROP_PRICE1, FU3 + ArrowDist);
  ObjectSet("Arrow03_dn", OBJPROP_PRICE1, FD3 - ArrowDist);*/
  
  
  ObjectSet("Range04Medium", OBJPROP_PRICE1, medium04);
  /*ObjectSet("Arrow04_up", 14, 159);
  ObjectSet("Arrow04_dn", 14, 159);
  ObjectSet("Arrow04_up", OBJPROP_TIME1, Time[shiftFU4]);
  ObjectSet("Arrow04_dn", OBJPROP_TIME1, Time[shiftFD4]);
  ObjectSet("Arrow04_up", OBJPROP_PRICE1, FU4 + ArrowDist);
  ObjectSet("Arrow04_dn", OBJPROP_PRICE1, FD4 - ArrowDist);*/
  
//------ Di Napoli op, cop, xop FIRST range

  ObjectSet("op01_dn", OBJPROP_PRICE1, op01_dn);
  ObjectSet("op01_up", OBJPROP_PRICE1, op01_up);
  
  ObjectSet("cop01_dn", OBJPROP_PRICE1, cop01_dn);
  ObjectSet("cop01_up", OBJPROP_PRICE1, cop01_up); 

  ObjectSet("xop01_dn", OBJPROP_PRICE1, xop01_dn);
  ObjectSet("xop01_up", OBJPROP_PRICE1, xop01_up); 

//------ Di Napoli op, cop, xop SECOND range

  ObjectSet("op02_dn", OBJPROP_PRICE1, op02_dn);
  ObjectSet("op02_up", OBJPROP_PRICE1, op02_up);
  
  ObjectSet("cop02_dn", OBJPROP_PRICE1, cop02_dn);
  ObjectSet("cop02_up", OBJPROP_PRICE1, cop02_up); 

  ObjectSet("xop02_dn", OBJPROP_PRICE1, xop02_dn);
  ObjectSet("xop02_up", OBJPROP_PRICE1, xop02_up); 
  
//------ Di Napoli op, cop, xop THIRD range

  ObjectSet("op03_dn", OBJPROP_PRICE1, op03_dn);
  ObjectSet("op03_up", OBJPROP_PRICE1, op03_up);
  
  ObjectSet("cop03_dn", OBJPROP_PRICE1, cop03_dn);
  ObjectSet("cop03_up", OBJPROP_PRICE1, cop03_up); 

  ObjectSet("xop03_dn", OBJPROP_PRICE1, xop03_dn);
  ObjectSet("xop03_up", OBJPROP_PRICE1, xop03_up); 
//----
   return(0);
  }
//+------------------------------------------------------------------+