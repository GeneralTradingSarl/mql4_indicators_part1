//+------------------------------------------------------------------+
//|                                               BID_VIEW-2.0.mq4   |
//|                                      Copyright © 2008, "OTCFX"   |
//|                                             Revision 2.0         |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008 OTCFX"
#property indicator_separate_window  


extern bool   Bid_Colors=True;
extern string FontType=" Sans MS";
extern color ColorHeading=Gainsboro;
extern color ColorValue= CadetBlue;
extern int  TimeFrame  = 1440;
extern  int    Trend_Bars=10;
extern bool show_Trend=false;
extern bool show_CTrend=true;
extern int price_x_offset= 50;
extern int price_y_offset= 10;
color  ColorPrice=CadetBlue;
extern int    myArrowSize=15;
int MAP=1;
int Spread;
int Local_Time;
string   labelNames;
string   shortName;
int      corner;
int      totalLabels;
int      window;
int nDigits;
int pZX;
int PTL;
int EROS;
int EROB;
double       O_P;
double       O_P1;
double       O_P2;
int    F_Offset=0;
string Arrow12="é";  // 12 oclock 225
string Arrow12_2= "ñ"; // 12 oclock
string Arrow6  = "ê";  //  6 oclock 226
string Arrow6_2= "ò";  // 6 oclock 
extern color N_color  = Lime;
extern color S_color  = Red;
double  xREV;
double  xREV1;

int   BidDir,R77Dir;
string PriceDir;
string PriceDir1;
color  CloseColor;
color  CloseColor1;
int NormalSpread,NormalStopLevel;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color fColor(double i)
  {
   color rColor;

   if(i==1) rColor=N_color; else
     {
      //if ( i >= 4 ) rColor = NE_color  ; else {
      //if ( i == 3 ) rColor = E_color  ; else {    
      if(i==0) rColor=S_color; else
        {
         rColor=S_color;
        }
     }

   return(rColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int fDirection(double i,double j)
  {
   int rColor;

   if(i>j) rColor=1;
   else
     {
      if(i<j) rColor=0;
      else rColor=0;
     }
   return(rColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string fCompass(double i)
  {
   string rCompass;

   if(i==1) rCompass=Arrow12; else
     {
      if(i==0) rCompass=Arrow6; else
        {
         rCompass=Arrow6;
        }
     }

   return(rCompass);
  }
/////////////////////////////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.....#2 
color tColor(double i)
  {
   color tColor;

   if(i==1) tColor=N_color; else
     {
      if(i==0) tColor=S_color; else
        {
         tColor=S_color;
        }
     }

   return(tColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int gDirection(double i,double j)
  {
   int tColor;

   if(i>j) tColor=1;
   else
     {
      if(i<j) tColor=0;
      else tColor=0;
     }
   return(tColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string gCompass(double i)
  {
   string gCompass;

   if(i==1) gCompass=Arrow12; else
     {
      if(i==0) gCompass=Arrow6; else
        {
         gCompass=Arrow6;
        }
     }

   return(gCompass);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+  

int init()
  {

   corner     = 0;
   shortName  = MakeUniqueName("MT ","");
   labelNames = shortName;
   IndicatorShortName(shortName);

   NormalSpread=MarketInfo(Symbol(),MODE_SPREAD);
   NormalStopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   start();

   string S=Symbol();

   if(S=="ER2" || S=="FESX" || S=="FTSE" || S=="FDAX") nDigits=1;

   if(S=="GBPJPY" || S=="EURJPY" || S=="USDJPY" || S=="GOLD" || S=="AUDJPY" || S=="FGBL" ||
      S=="NZDJPY" || S=="CADJPY" || S=="CHFJPY" || S=="BRN" || S=="WTI" || S=="NQ" || S=="ES" || S=="XAU") nDigits=2;

   if(S=="GBPUSD" || S=="EURUSD" || S=="NZDUSD" || S=="USDCHF" ||
      S=="USDCAD"||S=="AUDUSD"|| S=="EURUSD"||S=="EURCHF"|| S=="EURGBP"
      || S=="EURCAD" || S=="EURAUD" || S=="AUDNZD" || S=="GBPCHF" || S=="EURAUD" || 
      S=="GBPAUD"|| S== "AUDCAD" || S=="AUDCHF"|| S=="NZDCHF"|| S=="NZDCAD" ||S=="NZDCHF"||
      S=="EURNZD"|| S=="CADCHF"|| S=="EURCAD"|| S=="USDNOK"|| S=="USDDKK")  nDigits = 4;

   int result;

   if(TimeFrame==0)
      result=Period();
   else
     {
      switch(TimeFrame)
        {
         case 1    : result = PERIOD_M1;  break;
         case 5    : result = PERIOD_M5;  break;
         case 15   : result = PERIOD_M15; break;
         case 30   : result = PERIOD_M30; break;
         case 60   : result = PERIOD_H1;  break;
         case 240  : result = PERIOD_H4;  break;
         case 1440 : result = PERIOD_D1;  break;
         case 7200 : result = PERIOD_W1;  break;
         case 28800: result = PERIOD_MN1; break;
         default  : result=Period(); break;
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   while(totalLabels>0) { ObjectDelete(StringConcatenate(labelNames,totalLabels)); totalLabels--;}
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+ 
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
   if(limit<0) return;
   if(counted_bars<Trend_Bars) return;

   window=WindowFind(shortName);
   ObjectsDeleteAll(window,21);
   ObjectsDeleteAll(window,22);
   ObjectsDeleteAll(window,23);

   int i=0;
   int R77=0,CD=0,AM=0,Mval=0;
   double CC7,CC2,CC3,CC4,CC5,CC6;
   double HY1,HY2,HZ1,HZ2,SC1;
   double C7_7,C2_2,C3_3,C4_4,C5_5,C6_6;
   double HD,DL,BTX1,BTX1_1,BTX2,BTX2_2,BTX3,BTX3_3,BTX4,BTX4_4,BTX5,BTX5_5;
   double BTX6,BTX6_6,BTX7,BTX7_7,BTX8,BTX8_8,BTX9,BTX9_9,BTX10,BTX10_10,DC,DO;
   double PercentUp,Perc,Per;
   double R77T,R77T1,R77T2;
   string FX_T="Verdana Bold";
   string T=TimeFrame;
   if(TimeFrame==0) TimeFrame=Period();
   int yPos=24,xPos=10;
   int xSpacer=140;
   string SpacerText1 = "__________________________";
   string SpacerText2 = "__________________________________________________________________________________________________________";
   if(F_Offset>0) F_Offset=0;
   if(Trend_Bars>15) Trend_Bars=15;
   if(price_y_offset<10) price_y_offset=10;
   if(price_y_offset>20) price_y_offset=20;
   if(price_x_offset<0) price_x_offset=0;
   if(myArrowSize>15) myArrowSize=15;

   if(show_Trend==true) show_CTrend=false;

   string S=Symbol();

   if(S=="ES" || S=="WTI" || S=="XAU" || S=="GOLD") {EROS=13;}else {EROS=16;}

   if(S=="ES" || S=="WTI" || S=="XAU" || S=="GOLD") {EROB=12;}else {EROB=13;}

   if(S=="ER2" || S=="FESX" || S=="FTSE" || S=="FDAX") {pZX=1000000;}
   if(S=="GBPJPY" ||S=="EURJPY" || S=="USDJPY" || S=="GOLD"|| S=="AUDJPY"||S=="FGBL"||
      S=="NZDJPY"|| S=="CADJPY" ||S== "CHFJPY" || S=="BRN" ||S=="WTI" || S=="NQ" || S=="ES"||
      S=="XAU" || S=="XAG") {pZX=100000;}

   if(S=="GBPUSD" || S=="EURUSD" || S=="NZDUSD" || S=="USDCHF" ||
      S=="USDCAD"||S=="AUDUSD"|| S=="EURUSD"||S=="EURCHF"|| S=="EURGBP"
      || S=="EURCAD" || S=="EURAUD" || S=="AUDNZD" || S=="GBPCHF" || S=="EURAUD" || 
      S=="GBPAUD"|| S== "AUDCAD" || S=="AUDCHF"|| S=="NZDCHF"|| S=="NZDCAD" ||S=="NZDCHF"||
      S=="EURNZD" || S=="CADCHF" || S=="EURCAD" || S=="USDNOK" || S=="USDDKK"){pZX=1000;}

   CC2 =iClose(NULL,PERIOD_M5,0);
   C2_2= iOpen(NULL,PERIOD_M5,0);
   CC3 =iClose(NULL,PERIOD_M15,0);
   C3_3= iOpen(NULL,PERIOD_M15,0);
   CC4 =iClose(NULL,PERIOD_M30,0);
   C4_4= iOpen(NULL,PERIOD_M30,0);
   CC5 =iClose(NULL,PERIOD_H1,0);
   C5_5= iOpen(NULL,PERIOD_H1,0);
   CC6 =iClose(NULL,PERIOD_H4,0);
   C6_6= iOpen(NULL,PERIOD_H4,0);
   CC7 =iClose(NULL,PERIOD_D1,0);
   C7_7= iOpen(NULL,PERIOD_D1,0);

   R77=(iClose(NULL,PERIOD_D1,0)-iOpen(NULL,PERIOD_D1,0))/Point;
   if(R77<-99) {Mval=242;}else {Mval=246;}
   DO=iOpen(NULL,PERIOD_D1,0);
   DC =iClose(NULL,PERIOD_D1,0);
   HD = iHigh(NULL,PERIOD_D1,0);
   DL = iLow(NULL,PERIOD_D1,0);
//open0  =  iOpen(NULL,PERIOD_D1,0);
   if(DC!=0) PercentUp=((R77)/(DC))/100;
   else return;

   Per=PercentUp*pZX;
   Perc=Per/1000;

   RefreshRates();
   int ActualSpread=(Ask-Bid)/Point;
   int ActualStopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(ActualSpread>NormalSpread) {SC1=2;}else  {SC1=0; }
   color ColorCH7044;
   if(SC1>1) { ColorCH7044=Red;}  else  { ColorCH7044=ColorHeading;}

   Spread=NormalizeDouble((Ask-Bid)/Point,0);
   if(Spread<0) Spread=0;

   R77=(iClose(NULL,PERIOD_D1,0)-iOpen(NULL,PERIOD_D1,0))/Point;
   if(R77<-99) {Mval=242;}else {Mval=246;}

   if(Bid_Colors==True)
     {
      if(Close[i]>O_P) ColorPrice=DodgerBlue;
      if(Close[i]>O_P) {HY1=2;}
      if(Close[i]<O_P) ColorPrice=Silver;
      if(Close[i]<O_P) {HY2=0;}
      O_P=Close[i];
     }
   color ColorCT709;
   if(Close[i]<O_P2) { ColorCT709=Red;}
   O_P2=Close[i];
   if(Close[i]<O_P2) //{BP1=False;}

      color ColorCT708;
   if(Close[i]>O_P1) { ColorCT708=Lime;}

   string Market_Price=DoubleToStr(Close[i],Digits);

   color ColorCH704;
   if(R77 >= 0 ) { ColorCH704 =LimeGreen; }
   if(R77 >= 0 ) {HZ1=2;}
   color ColorCH705;
   if(R77 < 0) { ColorCH705 =Silver; }else { ColorCH705 =ColorValue; }
   if(R77>= 0) {HZ2=0;}

   BidDir= fDirection(HY1,HY2);
   R77Dir= gDirection(HZ1,HZ2);

   xREV=BidDir;
   xREV1=R77Dir;

   CloseColor=fColor(xREV);
   CloseColor1=tColor(xREV1);

   PriceDir=fCompass(xREV);
   PriceDir1=gCompass(xREV1);

   setObject(next(),PriceDir,115+price_x_offset,4+price_y_offset,CloseColor,"Wingdings",myArrowSize+F_Offset,0);
//setObject(next(),"^",129+price_x_offset, 32+price_y_offset,ColorCT709 ,"Arial Bold",20+F_Offset,180);
   setObject(next(),PriceDir1,227+price_x_offset,4+price_y_offset,CloseColor1,"Wingdings",myArrowSize+F_Offset,0);//
                                                                                                                  //setObject(next(),"^",240+price_x_offset, 32+price_y_offset,ColorCH705 ,"Arial Bold",18+F_Offset,180);//

   setObject(next(),Market_Price,140+price_x_offset,5+price_y_offset,ColorPrice,FX_T,EROS+F_Offset);
   setObject(next(),StringSubstr(Symbol(),0),22+price_x_offset,5+price_y_offset,ColorValue,FX_T,13+F_Offset);
   setObject(next(),DoubleToStr(DO,Digits),383+price_x_offset,5+price_y_offset,ColorValue,FX_T,EROB+F_Offset);
   setObject(next(),DoubleToStr(HD,Digits),472+price_x_offset,5+price_y_offset,ColorValue,FX_T,EROB+F_Offset);
   setObject(next(),DoubleToStr(DL,Digits),554+price_x_offset,5+price_y_offset,ColorValue,FX_T,EROB+F_Offset);
   setObject(next(),DoubleToStr(R77,0),Mval+price_x_offset,5+price_y_offset,ColorCH705,FX_T,EROB+F_Offset);
//setObject(next(),DoubleToStr(R77T2 ,nDigits),247+price_x_offset, 5+price_y_offset,ColorValue ,FX_T,13+F_Offset);   
   setObject(next(),TimeToStr(CurTime(),TIME_SECONDS),777+price_x_offset,5+price_y_offset,ColorValue,FX_T,13+F_Offset);
   setObject(next(),TimeToStr(LocalTime(),TIME_MINUTES),880+price_x_offset,5+price_y_offset,ColorValue,FX_T,13+F_Offset);
   setObject(next(),DoubleToStr(Spread,Digits-3),970+price_x_offset,5+price_y_offset,ColorValue,FX_T,13+F_Offset);
   setObject(next(),DoubleToStr(Perc,nDigits),300+price_x_offset,5+price_y_offset,ColorValue,FX_T,13+F_Offset);

   setObject(next(),"Name",45+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"Last",157+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"Change",237+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"%CH",317+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"Open",398+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"High",484+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"Low",571+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"BidTime",795+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"LocalTime",880+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
   setObject(next(),"Spread",970+price_x_offset,-10+price_y_offset,ColorCH7044,FX_T,9+F_Offset);
   if(show_Trend)
     {
      setObject(next(),"1",755+price_x_offset,-10+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),DoubleToStr(Trend_Bars,0),630+price_x_offset,-10+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"Trend",695+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
      setObject(next(),StringSubstr((T),0),655+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
     }

   setObject(next(),SpacerText1,88+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,199+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,270+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,350+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,430+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,520+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,600+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,745+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,840+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,930+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,1002+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);
   setObject(next(),SpacerText1,-25+price_x_offset,30+price_y_offset,DarkGray,FX_T,17+F_Offset,90);

   setObject(next(),SpacerText2,0+price_x_offset,-5+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText2,250+price_x_offset,-5+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText2,450+price_x_offset,-5+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText2,650+price_x_offset,-5+price_y_offset,DarkGray,FX_T,6+F_Offset);

   setObject(next(),SpacerText2,650+price_x_offset,21+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText2,380+price_x_offset,21+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText2,100+price_x_offset,21+price_y_offset,DarkGray,FX_T,6+F_Offset);
   setObject(next(),SpacerText1,0+price_x_offset,21+price_y_offset,DarkGray,FX_T,6+F_Offset);

   color ColorCX105;
   if(CC2>=C2_2) { ColorCX105=LimeGreen; }else { ColorCX105=Red; }
   color ColorCX106;
   if(CC3>=C3_3) { ColorCX106=LimeGreen; }else { ColorCX106=Red; }
   color ColorCX107;
   if(CC4>=C4_4) { ColorCX107=LimeGreen; }else { ColorCX107=Red; }
   color ColorCX108;
   if(CC5>=C5_5) { ColorCX108=LimeGreen; }else { ColorCX108=Red; }
   color ColorCX109;
   if(CC6>=C6_6) { ColorCX109=LimeGreen; }else { ColorCX109=Red; }
   color ColorCX110;
   if(CC7>=C7_7) { ColorCX110=LimeGreen; }else { ColorCX110=Red; }

   if(show_CTrend)
     {
      setObject(next(),"-",616+price_x_offset,24+price_y_offset,ColorCX105,FX_T,30+F_Offset,90);
      setObject(next(),"-",639+price_x_offset,24+price_y_offset,ColorCX106,FX_T,30+F_Offset,90);
      setObject(next(),"-",660+price_x_offset,24+price_y_offset,ColorCX107,FX_T,30+F_Offset,90);
      setObject(next(),"-",683+price_x_offset,24+price_y_offset,ColorCX108,FX_T,30+F_Offset,90);
      setObject(next(),"-",708+price_x_offset,24+price_y_offset,ColorCX109,FX_T,30+F_Offset,90);
      setObject(next(),"-",730+price_x_offset,24+price_y_offset,ColorCX110,FX_T,30+F_Offset,90);

      setObject(next(),"5",630+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"15",648+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"30",670+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"60",692+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"H4",715+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"D1",739+price_x_offset,13+price_y_offset,ColorHeading,"Verdana",8+F_Offset);
      setObject(next(),"Candle Color",657+price_x_offset,-10+price_y_offset,ColorHeading,FX_T,9+F_Offset);
     }

   color LabelColor;
   int SpX=615,SpX2=7;
   for(i=Trend_Bars; i>=0; i--)
     {
      BTX1=iMA(S,TimeFrame,MAP,0,1,1,i);
      BTX1_1=iMA(S,TimeFrame,MAP,0,0,0,i);

      LabelColor=Red;
      if(BTX1_1>BTX1) LabelColor=Lime;
      SpX=SpX+SpX2;
      if(show_Trend)
        {
         setObject(next(),"-",SpX+price_x_offset,25+price_y_offset,LabelColor,FX_T,30,90);
        }
     }
   return(0);
  }



string next() { totalLabels++; return(totalLabels); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string MakeUniqueName(string first,string rest)
  {
   string result=first+(MathRand()%1001)+rest;

   while(WindowFind(result)>0)
      result=first+(MathRand()%1001)+rest;
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setObject(string name,string text,int x,int y,color theColor,string font="Arial",int size=10,int angle=0)
  {
   string labelName=StringConcatenate(labelNames,name);

   if(ObjectFind(labelName)==-1)
     {
      ObjectCreate(labelName,OBJ_LABEL,window,0,0);
      ObjectSet(labelName,OBJPROP_CORNER,corner);
      if(angle!=0)
         ObjectSet(labelName,OBJPROP_ANGLE,angle);
     }
   ObjectSet(labelName,OBJPROP_XDISTANCE,x);
   ObjectSet(labelName,OBJPROP_YDISTANCE,y);
   ObjectSetText(labelName,text,size,font,theColor);

//}        
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
