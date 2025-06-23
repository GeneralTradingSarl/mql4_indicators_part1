//+------------------------------------------------------------------+
//|                                      DeMark Trendline Trader.mq4 |
//|                            Copyright © 2005,Kara Software Corp.  |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict
#property copyright "Copyright © 2005, Kara Software Corp."
#property link      ""
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrBlue /*Original #property indicator_color1 Red. Color of Upper TD Points*/
#property indicator_color2 clrBlue /*Original #property indicator_color2 Blue. Color of Lower TD Points*/
//---- input parameters
/* Mod 02: only one step, no back steps, only one target, no fractal trendlines, 
   no large arrow option for TD points, and added user changable colours and styles*/
/* Mod 03: Alerts Added.  Horizontal Lines indicating where projections start from and 
   where alerts should be determined from re-enabled with Default of False.*/
/* Mod 03B: Bug where TD Points and TD Lines drawn in wrong place for 
   double, triple and quadruple tops or bottoms is fixed*/
extern bool             AlertsOn=true;                         /* Line added.  Default is true.*/
extern bool             Comments=true;                         /*Optional Comments.  Default is false. Orginal variable called "Commen"*/
//---
extern bool             TrendLine=true;                        /*Default is true to draw current TD Lines*/
extern ENUM_LINE_STYLE  TrendLineStyle=STYLE_DOT;
extern int              TrendLineWidth=2;                      /*Thinnest or allow dots and dashes = 0 or 1, Thinner=2, Medium=3,Thicker=4,Thickest=5.  Line of code added from original.*/
//---
extern color            UpperTrendLineColour=clrLimeGreen;     /*Line of code added from original.*/
extern color            LowerTrendLineColour=clrRed;           /*Line of code added from original.*/
//---
extern bool             ProjectionLines=true;                  /*Default is True.  These are the TD Price Projections. Original variable called "Take Prof"*/
extern ENUM_LINE_STYLE  ProjectionLinesStyle=STYLE_SOLID;
extern int              ProjectionLinesWidth=3;                /*Thinnest or allow dots and dashes = 0 or 1, Thinner=2, Medium=3,Thicker=4,Thickest=5.  Line of code added from original.*/
//---
extern color            UpperProjectionLineColour=clrGreen;    /*Line of code added from original.*/
extern color            LowerProjectionLineColour=clrCrimson;  /*Line of code added from original.*/
//---
extern bool             HorizontLine=false;                    /*Default is false.  It seems the Horizontal Lines are were the code predicts price may cross TD line.*/
//----
bool             TD=False;          /*Default is false. True setting draws up and down arrows instead of dots on TD Points creating more clutter.*/
int              BackSteps=0;       /*Used to be extern int now just int. Leave at 0*/
int              ShowingSteps=1;    /*Used to be extern int now just int.  Leave at 1*/
bool             FractalAsTD=false; /*Used to be extern bool now just bool.  Leave at false, otherwise Trend Lines based on Fractal Points not TD Points*/
//----
double TrendLineBreakUp=-1;         //Line added.
bool TrendLineBreakUpFlag=False;    //Line added.
double TrendLineBreakDown=-1;       //Line added.
bool TrendLineBreakDownFlag=False;  //Line added.
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
//---
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,218);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
//---
   for(int i=1;i<=10;i++)
     {
      ObjectDelete("HHL_"+(string)i);ObjectDelete("HL_"+(string)i);
      ObjectDelete("HLL_"+(string)i);ObjectDelete("LL_"+(string)i);
      ObjectDelete("HC1_"+(string)i);
      ObjectDelete("HC2_"+(string)i);
      ObjectDelete("HC3_"+(string)i);
      ObjectDelete("LC1_"+(string)i);
      ObjectDelete("LC2_"+(string)i);
      ObjectDelete("LC3_"+(string)i);
     }
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i=1;i<=10;i++)
     {
      ObjectDelete("HHL_"+(string)i);ObjectDelete("HL_"+(string)i);
      ObjectDelete("HLL_"+(string)i);ObjectDelete("LL_"+(string)i);
      ObjectDelete("HC1_"+(string)i);
      ObjectDelete("HC2_"+(string)i);
      ObjectDelete("HC3_"+(string)i);
      ObjectDelete("LC1_"+(string)i);
      ObjectDelete("LC2_"+(string)i);
      ObjectDelete("LC3_"+(string)i);
     }
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SetTDPoint(int B)//It seems B is the same as IndicatorCounted() function 
  {
   B-=4;
   if(B>Bars) B=Bars-4;
   int shift;
   if(FractalAsTD==false)
     {
      //Print("B = ",B);
      //Print("Bars = ",Bars);
      //Print("IndicatorCounted() = ",IndicatorCounted());
      for(shift=B;shift>1;shift--)
        {
         if(High[shift+1]<High[shift] && High[shift-1]<High[shift])// determine single top TD Point
            ExtMapBuffer1[shift]=High[shift];// determine single top TD Point
         if(High[shift+2]<High[shift] && High[shift+1]==High[shift] && High[shift-1]<High[shift])//I added for double top
            ExtMapBuffer1[shift]=High[shift];//I added for double top
         if(High[shift+3]<High[shift] && High[shift+2]==High[shift] && High[shift+1]==High[shift]//I added for triple top
            && High[shift-1]<High[shift])    //I added for triple top
            ExtMapBuffer1[shift]=High[shift];//I added for triple top
         if(High[shift+4]<High[shift] && High[shift+3]==High[shift] && High[shift+2]==High[shift]//I added for quadruple top
            && High[shift+1]==High[shift]    //I added for quadruple top
            && High[shift-1]<High[shift])    //I added for quadruple top
            ExtMapBuffer1[shift]=High[shift];//I added for quadruple top
         if(High[shift-1]>=High[shift]) //I added for new way to determine Non-TD High Point
            ExtMapBuffer1[shift]=0;          //I added for new way to determine Non-TD High Point
         //else ExtMapBuffer1[shift]=0;
         if(Low[shift+1]>Low[shift] && Low[shift-1]>Low[shift])// determine single bottom TD Point
            ExtMapBuffer2[shift]=Low[shift]; // determine single bottom TD Point
         if(Low[shift+2]>Low[shift] && Low[shift+1]==Low[shift] && Low[shift-1]>Low[shift])//I added for double bottom
            ExtMapBuffer2[shift]=Low[shift]; //I added for double bottom
         if(Low[shift+3]>Low[shift] && Low[shift+2]==Low[shift] && Low[shift+1]==Low[shift]//I added for triple bottom
            && Low[shift-1]>Low[shift])      //I added for triple bottom
            ExtMapBuffer2[shift]=Low[shift]; //I added for triple bottom
         if(Low[shift+4]>Low[shift] && Low[shift+3]==Low[shift] && Low[shift+2]==Low[shift] && Low[shift+1]==Low[shift]//I added for quadruple bottom
            && Low[shift-1]>Low[shift])      //I added for quadruple bottom
            ExtMapBuffer2[shift]=Low[shift]; //I added for quadruple bottom   
         if(Low[shift-1]<=Low[shift]) //I added
            ExtMapBuffer2[shift]=0;          //I added
         //else ExtMapBuffer2[shift]=0;    
        }
      ExtMapBuffer1[0]=0;
      ExtMapBuffer2[0]=0;
      ExtMapBuffer1[1]=0;
      ExtMapBuffer2[1]=0;
     }
   else
     {
      for(shift=B;shift>3;shift--)
        {
         if(High[shift+1]<=High[shift] && High[shift-1]<High[shift] && High[shift+2]<=High[shift] && High[shift-2]<High[shift])
            ExtMapBuffer1[shift]=High[shift];
         else ExtMapBuffer1[shift]=0;
         if(Low[shift+1]>=Low[shift] && Low[shift-1]>Low[shift] && Low[shift+2]>=Low[shift] && Low[shift-2]>Low[shift])
            ExtMapBuffer2[shift]=Low[shift];
         else ExtMapBuffer2[shift]=0;
        }
      ExtMapBuffer1[0]=0;
      ExtMapBuffer2[0]=0;
      ExtMapBuffer1[1]=0;
      ExtMapBuffer2[1]=0;
      ExtMapBuffer1[2]=0;
      ExtMapBuffer2[2]=0;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHighTD(int P)
  {
   int i=0,j=0;
   while(j<P)
     {
      i++;
      while(ExtMapBuffer1[i]==0)
        {i++;if(i>Bars-2)return(-1);}
      j++;
     }
   return(i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetNextHighTD(int P)
  {
   int i=P+1;
   while(ExtMapBuffer1[i]<=High[P]){i++;if(i>Bars-2)return(-1);}
   return(i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLowTD(int P)
  {
   int i=0,j=0;
   while(j<P)
     {
      i++;
      while(ExtMapBuffer2[i]==0)
        {i++;if(i>Bars-2)return(-1);}
      j++;
     }
   return(i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetNextLowTD(int P)
  {
   int i=P+1;
   while(ExtMapBuffer2[i]>=Low[P] || ExtMapBuffer2[i]==0){i++;if(i>Bars-2)return(-1);}
   return(i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TrendLineHighTD(int H1,int H2,int Step,int Col)/*Draw Upper Trend Line*/
  {
   ObjectSet("HL_"+(string)Step,OBJPROP_TIME1,Time[H2]);ObjectSet("HL_"+(string)Step,OBJPROP_TIME2,Time[H1]);
   ObjectSet("HL_"+(string)Step,OBJPROP_PRICE1,High[H2]);ObjectSet("HL_"+(string)Step,OBJPROP_PRICE2,High[H1]);
   ObjectSet("HL_"+(string)Step,OBJPROP_COLOR,UpperTrendLineColour);/*TEMP Original OBJPROP_COLOR,Col*/
   if(Step==1)ObjectSet("HL_"+(string)Step,OBJPROP_WIDTH,TrendLineWidth);/*Original OBJPROP_WIDTH,2*/
   else ObjectSet("HL_"+(string)Step,OBJPROP_WIDTH,1);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TrendLineLowTD(int L1,int L2,int Step,int Col)/*Draw Lower Trend Line*/
  {
   ObjectSet("LL_"+(string)Step,OBJPROP_TIME1,Time[L2]);ObjectSet("LL_"+(string)Step,OBJPROP_TIME2,Time[L1]);
   ObjectSet("LL_"+(string)Step,OBJPROP_PRICE1,Low[L2]);ObjectSet("LL_"+(string)Step,OBJPROP_PRICE2,Low[L1]);
   ObjectSet("LL_"+(string)Step,OBJPROP_COLOR,LowerTrendLineColour);/*TEMP Original OBJPROP_COLOR,Col*/
   if(Step==1)ObjectSet("LL_"+(string)Step,OBJPROP_WIDTH,TrendLineWidth);/*Original OBJPROP_WIDTH,2*/
   else ObjectSet("LL_"+(string)Step,OBJPROP_WIDTH,1);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HorizontLineHighTD(int H1,int H2,int Step,double St,color Col)
  {
   ObjectSet("HHL_"+(string)Step,OBJPROP_PRICE1,High[H2]-(High[H2]-High[H1])/(H2-H1)*H2);//HORIZONTAL HIGH LINE HEIGHT CALCULATION
   ObjectSet("HHL_"+(string)Step,OBJPROP_STYLE,St);
   ObjectSet("HHL_"+(string)Step,OBJPROP_COLOR,Col);
   ObjectSet("HHL_"+(string)Step,OBJPROP_BACK,True);//Line added
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HorizontLineLowTD(int L1,int L2,int Step,double St,int Col)
  {
   ObjectSet("HLL_"+(string)Step,OBJPROP_PRICE1,Low[L2]+(Low[L1]-Low[L2])/(L2-L1)*L2);//HORIZONTAL LOW LINE HEIGHT CALCULATION
   ObjectSet("HLL_"+(string)Step,OBJPROP_STYLE,St);
   ObjectSet("HLL_"+(string)Step,OBJPROP_COLOR,Col);
   ObjectSet("HLL_"+(string)Step,OBJPROP_BACK,True);//Line added
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TakeProfitHighTD(int H1,int H2,int Step,int Col)/*Draw Buy TD Price Projection(s)*/
  {
   int i,ii,j=0;
   string Comm="";
   double kH,HC1,HC2,HC3,k,St;
   kH=(High[H2]-High[H1])/(H2-H1);
   while(NormalizeDouble(Point,j)==0)j++;
   k=0;
   for(i=H1;i>0;i--)if(Close[i]>High[H2]-kH*(H2-i)){k=High[H2]-kH*(H2-i);break;}
   if(k>0)
     {
      Comm=Comm+"UTD_Line ("+DoubleToStr(High[H2]-kH*H2,j)+") broken at "+DoubleToStr(k,j)+", uptargets:\n";
      ii=Lowest(NULL,0,MODE_LOW,H2-i,i);
      HC1=High[H2]-kH*(H2-ii)-Low[ii];
      HC2=High[H2]-kH*(H2-ii)-Close[ii];
      ii=Lowest(NULL,0,MODE_CLOSE,H2-i,i);
      HC3=High[H2]-kH*(H2-ii)-Close[ii];
      St=TrendLineStyle;/*Original STYLE_SOLID*/
     }
   else
     {
      k=High[H2]-kH*H2;
      Comm=Comm+"UTD_Line ("+DoubleToStr(k,j)+"), probable break-up targets:\n";
      ii=Lowest(NULL,0,MODE_LOW,H2,0);
      HC1=High[H2]-kH*(H2-ii)-Low[ii];
      HC2=High[H2]-kH*(H2-ii)-Close[ii];
      ii=Lowest(NULL,0,MODE_CLOSE,H2,0);
      HC3=High[H2]-kH*(H2-ii)-Close[ii];
      St=TrendLineStyle;/*Original STYLE_DASHDOT*/
     }
   ObjectSet("HL_"+(string)Step,OBJPROP_STYLE,St);
   Comm=Comm+"T1="+DoubleToStr(HC1+k,j)+" ("+DoubleToStr(HC1/Point,0)+"pts.)\n";//changed "pts.)" to "pts.)\n"
                                                                                //Comm=Comm+" T2="+DoubleToStr(HC2+k,j)+" ("+DoubleToStr(HC2/Point,0)+"pts.)";
//Comm=Comm+" T3="+DoubleToStr(HC3+k,j)+" ("+DoubleToStr(HC3/Point,0)+"pts.)\n";  
   ObjectSet("HC1_"+(string)Step,OBJPROP_TIME1,Time[H1]);ObjectSet("HC1_"+(string)Step,OBJPROP_TIME2,Time[0]);
   ObjectSet("HC1_"+(string)Step,OBJPROP_PRICE1,HC1+k);ObjectSet("HC1_"+(string)Step,OBJPROP_PRICE2,HC1+k);
   ObjectSet("HC1_"+(string)Step,OBJPROP_COLOR,Col);ObjectSet("HC1_"+(string)Step,OBJPROP_STYLE,St);
//ObjectSet("HC2_"+Step,OBJPROP_TIME1,Time[H1]);ObjectSet("HC2_"+Step,OBJPROP_TIME2,Time[0]);
//ObjectSet("HC2_"+Step,OBJPROP_PRICE1,HC2+k);ObjectSet("HC2_"+Step,OBJPROP_PRICE2,HC2+k);
//ObjectSet("HC2_"+Step,OBJPROP_COLOR,Col);ObjectSet("HC2_"+Step,OBJPROP_STYLE,St);
//ObjectSet("HC3_"+Step,OBJPROP_TIME1,Time[H1]);ObjectSet("HC3_"+Step,OBJPROP_TIME2,Time[0]);
//ObjectSet("HC3_"+Step,OBJPROP_PRICE1,HC3+k);ObjectSet("HC3_"+Step,OBJPROP_PRICE2,HC3+k);
//ObjectSet("HC3_"+Step,OBJPROP_COLOR,Col);ObjectSet("HC3_"+Step,OBJPROP_STYLE,St);   
   if(Step==1)
     {
      ObjectSet("HC1_"+(string)Step,OBJPROP_WIDTH,ProjectionLinesWidth);/*Original OBJPROP_WIDTH,2*/
      ObjectSet("HC1_"+(string)Step,OBJPROP_STYLE,ProjectionLinesStyle);/*This Line of code added from original. TD Upper Projection Line Style*/
      //    ObjectSet("HC2_"+Step,OBJPROP_WIDTH,2);
      //    ObjectSet("HC3_"+Step,OBJPROP_WIDTH,2);
     }
   else
     {
      ObjectSet("HC1_"+(string)Step,OBJPROP_WIDTH,2);
      //    ObjectSet("HC2_"+Step,OBJPROP_WIDTH,2);
      //    ObjectSet("HC3_"+Step,OBJPROP_WIDTH,2);
     }
   return(Comm);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TakeProfitLowTD(int L1,int L2,int Step,int Col)/*Draw Sell TD Price Projection(s)*/
  {
   int i,ii,j=0;
   string Comm="";
   double kL,LC1,LC2,LC3,k,St;
   kL=(Low[L1]-Low[L2])/(L2-L1);
   while(NormalizeDouble(Point,j)==0)j++;
   k=0;
   for(i=L1;i>0;i--)if(Close[i]<Low[L2]+kL*(L2-i)){k=Low[L2]+kL*(L2-i);break;}
   if(k>0)
     {
      Comm=Comm+"LTD_Line ("+DoubleToStr(Low[L2]+kL*L2,j)+") broken at "+DoubleToStr(k,j)+", downtargets:\n";
      ii=Highest(NULL,0,MODE_HIGH,L2-i,i);
      LC1=High[ii]-(Low[L2]+kL*(L2-ii));
      LC2=Close[ii]-(Low[L2]+kL*(L2-ii));
      i=Highest(NULL,0,MODE_CLOSE,L2-i,i);
      LC3=Close[ii]-(Low[L2]+kL*(L2-ii));
      St=TrendLineStyle;/*Original STYLE_SOLID*/
     }
   else
     {
      k=Low[L2]+kL*L2;
      Comm=Comm+"LTD_Line ("+DoubleToStr(k,j)+"), probable downbreak targets:\n";
      ii=Highest(NULL,0,MODE_HIGH,L2,0);
      LC1=High[ii]-(Low[L2]+kL*(L2-ii));
      LC2=Close[ii]-(Low[L2]+kL*(L2-ii));
      ii=Highest(NULL,0,MODE_CLOSE,L2,0);
      LC3=Close[ii]-(Low[L2]+kL*(L2-ii));
      St=TrendLineStyle;/*Original STYLE_DASHDOT*/
     }
   ObjectSet("LL_"+(string)Step,OBJPROP_STYLE,St);
   Comm=Comm+"T1="+DoubleToStr(k-LC1,j)+" ("+DoubleToStr(LC1/Point,0)+"pts.)\n";//changed "pts.)" to "pts.)\n"
                                                                                //Comm=Comm+" T2="+DoubleToStr(k-LC2,j)+" ("+DoubleToStr(LC2/Point,0)+"pts.)";
//Comm=Comm+" T3="+DoubleToStr(k-LC3,j)+" ("+DoubleToStr(LC3/Point,0)+"pts.)\n";
   ObjectSet("LC1_"+(string)Step,OBJPROP_TIME1,Time[L1]);ObjectSet("LC1_"+(string)Step,OBJPROP_TIME2,Time[0]);
   ObjectSet("LC1_"+(string)Step,OBJPROP_PRICE1,k-LC1);ObjectSet("LC1_"+(string)Step,OBJPROP_PRICE2,k-LC1);
   ObjectSet("LC1_"+(string)Step,OBJPROP_COLOR,Col);ObjectSet("LC1_"+(string)Step,OBJPROP_STYLE,St);
//ObjectSet("LC2_"+Step,OBJPROP_TIME1,Time[L1]);ObjectSet("LC2_"+Step,OBJPROP_TIME2,Time[0]);
//ObjectSet("LC2_"+Step,OBJPROP_PRICE1,k-LC2);ObjectSet("LC2_"+Step,OBJPROP_PRICE2,k-LC2);
//ObjectSet("LC2_"+Step,OBJPROP_COLOR,Col);ObjectSet("LC2_"+Step,OBJPROP_STYLE,St);
//ObjectSet("LC3_"+Step,OBJPROP_TIME1,Time[L1]);ObjectSet("LC3_"+Step,OBJPROP_TIME2,Time[0]);
//ObjectSet("LC3_"+Step,OBJPROP_PRICE1,k-LC3);ObjectSet("LC3_"+Step,OBJPROP_PRICE2,k-LC3);
//ObjectSet("LC3_"+Step,OBJPROP_COLOR,Col);ObjectSet("LC3_"+Step,OBJPROP_STYLE,St);   
   if(Step==1)
     {
      ObjectSet("LC1_"+(string)Step,OBJPROP_WIDTH,ProjectionLinesWidth);/*Original OBJPROP_WIDTH,2*/
      ObjectSet("LC1_"+(string)Step,OBJPROP_STYLE,ProjectionLinesStyle);/*This Line of code added from original. TD Lower Projection Line Style*/
      //ObjectSet("LC2_"+Step,OBJPROP_WIDTH,2);
      //ObjectSet("LC3_"+Step,OBJPROP_WIDTH,2);
     }
   else
     {
      ObjectSet("LC1_"+(string)Step,OBJPROP_WIDTH,2);
      //ObjectSet("LC2_"+Step,OBJPROP_WIDTH,2);
      //ObjectSet("LC3_"+Step,OBJPROP_WIDTH,2);
     }
   return(Comm);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TDMain(int Step)
  {
   int H1,H2,L1,L2;
   string Comm="---   step "+(string)Step+"   --------------------\n";
   int j=0; while(NormalizeDouble(Point,j)==0)j++;
   double Style;
   color Col[20];
   Col[0]=UpperProjectionLineColour/*Original Col[0]=Red, Colour for Current Upper TD Projection*/;
   Col[1]=LowerProjectionLineColour/*Original Col[1]=Blue, Colour for Current Lower TD Projection*/;
   Col[2]=clrMagenta;
   Col[3]=clrFireBrick;
   Col[4]=clrChocolate;
   Col[5]=clrGreen;
   Col[6]=clrGoldenrod;
   Col[7]=clrMediumOrchid;
   Col[8]=clrSlateBlue;
   Col[9]=clrCornflowerBlue;
   Col[10]=clrRed;
   Col[11]=clrBlue;
   Col[12]=clrMagenta;
   Col[13]=clrFireBrick;
   Col[14]=clrChocolate;
   Col[15]=clrGreen;
   Col[16]=clrGoldenrod;
   Col[17]=clrMediumOrchid;
   Col[18]=clrSlateBlue;
   Col[19]=clrCornflowerBlue;
   Step=Step+BackSteps;
   H1=GetHighTD(Step);
   H2=GetNextHighTD(H1);
   L1=GetLowTD(Step);
   L2=GetNextLowTD(L1);
   TrendLineBreakUp=NormalizeDouble((High[H2]-(High[H2]-High[H1])/(H2-H1)*H2),_Digits);//added line
   TrendLineBreakDown=NormalizeDouble((Low[L2]+(Low[L1]-Low[L2])/(L2-L1)*L2),_Digits);//added line
   if(H1<0)Comm=Comm+"UTD no TD up-point \n";
   else
      if(H2<0)Comm=Comm+"UTD no TD point-upper then last one ("+DoubleToStr(High[H1],j)+")\n";
   else Comm=Comm+"UTD "+DoubleToStr(High[H2],j)+"  "+DoubleToStr(High[H1],j)+"\n";
   if(L1<0)Comm=Comm+"LTD no TD down-point \n";
   else
      if(L2<0)Comm=Comm+"LTD no TD point-lower then last one ("+DoubleToStr(Low[L1],j)+")\n";
   else Comm=Comm+"LTD  "+DoubleToStr(Low[L2],j)+"  "+DoubleToStr(Low[L1],j)+"\n";
//-----------------------------------------------------------------------------------
   if(Step==1)Style=STYLE_SOLID;
   else Style=STYLE_DOT;
   if(H1>0 && H2>0)
     {
      if(TrendLine==1)
        {
         ObjectCreate("HL_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         TrendLineHighTD(H1,H2,Step,Col[Step*2-2]);
        }
      else ObjectDelete("HL_"+(string)Step);
      if(HorizontLine==1 && Step==1)
        {
         ObjectCreate("HHL_"+(string)Step,OBJ_HLINE,0,0,0,0,0);
         ObjectSet("HHL_"+(string)Step,OBJPROP_BACK,True);//Line added
         HorizontLineHighTD(H1,H2,Step,Style,Col[Step*2-2]);
        }
      else ObjectDelete("HHL_"+(string)Step);
      if(ProjectionLines==1)
        {
         ObjectCreate("HC1_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         ObjectCreate("HC2_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         ObjectCreate("HC3_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         Comm=Comm+TakeProfitHighTD(H1,H2,Step,Col[Step*2-2]);
        }
      else
        {
         ObjectDelete("HC1_"+(string)Step);
         ObjectDelete("HC2_"+(string)Step);
         ObjectDelete("HC3_"+(string)Step);
        }
     }
//-----------------------------------------------------------------------------------   
   if(L1>0 && L2>0)
     {
      if(TrendLine==1)
        {
         ObjectCreate("LL_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         TrendLineLowTD(L1,L2,Step,Col[Step*2-1]);
        }
      else ObjectDelete("LL_"+(string)Step);
      if(HorizontLine==1 && Step==1)
        {
         ObjectCreate("HLL_"+(string)Step,OBJ_HLINE,0,0,0,0,0);
         ObjectSet("HLL_"+(string)Step,OBJPROP_BACK,True);//Line added
         HorizontLineLowTD(L1,L2,Step,Style,Col[Step*2-1]);
        }
      else ObjectDelete("HLL_"+(string)Step);
      if(ProjectionLines==1)
        {
         ObjectCreate("LC1_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         ObjectCreate("LC2_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         ObjectCreate("LC3_"+(string)Step,OBJ_TREND,0,0,0,0,0);
         Comm=Comm+TakeProfitLowTD(L1,L2,Step,Col[Step*2-1]);
        }
      else
        {
         ObjectDelete("LC1_"+(string)Step);
         ObjectDelete("LC2_"+(string)Step);
         ObjectDelete("LC3_"+(string)Step);
        }
     }
//--------------------------------------------------------------------
   if(AlertsOn)//added this Alerts section
     {
      //Print("Alerts On");

      if(Close[0]>TrendLineBreakUp && TrendLineBreakUpFlag==False)
        {
         //Print("Upper TrendLine Break ",Symbol()," ",Period()," ",Bid);
         Alert("UTL Break>",TrendLineBreakUp," on ",Symbol()," ",Period()," @ ",Bid);
         TrendLineBreakUpFlag=True;
        }
      if(Close[0]<TrendLineBreakDown && TrendLineBreakDownFlag==False)
        {
         //Print("Lower Trendline Break ",Symbol()," ",Period()," ",Bid);
         Alert("LTL Break<",TrendLineBreakDown," on ",Symbol()," ",Period()," @ ",Bid);
         TrendLineBreakDownFlag=True;
        }
      //--------------------------------------------------------------------    
     }
   return(Comm);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   string Comm="";
   SetTDPoint(Bars-1);
   if(TD==1)
     {
      SetIndexArrow(0,217);
      SetIndexArrow(1,218);
     }
   else
     {
      SetIndexArrow(0,160);
      SetIndexArrow(1,160);
     }
   if(ShowingSteps>10)
     {
      Comment("ShowingSteps readings 0 - 10");
      return(0);
     }
   for(int i=1;i<=ShowingSteps;i++)Comm=Comm+TDMain(i);
   Comm=Comm+"------------------------------------\nShowingSteps="+(string)ShowingSteps+"\nBackSteps="+(string)BackSteps;
   if(FractalAsTD==true)Comm=Comm+"\nFractals";
   else Comm=Comm+"\nTD point";
   if(Comments==1)Comment(Comm);
   else Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
