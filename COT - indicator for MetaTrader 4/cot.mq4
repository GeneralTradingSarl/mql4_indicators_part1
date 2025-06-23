//+------------------------------------------------------------------+
//|                                                          cot.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
/*
  COT index formula:

  The COT index is stochastic oscillator of Net. 
 Net = Positions long - Positions short.


  WILLCO index formula:

  The WILLCO index is stochastic oscillator of %Net.
 %Net = 100%*(Positions long - Positions short)/OI.
 The OI is open interest.


  OI index formula:

 The OI index is stochastic oscillator of OI.


  Movement index formula:

  Movement index = COT(t) - COT(t+n).
 The n is a rate of change for Movement index.
 The t is an interval.
 The COT(t) is current value of COT index.
 The COT(t+n) is value of COT index n weeks ago.


  Spread movement index formula:
    
  Spread movement index = Movement index - OI Movement index.
 Movement index = COT(t) - COT(t+n).
 OI Movement index = OI index(t) - OI index(t+n).
 The n is a rate of change for Spread movement index.
 The t is an interval.
 The COT(t) is current value of COT index.
 The OI index(t) is current value of OI index.
 The COT(t+n) is value of COT index n weeks ago.
 The OI index(t+n) is value of OI index n weeks ago.



  How to begin to work?

  The indicator uses historical compressed files type of annual.txt, or annualof.txt for categories  "Futures Only", or
 "Futures-and-Options-Combined". These files have identical names for each year. Therefore, you need to rename these files.
 For example, you want to use 5 files type of annual.txt. The file annual.txt for current year must be renamed in year.txt
 The name "year" is the number of current year. For example, renamed files can have such names: 2015.txt,
 2014.txt, 2013.txt, 2012.txt, 2011.txt.
  Then, place these files into the folder Files/MQL4. Now, the indicator is ready for a work.
 Maximal number of used files type of year.txt is 50 for this version.



  How to update files code.bin every week?

  The indicator creates files type of code.bin. The name "code" is market's code. So as to update these files,
 do next steps:
 1. Update the file year.txt for current year.
 2. Open the window "Global Variables", choose the tab "Tools", or press the key F3.
 3. Change the value of variable "Update files code.bin" from 0 to 1.
 4. Close the window "Global Variables".
 5. Update the chart, choose the tab "Charts" and press "Refresh".
 After that, all of files code.bin will be updated.
*/
#property strict
#property indicator_separate_window
#property indicator_buffers 6

#property indicator_color1 LimeGreen
#property indicator_color2 DodgerBlue
#property indicator_color3 OrangeRed
#property indicator_color4 DarkGray
#property indicator_color5 LightSlateGray
#property indicator_color6 LightSlateGray

#property indicator_style1 STYLE_SOLID
#property indicator_style2 STYLE_SOLID
#property indicator_style3 STYLE_SOLID
#property indicator_style4 STYLE_SOLID
#property indicator_style5 STYLE_DOT
#property indicator_style6 STYLE_DOT

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 1
#property indicator_width6 1

#property indicator_levelcolor LightSlateGray
#property indicator_levelstyle STYLE_DOT

//---- indicator parameters
input string Code="xxxxxx";
input int period_0=26;   // Period of COT index and WILLCO index
input int period_1=52;  // Period of OI index 
input int period_2=6;  // Rate of change for Movement index and Spread movement index
//+------------------------------------------------------------------+
//| Indicators                                                       |
//+------------------------------------------------------------------+
enum id
  {
   COT,     // COT index
   WILLCO,  // WILLCO index
   Spread_move,    // Spread movement index
   Movement,       // Movement index
   Open_interest,  // Open interest
   Net,    // Net = Long - Short
   Long,   // Long
   Short,  // Short
   Pct_net,    // % Net = 100% * Net / Open interest
   Pct_long,   // % Long = 100% * Long / Open interest
   Pct_short,  // % Short = 100% * Short / Open interest
   Change_Long,  // Change Long
   Change_Short  // Change Short
  };
input id   Indicator=COT;
input bool OI_index=false;  // OI index
input bool Large=false;     // Noncommercial
input bool Comm=true;       // Commercial
input bool Specs=false;     // Nonreportable
input bool Inverted=false;  // Inverted chart
input bool Histogram=false;
//----
bool work=true;
double zi=-1;
double l0=100;
double l1=0;
double Buffer0[],Buffer1[],Buffer2[],Buffer3[],Buffer4[],Buffer5[],E1[],E2[],E3[],az;
int OI[],L1[],L2[],L3[],S1[],S2[],S3[],C1[],C2[],C3[],b,p0,p1,p2;
datetime DT[];
string c,n,w;
char j=2;
uint x;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(_Period<PERIOD_H1)
     {
      work=false;
      return(INIT_SUCCEEDED);
     }
//--- indicator buffers mapping
   IndicatorBuffers(6);
   SetIndexBuffer(0,Buffer0);
   SetIndexBuffer(1,Buffer1);
   SetIndexBuffer(2,Buffer2);
   SetIndexBuffer(3,Buffer3);
   SetIndexBuffer(4,Buffer4);
   SetIndexBuffer(5,Buffer5);
//---
   ArrayResize(S3,2655,2655);
   ArrayResize(S2,2655,2655);
   ArrayResize(S1,2655,2655);
   ArrayResize(L3,2655,2655);
   ArrayResize(L2,2655,2655);
   ArrayResize(L1,2655,2655);
   ArrayResize(OI,2655,2655);
   ArrayResize(DT,2655,2655);
   ArrayResize(C3,2655,2655);
   ArrayResize(C2,2655,2655);
   ArrayResize(C1,2655,2655);
   ArrayResize(E3,2655,2655);
   ArrayResize(E2,2655,2655);
   ArrayResize(E1,2655,2655);
//---
   if(!Histogram)
      b=DRAW_LINE;
   else
      b=DRAW_HISTOGRAM;
//---
   SetIndexStyle(0,b);
   SetIndexStyle(1,b);
   SetIndexStyle(2,b);
   SetIndexStyle(3,b);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
//---
   p0=period_0;
   p1=period_1;
   p2=period_2;
//--- restrictions 
   if(p0<2) p0=2;
   if(p1<2) p1=2;
   if(Indicator==2) p1=p0;
   if(p2<0) p2=0;
//---
   c=(string)p0;
   switch(Indicator)
     {
      case 0 :  w="COT("+c+").";  break;
      case 1 :  w="WILLCO("+c+").";  break;
      case 2 :  w="Spr("+c+", "+(string)p2+").";  l0=60;  l1=-60;  break;
      case 3 :  w="Mov("+c+", "+(string)p2+").";  l0=40;  l1=-40;  break;
      case 4 :  w="OI."; SetIndexLabel(3,"OI");  j=0;  break;
      case 5 :  w="Net.";  j=0;  break;
      case 6 :  w="Long.";  j=0;  break;
      case 7 :  w="Short.";  j=0;  break;
      case 8 :  w="% Net.";  break;
      case 9 :  w="% Long.";  break;
      case 10 :  w="% Short.";  break;
      case 11 :  w="~ Long.";  j=0;  break;
      case 12 :  w="~ Short.";  j=0;  break;
      default :  return(INIT_FAILED);
     }
//---
   IndicatorDigits(j);
   SetIndexLabel(0,w+" Noncommercial");
   SetIndexLabel(1,w+" Commercial");
   SetIndexLabel(2,w+" Nonreportable");
   if(Indicator<2)
     {
      SetIndexLabel(3,"OI index("+(string)p1+")");
      SetLevelValue(0,50.0);
     }
   else
      SetLevelValue(0,0.0);
   GlobalVariableSet("Update files code.bin",0);
//---
   if(Inverted)
     {
      az=1;
      zi=1;
     }
//---
   c=Code;
   if(ObjectFind("code")==-1 || c!="xxxxxx")
     {
      string sc[]=
        {
         "GBPUSD","096742", // BRITISH POUND STERLING
         "6B","096742",     // BRITISH POUND STERLING
         "EURUSD","099741", // EURO FX
         "6E","099741",     // EURO FX
         "AUDUSD","232741", // AUSTRALIAN DOLLAR
         "6A","232741",     // AUSTRALIAN DOLLAR
         "NZDUSD","112741", // NEW ZEALAND DOLLAR
         "6N","112741",     // NEW ZEALAND DOLLAR
         "USDCAD","090741", // CANADIAN DOLLAR
         "6C","090741",     // CANADIAN DOLLAR
         "USDCHF","092741", // SWISS FRANC
         "6S","092741",     // SWISS FRANC
         "USDJPY","097741", // JAPANESE YEN
         "6J","097741",     // JAPANESE YEN
         "XAUUSD","088691", // GOLD
         "GOLD","088691",   // GOLD
         "GC","088691",     // GOLD
         "XAGUSD","084691", // SILVER
         "SILVER","084691", // SILVER
         "SI","084691",     // SILVER
         "HG","085692",     // COPPER-GRADE #1
         "PA","075651",     // PALLADIUM
         "PL","076651",     // PLATINUM
         "ZW","001602",     // WHEAT
         "ZC","002602",     // CORN
         "ZS","005602",     // SOYBEANS
         "ZM","026603",     // SOYBEAN MEAL
         "ZL","007601",     // SOYBEAN OIL
         "ZO","004603",     // OATS
         "ZR","039601",     // ROUGH RICE
         "CL","067651",     // CRUDE OIL, LIGHT SWEET
         "HO","022651",     // #2 HEATING OIL
         "XR","111659",     // GASOLINE BLENDSTOCK (RBOB)
         "NG","023651",     // NATURAL GAS
         "DX","098662",     // U.S.DOLLAR INDEX
         "ZN","043602",     // 10-YEAR U.S. TREASURY NOTES
         "ZB","020601",     // U.S. TREASURY BONDS
         "YM","124603",     // DOW JONES INDUSTRIAL AVG- x $5
         "ES","13874A",     // E-MINI S&P 500 STOCK INDEX
         "NQ","209742",     // NASDAQ-100 STOCK INDEX (MINI)
         "ER2","23977A",    // RUSSELL 2000 MINI INDEX FUTURE
         "GE","132741",     // 3-MONTH EURODOLLARS
         "LE","057642",     // LIVE CATTLE
         "GF","061641",     // FEEDER CATTLE
         "HE","054642",     // LEAN HOGS
         "JO","040701",     // FRZN CONCENTRATED ORANGE JUICE
         "LBS","058643",    // RANDOM LENGTH LUMBER
         "CC","073732",     // COCOA
         "CT","033661",     // COTTON NO. 2
         "KC","083731",     // COFFEE C
         "SB","080732"      // SUGAR NO. 11
        };
      //--- 
      b=0;
      while(b<ArraySize(sc))
        {
         x=StringLen(sc[b]);
         if(StringSubstr(_Symbol,0,x)==sc[b])
           {
            c=sc[b+1];
            break;
           }
         b+=2;
        }
      //---
      if(c=="xxxxxx")
        {
         Alert("Enter market's code!");
         work=false;
        }
      else
         if(!FileIsExist(c+".bin")) x=1;
     }
   else
      c=ObjectDescription("code");
   n=c+".bin";
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   GlobalVariableDel(n);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---
   if(!work) return(rates_total);
//--- to change global variables
   int i;
   string v;
   if(GlobalVariableGet("Update files code.bin")==1)
     {
      for(i=0; i<GlobalVariablesTotal(); i++)
        {
         v=GlobalVariableName(i);
         if(StringFind(v,".bin",6)==6)
            GlobalVariableSet(v,1);
        }
      GlobalVariableSet("Update files code.bin",0);
     }
   double q=GlobalVariableGet(n);
   if(q!=1 && rates_total==prev_calculated)
      return(rates_total);
   int handle,e,f,z;
   uchar o=0;
   int d=0;
   int g=0;
   int r=0;
   int s=0;
   double g0=0;
//--- 
   if(q==1 || x==1)
     {
      x=0;
      int t=0;
      int y[],k,n1,n2,n3,n4,n5,n6,n7,n8,n9;
      string text[],files[],u,h,tx,m;
      ArrayResize(text,252,252);
      ArrayResize(files,51,51);
      ResetLastError();
      //--- to get last date
      if(FileIsExist(n))
        {
         handle=FileOpen(n,FILE_READ|FILE_BIN);
         if(handle!=INVALID_HANDLE)
           {
            FileSeek(handle,-4,SEEK_END);
            t=FileReadInteger(handle,INT_VALUE);
            FileClose(handle);
            tx="updated!";
           }
         else
           {
            Alert("Error in FileOpen(). Line 377. Error code = ",GetLastError());
            GlobalVariableSet(n,0);
            work=false;
            return(rates_total);
           }
        }
      else
         tx="created!";
      //--- to get the number of files year.txt
      z=Year();
      k=z-50;
      e=0;
      d=0;
      for(i=z; i>k; i--)
        {
         h=(string)i+".txt";
         if(FileIsExist(h))
           {
            files[d]=h;
            d++;
           }
         else
            if(d>0) break;
        }
      //---
      if(d==0)
        {
         Alert("There are not files year.txt in the folder Files/MQL4!");
         GlobalVariableSet(n,0);
         work=false;
         return(rates_total);
        }
      //---
      e=d*432;
      ArrayResize(y,e,e);
      //--- column for a reading
      string column1="\"CFTC Contract Market Code\"";
      string column2="\"As of Date in Form YYYY-MM-DD\"";
      string column3="\"Open Interest (All)\"";
      string column4="\"Noncommercial Positions-Long (All)\"";
      string column5="\"Noncommercial Positions-Short (All)\"";
      string column6="\"Commercial Positions-Long (All)\"";
      string column7="\"Commercial Positions-Short (All)\"";
      string column8="\"Nonreportable Positions-Long (All)\"";
      string column9="\"Nonreportable Positions-Short (All)\"";
      //--- to read files year.txt
      for(z=0; z<d; z++)
        {
         i=0;
         e=0;
         f=0;
         n1=0;
         n2=0;
         n3=0;
         n4=0;
         n5=0;
         n6=0;
         n7=0;
         n8=0;
         n9=0;
         handle=FileOpen(files[z],FILE_CSV|FILE_READ,",");
         if(handle!=INVALID_HANDLE)
           {
            while(!FileIsEnding(handle))
              {
               if(FileIsLineEnding(handle)) i=0;
               i++;
               text[i]=FileReadString(handle);
               if(i>20) continue;
               //--- to search column
               if(f<=18)
                 {
                  if(text[i]==column1) n1=i;
                  if(text[i]==column2) n2=i;
                  if(text[i]==column3) n3=i;
                  if(text[i]==column4) n4=i;
                  if(text[i]==column5) n5=i;
                  if(text[i]==column6) n6=i;
                  if(text[i]==column7) n7=i;
                  if(text[i]==column8) n8=i;
                  if(text[i]==column9) n9=i;
                  if(f==18)
                    {
                     if(n1==0 || n2==0 || n3==0 || n4==0 || n5==0 || n6==0 || n7==0 || n8==0 || n9==0)
                       {
                        v=" ";
                        if(n1==0) v+="\n"+column1;
                        if(n2==0) v+="\n"+column2;
                        if(n3==0) v+="\n"+column3;
                        if(n4==0) v+="\n"+column4;
                        if(n5==0) v+="\n"+column5;
                        if(n6==0) v+="\n"+column6;
                        if(n7==0) v+="\n"+column7;
                        if(n8==0) v+="\n"+column8;
                        if(n9==0) v+="\n"+column9;
                        Alert("These column are not found in the file "+files[z]+":"+"\n"+v);
                        work=false;
                        break;
                       }
                    }
                  f++;
                 }
               //---
               if(i<5)
                 {
                  k=StringLen(text[i])-2;
                  if(StringFind(text[i],"\"",k)!=-1) r=i-1;
                 }
               //---
               if(i<20) continue;
               v=StringTrimRight(text[n1+r]);
               u=StringTrimLeft(v);
               if(e==0)
                 {
                  if(u!=c) continue;
                  e=1;
                  if(g==0)
                    {
                     h=text[1];
                     if(r>0) h+=", "+text[2];
                    }
                 }
               else
                  if(u!=c) break;
               //---
               v=StringTrimRight(text[n2+r]);  // Date in form yyyy-mm-dd
               u=StringTrimLeft(v);
               v=StringSubstr(u,0,4)+"."+StringSubstr(u,5,2)+"."+StringSubstr(u,8,2); // Date in form yyyy.mm.dd
               s=(int)StrToTime(v);
               if(s>t)
                 {
                  y[g]=s;                         g++; // Date
                  y[g]=StrToInteger(text[n3+r]);  g++; // Open interest
                  y[g]=StrToInteger(text[n4+r]);  g++; // Noncommercial positions-long
                  y[g]=StrToInteger(text[n6+r]);  g++; // Commercial positions-long
                  y[g]=StrToInteger(text[n8+r]);  g++; // Nonreportable positions-long
                  y[g]=StrToInteger(text[n5+r]);  g++; // Noncommercial positions-short
                  y[g]=StrToInteger(text[n7+r]);  g++; // Commercial positions-short
                  y[g]=StrToInteger(text[n9+r]);  g++; // Nonreportable positions-short
                 }
               else
                 {
                  z=50;
                  break;
                 }
              }
            FileClose(handle);
            if(!work || (s!=0 && e==0)) break;
           }
         else
           {
            Alert("Error in FileOpen(). Line 447. Error code = ",GetLastError());
            if(tx=="updated!") GlobalVariableSet(n,0);
            work=false;
            break;
           }
         //---
         if(s==0)
           {
            Alert("Entered code  "+c+"  is not found in the file "+files[z]+"!");
            work=false;
            break;
           }
         //---
         if(g==0)
           {
            PrintFormat("The updating of the file  "+n+"  for  "+h+"  is not required!");
            GlobalVariableSet(n,0);
            break;
           }
         //--- limitation of quantity of used files year.txt
         if(z==50) break;
         //--- used files year.txt
         o++;
         m+=files[z]+", ";
         if(o>9)
           {
            m+="\n";
            o=0;
           }
        }
      //---
      if(!work || g==0) return(rates_total);
      //--- to write data to the file code.bin
      handle=FileOpen(n,FILE_READ|FILE_WRITE|FILE_BIN);
      if(handle!=INVALID_HANDLE)
        {
         FileSeek(handle,0,SEEK_END);
         i=g-1;
         //---
         do
           {
            x=FileWriteInteger(handle,y[i],INT_VALUE);
            if(x==0)
               break;
            i--;
           }
         while(i>=0);
         //---
         FileClose(handle);
         //---
         if(x>0)
           {
            if(tx=="created!")
               Alert("The file "+n+" for "+h+" has been "+tx+"\nUsed files: "+m);
            else
               PrintFormat("The file "+n+" for "+h+" has been "+tx);
           }
         else
           {
            Alert("Error in FileWriteInteger(). Line 579. The file "+n+" has been deleted. Error code = ",GetLastError());
            GlobalVariableSet(n,0);
            work=false;
            FileDelete(n);
            return(rates_total);
           }
        }
      else
        {
         Alert("Error in FileOpen(). Line 571. Error code = ",GetLastError());
         GlobalVariableSet(n,0);
         return(rates_total);
        }
     }
//--- to read the file code.bin
   if(q==1 || j!=-1)
     {
      j=-1;
      GlobalVariableSet(n,0);
      if(FileIsExist(n))
        {
         handle=FileOpen(n,FILE_READ|FILE_BIN);
         if(handle!=INVALID_HANDLE)
           {
            i=0;
            while(!FileIsEnding(handle))
              {
               S3[i]=FileReadInteger(handle,INT_VALUE); // Nonreportable positions-short
               S2[i]=FileReadInteger(handle,INT_VALUE); // Commercial positions-short
               S1[i]=FileReadInteger(handle,INT_VALUE); // Noncommercial positions-short
               L3[i]=FileReadInteger(handle,INT_VALUE); // Nonreportable positions-long
               L2[i]=FileReadInteger(handle,INT_VALUE); // Commercial positions-long
               L1[i]=FileReadInteger(handle,INT_VALUE); // Noncommercial positions-long
               OI[i]=FileReadInteger(handle,INT_VALUE); // Open interest
               DT[i]=(datetime)FileReadInteger(handle,INT_VALUE); // Date
               C3[i]=L3[i]-S3[i]; // Nonreportable positions-net
               C2[i]=L2[i]-S2[i]; // Commercial positions-net
               C1[i]=L1[i]-S1[i]; // Noncommercial positions-net
               E3[i]=100.0*C3[i]/OI[i]; // % of open interest for nonreportable positions-net
               E2[i]=100.0*C2[i]/OI[i]; // % of open interest for commercial positions-net
               E1[i]=100.0*C1[i]/OI[i]; // % of open interest for noncommercial positions-net
               i++;
              }
            FileClose(handle);
            //--- permutation of data in backwards order
            datetime l;
            b=i;
            g=0;
            i--;
            do
              {
               e=S3[g];    S3[g]=S3[i];    S3[i]=e;
               e=S2[g];    S2[g]=S2[i];    S2[i]=e;
               e=S1[g];    S1[g]=S1[i];    S1[i]=e;
               e=L3[g];    L3[g]=L3[i];    L3[i]=e;
               e=L2[g];    L2[g]=L2[i];    L2[i]=e;
               e=L1[g];    L1[g]=L1[i];    L1[i]=e;
               e=OI[g];    OI[g]=OI[i];    OI[i]=e;
               l=DT[g];    DT[g]=DT[i];    DT[i]=l;
               e=C3[g];    C3[g]=C3[i];    C3[i]=e;
               e=C2[g];    C2[g]=C2[i];    C2[i]=e;
               e=C1[g];    C1[g]=C1[i];    C1[i]=e;
               g0=E3[g];    E3[g]=E3[i];    E3[i]=g0;
               g0=E2[g];    E2[g]=E2[i];    E2[i]=g0;
               g0=E1[g];    E1[g]=E1[i];    E1[i]=g0;
               g++;
               i--;
              }
            while(i>g);
            //---
            if(ObjectFind("code")==-1)
              {
               ObjectCreate("code",OBJ_LABEL,0,0,0,0,0,0,0);
               ObjectSet("code",OBJPROP_XDISTANCE,-50);
               ObjectSet("code",OBJPROP_YDISTANCE,-50);
              }
            ObjectSetText("code",c,8,"Arial",CLR_NONE);
           }
         else
           {
            Alert("Error in FileOpen(). Line 618. Error code = ",GetLastError());
            return(rates_total);
           }
         IndicatorShortName(w+" History: "+(string)b+" weeks. Last report: "+TimeToStr(DT[0],TIME_DATE)+"   ");
        }
      else
        {
         Alert("There is not the file "+n+" in the folder Files/MQL4! For creating this file,\n"+
               "change the value of global variable \""+n+"\" from 0 to 1 and then, refresh a chart");
         return(rates_total);
        }
     }
//--- calculations
   double g1=0;
   double g2=0;
   double g3=0;
   d=0;
   o=0;
   for(i=0; i<rates_total; i++)
     {
      Buffer0[i]=EMPTY_VALUE;
      Buffer1[i]=EMPTY_VALUE;
      Buffer2[i]=EMPTY_VALUE;
      Buffer3[i]=EMPTY_VALUE;
      Buffer4[i]=EMPTY_VALUE;
      Buffer5[i]=EMPTY_VALUE;
      if(d==-1) continue;
      //---
      if(time[i]<=DT[d])
        {
         for(f=0; f<26; f++)
           {
            if(time[i]>DT[d+1+f])
               break;
           }
         d+=f;
         //--- OI index
         if((Indicator<2 && OI_index && o==0) || Indicator==2)
           {
            e=ArrayMaximum(OI,p1,d);
            z=ArrayMinimum(OI,p1,d);
            s=OI[e]-OI[z];
            if(s>0) g3=100.0*(OI[d]-OI[z])/s;
           }
         else
            g3=EMPTY_VALUE;
         //--- COT index
         if(Indicator!=1 && Indicator<4)
           {
            e=ArrayMaximum(C1,p0,d);
            z=ArrayMinimum(C1,p0,d);
            s=C1[e]-C1[z];
            if(s>0) g0=100.0*(az-zi*(C1[d]-C1[z])/s);
            e=ArrayMaximum(C2,p0,d);
            z=ArrayMinimum(C2,p0,d);
            s=C2[e]-C2[z];
            if(s>0) g1=100.0*(az-zi*(C2[d]-C2[z])/s);
            e=ArrayMaximum(C3,p0,d);
            z=ArrayMinimum(C3,p0,d);
            s=C3[e]-C3[z];
            if(s>0) g2=100.0*(az-zi*(C3[d]-C3[z])/s);
            //--- Movement index
            if(Indicator==2 || Indicator==3)
              {
               r=d+p2;
               e=ArrayMaximum(C1,p0,r);
               z=ArrayMinimum(C1,p0,r);
               s=C1[e]-C1[z];
               if(s>0) g0=g0-100.0*(az-zi*(C1[r]-C1[z])/s);
               e=ArrayMaximum(C2,p0,r);
               z=ArrayMinimum(C2,p0,r);
               s=C2[e]-C2[z];
               if(s>0) g1=g1-100.0*(az-zi*(C2[r]-C2[z])/s);
               e=ArrayMaximum(C3,p0,r);
               z=ArrayMinimum(C3,p0,r);
               s=C3[e]-C3[z];
               if(s>0) g2=g2-100.0*(az-zi*(C3[r]-C3[z])/s);
               //--- OI Movement index
               if(Indicator==2)
                 {
                  e=ArrayMaximum(OI,p0,r);
                  z=ArrayMinimum(OI,p0,r);
                  s=OI[e]-OI[z];
                  if(s>0) g3=g3-100.0*(OI[r]-OI[z])/s;
                  if(zi==1) g3=-g3;
                  //--- Spread movement index
                  g0-=g3;
                  g1-=g3;
                  g2-=g3;
                 }
              }
           }
         //--- WILLCO index
         if(Indicator==1)
           {
            e=ArrayMaximum(E1,p0,d);
            z=ArrayMinimum(E1,p0,d);
            q=E1[e]-E1[z];
            if(q>0) g0=100.0*(az-zi*(E1[d]-E1[z])/q);
            e=ArrayMaximum(E2,p0,d);
            z=ArrayMinimum(E2,p0,d);
            q=E2[e]-E2[z];
            if(q>0) g1=100.0*(az-zi*(E2[d]-E2[z])/q);
            e=ArrayMaximum(E3,p0,d);
            z=ArrayMinimum(E3,p0,d);
            q=E3[e]-E3[z];
            if(q>0) g2=100.0*(az-zi*(E3[d]-E3[z])/q);
           }
         //--- OI
         if(Indicator==4) g3=-zi*OI[d];
         //--- Net
         if(Indicator==5)
           {
            g0=-zi*C1[d];
            g1=-zi*C2[d];
            g2=-zi*C3[d];
           }
         //--- Long
         if(Indicator==6)
           {
            g0=-zi*L1[d];
            g1=-zi*L2[d];
            g2=-zi*L3[d];
           }
         //--- Short
         if(Indicator==7)
           {
            g0=-zi*S1[d];
            g1=-zi*S2[d];
            g2=-zi*S3[d];
           }
         //--- % Net
         if(Indicator==8)
           {
            g0=-zi*E1[d];
            g1=-zi*E2[d];
            g2=-zi*E3[d];
           }
         //--- % Long
         if(Indicator==9)
           {
            g0=-zi*100.0*L1[d]/OI[d];
            g1=-zi*100.0*L2[d]/OI[d];
            g2=-zi*100.0*L3[d]/OI[d];
           }
         //--- % Short
         if(Indicator==10)
           {
            g0=-zi*100.0*S1[d]/OI[d];
            g1=-zi*100.0*S2[d]/OI[d];
            g2=-zi*100.0*S3[d]/OI[d];
           }
         //--- Change Long
         if(Indicator==11)
           {
            g0=-zi*(L1[d]-L1[d+1]);
            g1=-zi*(L2[d]-L2[d+1]);
            g2=-zi*(L3[d]-L3[d+1]);
           }
         //--- Change Short
         if(Indicator==12)
           {
            g0=-zi*(S1[d]-S1[d+1]);
            g1=-zi*(S2[d]-S2[d+1]);
            g2=-zi*(S3[d]-S3[d+1]);
           }
         d++;
        }
      //---
      if(d==0) continue;
      if(Indicator<4)
        {
         if(Large) Buffer0[i]=g0;
         if(Comm)  Buffer1[i]=g1;
         if(Specs) Buffer2[i]=g2;
         Buffer4[i]=l0;
         Buffer5[i]=l1;
         if(Indicator<2)
           {
            if(OI_index)
              {
               Buffer3[i]=g3;
               if(d>b-p1) o=1;
              }
            if(d>b-p0) d=-1;
           }
         else
            if(d>b-p0-p2) d=-1;
        }
      else
        {
         if(Indicator>4)
           {
            if(Large) Buffer0[i]=g0;
            if(Comm)  Buffer1[i]=g1;
            if(Specs) Buffer2[i]=g2;
            if(Indicator>10)
               if(d>=b-1) d=-1;
           }
         else
            Buffer3[i]=g3;
         if(d>=b) d=-1;
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
