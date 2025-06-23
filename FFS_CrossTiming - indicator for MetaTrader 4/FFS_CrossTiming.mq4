//+------------------------------------------------------------------+
//|                                              FFS_CrossTiming.mq4 |   
//|                                            Release date 20070128 |                                  
//+------------------------------------------------------------------+
#property copyright "icm63 (user name at Forex-TSD)"
#property link      "Forex-TSD"
//+---------------------------------------------------------------------------------------------------+
//|                                                                                                   |
//| READ ME FIRST.                                                                                    |
//|  I have nothing to do with www.forexforsmarties.com.                                              |
//|  You use these tools at YOUR OWN RISK.                                                            |
//|  I do not endorse or sell FFS methods or products in any way.                                     |
//|  These tools are provided FREE of charge, I wish to promote the development of MT4 tools and minds|
//|  of those who trade FFS to get the best 'How to FFS tools'. So we all can trade FFS thru easy     |
//|  and tough times. As the Forex market gives and takes away fortunes ! To make 5% monthly          |
//|  compounding over 10 years is not easy when the forex beast changes.                              |
//|                                                                                                   |
//| Use with                                                                                          |
//|  FFS_Trend                                                                                        |
//|  FFS_Correlation                                                                                  |
//|  FFS_Cross                                                                                        |
//|  FFS_NetPipChange                                                                                 |
//|                                                                                                   |
//| IMPORTANT:                                                                                        |
//|  Make sure the 'IndexType' is the same within each MT4 tool.                                      |
//|  The FFS_Mode should be set as BUY, to mirror the FFS Calcutator.                                 |
//|                                                                                                   |
//|  Like the FFS_Correlation tool, this is a fundamental watch. It shows the combined trend of       |
//|  all the crosses related to the hedge pair in question. All cross have been adjusted to be on     |
//|  the same price scale and treated as equal weight.                                                |
//|                                                                                                   |
//|  When this start getting wild so will the accounts trading FFS, and settings will have to be      |
//|  adjusted for survival. Use the FFS_Trainspotter (in FFS_Trend) to see FFS_NetPipChange summary   |
//|  to view the extremes of the net pip swings of the hedge pairs.                                   |
//|                                                                                                   |
//| This is the index selection format                                                                |
//|  1. EUR/USD, USD/CHF                                                                              |
//|  2. EUR/USD, USD/CHF, GBP/USD                                                                     |
//|  3. EUR/USD, USD/CHF, GBP/USD, USD/JPY                                                            |
//|  4. EUR/USD, USD/CHF, USD/JPY                                                                     |
//|  5. EUR/USD, GBP/USD, USD/JPY                                                                     |
//|  6. USD/CHF, GBP/USD                                                                              |
//|  7. USD/CHF, GBP/USD, USD/JPY                                                                     |
//|  8. GBP/USD, USD/JPY                                                                              |
//+---------------------------------------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 3
//----
#property indicator_color1 Red
#property indicator_color2 DarkGreen
#property indicator_color3 Lime
//----
#property indicator_level1  60
#property indicator_level2  40
//User Inputs Parameters
extern int IndexType=9; // FFS Index see above
extern int CCI=5; //CCI period
extern double Lag1_Gamma=0.5; //Laguerre Gamma Short
extern double Lag2_Gamma=0.8; //Laguerre Gamma Long
//---- variables
double cross1[];
double CCI1[];
double Lag1[];
double Lag2[];
double normCCI1[];
double normcross1[];
string shortname;
//---- Laguerra Variables
double L0A=0;
double L1A=0;
double L2A=0;
double L3A=0;
double L0=0;
double L1=0;
double L2=0;
double L3=0;
double CU=0;
double CD=0;
double LRSI=0;
//---
double Maxcross1=-10000000,Mincross1=10000000;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   shortname="FFS_CrossTiming  Index "+(string)IndexType+
             ", CCI Red ("+(string)CCI+"), Laguerre("+DoubleToStr(Lag1_Gamma,1)+","+DoubleToStr(Lag2_Gamma,1)+"), ";
//----
   IndicatorShortName(shortname);
   IndicatorBuffers(6);
//----
   SetIndexDrawBegin(0,CCI+1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,normCCI1);
   SetIndexLabel(0,"CCI1");
//---
   SetIndexDrawBegin(1,5);
   SetIndexEmptyValue(1,-0.01);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Lag1);
   SetIndexLabel(1,"Lag1");
//---
   SetIndexDrawBegin(2,5);
   SetIndexEmptyValue(2,-0.01);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Lag2);
   SetIndexLabel(2,"Lag2");
//---
   SetIndexBuffer(3,cross1);
   SetIndexBuffer(4,CCI1);
   SetIndexBuffer(5,normcross1);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
//----
   double EURCHFW,GBPCHFW,EURJPYW,GBPJPYW,CHFJPYW,EURGBPW;
//Determine correct weight to get all prices on scale of 10,000
   double iclose_EURCHF = (iClose("EURCHF",0,1)*10000); if(iclose_EURCHF==0) return(0);
   double iclose_GBPCHF = (iClose("GBPCHF",0,1)*10000); if(iclose_GBPCHF==0) return(0);
   double iclose_EURJPY = (iClose("EURJPY",0,1)*10000); if(iclose_EURJPY==0) return(0);
   double iclose_GBPJPY = (iClose("GBPJPY",0,1)*10000); if(iclose_GBPJPY==0) return(0);
   double iclose_CHFJPY = (iClose("CHFJPY",0,1)*10000); if(iclose_CHFJPY==0) return(0);
   double iclose_EURGBP = (iClose("EURGBP",0,1)*10000); if(iclose_EURGBP==0) return(0);

   EURCHFW=(10000/iclose_EURCHF)*10000;
   GBPCHFW=(10000/iclose_GBPCHF)*10000;
   EURJPYW=(10000/iclose_EURJPY)*10000;
   GBPJPYW=(10000/iclose_GBPJPY)*10000;
   CHFJPYW=(10000/iclose_CHFJPY)*10000;
   EURGBPW=(10000/iclose_EURGBP)*10000;
//----
   for(int i=limit; i>=0; i--)
     {
      switch(IndexType)
        {
         case 1:
            //1. EUR/USD, USD/CHF"
            cross1[i]=iClose("EURCHF",0,i)*EURCHFW;
            break;
         case 2:
            //2. EUR/USD, USD/CHF, GBP/USD
            cross1[i]=iClose("EURCHF",0,i)*EURCHFW+iClose("GBPCHF",0,i)*GBPCHFW
            +iClose("EURGBP",0,i)*EURGBPW;
            break;
         case 3:
            //3. EUR/USD, USD/CHF, GBP/USD, USD/JPY
            cross1[i]=iClose("EURCHF",0,i)*EURCHFW+iClose("GBPCHF",0,i)*GBPCHFW
            +iClose("EURJPY",0,i)*EURJPYW+iClose("GBPJPY",0,i)*GBPJPYW
            +iClose("CHFJPY",0,i)*CHFJPYW+iClose("EURGBP",0,i)*EURGBPW;
            break;
         case 4:
            //4. EUR/USD, USD/CHF, USD/JPY 
            cross1[i]=iClose("EURCHF",0,i)*EURCHFW+iClose("EURJPY",0,i)*EURJPYW
            +iClose("CHFJPY",0,i)*CHFJPYW;
            break;
         case 5:
            //5. EUR/USD, GBP/USD, USD/JPY
            cross1[i]=iClose("EURJPY",0,i)*EURJPYW+iClose("GBPJPY",0,i)*GBPJPYW
            +iClose("EURGBP",0,i)*EURGBPW;
            break;
         case 6:
            //6. USD/CHF, GBP/USD
            cross1[i]=iClose("GBPCHF",0,i)*GBPCHFW;
            break;
         case 7:
            //7. USD/CHF, GBP/USD, USD/JPY
            cross1[i]=iClose("GBPCHF",0,i)*GBPCHFW+iClose("GBPJPY",0,i)*GBPJPYW
            +iClose("CHFJPY",0,i)*CHFJPYW;
            break;
         case 8:
            //8. GBP/USD, USD/JPY 
            cross1[i]=iClose("GBPJPY",0,i)*GBPJPYW;
            break;

         case 9:
            //9. Chart Symbol
            cross1[i]=iClose(NULL,0,i);
            break;
         default:
            //3. EUR/USD, USD/CHF, GBP/USD, USD/JPY
            cross1[i]=iClose("EURCHF",0,i)*EURCHFW+iClose("GBPCHF",0,i)*GBPCHFW
            +iClose("EURJPY",0,i)*EURJPYW+iClose("GBPJPY",0,i)*GBPJPYW
            +iClose("CHFJPY",0,i)*CHFJPYW+iClose("EURGBP",0,i)*EURGBPW;
            break;
        }
      //Find Max and Min or series

      for(int k=0; k<limit;k++)
        {
         if(i+k<ArraySize(cross1))
           {
            if(cross1[i+k] > Maxcross1) Maxcross1=cross1[i+k];
            if(cross1[i+k] < Mincross1) Mincross1=cross1[i+k];
           }
        }
     }
//Normalise Data btw 0 and 100

   for(int m=limit; m>=0; m--)
     {
      if(Maxcross1-Mincross1!=0) normcross1[m]=NormalizeDouble(100*(cross1[m]-Mincross1)/(Maxcross1-Mincross1),2);
     }
//INDICATORS FOR NORMALISED CROSSES DATA FOR ENTRY AND EXIT TIMING FOR FFS TRADES
//Calculate CCI and Laguerre arrays
   if(CCI>0)
     {
      for(int g=limit; g>=0; g--)
        {
         CCI1[g]=iCCIOnArray(normcross1,limit,CCI,g); //Red
         Lag1[g]=LaguerreRSI(normcross1[g],Lag1_Gamma);
        }
      for(int y=limit; y>=0; y--)
        {
         Lag2[y]=LaguerreRSI(normcross1[y],Lag2_Gamma);
        }
     }
   NormaliseSeries(CCI1,normCCI1,limit);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|FUNCTIONS                                                         |
//+------------------------------------------------------------------+
void NormaliseSeries(double &InData[],double &OutData[],
                     int limit)
  {
   double nMax= -10000000;
   double nMin= 10000000;
//----
   for(int k=0; k<limit;k++)
     {
      if(InData[k] > nMax) nMax=InData[k];
      if(InData[k] < nMin) nMin=InData[k];
     }
//Normalise Data btw Min and Max
   for(int m=limit; m>=0; m--)
     {
      if(nMax-nMin!=0) OutData[m]=NormalizeDouble(100*((InData[m]-nMin)/(nMax-nMin)),2);
     }
  }
//+------------------------------------------------------------------+
//|Laguerre calc                                                     |
//+------------------------------------------------------------------+
double LaguerreRSI(double InData,double gamma)
  {
   L0A=L0;
   L1A=L1;
   L2A=L2;
   L3A=L3;
   L0=(1 - gamma)* InData + gamma* L0A;
   L1=- gamma * L0 + L0A + gamma * L1A;
   L2=- gamma * L1 + L1A + gamma * L2A;
   L3=- gamma * L2 + L2A + gamma * L3A;
//----
   CU=0;
   CD=0;
//----
   if(L0>=L1)
      CU=L0-L1;
   else
      CD=L1-L0;
//----
   if(L1>=L2)
      CU=CU+L1-L2;
   else
      CD=CD+L2-L1;
//----
   if(L2>=L3)
      CU=CU+L2-L3;
   else
      CD=CD+L3-L2;
//----
   if(CU+CD!=0) LRSI=NormalizeDouble((CU/(CU+CD)) *90,2);
   return(LRSI);
  }
//+------------------------------------------------------------------+
