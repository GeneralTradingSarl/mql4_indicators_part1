//+------------------------------------------------------------------+
//|                                 Day Trader Market In Profile.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Eng\Bassam El-Faramawi."
#property link      "bmaamoon@yahoo.com"


#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
extern int Step = 4;
extern int NumberOfDays = 10;
extern int SessionHalfHours = 48;
           
extern bool ViewTPOs = true;
extern bool TPOs_as_Letters = true;
extern int TPOs_Shift = 0;
extern int Letter_Size = 6;
extern color TPO_Color =DarkGray;

extern bool ViewOpenFlag = true;
extern color OpenColor=LightSteelBlue;
extern int OpenFlagShift = 0;

extern bool View_Pointer = true;
extern color PointerColor = Magenta;
extern int PointerShift = 2;

extern bool ViewrangeLine = false;
extern color RangeLineColor = LightSteelBlue;
extern int rangeLine_Shift = 1;

extern bool ViewInitialBalanceLine = True;
extern color IBLineColor = SteelBlue;
extern int IBLineWidth = 2;
extern int IBLine_Shift = 1;

extern bool ViewValueArea = true;
extern double Persent_Of_TPO_ValueArea = 0.7; 
extern int ValueArea_Shift = 1;
extern color TopLine_Color = Red;
extern int TopLine_Width = 1;
extern int TopLine_Start = 1;
extern int TopLine_End = 1;
extern color BottomLine_Color = Red;
extern int BottomLine_Width = 1;
extern int BottomLine_Start = 1;
extern int BottomLine_End = 1;

extern bool ViewPocLine = true;
extern int PocLine_shift = 1;
extern color PocColor =Blue;
extern int PocLine_Start = 1;
extern int PocLine_Width = 1;
extern int PocLine_End = 1;


extern bool ViewInformationText = false;
extern int InformationTextSize = 7;
extern color InformationTextColor = DarkTurquoise;
extern int InformationTextShift = 12;
             
             
string Text[50];


int init()
  {
  DeleteAllObjects(NumberOfDays);
//---- indicators
Text[1]="A";      Text[2]="B";      Text[3]="C";      Text[4]="D";      Text[5]="E";     
Text[6]="F";      Text[7]="G";      Text[8]="H";      Text[9]="I";      Text[10]="J";     
Text[11]="K";     Text[12]="L";     Text[13]="M";     Text[14]="N";     Text[15]="O";     
Text[16]="P";     Text[17]="Q";     Text[18]="R";     Text[19]="S";     Text[20]="T";     
Text[21]="U";     Text[22]="V";     Text[23]="W";     Text[24]="X";     Text[25]="a";     
Text[26]="b";     Text[27]="c";     Text[28]="d";     Text[29]="e";     Text[30]="f";     
Text[31]="g";     Text[32]="h";     Text[33]="i";     Text[34]="j";     Text[35]="k";     
Text[36]="l";     Text[37]="m";     Text[38]="n";     Text[39]="o";     Text[40]="p";     
Text[41]="q";     Text[42]="r";     Text[43]="s";     Text[44]="t";     Text[45]="u";     
Text[46]="v";     Text[47]="w";     Text[48]="x";     
//----
Createobjects();
Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
  DeleteAllObjects(NumberOfDays); 
  Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
 Comment(" ","\n","Eng.Bassam Market Profile V1.0","\n"," ","\n","By : Eng\ Bassam El-Faramawi","\n"," ","\n","bmaamoon@yahoo.com");

int    counted_bars=IndicatorCounted();
int    m,H,t,n,i,Ymax,Ymin;
double h, TickVolume;
datetime dt = TimeCurrent(),t0;

//----
t = 48/SessionHalfHours;
if (MathMod(48,SessionHalfHours)>0) t++;
if (MathMod(SessionHalfHours,2)>0) m=1;

//----
t0=StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"00"+":"+"00");
Ymax = iBarShift(NULL, 30, t0);
TickVolume = iVolume(NULL, 1440, 0);
for(n=1; n<=t; n++)
{
h= ((TimeHour(dt)*2)+m)/SessionHalfHours;
if (h<n-1)
continue;

Ymin = Ymax-SessionHalfHours+1;

drawobjects(Ymax,Ymin,TickVolume);
Ymax=Ymax-SessionHalfHours;
}
//----
   return(0);
  }



//+----------------------//|------------------|\\----------------------+
//+---------------------///|                  |\\\---------------------+
//+---------------------\**| Custom Functions |**/---------------------+
//+----------------------\\|                  |//----------------------+
//+-----------------------\|------------------|/-----------------------+


void Createobjects()
{
int    m,H,t,n,i,y0,Ymax,Ymin;

double h,TickVolume;

t = 48/SessionHalfHours;
if (MathMod(48,SessionHalfHours)>0) t++;
if (MathMod(SessionHalfHours,2)>0) m=1;

datetime dt = TimeCurrent(),t0;
t0=StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"00"+":"+"00");
y0=iBarShift(NULL,0,t0);

//----
for(i=1; i<NumberOfDays; i++)
{
dt=iTime(NULL,0,y0+1);
t0=StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"00"+":"+"00");
TickVolume = iVolume(NULL, 1440, i);
Ymax = iBarShift(NULL, 30, t0);
for(n=1; n<=t; n++)
{
Ymin = Ymax-SessionHalfHours+1;

if (n==t)
Ymin=iBarShift(NULL, 30, StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"23"+":"+"30"));

drawobjects(Ymax,Ymin,TickVolume);
Ymax=Ymax-SessionHalfHours;
}
y0=iBarShift(NULL,0,t0);
}
}
//+------------------------------------------------------------------+
void drawobjects(int Ymax,int Ymin ,double TickVolume)
{
int    u,s,fac,y,Yt,Space,POC,AllTicks,ValueArea,i,imax,imin,ValueRange,TPOs[1000];
double x,Mid,PocTick;

if (Digits == 2 || Digits == 4) fac = 1;
if (Digits == 3 || Digits == 5) fac = 10;

double Max= High[iHighest(NULL,30,MODE_HIGH,(Ymax-Ymin+1),Ymin)],
       Min= Low[iLowest(NULL,30,MODE_LOW,(Ymax-Ymin+1),Ymin)],
       IBmax= High[iHighest(NULL,30,MODE_HIGH,2,Ymax-1)],
       IBmin= Low[iLowest(NULL,30,MODE_LOW,2,Ymax-1)],
       STEP=Step*fac*Point;
       Mid= (Max-Min)*0.5 +Min;
       Yt = iBarShift(NULL,0,iTime(NULL,30,Ymax),false);
       u=0; 

for( y=Ymax; y>=Ymin; y--)
  {
  for( s=1; s<=(Max-Min)/STEP; s++)
    {
     ObjectDelete(TimeToStr(iTime(NULL,0,y+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES) +"  "+ DoubleToStr(s,0));
     }
   }

for(x=Max; x>=Min; x=x-STEP)
  {
    
   Space = 0;
   i=(Max-x)/STEP;
   u++;
   for( y=Ymax; y>=Ymin; y--)
    {
    
    double opentick = iOpen(Symbol(),30,Ymax),
           Maximum= iHigh(Symbol(),30,y),
           Minimum= iLow(Symbol(),30,y);
    if (Maximum <x || Minimum >x)
    continue;
    Space++;
//-------------
    string TPOName = TimeToStr(iTime(NULL,0,Ymax-Space+1+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES) +"  "+ DoubleToStr(u,0);
    if (ViewTPOs)
    {
     if(TPOs_as_Letters == true)
      {
      ObjectDelete(TPOName);
      ObjectCreate(TPOName, OBJ_TEXT, 0, iTime(NULL,0,Yt-Space+1+(TPOs_Shift*SessionHalfHours)), x);
      ObjectSetText(TPOName,Text[Ymax-y+1], Letter_Size, "Arial", TPO_Color);
      }
     else
      {
      ObjectDelete(TPOName);
      ObjectCreate(TPOName, OBJ_ARROW, 0, iTime(NULL,0,Yt-Space+1+(TPOs_Shift*SessionHalfHours)), x);
      ObjectSet(TPOName,OBJPROP_ARROWCODE,167);
      ObjectSet(TPOName,OBJPROP_COLOR,TPO_Color);
      ObjectSet(TPOName, OBJPROP_BACK, True);
      } 
    }
  
   } 
//--------------       


 
    string open = "open  "+TimeToStr(iTime(NULL,0,Ymax+OpenFlagShift+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES);
           
    if(ViewOpenFlag)
    {
    ObjectDelete(open);
    ObjectCreate(open, OBJ_ARROW, 0, iTime(NULL,0,Yt+OpenFlagShift+(TPOs_Shift*SessionHalfHours)), opentick);
    ObjectSet(open,OBJPROP_ARROWCODE,161);
    ObjectSet(open,OBJPROP_COLOR,OpenColor);
    ObjectSet(open, OBJPROP_BACK, True);
    }
    
//--------------
  
  double POCShift = MathAbs(PocTick-Mid),
         SpaceShift=MathAbs(x-Mid);
     
         
    if (Space > POC)
    {
     POC = Space;
     PocTick = x;
     }
    
    if (Space == POC && SpaceShift < POCShift)
    PocTick = x;
 
//--------------
  
  string Poc = "POC  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES); 
  
  int Poc_start =Yt+PocLine_Start-(PocLine_shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours) ,
      Poc_end = Yt-POC+PocLine_End-(PocLine_shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours);
         
    
  if(ViewPocLine)
  {
  ObjectDelete(Poc);
  ObjectCreate(Poc, OBJ_TREND, 0, iTime(NULL,0,Poc_start), PocTick ,iTime(NULL,0,Poc_end),PocTick );
  ObjectSet(Poc,OBJPROP_COLOR,PocColor);
  ObjectSet(Poc, OBJPROP_WIDTH,PocLine_Width);
  ObjectSet(Poc, OBJPROP_RAY, false);
  ObjectSet(Poc, OBJPROP_BACK, True);
  }  
  
     
 
//--------------  
 AllTicks=AllTicks+Space;
 TPOs[i]=Space;
}
ValueArea=AllTicks*Persent_Of_TPO_ValueArea;
imax=(Max-PocTick)/STEP;
imin=imax;
ValueRange=TPOs[imax];


 while(ValueRange < ValueArea)
 {
 
  if(TPOs[imax-1] == TPOs[imin+1])
    {
     ValueRange = ValueRange+(2*TPOs[imax-1]);
     imax--;
     imin++;
     }   

 if(TPOs[imax-1] > TPOs[imin+1])
   {
    ValueRange = ValueRange+TPOs[imax-1];
    imax--;
    }

 if(TPOs[imax-1] < TPOs[imin+1])
    {
     ValueRange = ValueRange+TPOs[imin+1];
     imin++;
     }


     
  }

string Range = "Range  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),
       ValueAreaRange = "ValueAreaRange  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),       
       TVolume = "TVolume "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),
       ValueTop = "ValueTop  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),
       ValueBottom = "ValueBottom  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),
       RangeLine = "RangeLine  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES),
       IBLine = "IBLine  "+TimeToStr(iTime(NULL,0,Ymax+(TPOs_Shift*SessionHalfHours)),TIME_DATE|TIME_MINUTES);
       
       
       int Yvt_start= Yt+TopLine_Start-(ValueArea_Shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours),
           Yvt_end= Yt-TPOs[imax]+TopLine_End-(ValueArea_Shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours),
           Yvb_start= Yt+BottomLine_Start-(ValueArea_Shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours),
           Yvb_end= Yt-TPOs[imin]+BottomLine_End-(ValueArea_Shift*SessionHalfHours)+(TPOs_Shift*SessionHalfHours);
           

if(ViewValueArea)
  {
  ObjectDelete(ValueTop);
  ObjectCreate(ValueTop, OBJ_TREND,0,iTime(NULL,0,Yvt_start),Max-(imax*STEP), iTime(NULL,0,Yvt_end),Max-(imax*STEP));
  ObjectSet(ValueTop, OBJPROP_COLOR, TopLine_Color);
  ObjectSet(ValueTop, OBJPROP_WIDTH,TopLine_Width);
  ObjectSet(ValueTop, OBJPROP_RAY, false);
  ObjectSet(ValueTop, OBJPROP_BACK, True);
  
  ObjectDelete(ValueBottom);
  ObjectCreate(ValueBottom, OBJ_TREND,0,iTime(NULL,0,Yvb_start),Max-(imin*STEP),iTime(NULL,0,Yvb_end),Max-(imin*STEP));
  ObjectSet(ValueBottom, OBJPROP_COLOR, BottomLine_Color);
  ObjectSet(ValueBottom, OBJPROP_WIDTH,BottomLine_Width);
  ObjectSet(ValueBottom, OBJPROP_RAY, false);
  ObjectSet(ValueBottom, OBJPROP_BACK, True);
  }

if(ViewInformationText)
  {  
  ObjectDelete(Range);
  ObjectCreate(Range, OBJ_TEXT, 0,iTime(NULL,0,Yt-SessionHalfHours+InformationTextShift+(TPOs_Shift*SessionHalfHours)), PocTick);
  ObjectSetText(Range, "Range= "+DoubleToStr((Max-Min),4)+" Pip", InformationTextSize, "Arial",InformationTextColor);
  
  ObjectDelete(ValueAreaRange);
  ObjectCreate(ValueAreaRange, OBJ_TEXT, 0,iTime(NULL,0,Yt-SessionHalfHours+InformationTextShift+(TPOs_Shift*SessionHalfHours)), PocTick-(2*STEP));
  ObjectSetText(ValueAreaRange, "TPO ValueArea= "+DoubleToStr((imin-imax)*STEP,4)+" Pip", InformationTextSize, "Arial",InformationTextColor);
  
  
  ObjectDelete(TVolume);
  ObjectCreate(TVolume, OBJ_TEXT, 0,iTime(NULL,0,Yt-SessionHalfHours+InformationTextShift+(TPOs_Shift*SessionHalfHours)), PocTick-(4*STEP));
  ObjectSetText(TVolume, "Tick Volume= "+DoubleToStr(TickVolume,0), InformationTextSize, "Arial",InformationTextColor);
  }
  
if(ViewrangeLine)  
  {
  ObjectDelete(RangeLine);
  ObjectCreate(RangeLine, OBJ_TREND,0,iTime(NULL,0,Yt-(rangeLine_Shift*SessionHalfHours)+1+(TPOs_Shift*SessionHalfHours)),Max, iTime(NULL,0,Yt-(rangeLine_Shift*SessionHalfHours)+1+(TPOs_Shift*SessionHalfHours)),Min);
  ObjectSet(RangeLine, OBJPROP_COLOR, RangeLineColor);
  ObjectSet(RangeLine, OBJPROP_STYLE,STYLE_DOT);
  ObjectSet(RangeLine, OBJPROP_RAY, false);
  }
  
if (ViewInitialBalanceLine)
   {
   ObjectDelete(IBLine);
   ObjectCreate(IBLine, OBJ_TREND,0,iTime(NULL,0,Yt+IBLine_Shift+(TPOs_Shift*SessionHalfHours)),IBmax, iTime(NULL,0,Yt+IBLine_Shift+(TPOs_Shift*SessionHalfHours)),IBmin);
   ObjectSet(IBLine, OBJPROP_COLOR, IBLineColor);
   ObjectSet(IBLine, OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(IBLine, OBJPROP_WIDTH,IBLineWidth);
   ObjectSet(IBLine, OBJPROP_RAY, false);
   }
   
if(View_Pointer)
  {
  
  int Pointer= (Max-Close[0])/STEP;
      
  if ( Max-(Pointer*STEP)-Close[0]  > Close[0]-Max+((Pointer+1)*STEP) )
      Pointer++;
  int Pointr =Yt-TPOs[Pointer]-PointerShift;
  if (Pointr < 0)
  Pointr =0;
  ObjectDelete("Pointer");
   
  if(ObjectFind("Pointer") != 0)
    {
    ObjectCreate("Pointer", OBJ_ARROW, 0, iTime(NULL,0,Pointr+(TPOs_Shift*SessionHalfHours)), Close[0]+STEP);
    ObjectSet("Pointer", OBJPROP_ARROWCODE,239);
    ObjectSet("Pointer",OBJPROP_COLOR,PointerColor);
    ObjectSet("Pointer", OBJPROP_BACK, false);
     }
  else
    {
   ObjectMove("Pointer", 0, iTime(NULL,0,Pointr+(TPOs_Shift*SessionHalfHours)), Close[0]+STEP);
    }

    }
    
}





//+------------------------------------------------------------------+

void DeleteAllObjects(int NumberOfDays)
{
datetime dt,t0;
int y,u,Ymax;
string TPOName;

dt =iTime(NULL,0,0);
t0=StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"00"+":"+"00");
Ymax=iBarShift(NULL,0,t0);

for (y=0; y<=NumberOfDays+6; y++)
{
dt=iTime(NULL,0,Ymax+1);
t0=StrToTime(TimeYear(dt)+"."+TimeMonth(dt)+"."+TimeDay(dt)+" "+"00"+":"+"00");
Ymax=iBarShift(NULL,0,t0);
}

for (y=0; y<=Ymax; y++)
{
 TPOName = TimeToStr(iTime(NULL,0,y),TIME_DATE|TIME_MINUTES);
 if(ObjectFind("open  "+TPOName)==0)
    ObjectDelete("open  "+TPOName);
    
 if(ObjectFind("Pointer")==0)
    ObjectDelete("Pointer");
     
 if(ObjectFind("POC  "+TPOName)==0)
    ObjectDelete("POC  "+TPOName);   
 
 if(ObjectFind("ValueTop  "+TPOName)==0)
    ObjectDelete("ValueTop  "+TPOName); 
 
 if(ObjectFind("ValueBottom  "+TPOName)==0)
    ObjectDelete("ValueBottom  "+TPOName); 
    
 if(ObjectFind("Range  "+TPOName)==0)
    ObjectDelete("Range  "+TPOName);    
    
 if(ObjectFind("ValueAreaRange  "+TPOName)==0)
    ObjectDelete("ValueAreaRange  "+TPOName); 
 
 if(ObjectFind("TVolume "+TPOName)==0)
    ObjectDelete("TVolume "+TPOName); 
       
 if(ObjectFind("RangeLine  "+TPOName)==0)
    ObjectDelete("RangeLine  "+TPOName);   
    
 if(ObjectFind("IBLine  "+TPOName)==0)
    ObjectDelete("IBLine  "+TPOName);   
 
      
    
 for (u=0; u<=1000; u++)
 {
 if(ObjectFind(TPOName+"  "+DoubleToStr(u,0))==0)
 ObjectDelete(TPOName+"  "+DoubleToStr(u,0));
 }

}

}
//+------------------------------------------------------------------+


