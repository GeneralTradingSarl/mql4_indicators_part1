//+------------------------------------------------------------------+
//|                                  Dolly_Graphics_v11-GMTShift.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property strict
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//+------------------------------------------------------------------+
//|                                         Dolly (the famous sheep) |
//|               original indicator is called valasholic13 v2.5.mq4 |
//|                                                                  |
//|                  and the original author is valasholic@yahoo.com |
//|                                                                  |         
//|                        mods and stuff by Linuxser for Forex-TSD  |
//|                      (there is a lot of usefull code inside here)|
//|Credits: hulahula (traslation from original indonesian language)  |
//|ign... in collaboration with Linuxser (with mods and improvments  |
//+------------------------------------------------------------------+
/*
Thanks to the above coders for all their work on the original Dolly 

Dolly Graphics 4: by cja
   - Comments restored to original figures but different layout, kept simple thanks to FxNorth for advise
   - Graphics code cleaned up now can be run on any colour background
   - Pivot points altered to short LINES and Labels can be shifted and LINES extended
   - Pivot M Levels added and Labels can be shifted and LINES extended
   - Dolly Sell Buy Target Labels can be shifted
   - Daily Average Range added above & below Dolly Levels and DAR Labels can be shifted 
Dolly Graphics 5   
   - Dolly coloured panels & Daily Average Range can now be either panels or lines or a combo of both 
   - Daily Average Panels can now be turned on/off  
   - Dolly trading Comments reset to original layout with larger type & can now be turned on/off
   - Pivot points and M pivot levels can now be selected individually
   - Added in Back TEST simply set to # of days and scroll back to the 1st graphic in the line
Dolly Graphics 6
   - Central Pivot Point and Main Pivots now automatically show in BackTEST if Pivots on.
Dolly Graphics 8
   - Fib Levels added with option to take data back to previous days, Fib Levels on/off & TEXT on/off, 
   - move Fib TEXT & Extend line length if required.
   - Revised code and removed excess objects to increase speed. 
   - Fib Display able to be Short (Cover only the Graphics) or long extend to previous Day or more.
   - Adjustment of Dolly & Daily Average colours in inputs
   - Adjustment of BUY/SELL Levels in inputs 
   - Daily Average labels delete when Daily Graphics are removed.
Dolly Graphics 9
   - Extra Fib levels added to extend range if previous day was Range Bound.
   - Target 2 BUY & SELL have altered the code for the take profit so the Graphics now match the Text 
   - & when the level figure is altered the Text now alters to reflect the change, the old code was target 1 plus 
   - or minus 10. 
Dolly Graphics 10
   - NONE of the ORIGINAL CODE is now being used
   - Rewrote the original Dolly Code as I think that was where the REFRESH UPDATE issue problem existed
   - Rewrote the Pivots & M Pivot levels to speed up the indicator.
   - All Pivots now Backtest if Pivots & M Pivots turned on
   - Added a daily High/Low that is turned off by default - when on this feature will Backtest. 
   - Added Daily OPEN line Default is off, useful for the days that price starts above or below the Targets
   - can be used as a dynamic Pivot.         
Dolly Graphics #10 - by hymns
   - Add Daily Change Value
   - Tweak for using Open Graphics   
Fixed TimeShift - by FiFtHeLeMeNt
   - Fixed Pivots and added GMTshift , but backtest can not be used anymore , I think accurate data for today trade is more important than having backtest feature   
   - Fixed FiboLines and Graphics to be compatible with GMTshift
   - Fixed some bugs causing errors
Dolly Graphics #11 - by cja & thanks to FiFtHeLeMeNt for the GMT shift code
   - Added a pop up window alert when price approaches the Dolly levels 
   - Added an Auto Signals feature which removes the Comments and replaces them with an Auto ObjectsDeleteAll(0,OBJ_TEXT); signal system       
*/
#property copyright ""
#property link      " Dolly Graphics cja"
//----
#property indicator_chart_window
#define IND_NAME "Dolly Graphics #11 GMT Shift"
//----
extern int GMTshift=0;
extern bool Using_OpenGraphics=true;
extern bool Dolly_GRAPHICS=true;
extern bool Alert_ON=false;
extern bool Auto_Signals=true;
extern bool Show_DollyCOMMENTS=true;
extern color BUY_Color_2=C'0,0,150';
extern color BUY_Color_1=C'0,0,100';
extern color SELL_Color_1=C'120,0,0';
extern color SELL_Color_2=C'180,0,0';
extern int BUY_Target_2 =50;
extern int BUY_Target_1 =40;
extern int BUY_Area =20;
extern int SELL_Area =20;
extern int SELL_Target_1 =40;
extern int SELL_Target_2 =50;
extern int SHIFT_DollyText=0;
//----
extern bool Show_DailyAverageGRAPHICS=true;
extern bool Daily_AverageGRAPHICS=true;
extern color DAILY_Av_UP_Color_150=C'0,110,255';
extern color DAILY_Av_UP_Color_125=C'0,70,255';
extern color DAILY_Av_UP_Color_100=C'20,20,255';
extern color DAILY_Av_UP_Color_75=C'0,0,210';
extern color DAILY_Av_DN_Color_75=C'220,0,0';
extern color DAILY_Av_DN_Color_100=C'255,0,10';
extern color DAILY_Av_DN_Color_125=C'255,70,0';
extern color DAILY_Av_DN_Color_150=C'255,110,0';
extern int SHIFT_DailyAverageText=28;
//----
extern bool Show_PivotLines=false;
extern bool Show_M_PivotLines=false;
extern int SHIFT_PivotPointText=0;
extern int PivotPoint_ExtendLINE=0;
//----
extern bool Show_FibLines=false;
extern bool Show_EXTRAFibLines=false;
extern int SHIFT_FibText=65;
extern int FIB_ExtendDISPLAY=1;
//----
extern bool Show_Daily_HI_LOW=false;
extern int SHIFT_HI_LOW_TEXT=50;
//----
extern bool Show_Daily_OPEN=false;
extern int SHIFT_Daily_OPEN_TEXT=0;
//Daily OPEN
#define DO "DO"
//Daily HI/LOW
#define DHI "DHI"
#define DLO "DLO"
#define DDHI "DDHI"
#define DDLO "DDLO"
//Dolly Levels
#define DollyBUY3 "DollyBUY3"
#define DollyBUY2 "DollyBUY2"
#define DollyBUY1 "DollyBUY1"
#define DollySELL1 "DollySELL1"
#define DollySELL2 "DollySELL2"
#define DollySELL3 "DollySELL3"
//Daily Average Levels
#define AvBUY150 "AvBUY150"
#define AvBUY125 "AvBUY125"
#define AvBUY100 "AvBUY100"
#define AvBUY75 "AvBUY75"
#define AvSELL75 "AvSELL75"
#define AvSELL100 "AvSELL100"
#define AvSELL125 "AvSELL125"
#define AvSELL150 "AvSELL150"
//Pivot Levels
#define P1 "P1"
#define PP1 "PP1"
#define RR3 "RR3"
#define RR2 "RR2"
#define RR1 "RR1"
#define SS1 "SS1"
#define SS2 "SS2"
#define SS3 "SS3"
//----
#define MM1 "MM1"
#define MM2 "MM2"
#define MM3 "MM3"
#define MM4 "MM4"
#define MM5 "MM5"
#define MM0 "MM0"
//----
#define PPP1 "PPP1"
#define RRR3 "RRR3"
#define RRR2 "RRR2"
#define RRR1 "RRR1"
#define SSS1 "SSS1"
#define SSS2 "SSS2"
#define SSS3 "SSS3"
//FIB Levels
#define FibP100 "FibP100"
#define FibP618 "FibP618"
#define FibP50 "FibP50"
#define FibP382 "FibP382"
#define Fib100 "Fib100"
#define Fib764 "Fib764"
#define Fib618 "Fib618"
#define Fib50 "Fib50"
#define Fib382 "Fib382"
#define Fib236 "Fib236"
#define Fib0 "Fib0"
#define FibM100 "FibM100"
#define FibM618 "FibM618"
#define FibM50 "FibM50"
#define FibM382 "FibM382"
#define FibP236 "FibP236"
#define FibP764 "FibP764"
#define FibM236 "FibM236"
#define FibM764 "FibM764"
#define FibM150 "FibM150"
#define FibP150 "FibP150"
#define FibM200 "FibM200"
#define FibP200 "FibP200"
#define FibM250 "FibM250"
#define FibP250 "FibP250"
#define FibM300 "FibM300"
#define FibP300 "FibP300"
//----
double P, S1, B1, S2, B2, S3, B3;
double day_high;
double day_low;
double yesterday_open;
double today_open;
double cur_day;
double prev_day;
double yesterday_high=0;
double yesterday_low=0;
double yesterday_close=0;
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll(0,OBJ_TEXT);
   ObjectsDeleteAll(0,OBJ_LABEL);
   ObjectsDeleteAll(0,OBJ_RECTANGLE);
   ObjectsDeleteAll(0,OBJ_TRENDBYANGLE);
   ObjectDelete("Pivot");
   ObjectDelete("Open");
   ObjectDelete("Dolly");
   ObjectDelete("Dolly1");  ObjectDelete("Dolly2"); ObjectDelete("Dolly3"); ObjectDelete("Dolly4");
   ObjectDelete("Dolly5");  ObjectDelete("Dolly6"); ObjectDelete("Dolly7"); ObjectDelete("Dolly8");
   ObjectDelete("Dolly9");  ObjectDelete("Dolly10"); ObjectDelete("Dolly11"); ObjectDelete("Dolly12");
   ObjectDelete("Dolly13"); ObjectDelete("Dolly14"); ObjectDelete("Dolly15"); ObjectDelete("Dolly16");
   ObjectDelete("Dolly17"); ObjectDelete("Dolly18"); ObjectDelete("Dolly19"); ObjectDelete("Dolly20");
   ObjectDelete("Dolly21"); ObjectDelete("Dolly22"); ObjectDelete("Dolly23"); ObjectDelete("Dolly24");
   ObjectDelete("Dolly25"); ObjectDelete("Dolly26"); ObjectDelete("Dolly27"); ObjectDelete("Dolly28");
   ObjectDelete("Dolly29"); ObjectDelete("Dolly30"); ObjectDelete("Dolly31"); ObjectDelete("Dolly32");
   ObjectDelete("Dolly33"); ObjectDelete("Dolly34"); ObjectDelete("Dolly35"); ObjectDelete("Dolly36");
   ObjectDelete("Dolly37"); ObjectDelete("Dolly38"); ObjectDelete("Dolly39"); ObjectDelete("Dolly40");
   ObjectDelete("Dolly41"); ObjectDelete("Dolly42"); ObjectDelete("Dolly43"); ObjectDelete("Dolly44");
   ObjectDelete("Dolly45"); ObjectDelete("Dolly46"); ObjectDelete("Dolly47"); ObjectDelete("Dolly48");
   ObjectDelete("Dolly49"); ObjectDelete("Dolly50"); ObjectDelete("Dolly51");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName(IND_NAME);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   CreateP();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateP()
  {
   ObjectsDeleteAll(0,OBJ_TRENDBYANGLE);
   DeleteCreatePivots1();
   CreateDL();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteCreatePivots1()
  {
   ObjectDelete(P1);
   ObjectDelete(DHI);
   ObjectDelete(DLO);
   ObjectDelete(DO);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateDL()
  {
   ObjectsDeleteAll(0,OBJ_RECTANGLE);
   DeleteDollyGraphics();
   CreateAL();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteDollyGraphics()
  {
   ObjectDelete(DollyBUY3);
   ObjectDelete(DollyBUY2);
   ObjectDelete(DollyBUY1);
   ObjectDelete(DollySELL1);
   ObjectDelete(DollySELL2);
   ObjectDelete(DollySELL3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateAL()
  {
   ObjectsDeleteAll(0,OBJ_RECTANGLE);
   DeleteAvGraphics();
   CreatePP();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteAvGraphics()
  {
   ObjectDelete (AvBUY150);  ObjectDelete (AvBUY125);  ObjectDelete (AvBUY100); ObjectDelete (AvBUY75);
   ObjectDelete (AvSELL75);  ObjectDelete (AvSELL100);  ObjectDelete (AvSELL125);  ObjectDelete (AvSELL150);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreatePP()
  {
   ObjectsDeleteAll(0,OBJ_TRENDBYANGLE);
   DeleteCreatePivots();
   CreateFIB();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteCreatePivots()
  {
   ObjectDelete(PP1); ObjectDelete(RR3); ObjectDelete(RR2); ObjectDelete(RR1);
   ObjectDelete(SS1); ObjectDelete(SS2); ObjectDelete(SS3); ObjectDelete(P1);
   ObjectDelete(MM1); ObjectDelete(MM2); ObjectDelete(MM3);
   ObjectDelete(MM4); ObjectDelete(MM5); ObjectDelete(MM0);
   ObjectDelete(DDHI); ObjectDelete(DDLO);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreatePivots1(string Pivots1, double Start, double end,double w, double s,color clr)
  {
   ObjectCreate(Pivots1, OBJ_TRENDBYANGLE, 0, iTime(NULL,1440,0)+GMTshift*3600, Start, Time[0],w,(datetime)s, end);
   ObjectSet(Pivots1, OBJPROP_COLOR, clr);
   ObjectSet(Pivots1,OBJPROP_RAY,false);
   ObjectSet(Pivots1,OBJPROP_BACK,true);
   ObjectSet(Pivots1,OBJPROP_WIDTH,w);
   ObjectSet(Pivots1,OBJPROP_STYLE,s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateDollyGraphics(string Dolly, double Start, double end, color clr)
  {
   ObjectCreate(Dolly, OBJ_RECTANGLE, 0, iTime(NULL,1440,0)+GMTshift*3600, Start, Time[0], end);
   ObjectSet(Dolly, OBJPROP_COLOR, clr);
   ObjectSet(Dolly,OBJPROP_BACK,Dolly_GRAPHICS);
   ObjectSet(Dolly,OBJPROP_WIDTH,2);
   ObjectSet(Dolly,OBJPROP_STYLE,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateAvGraphics(string DailyAv, double Start, double end, color clr)
  {
   ObjectCreate(DailyAv, OBJ_RECTANGLE, 0, iTime(NULL,1440,0)+GMTshift*3600, Start, Time[0], end);
   ObjectSet(DailyAv, OBJPROP_COLOR, clr);
   ObjectSet(DailyAv,OBJPROP_BACK,Daily_AverageGRAPHICS);
   ObjectSet(DailyAv,OBJPROP_WIDTH,0);
   ObjectSet(DailyAv,OBJPROP_STYLE,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreatePivots(string Pivots, double Start, double end,double w, double s,color clr)
  {
   ObjectCreate(Pivots, OBJ_TRENDBYANGLE, 0, iTime(NULL,1440,PivotPoint_ExtendLINE+0), Start, Time[0],w,(datetime)s, end);
   ObjectSet(Pivots, OBJPROP_COLOR, clr);
   ObjectSet(Pivots,OBJPROP_RAY,false);
   ObjectSet(Pivots,OBJPROP_WIDTH,w);
   ObjectSet(Pivots,OBJPROP_STYLE,s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateFibs(string FibLevels, double Start, double end,double w, double s,color clr)
  {
   ObjectCreate(FibLevels, OBJ_TRENDBYANGLE, 0, iTime(NULL,1440,FIB_ExtendDISPLAY), Start, Time[0],w,(datetime)s, end);
   ObjectSet(FibLevels, OBJPROP_COLOR, clr);
   ObjectSet(FibLevels,OBJPROP_RAY,false);
   ObjectSet(FibLevels,OBJPROP_WIDTH,w);
   ObjectSet(FibLevels,OBJPROP_STYLE,s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteCreateFibs()
  {
   ObjectDelete(Fib100); ObjectDelete(Fib764); ObjectDelete(Fib618); ObjectDelete(Fib50);
   ObjectDelete(Fib236); ObjectDelete(Fib0); ObjectDelete(Fib382);
   ObjectDelete(FibP100); ObjectDelete(FibP618); ObjectDelete(FibP50); ObjectDelete(FibP382);
   ObjectDelete(FibM100); ObjectDelete(FibM618); ObjectDelete(FibM50); ObjectDelete(FibM382);
   ObjectDelete(FibP236); ObjectDelete(FibM236); ObjectDelete(FibP764); ObjectDelete(FibM764);
   ObjectDelete(FibP150); ObjectDelete(FibM150); ObjectDelete(FibP200); ObjectDelete(FibM200);
   ObjectDelete(FibP250); ObjectDelete(FibM250); ObjectDelete(FibP300); ObjectDelete(FibM300);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateFIB()
  {
   ObjectsDeleteAll(0,OBJ_TRENDBYANGLE);
   DeleteCreateFibs();
//---- Get new daily prices & calculate pivots
   day_high=0;
   day_low=0;
   yesterday_open=0;
   today_open=0;
   cur_day=0;
   prev_day=0;
//----
   int cnt=720;
   if(Bars<cnt) cnt=Bars-2;
   while(cnt!= 0)
     {
      if (TimeDayOfWeek(Time[cnt])==0)
        {
         cur_day=prev_day;
        }
      else
        {
         cur_day=TimeDay(Time[cnt]-(GMTshift*3600));
        }
      if (prev_day!=cur_day)
        {
         yesterday_close=Close[cnt+1];
         today_open=Open[cnt];
         yesterday_high=day_high;
         yesterday_low=day_low;
         day_high=High[cnt];
         day_low =Low[cnt];
         prev_day=cur_day;
        }
      if (High[cnt]>day_high)
        {
         day_high=High[cnt];
        }
      if (Low[cnt]<day_low)
        {
         day_low=Low[cnt];
        }
      cnt--;
     }
   P=(yesterday_high + yesterday_low + yesterday_close)/3;//Pivot
   //Pivots & M Pivots
   double r3 =(2 * P)+(yesterday_high -(2 * yesterday_low ));
   double r2=P +(yesterday_high - yesterday_low );
   double r1 =(2 * P)- yesterday_low;
   double s1 =(2 * P)- yesterday_high;
   double s2=P -(yesterday_high- yesterday_low);
   double s3 =(2 * P)-(( 2 * yesterday_high)- yesterday_low );
//----
   double m0=(s2 + s3)/2;
   double m1=(s1 + s2)/2;
   double m2=(P + s1)/2;
   double m3=(P + r1)/2;
   double m4=(r1 + r2)/2;
   double m5=(r2 + r3)/2;
//----
   double OPEN=today_open;
   double HI2=iHigh(NULL,1440,0);
   double LOW2=iLow(NULL,1440,0);
   double HI3=yesterday_high;
   double LOW3=yesterday_low;
   double HI4=iHigh(NULL,1440,0);
   double LOW4=iLow(NULL,1440,0);
   double HI5=iHigh(NULL,1440,2);
   double LOW5=iLow(NULL,1440,2);
   double HI6=iHigh(NULL,1440,3);
   double LOW6=iLow(NULL,1440,3);
   double HI7=iHigh(NULL,1440,4);
   double LOW7=iLow(NULL,1440,4);
   double HI8=iHigh(NULL,1440,5);
   double LOW8=iLow(NULL,1440,5);
   double HI9=iHigh(NULL,1440,6);
   double LOW9=iLow(NULL,1440,6);
   double HI10=iHigh(NULL,1440,7);
   double LOW10=iLow(NULL,1440,7);
   double HI11=iHigh(NULL,1440,8);
   double LOW11=iLow(NULL,1440,8);
   double HI12=iHigh(NULL,1440,9);
   double LOW12=iLow(NULL,1440,9);
   double HI13=iHigh(NULL,1440,10);
   double LOW13=iLow(NULL,1440,10);
   double HI14=iHigh(NULL,1440,11);
   double LOW14=iLow(NULL,1440,11);
   double HI15=iHigh(NULL,1440,12);
   double LOW15=iLow(NULL,1440,12);
   double HI16=iHigh(NULL,1440,13);
   double LOW16=iLow(NULL,1440,13);
   double HI17=iHigh(NULL,1440,14);
   double LOW17=iLow(NULL,1440,14);
   double HI18=iHigh(NULL,1440,15);
   double LOW18=iLow(NULL,1440,15);
   double HI19=iHigh(NULL,1440,16);
   double LOW19=iLow(NULL,1440,16);
   double HI20=iHigh(NULL,1440,17);
   double LOW20=iLow(NULL,1440,17);
   double HI21=iHigh(NULL,1440,18);
   double LOW21=iLow(NULL,1440,18);
   double HI22=iHigh(NULL,1440,19);
   double LOW22=iLow(NULL,1440,19);
   double HI23=iHigh(NULL,1440,20);
   double LOW23=iLow(NULL,1440,20);
//----
   double ONE=(HI3-LOW3);
   double FIVE=((HI3-LOW3)+(HI5-LOW5)+(HI6-LOW6)+(HI7-LOW7)+(HI8-LOW8))/5;
   double TEN=((HI3-LOW3)+(HI5-LOW5)+(HI6-LOW6)+(HI7-LOW7)+(HI8-LOW8)+
                 (HI9-LOW9)+(HI10-LOW10)+(HI11-LOW11)+(HI12-LOW12)+(HI13-LOW13))/10;
   double TWENTY=((HI3-LOW3)+(HI5-LOW5)+(HI6-LOW6)+(HI7-LOW7)+(HI8-LOW8)+
              (HI9-LOW9)+(HI10-LOW10)+(HI11-LOW11)+(HI12-LOW12)+(HI13-LOW13)+
              (HI14-LOW14)+(HI15-LOW15)+(HI16-LOW16)+(HI17-LOW17)+(HI18-LOW18)+
              (HI19-LOW19)+(HI20-LOW20)+(HI21-LOW21)+(HI22-LOW22)+(HI23-LOW23))/20;
   double AV=(ONE+FIVE+TEN+TWENTY)/4;// New Setting AV = (FIVE+TEN+TWENTY)/3;
   //Add for Open Graphics - hymns
   double DollyOpenGraphics;
   if (Using_OpenGraphics==true) { DollyOpenGraphics=OPEN; }
   else { DollyOpenGraphics=P; }
   //Tweak for Open Graphics - hymns   
   double AvDN150=DollyOpenGraphics-AV/2*3;
   double AvUP150=DollyOpenGraphics+AV/2*3;
   double AvDN125=DollyOpenGraphics-AV/4*5;
   double AvUP125=DollyOpenGraphics+AV/4*5;
   double AvDN100=DollyOpenGraphics-AV;
   double AvUP100=DollyOpenGraphics+AV;
   double AvDN75=DollyOpenGraphics-AV/4*3;
   double AvUP75=DollyOpenGraphics+AV/4*3;
   double AvDN50=DollyOpenGraphics-AV/2;
   double AvUP50=DollyOpenGraphics+AV/2;
   double AvDN25=DollyOpenGraphics-AV/4;
   double AvUP25=DollyOpenGraphics+AV/4;
//----
   double CLOSE=iClose(NULL,1440,0);
   double F;
   F=(yesterday_high-yesterday_low);
   double FIBP300= yesterday_low + F*4.00;
   double FIBP250= yesterday_low + F*3.5;
   double FIBP200= yesterday_low + F*3.00;
   double FIBP150= yesterday_low + F*2.5;
   double FIBP100= yesterday_low + F*2.00;
   double FIBP764=yesterday_low + F*1.764;
   double FIBP618= yesterday_low + F*1.618;
   double FIBP50=yesterday_low + F*1.5;
   double FIBP382= yesterday_low + F*1.382;
   double FIBP236=yesterday_low + F*1.236;
   double FIB100= yesterday_high;
   double FIB764=yesterday_low + F*0.764;
   double FIB618= yesterday_low + F*0.618;
   double FIB50=yesterday_low + F*0.5;
   double FIB382= yesterday_low + F*0.382;
   double FIB236=yesterday_low + F*0.236;
   double FIB0=yesterday_low + F*0.0;
   double FIBM236=yesterday_low - F*0.236;
   double FIBM382= yesterday_low - F*0.382;
   double FIBM50=yesterday_low - F*0.5;
   double FIBM618= yesterday_low - F*0.618;
   double FIBM764=yesterday_low  - F*0.764;
   double FIBM100= yesterday_low - F*1.00;
   double FIBM150= yesterday_low - F*1.5;
   double FIBM200= yesterday_low - F*2.00;
   double FIBM250= yesterday_low - F*2.5;
   double FIBM300= yesterday_low - F*3.00;
   //Tweak for Open Graphics - hymns  
   B1=DollyOpenGraphics + BUY_Area * Point; // Logic to determine Buy Area 
   S1=DollyOpenGraphics - SELL_Area * Point; // Logic to determine Sell Area 
   B2=DollyOpenGraphics + BUY_Target_1 * Point; // Logic to determine High Break Area 
   S2=DollyOpenGraphics - SELL_Target_1 * Point; // Logic to determine Low Break Area )
   B3=DollyOpenGraphics + BUY_Target_2 * Point; // Logic to determine High Target Area 
   S3=DollyOpenGraphics - SELL_Target_2 * Point; // Logic to determine Low Target Area 
   ObjectsRedraw();
//----
   if (Alert_ON ==true)
     {
      if(Ask>(B1-2*Point)&&Ask<(B1+2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : BUY AREA  @  "+(DoubleToStr (B1,Digits))+"");}
      if(Bid<(S1+2*Point)&&Bid>(S1-2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : SELL AREA  @  "+(DoubleToStr (S1,Digits))+"" );}
      if(Ask>(B2-2*Point)&&Ask<(B2+2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : BUY TARGET #1  @  "+(DoubleToStr (B2,Digits))+"" );}
      if(Bid<(S2+2*Point)&&Bid>(S2-2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : SELL TARGET #1  @  "+(DoubleToStr (S2,Digits))+"" );}
      if(Ask>(B3-2*Point)&&Ask<(B3+2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : BUY TARGET #2  @  "+(DoubleToStr (B3,Digits))+"" );}
      if(Bid<(S3+2*Point)&&Bid>(S3-2*Point)){ Alert(Symbol()," M",Period()," : DOLLY : SELL TARGET #2  @  "+(DoubleToStr (S3,Digits))+"" );}
     }
   string Signal="",Signal2=""; color Dolly_col=clrNONE,Dolly_col2=clrNONE;
   if(Show_DollyCOMMENTS==true )
     {
      if(Auto_Signals==true )
        {
         if (Using_OpenGraphics==true)
           {
            Signal="Currently Signals Pending ................................."; Dolly_col=  clrCrimson;
              if(Ask>(B1-3*Point)&&Ask<(B1+3*Point)){Signal="OPEN + ["+(string)BUY_Area+"] @ "+DoubleToStr(B1,Digits)+""
               +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"";
               Dolly_col=C'0,250,250';
              }
              if(Ask>(B2-3*Point)&&Ask<(B2+3*Point)){Signal="BUY Stop : OPEN + ["+(string)BUY_Target_1+"] @ "+DoubleToStr(B2,Digits)+""
               +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"";
               Dolly_col= C'0,250,250';
              }
              if(Ask>(B3-3*Point)&&Ask<(B3+3*Point)){Signal="BUY Stop : OPEN + ["+(string)BUY_Target_2 +"] @ "+DoubleToStr(B3,Digits)+""
               +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"";
               Dolly_col =C'0,250,250' ;
              }
              if(Ask>(AvUP100-3*Point)&&Ask<(AvUP100+3*Point)){Signal="Caution approaching Daily Average Range @ "+DoubleToStr(AvUP100,Digits)+"";
               Dolly_col=YellowGreen;
              }
              if(Bid>(AvDN100+3*Point)&&Bid<(AvDN100-3*Point)){Signal="Caution approaching Daily Average Range @ "+DoubleToStr(AvDN100,Digits)+"";
               Dolly_col=YellowGreen;
              }
              if(Bid<(S1+3*Point)&&Bid>(S1-3*Point)){Signal="OPEN - ["+(string)SELL_Area+"] @ "+DoubleToStr(S1,Digits)+""
               +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"";
               Dolly_col= C'250,150,0';
              }
              if(Bid<(S2+3*Point)&&Bid>(S2-3*Point)){Signal="SELL Stop : OPEN - ["+(string)SELL_Target_1+"] @ "+DoubleToStr(S2,Digits)+""
               +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"";
               Dolly_col= C'250,150,0';
              }
              if(Bid<(S3+3*Point)&&Bid>(S3-3*Point)){Signal="SELL Stop : OPEN - ["+(string)SELL_Target_2+"] @ "+DoubleToStr(S3,Digits)+""
               +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"";
               Dolly_col=C'250,150,0';
              }
              if(Bid<(P+3*Point)&&Bid>(P-3*Point)){Signal="Caution possible reversal  PIVOT @ "+DoubleToStr(P,Digits)+"";
               Dolly_col=White;
              }
              if(Bid<(OPEN+2*Point)&&Bid>(OPEN-2*Point)){Signal="Caution possible reversal  OPEN @ "+DoubleToStr(OPEN,Digits)+"";
               Dolly_col=White;
              }
              if((Bid>S1)&& (Bid<B1)){Signal2="Price Currently between BUY & SELL ZONES";
               Dolly_col2= C'255,230,0';
              }
              if((Bid<=S1)&& (Bid>S2)){Signal2="Price Currently in SELL ZONE #1";
               Dolly_col2= C'250,50,0';
              }
              if((Bid<=S2)&& (Bid>S3)){Signal2="Price Currently in SELL ZONE #2";
               Dolly_col2= C'250,90,0';
              }
              if((Bid>=B1)&& (Bid<B2)){Signal2="Price Currently in BUY ZONE #1";
               Dolly_col2= C'0,120,250';
              }
              if((Bid>=B2)&& (Bid<B3)){Signal2="Price Currently in BUY ZONE #2";
               Dolly_col2=  C'0,180,250';
              }
              if((Bid>=B3)&& (Bid<AvUP100)){Signal2="Price Currently Between BUY ZONE #2 & 100% D/AV";
               Dolly_col2=C'120,250,250';
              }
              if((Bid<=S3)&& (Bid>AvDN100)){Signal2="Price Currently Between SELL ZONE #2 & 100% D/AV";
               Dolly_col2= C'220,250,0';//
              }
           }
         if (Using_OpenGraphics==false)
           {
            Signal="Currently Signals Pending ................................."; Dolly_col= C'250,250,0';
              if(Ask>(B1-3*Point)&&Ask<(B1+3*Point)){Signal="PIVOT + ["+(string)BUY_Area+"] @ "+DoubleToStr(B1,Digits)+""
               +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"";
               Dolly_col=C'0,250,250';
              }
              if(Ask>(B2-3*Point)&&Ask<(B2+3*Point)){Signal="BUY Stop : PIVOT + ["+(string)BUY_Target_1+"] @ "+DoubleToStr(B2,Digits)+""
               +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"";
               Dolly_col= C'0,250,250';
              }
              if(Ask>(B3-3*Point)&&Ask<(B3+3*Point)){Signal="BUY Stop : PIVOT + ["+(string)BUY_Target_2 +"] @ "+DoubleToStr(B3,Digits)+""
               +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"";
               Dolly_col =C'0,250,250' ;
              }
              if(Ask>(AvUP100-3*Point)&&Ask<(AvUP100+3*Point)){Signal="Caution approaching Daily Average Range @ "+DoubleToStr(AvUP100,Digits)+"";
               Dolly_col=YellowGreen;
              }
              if(Bid>(AvDN100+3*Point)&&Bid<(AvDN100-3*Point)){Signal="Caution approaching Daily Average Range @ "+DoubleToStr(AvDN100,Digits)+"";
               Dolly_col=YellowGreen;
              }
              if(Bid<(S1+3*Point)&&Bid>(S1-3*Point)){Signal="PIVOT - ["+(string)SELL_Area+"] @ "+DoubleToStr(S1,Digits)+""
               +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"";
               Dolly_col=C'250,150,0';
              }
              if(Bid<(S2+3*Point)&&Bid>(S2-3*Point)){Signal="SELL Stop : PIVOT - ["+(string)SELL_Target_1+"] @ "+DoubleToStr(S2,Digits)+""
               +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"";
               Dolly_col= C'250,150,0';
              }
              if(Bid<(S3+3*Point)&&Bid>(S3-3*Point)){Signal="SELL Stop : PIVOT - ["+(string)SELL_Target_2+"] @ "+DoubleToStr(S3,Digits)+""
               +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
               +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"";
               Dolly_col=C'250,150,0';
              }
              if(Bid<(P+3*Point)&&Bid>(P-3*Point)){Signal="Caution possible reversal  PIVOT @ "+DoubleToStr(P,Digits)+"";
               Dolly_col=White;
              }
              if(Bid<(OPEN+2*Point)&&Bid>(OPEN-2*Point)){Signal="Caution possible reversal  OPEN @ "+DoubleToStr(OPEN,Digits)+"";
               Dolly_col=White;
              }
              if((Bid>S1)&& (Bid<B1)){Signal2="Price Currently between BUY & SELL ZONES";
               Dolly_col2= C'255,230,0';
              }
              if((Bid<=S1)&& (Bid>S2)){Signal2="Price Currently in SELL ZONE #1";
               Dolly_col2= C'250,50,0';
              }
              if((Bid<=S2)&& (Bid>S3)){Signal2="Price Currently in SELL ZONE #2";
               Dolly_col2= C'250,90,0';
              }
              if((Bid>=B1)&& (Bid<B2)){Signal2="Price Currently in BUY ZONE #1";
               Dolly_col2= C'0,120,250';
              }
              if((Bid>=B2)&& (Bid<B3)){Signal2="Price Currently in BUY ZONE #2";
               Dolly_col2=  C'0,180,250';
              }
              if((Bid>=B3)&& (Bid<AvUP100)){Signal2="Price Currently Between BUY ZONE #2 & 100% D/AV";
               Dolly_col2=C'120,250,250';
              }
              if((Bid<=S3)&& (Bid>AvDN100)){Signal2="Price Currently Between SELL ZONE #2 & 100% D/AV";
               Dolly_col2= C'220,250,0';//
              }
           }
         //{Signal = "Waiting..."; col = Orange;}
         ObjectCreate("Signal", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("Signal", Signal, 11,"Arial Bold", Dolly_col);
         ObjectSet("Signal", OBJPROP_CORNER, 0);
         ObjectSet("Signal", OBJPROP_XDISTANCE, 20);
         ObjectSet("Signal", OBJPROP_YDISTANCE, 65);
//----
         ObjectCreate("Signal2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("Signal2", Signal2, 11,"Arial Bold", Dolly_col2);
         ObjectSet("Signal2", OBJPROP_CORNER, 0);
         ObjectSet("Signal2", OBJPROP_XDISTANCE, 20);
         ObjectSet("Signal2", OBJPROP_YDISTANCE, 85);
         // Signal = "Currently Signals Pending ................................."; col = Yellow;
         ObjectCreate("Signal1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("Signal1","Signal Auto Display", 9, "Arial", Silver);
         ObjectSet("Signal1", OBJPROP_CORNER, 4);
         ObjectSet("Signal1", OBJPROP_XDISTANCE, 20);
         ObjectSet("Signal1", OBJPROP_YDISTANCE, 47);
        }
       }
   // Dolly Colored Levels
   CreateDollyGraphics(DollyBUY3, B3, B3, C'0,0,210' );
   CreateDollyGraphics(DollyBUY2, B2, B3,BUY_Color_2); //C'0,0,150'
   CreateDollyGraphics(DollyBUY1, B1, B2,BUY_Color_1 ); //C'0,0,100'
   CreateDollyGraphics(DollySELL1, S1, S2,SELL_Color_1 ); //C'120,0,0'
   CreateDollyGraphics(DollySELL2, S2, S3,SELL_Color_2 ); //C'180,0,0'
   CreateDollyGraphics(DollySELL3, S3, S3, C'230,0,0');
   //Daily Average Colored Levels   
   if (Show_DailyAverageGRAPHICS==true)
     {
      CreateAvGraphics(AvBUY150,AvUP150,AvUP125, DAILY_Av_UP_Color_150 ); // C'0,110,255'
      CreateAvGraphics(AvBUY125,AvUP125,AvUP100, DAILY_Av_UP_Color_125); //C'0,70,255'
      CreateAvGraphics(AvBUY100,AvUP100,AvUP75,DAILY_Av_UP_Color_100); //C'20,20,255'
      CreateAvGraphics(AvBUY75,AvUP75,B3,DAILY_Av_UP_Color_75 ); //C'0,0,210'
      CreateAvGraphics(AvSELL75,AvDN75,S3,DAILY_Av_DN_Color_75 ); //C'220,0,0'
      CreateAvGraphics(AvSELL100,AvDN100,AvDN75,DAILY_Av_DN_Color_100); // C'255,0,0'
      CreateAvGraphics(AvSELL125,AvDN100,AvDN125,DAILY_Av_DN_Color_125); //C'255,70,0'
      CreateAvGraphics(AvSELL150,AvDN125,AvDN150,DAILY_Av_DN_Color_150); // C'255,110,0'
     }
   //Create Pivot Line   
   CreatePivots1(P1,P,P,2,0, DimGray);
   //Show Pivot Support & Resistance Lines
   if (Show_PivotLines==true)
     {
      CreatePivots(PP1,P,P,2,1, Gray);
      CreatePivots(RR3,r3,r3,1,0, Gray);
      CreatePivots(RR2,r2,r2,1,0, Gray);
      CreatePivots(RR1,r1,r1,1,0, Gray);
      CreatePivots(SS1,s1,s1,1,0, Gray);
      CreatePivots(SS2,s2,s2,1,0, Gray);
      CreatePivots(SS3,s3,s3,1,0, Gray);
     }
   //Show Middle Pivot Lines
   if (Show_M_PivotLines==true)
     {
      CreatePivots(MM5,m5,m5,1,2, Gray);
      CreatePivots(MM4,m4,m4,1,2, Gray);
      CreatePivots(MM3,m3,m3,1,2, Gray);
      CreatePivots(MM2,m2,m2,1,2, Gray);
      CreatePivots(MM1,m1,m1,1,2, Gray);
      CreatePivots(MM0,m0,m0,1,2, Gray);
     }
   //Show Fibo Lines     
   if (Show_FibLines==true)
     {
      CreateFibs(FibP100, FIBP100, FIBP100,1,0,Green );
      CreateFibs(FibP764, FIBP764, FIBP764,1,0, C'0,53,0' );
      CreateFibs(FibP618, FIBP618, FIBP618,1,0, Green);
      CreateFibs(FibP50, FIBP50, FIBP50,1,0, C'0,53,0' );
      CreateFibs(FibP382, FIBP382, FIBP382,1,0, Green );
      CreateFibs(FibP236, FIBP236, FIBP236,1,0, C'0,53,0' );
      CreateFibs(Fib100, FIB100, FIB100,1,0,  C'0,200,0');
      CreateFibs(Fib764, FIB764, FIB764,1,0, C'0,53,0' );
      CreateFibs(Fib618, FIB618, FIB618,1,0, Green );
      CreateFibs(Fib50, FIB50, FIB50,1,0, C'0,53,0' );
      CreateFibs(Fib382, FIB382, FIB382,1,0, Green );
      CreateFibs(Fib236, FIB236, FIB236,1,0, C'0,53,0' );
      CreateFibs(Fib0, FIB0, FIB0,1,0,  C'0,200,0' );
      CreateFibs(FibM236, FIBM236, FIBM236,1,0, C'0,53,0' );
      CreateFibs(FibM382, FIBM382, FIBM382,1,0, Green );
      CreateFibs(FibM50, FIBM50, FIBM50,1,0, C'0,53,0' );
      CreateFibs(FibM618, FIBM618, FIBM618,1,0, Green );
      CreateFibs(FibM764, FIBM764, FIBM764,1,0,C'0,53,0');
      CreateFibs(FibM100, FIBM100, FIBM100,1,0, Green );
     }
   //Show Extra Fibo Lines
   if (Show_EXTRAFibLines==true)
     {
      CreateFibs(FibP300, FIBP300, FIBP300,1,0, Green );
      CreateFibs(FibP250, FIBP250, FIBP250,1,0, Green );
      CreateFibs(FibP200, FIBP200, FIBP200,1,0, Green );
      CreateFibs(FibP150, FIBP150, FIBP150,1,0, Green );
//----
      CreateFibs(FibM150, FIBM150, FIBM150,1,0, Green );
      CreateFibs(FibM200, FIBM200, FIBM200,1,0, Green );
      CreateFibs(FibM250, FIBM250, FIBM250,1,0, Green );
      CreateFibs(FibM300, FIBM300, FIBM300,1,0, Green );
     }
   //Show Daily HI-LOW
   if (Show_Daily_HI_LOW==true)
     {
      CreatePivots1(DHI,HI3,HI3,2,0, Turquoise);
      CreatePivots1(DLO,LOW3,LOW3,2,0, Turquoise);
      CreatePivots(DDHI,HI3,HI3,2,0, Turquoise);
      CreatePivots(DDLO,LOW3,LOW3,2,0, Turquoise);
     }
   //Show Daily Open
   if (Show_Daily_OPEN==true || Using_OpenGraphics==true) //Tweak for Open Graphics - hymns
     {
      CreatePivots1(DO,OPEN,OPEN,2,0, YellowGreen);
     }
   //Buy	  
   if(ObjectFind("B1")!=0)
     {
      ObjectCreate("B1", OBJ_TEXT, 0, Time[SHIFT_DollyText], B1);
      ObjectSetText("B1", "                        BUY AREA", 8, "Arial",DodgerBlue);
      ObjectSet("B1",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("B1", 0, Time[SHIFT_DollyText], B1);
     }
   if(ObjectFind("B2")!=0)
     {
      ObjectCreate("B2", OBJ_TEXT, 0, Time[SHIFT_DollyText], B2);
      ObjectSetText("B2", "                                   1st BUY TARGET ", 8, "Arial",DodgerBlue);
      ObjectSet("B2",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("B2", 0, Time[SHIFT_DollyText],B2);
     }
   if(ObjectFind("B3")!=0)
     {
      ObjectCreate("B3", OBJ_TEXT, 0, Time[SHIFT_DollyText], B3);
      ObjectSetText("B3", "                             2nd TARGET ", 8, "Arial",DodgerBlue);
      ObjectSet("B3",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("B3", 0, Time[SHIFT_DollyText], B3);
     }
   //Sell
   if(ObjectFind("S1")!=0)
     {
      ObjectCreate("S1", OBJ_TEXT, 0, Time[SHIFT_DollyText],S1);
      ObjectSetText("S1", "                         SELL AREA", 8, "Arial", Orange);
      ObjectSet("S1",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("S1", 0, Time[SHIFT_DollyText], S1);
     }
   if(ObjectFind("S2")!=0)
     {
      ObjectCreate("S2", OBJ_TEXT, 0, Time[SHIFT_DollyText], S2);
      ObjectSetText("S2", "                                   1st SELL TARGET ", 8, "Arial",Orange);
      ObjectSet("S2",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("S2", 0, Time[SHIFT_DollyText], S2);
     }
   if(ObjectFind("S3")!=0)
     {
      ObjectCreate("S3", OBJ_TEXT, 0, Time[SHIFT_DollyText], S3);
      ObjectSetText("S3", "                             2nd TARGET ", 8, "Arial",Orange);
      ObjectSet("S3",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("S3", 0, Time[SHIFT_DollyText], S3);
     }
   //Pivot
   if(ObjectFind("Pivot")!=0)
     {
      ObjectCreate("Pivot", OBJ_TEXT, 0, Time[SHIFT_DollyText], P);
      ObjectSetText("Pivot", "                             PIVOT "+ DoubleToStr(P,Digits)+"", 8, "Arial",Silver);
      ObjectSet("Pivot",OBJPROP_BACK,true);
     }
     else
     {
      ObjectMove("Pivot", 0, Time[SHIFT_DollyText], P);
     }
   //Average Levels
   if (Show_DailyAverageGRAPHICS==true)
     {
      if(ObjectFind("TOP/AV150")!=0)
        {
         ObjectCreate("TOP/AV150", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP150);
         ObjectSetText("TOP/AV150", "                                    150% ", 8, "Arial", DeepSkyBlue);
         ObjectSet("TOP/AV150",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV150", 0, Time[SHIFT_DailyAverageText], AvUP150);
        }
        if(ObjectFind("LOW/AV150")!=0)
        {
         ObjectCreate("LOW/AV150", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN150);
         ObjectSetText("LOW/AV150", "                                    150% ", 8, "Arial", Green);
         ObjectSet("LOW/AV150",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV150", 0, Time[SHIFT_DailyAverageText], AvDN150);
        }
      if(ObjectFind("TOP/AV125")!=0)
        {
         ObjectCreate("TOP/AV125", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP125);
         ObjectSetText("TOP/AV125", "                                    125% ", 8, "Arial", DeepSkyBlue);
         ObjectSet("TOP/AV125",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV125", 0, Time[SHIFT_DailyAverageText], AvUP125);
        }
      if(ObjectFind("LOW/AV125")!=0)
        {
         ObjectCreate("LOW/AV125", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN125);
         ObjectSetText("LOW/AV125", "                                    125% ", 8, "Arial", Green);
         ObjectSet("LOW/AV125",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV125", 0, Time[SHIFT_DailyAverageText], AvDN125);
        }
      if(ObjectFind("TOP/AV100")!=0)
        {
         ObjectCreate("TOP/AV100", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP100);
         ObjectSetText("TOP/AV100", "                                   100%", 8, "Arial", DeepSkyBlue);
         ObjectSet("TOP/AV100",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV100", 0, Time[SHIFT_DailyAverageText], AvUP100);
        }
      if(ObjectFind("LOW/AV100")!=0)
        {
         ObjectCreate("LOW/AV100", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN100);
         ObjectSetText("LOW/AV100", "                                    100% ", 8, "Arial", Green);
         ObjectSet("LOW/AV100",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV100", 0, Time[SHIFT_DailyAverageText], AvDN100);
        }
      if(ObjectFind("TOP/AV75")!=0)
        {
         ObjectCreate("TOP/AV75", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP75);
         ObjectSetText("TOP/AV75", "                                      75% ", 8, "Arial", DeepSkyBlue);
         ObjectSet("TOP/AV75",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV75", 0, Time[SHIFT_DailyAverageText], AvUP75);
        }
      if(ObjectFind("LOW/AV75")!=0)
        {
         ObjectCreate("LOW/AV75", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN75);
         ObjectSetText("LOW/AV75", "                                     75%", 8, "Arial", Green);
         ObjectSet("LOW/AV75",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV75", 0, Time[SHIFT_DailyAverageText], AvDN75);
        }
      if(ObjectFind("LOW/AV50")!=0)
        {
         ObjectCreate("LOW/AV50", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP50);
         ObjectSetText("LOW/AV50", "                                       50% ", 8, "Arial",DeepSkyBlue );
         ObjectSet("LOW/AV50",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV50", 0, Time[SHIFT_DailyAverageText], AvUP50);
        }
      if(ObjectFind("TOP/AV50")!=0)
        {
         ObjectCreate("TOP/AV50", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN50);
         ObjectSetText("TOP/AV50", "                                      50% ", 8, "Arial",Green );
         ObjectSet("TOP/AV50",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV50", 0, Time[SHIFT_DailyAverageText], AvDN50);
        }
      if(ObjectFind("TOP/AV25")!=0)
        {
         ObjectCreate("TOP/AV25", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP25);
         ObjectSetText("TOP/AV25", "                                      25% ", 8, "Arial", DeepSkyBlue);
         ObjectSet("TOP/AV25",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("TOP/AV25", 0, Time[SHIFT_DailyAverageText], AvUP25);
        }
        if(ObjectFind("LOW/AV25")!=0)
        {
         ObjectCreate("LOW/AV25", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN25);
         ObjectSetText("LOW/AV25", "                                      25% ", 8, "Arial", Green);
         ObjectSet("LOW/AV25",OBJPROP_BACK,true);
        }
        else
        {
         ObjectMove("LOW/AV25", 0, Time[SHIFT_DailyAverageText], AvDN25);
        }
     } //Average Levels - End
   //Pivots Lines
   if (Show_PivotLines==true)
     {
      if(ObjectFind("C/PIVOT")!=0)
        {
         ObjectCreate("C/PIVOT", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], P);
         ObjectSetText("C/PIVOT", "P", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("C/PIVOT", 0, Time[SHIFT_PivotPointText], P);
        }
      if(ObjectFind("R3")!=0)
        {
         ObjectCreate("R3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r3);
         ObjectSetText("R3", "R3", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("R3", 0, Time[SHIFT_PivotPointText], r3);
        }
        if(ObjectFind("R2")!=0)
        {
         ObjectCreate("R2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r2);
         ObjectSetText("R2", "R2", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("R2", 0, Time[SHIFT_PivotPointText], r2);
        }
        if(ObjectFind("R1")!=0)
        {
         ObjectCreate("R1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r1);
         ObjectSetText("R1", "R1", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("R1", 0, Time[SHIFT_PivotPointText], r1);
        }
      if(ObjectFind("PS1")!=0)
        {
         ObjectCreate("PS1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s1);
         ObjectSetText("PS1", "S1", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("PS1", 0, Time[SHIFT_PivotPointText], s1);
        }
      if(ObjectFind("PS2")!=0)
        {
         ObjectCreate("PS2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s2);
         ObjectSetText("PS2", "S2", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("PS2", 0, Time[SHIFT_PivotPointText], s2);
        }
      if(ObjectFind("PS3")!=0)
        {
         ObjectCreate("PS3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s3);
         ObjectSetText("PS3", "S3", 8, "Arial", Silver);
        }
        else
        {
         ObjectMove("PS3", 0, Time[SHIFT_PivotPointText], s3);
        }
      //M Pivots
      if (Show_M_PivotLines==true)
        {
         if(ObjectFind("M5")!=0)
           {
            ObjectCreate("M5", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m5);
            ObjectSetText("M5", "M5", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M5", 0, Time[SHIFT_PivotPointText], m5);
           }
         if(ObjectFind("M4")!=0)
           {
            ObjectCreate("M4", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m4);
            ObjectSetText("M4", "M4", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M4", 0, Time[SHIFT_PivotPointText], m4);
           }
         if(ObjectFind("M3")!=0)
           {
            ObjectCreate("M3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m3);
            ObjectSetText("M3", "M3", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M3", 0, Time[SHIFT_PivotPointText], m3);
           }
         if(ObjectFind("M2")!=0)
           {
            ObjectCreate("M2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m2);
            ObjectSetText("M2", "M2", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M2", 0, Time[SHIFT_PivotPointText], m2);
           }
         if(ObjectFind("M1")!=0)
           {
            ObjectCreate("M1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m1);
            ObjectSetText("M1", "M1", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M1", 0, Time[SHIFT_PivotPointText], m1);
           }
         if(ObjectFind("M0")!=0)
           {
            ObjectCreate("M0", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m0);
            ObjectSetText("M0", "M0", 8, "Arial", Silver);
           }
           else
           {
            ObjectMove("M0", 0, Time[SHIFT_PivotPointText], m0);
           }
        } // M Pivot - End
     } // Pivot Lines - End
   //FIBS
   if (Show_FibLines==true)
     {
      if(ObjectFind("FIB")!=0)
        {
         ObjectCreate("FIB", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB100);
         ObjectSetText("FIB", "FIB 100% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB", 0, Time[SHIFT_FibText], FIB100);
        }
      if(ObjectFind("FIB2")!=0)
        {
         ObjectCreate("FIB2", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB50);
         ObjectSetText("FIB2", "FIB 50% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB2", 0, Time[SHIFT_FibText], FIB50);
        }
      if(ObjectFind("FIB3")!=0)
        {
         ObjectCreate("FIB3", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB0);
         ObjectSetText("FIB3", "FIB 0.00% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB3", 0, Time[SHIFT_FibText], FIB0);
        }
      if(ObjectFind("FIB4")!=0)
        {
         ObjectCreate("FIB4", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB382);
         ObjectSetText("FIB4", "FIB 0.382% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB4", 0, Time[SHIFT_FibText], FIB382);
        }
        if(ObjectFind("FIB5")!=0)
        {
         ObjectCreate("FIB5", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB618);
         ObjectSetText("FIB5", "FIB 0.618% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB5", 0, Time[SHIFT_FibText], FIB618);
        }
      if(ObjectFind("FIB6")!=0)
        {
         ObjectCreate("FIB6", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP50);
         ObjectSetText("FIB6", "FIB +1.50% ", 8, "Arial",  C'0,93,0');
        }
        else
        {
         ObjectMove("FIB6", 0, Time[SHIFT_FibText], FIBP50);
        }
      if(ObjectFind("FIB7")!=0)
        {
         ObjectCreate("FIB7", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP100);
         ObjectSetText("FIB7", "FIB +200% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB7", 0, Time[SHIFT_FibText], FIBP100);
        }
      if(ObjectFind("FIB8")!=0)
        {
         ObjectCreate("FIB8", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM50);
         ObjectSetText("FIB8", "FIB -1.50% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB8", 0, Time[SHIFT_FibText], FIBM50);
        }
      if(ObjectFind("FIB9")!=0)
        {
         ObjectCreate("FIB9", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM100);
         ObjectSetText("FIB9", "FIB -200% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB9", 0, Time[SHIFT_FibText], FIBM100);
        }
      if(ObjectFind("FIB10")!=0)
        {
         ObjectCreate("FIB10", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP382);
         ObjectSetText("FIB10", "FIB +1.382% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB10", 0, Time[SHIFT_FibText], FIBP382);
        }
      if(ObjectFind("FIB11")!=0)
        {
         ObjectCreate("FIB11", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM382);
         ObjectSetText("FIB11", "FIB -1.382% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB11", 0, Time[SHIFT_FibText], FIBM382);
        }
      if(ObjectFind("FIB12")!=0)
        {
         ObjectCreate("FIB12", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP618);
         ObjectSetText("FIB12", "FIB +1.618% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB12", 0, Time[SHIFT_FibText], FIBP618);
        }
      if(ObjectFind("FIB13")!=0)
        {
         ObjectCreate("FIB13", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM618);
         ObjectSetText("FIB13", "FIB -1.618% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB13", 0, Time[SHIFT_FibText], FIBM618);
        }
      if(ObjectFind("FIB14")!=0)
        {
         ObjectCreate("FIB14", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB764);
         ObjectSetText("FIB14", "FIB 0.764% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB14", 0, Time[SHIFT_FibText], FIB764);
        }
      if(ObjectFind("FIB15")!=0)
        {
         ObjectCreate("FIB15", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB236);
         ObjectSetText("FIB15", "FIB 0.236% ", 8, "Arial", Green);
        }
        else
        {
         ObjectMove("FIB15", 0, Time[SHIFT_FibText], FIB236);
        }
      if(ObjectFind("FIB16")!=0)
        {
         ObjectCreate("FIB16", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM236);
         ObjectSetText("FIB16", "FIB -1.236% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB16", 0, Time[SHIFT_FibText], FIBM236);
        }
      if(ObjectFind("FIB17")!=0)
        {
         ObjectCreate("FIB17", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP236);
         ObjectSetText("FIB17", "FIB +1.236% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB17", 0, Time[SHIFT_FibText], FIBP236);
        }
      if(ObjectFind("FIB18")!=0)
        {
         ObjectCreate("FIB18", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM764);
         ObjectSetText("FIB18", "FIB -1.764% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB18", 0, Time[SHIFT_FibText], FIBM764);
        }
      if(ObjectFind("FIB19")!=0)
        {
         ObjectCreate("FIB19", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP764);
         ObjectSetText("FIB19", "FIB +1.764% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB19", 0, Time[SHIFT_FibText], FIBP764);
        }
     } // Fibs - End
   //Fibs Extra
   if (Show_EXTRAFibLines==true)
     {
      if(ObjectFind("FIB120")!=0)
        {
         ObjectCreate("FIB20", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP150);
         ObjectSetText("FIB20", "FIB +250% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB20", 0, Time[SHIFT_FibText], FIBP150);
        }
      if(ObjectFind("FIB21")!=0)
        {
         ObjectCreate("FIB21", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM150);
         ObjectSetText("FIB21", "FIB -250% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB21", 0, Time[SHIFT_FibText], FIBM150);
        }
      if(ObjectFind("FIB122")!=0)
        {
         ObjectCreate("FIB22", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP200);
         ObjectSetText("FIB22", "FIB +300% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB22", 0, Time[SHIFT_FibText], FIBP200);
        }
      if(ObjectFind("FIB23")!=0)
        {
         ObjectCreate("FIB23", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM200);
         ObjectSetText("FIB23", "FIB -300% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB23", 0, Time[SHIFT_FibText], FIBM200);
        }
      if(ObjectFind("FIB124")!=0)
        {
         ObjectCreate("FIB24", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP250);
         ObjectSetText("FIB24", "FIB +350% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB24", 0, Time[SHIFT_FibText], FIBP250);
        }
      if(ObjectFind("FIB25")!=0)
        {
         ObjectCreate("FIB25", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM250);
         ObjectSetText("FIB25", "FIB -350% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB25", 0, Time[SHIFT_FibText], FIBM250);
        }
      if(ObjectFind("FIB126")!=0)
        {
         ObjectCreate("FIB26", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP300);
         ObjectSetText("FIB26", "FIB +400% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB26", 0, Time[SHIFT_FibText], FIBP300);
        }
      if(ObjectFind("FIB27")!=0)
        {
         ObjectCreate("FIB27", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM300);
         ObjectSetText("FIB27", "FIB -400% ", 8, "Arial", C'0,93,0');
        }
        else
        {
         ObjectMove("FIB27", 0, Time[SHIFT_FibText], FIBM300);
        }
     } // Fibs Extra - End
   // Daily HI-LOW
   if (Show_Daily_HI_LOW==true)
     {
      if(ObjectFind("DHIGH")!=0)
        {
         ObjectCreate("DHIGH", OBJ_TEXT, 0, Time[SHIFT_HI_LOW_TEXT], HI3);
         ObjectSetText("DHIGH", "Daily High ", 8, "Arial", Turquoise);
        }
        else
        {
         ObjectMove("DHIGH", 0, Time[SHIFT_HI_LOW_TEXT], HI3);
        }
      if(ObjectFind("DLOW")!=0)
        {
         ObjectCreate("DLOW", OBJ_TEXT, 0, Time[SHIFT_HI_LOW_TEXT], LOW3);
         ObjectSetText("DLOW", "Daily Low ", 8, "Arial", Turquoise);
        }
        else
        {
         ObjectMove("DLOW", 0, Time[SHIFT_HI_LOW_TEXT], LOW3);
        }
     } // Daily HI-LOW - End
   // Daily Open
   if (Show_Daily_OPEN==true || Using_OpenGraphics==true) //Tweak for Open Graphics - hymns
     {
      if(ObjectFind("Open")!=0)
        {
         ObjectCreate("Open", OBJ_TEXT, 0, Time[SHIFT_Daily_OPEN_TEXT], OPEN);
         ObjectSetText("Open", "                            OPEN "+ DoubleToStr(OPEN,Digits)+"", 8, "Arial Bold",YellowGreen);
        }
        else
        {
         ObjectMove("Open", 0, Time[SHIFT_Daily_OPEN_TEXT], OPEN);
        }
     } // Daily Open - End
   // Show Comments
   if (Show_DollyCOMMENTS==true)
     {
      string  NAME,BUYSTOP,BUYSTOP1,STOP,STOP1,PROFIT,PROFIT1,SELL,SELL1,STOP2,STOP3,PROFIT2,
      PROFIT3,BUYTARGT,PROFIT4,SELLTARGT,PROFIT5,OPEN1,DAR,TOTAL,TDR,LDR,TIME,
      TIME2,PRICE,CHANGE,TDR1,LDR1,STOP4,STOP5;
//----
      double ChangeVal=Bid - iOpen(Symbol(),PERIOD_D1,0);
      NAME=IND_NAME;
      BUYSTOP=(DoubleToStr (B1,Digits));
      BUYSTOP1=(DoubleToStr(B2,Digits));
      STOP=(DoubleToStr (S1,Digits));
      STOP1=(DoubleToStr(B1,Digits));
      PROFIT=(DoubleToStr ((B2),Digits));
      PROFIT1=(DoubleToStr (B3,Digits));//((B2+(10*Point)),Digits)); 
      SELL=(DoubleToStr (S1,Digits));
      SELL1=(DoubleToStr (S2,Digits));
      STOP2=(DoubleToStr (B1,Digits));
      STOP3=(DoubleToStr(S1,Digits));
      PROFIT2=(DoubleToStr ((S2),Digits));
      PROFIT3=(DoubleToStr (S3,Digits));//((S2-(10*Point)),Digits));
      BUYTARGT=(DoubleToStr(S2,Digits));
      PROFIT4=(DoubleToStr(B1,Digits));
      STOP4=(DoubleToStr(S3,Digits));
      SELLTARGT=(DoubleToStr(B2,Digits));
      PROFIT5=(DoubleToStr(S1,Digits));
      STOP5=(DoubleToStr(B3,Digits));
      OPEN1=(DoubleToStr(OPEN,Digits));
      DAR=(DoubleToStr(AV/Point,0));
      TOTAL=(DoubleToStr(HI2-LOW2,Digits));
      TDR=(DoubleToStr(P+AV,Digits));
      LDR=(DoubleToStr(P-AV,Digits));
      TDR1=(DoubleToStr(P+AV/2,Digits));
      LDR1=(DoubleToStr(P-AV/2,Digits));
      TIME=(TimeToStr(LocalTime(),Digits-6));
      TIME2=(TimeToStr(CurTime(),Digits-6));
      PRICE=(DoubleToStr(iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0),Digits));//iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);        
      CHANGE=(DoubleToStr(ChangeVal,Digits));
//----
      ObjectDelete("Dolly");
      Dolly( "Dolly", 22, 12,4);
      ObjectSetText( "Dolly",""+ NAME +"", 11, "Arial", Red );
 
      ObjectDelete("Dolly1");
      Dolly1( "Dolly1", 35, 12,4);
      ObjectSetText( "Dolly1", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
      if(Auto_Signals==false )
        {
         ObjectDelete("Dolly2");
         Dolly2( "Dolly2", 50, 12,4);
         ObjectSetText( "Dolly2", "BUY ZONE", 9, "Arial", DeepSkyBlue );
         //
         ObjectDelete("Dolly3");
         Dolly3( "Dolly3", 60, 12,4);
         ObjectSetText( "Dolly3",",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,", 8, "Arial", Black );
         //
         ObjectDelete("Dolly4");
         Dolly4( "Dolly4", 75, 12,4);
         ObjectSetText( "Dolly4", "BUY STOP-1  "+Symbol()+ "  @ ", 9, "Arial", DodgerBlue );
         //
         ObjectDelete("Dolly5");
         Dolly5( "Dolly5", 75, 12,4);
         ObjectSetText( "Dolly5"," "+ BUYSTOP +"", 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly6");
         Dolly6( "Dolly6", 90, 12,4);
         ObjectSetText( "Dolly6", "TP               and SL @    ", 9, "Arial", DodgerBlue);
         //
         ObjectDelete("Dolly7");
         Dolly7( "Dolly7", 90, 12,4);
         ObjectSetText( "Dolly7"," "+ BUYSTOP1 +"", 9, "Arial", YellowGreen);
         //
         ObjectDelete("Dolly8");
         Dolly8( "Dolly8", 90, 12,4);
         ObjectSetText( "Dolly8"," "+ STOP +"", 9, "Arial", CornflowerBlue );
         //
         ObjectDelete("Dolly9");
         Dolly9( "Dolly9", 110, 12,4);
         ObjectSetText( "Dolly9", "BUY STOP-2  "+Symbol()+ "  @ ",9, "Arial", LightBlue );
         //
         ObjectDelete("Dolly10");
         Dolly10( "Dolly10", 110, 12,4);
         ObjectSetText( "Dolly10"," "+ BUYSTOP1 +"", 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly11");
         Dolly11( "Dolly11", 125, 12,4);
         ObjectSetText( "Dolly11",  "TP               and SL @    ", 9, "Arial", LightBlue);
         //
         ObjectDelete("Dolly12");
         Dolly12( "Dolly12", 125, 12,4);
         ObjectSetText( "Dolly12"," "+ PROFIT1 +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly13");
         Dolly13( "Dolly13", 125, 12,4);
         ObjectSetText( "Dolly13", ""+ STOP1 +""  , 9, "Arial", Red );
         //
         ObjectDelete("Dolly14");
         Dolly14( "Dolly14", 140, 12,4);
         ObjectSetText( "Dolly14", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         //
         ObjectDelete("Dolly15");
         Dolly15( "Dolly15", 155, 12,4);
         ObjectSetText( "Dolly15", "SELL ZONE"  , 9, "Arial",Maroon  );
         //
         ObjectDelete("Dolly16");
         Dolly16( "Dolly16", 165, 12,4);
         ObjectSetText( "Dolly16", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         // 
         ObjectDelete("Dolly17");
         Dolly17( "Dolly17", 180, 12,4);
         ObjectSetText( "Dolly17", "SELL STOP-1  "+Symbol()+ "  to ", 9, "Arial", OrangeRed );
         //
         ObjectDelete("Dolly18");
         Dolly18( "Dolly18", 180, 12,4);
         ObjectSetText( "Dolly18"," "+ SELL +"", 9, "Arial",DarkOrange);
         //
         ObjectDelete("Dolly19");
         Dolly19( "Dolly19", 195, 12,4);
         ObjectSetText( "Dolly19",  "TP               and SL @    ", 9, "Arial", OrangeRed );
         //
         ObjectDelete("Dolly20");
         Dolly20( "Dolly20", 195, 12,4);
         ObjectSetText( "Dolly20"," "+ PROFIT2  +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly21");
         Dolly21( "Dolly21", 195, 12,4);
         ObjectSetText( "Dolly21"," "+STOP1+ " " , 9, "Arial", Yellow );
         //
         ObjectDelete("Dolly22");
         Dolly22( "Dolly22", 215, 12,4);
         ObjectSetText( "Dolly22", "SELL STOP-2  "+Symbol()+ "  to ", 9, "Arial", OrangeRed );
         //
         ObjectDelete("Dolly23");
         Dolly23( "Dolly23", 215, 12,4);
         ObjectSetText( "Dolly23"," "+ SELL1 +"", 9, "Arial",DarkOrange);
         //
         ObjectDelete("Dolly24");
         Dolly24( "Dolly24", 230, 12,4);
         ObjectSetText( "Dolly24",  "TP               and SL @    ", 9, "Arial", OrangeRed );
         //
         ObjectDelete("Dolly25");
         Dolly25( "Dolly25", 230, 12,4);
         ObjectSetText( "Dolly25"," "+ PROFIT3 +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly26");
         Dolly26( "Dolly26", 230, 12,4);
         ObjectSetText( "Dolly26"," "+STOP3+ " " , 9, "Arial", Yellow );
         //
         ObjectDelete("Dolly27");
         Dolly27( "Dolly27", 245, 12,4);
         ObjectSetText( "Dolly27", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         //
         ObjectDelete("Dolly28");
         Dolly28( "Dolly28", 260, 12,4);
         ObjectSetText( "Dolly28", "POTENTIAL REVERSAL LEVELS"  , 9, "Arial",DarkSeaGreen);
         //
         ObjectDelete("Dolly29");
         Dolly29( "Dolly29", 270, 12,4);
         ObjectSetText( "Dolly29", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         //
         ObjectDelete("Dolly30");
         Dolly30( "Dolly30", 285, 12,4);
         ObjectSetText( "Dolly30", "BEARISH CORRECTION : "  , 9, "Arial",DeepSkyBlue);
         //
         ObjectDelete("Dolly31");
         Dolly31( "Dolly31", 300, 12,4);
         ObjectSetText( "Dolly31", "BUY STOP "+Symbol()+ "  @ ", 9, "Arial", DodgerBlue );
         //
         ObjectDelete("Dolly32");
         Dolly32( "Dolly32", 300, 12,4);
         ObjectSetText( "Dolly32"," "+ BUYTARGT +"", 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly33");
         Dolly33( "Dolly33", 315, 12,4);
         ObjectSetText( "Dolly33",  "TP               and SL @    ", 9, "Arial", DodgerBlue );
         //
         ObjectDelete("Dolly34");
         Dolly34( "Dolly34", 315, 12,4);
         ObjectSetText( "Dolly34"," "+ PROFIT4  +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly35");
         Dolly35( "Dolly35", 315, 12,4);
         ObjectSetText( "Dolly35"," "+STOP4+ " " , 9, "Arial", Yellow );
         //
         ObjectDelete("Dolly36");
         Dolly36( "Dolly36", 335, 12,4);
         ObjectSetText( "Dolly36", "BULLISH CORRECTION : "  , 9, "Arial",Orange);
         //
         ObjectDelete("Dolly37");
         Dolly37( "Dolly37", 350, 12,4);
         ObjectSetText( "Dolly37", "SELL STOP "+Symbol()+ "  @ ", 9, "Arial",  OrangeRed );
         //
         ObjectDelete("Dolly38");
         Dolly38( "Dolly38", 350, 12,4);
         ObjectSetText( "Dolly38"," "+ SELLTARGT +"", 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly39");
         Dolly39( "Dolly39", 365, 12,4);
         ObjectSetText( "Dolly39",  "TP               and SL @    ", 9, "Arial",  OrangeRed );
         //
         ObjectDelete("Dolly40");
         Dolly40( "Dolly40", 365, 12,4);
         ObjectSetText( "Dolly40"," "+ PROFIT5  +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly41");
         Dolly41( "Dolly41", 365, 12,4);
         ObjectSetText( "Dolly41"," "+STOP5+ " " , 9, "Arial", Yellow );
         //
         ObjectDelete("Dolly42");
         Dolly42( "Dolly42", 380, 12,4);
         ObjectSetText( "Dolly42", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         //
         ObjectDelete("Dolly43");
         Dolly43( "Dolly43", 395, 12,4);
         ObjectSetText( "Dolly43",  "DAILY OPEN", 9, "Arial",  Orange );
         //
         ObjectDelete("Dolly44");
         Dolly44( "Dolly44", 395, 12,4);
         ObjectSetText( "Dolly44"," "+ OPEN1 +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly45");
         Dolly45( "Dolly45", 410, 12,4);
         ObjectSetText( "Dolly45","DAILY AVERAGE RANGE " , 9, "Arial",DarkSeaGreen);
         //
         ObjectDelete("Dolly46");
         Dolly46( "Dolly46", 410, 12,4);
         ObjectSetText( "Dolly46"," "+DAR+ " " , 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly47");
         Dolly47( "Dolly47", 420, 12,4);
         ObjectSetText( "Dolly47", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );  
         // Market Price
         ObjectDelete("Dolly48");
         Dolly48( "Dolly48", 435, 12,4);
         ObjectSetText( "Dolly48","Price", 10, "Arial", Silver);
         //
         ObjectDelete("Dolly49");
         Dolly49( "Dolly49", 435, 12,4);
         ObjectSetText( "Dolly49"," "+PRICE+" ", 15, "Arial", Silver);
        }
      // Today Market Change
      ObjectDelete("Dolly50");
      Dolly50( "Dolly50", 10, 12,4);
      ObjectSetText( "Dolly50","Change", 10, "Arial", Silver);
      //
      ObjectDelete("Dolly51");
      Dolly51( "Dolly51", 18, 12,4);
      if (ChangeVal==0)
        {
         ObjectSetText( "Dolly51","+"+CHANGE+" ", 15, "Arial", Gold);
        }
        else if (ChangeVal > 0) 
        {
            ObjectSetText( "Dolly51","+"+CHANGE+" ", 15, "Arial", Lime);
           }
           else 
           {
            ObjectSetText( "Dolly51"," "+CHANGE+" ", 15, "Arial", Red);
           }
     } // Show Comment - End
   if(Auto_Signals==true )
     {
     string OPEN1=(DoubleToStr(OPEN,Digits));
     string DAR=(DoubleToStr(AV/Point,0));
     string PRICE=(DoubleToStr(iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0),Digits));
      if (Show_DollyCOMMENTS==true)
        {
         ObjectDelete("Dolly42");
         Dolly42( "Dolly42", 98, 12,4);
         ObjectSetText( "Dolly42", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );
         //
         ObjectDelete("Dolly43");
         Dolly43( "Dolly43", 112, 12,4);
         ObjectSetText( "Dolly43",  "DAILY OPEN", 9, "Arial",  Orange );
         //
         ObjectDelete("Dolly44");
         Dolly44( "Dolly44", 112, 12,4);
         ObjectSetText( "Dolly44"," "+ OPEN1 +"", 9, "Arial", YellowGreen );
         //
         ObjectDelete("Dolly45");
         Dolly45( "Dolly45", 125, 12,4);
         ObjectSetText( "Dolly45","DAILY AVERAGE RANGE " , 9, "Arial",DarkSeaGreen);
         //
         ObjectDelete("Dolly46");
         Dolly46( "Dolly46", 125, 12,4);
         ObjectSetText( "Dolly46"," "+DAR+ " " , 9, "Arial", DarkOrange );
         //
         ObjectDelete("Dolly47");
         Dolly47( "Dolly47", 134, 12,4);
         ObjectSetText( "Dolly47", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", Black );    
         //
         ObjectDelete("Dolly48");
         Dolly48( "Dolly48", 148, 12,4);
         ObjectSetText( "Dolly48","Price", 10, "Arial", Silver);
         //
         ObjectDelete("Dolly49");
         Dolly49( "Dolly49", 148, 12,4);
         ObjectSetText( "Dolly49"," "+(string)PRICE+" ", 15, "Arial", Silver);
        }
      }
    }
//+------------------------------------------------------------------+
void Dolly( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  {  
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly1( string Text, int xOffset, int yOffset,int iCorner) //LINE
  {  
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly2( string Text, int xOffset, int yOffset,int iCorner)//Buy Zone
  {
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly3( string Text, int xOffset, int yOffset,int iCorner) //LINE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly4( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly5( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly6( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly7( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly8( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly9( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly10( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly11( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly12( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly13( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly14( string Text, int xOffset, int yOffset,int iCorner) //Line
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly15( string Text, int xOffset, int yOffset,int iCorner) //SELL ZONE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly16( string Text, int xOffset, int yOffset,int iCorner) //LINE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly17( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly18( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly19( string Text, int xOffset, int yOffset,int iCorner) // Line
  {
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly20( string Text, int xOffset, int yOffset,int iCorner) // 1st SELL 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly21( string Text, int xOffset, int yOffset,int iCorner) // 1st SELL SL
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly22( string Text, int xOffset, int yOffset,int iCorner) // 2nd SELL
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly23( string Text, int xOffset, int yOffset,int iCorner) // 2nd SELL
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly24( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly25( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly26( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly27( string Text, int xOffset, int yOffset,int iCorner)//LINE 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly28( string Text, int xOffset, int yOffset,int iCorner) // POTENTIAL 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly29( string Text, int xOffset, int yOffset,int iCorner) // LINE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly30( string Text, int xOffset, int yOffset,int iCorner) //BEARISH CORR
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly31( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly32( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly33( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly34( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly35( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly36( string Text, int xOffset, int yOffset,int iCorner) //BULLISH CORR
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly37( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly38( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly39( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly40( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly41( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly42( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly43( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly44( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 100 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly45( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly46( string Text, int xOffset, int yOffset,int iCorner)
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 160 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly47( string Text, int xOffset, int yOffset,int iCorner) //Line 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly48( string Text, int xOffset, int yOffset,int iCorner) //Price Text 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly49( string Text, int xOffset, int yOffset,int iCorner) //Price Value
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 50 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly50( string Text, int xOffset, int yOffset,int iCorner) //Change Text
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 850 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dolly51( string Text, int xOffset, int yOffset,int iCorner) //Change Value 
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 885 );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+