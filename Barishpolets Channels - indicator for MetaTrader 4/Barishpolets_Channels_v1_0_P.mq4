//+------------------------------------------------------------------+
//|                                        Barishpolets Channels.mq4 |
//|                                                                  |
//| Conversion from MT3 by Mike & ...                                |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- Inputs
extern int  CalcBars=240;     //number of bars counted. 0-all bars counted
extern int  BarsForFract=0;   //bars of fractal's "shoulder"
//---- Variables
int    B1=-1,B2=-1,UpDown=0,CurrentBar=0,limit,k,i,i2,NumBars;
int    BFF=0,ishift=0,LowBar,HighBar,BMax,BMin,start;
double P1=0,P2=0,PP=0,Step=0,iprice=0,PMax,PMin,price;
//---- Buffers
double Buffer1[];
int init()
  {
//---- indicators
   IndicatorBuffers(1);
   SetIndexBuffer(0,Buffer1);
   SetIndexStyle(0,DRAW_ARROW,EMPTY);
   SetIndexArrow(0,164);
//---- selections
   if (BarsForFract>0) {BFF=BarsForFract;}
   else
     {
      switch(Period())
        {
         case 1:     BFF=12; break;
         case 5:     BFF=48; break;
         case 15:    BFF=24; break;
         case 30:    BFF=24; break;
         case 60:    BFF=24; break;
         case 240:   BFF=24; break;
         case 1440:  BFF=12; break;
         case 10080: BFF=12; break;
         default:      return(-1);
        }
     }
   //+----
   return(0);
  }
//----
int deinit()
  {
   for(k=0; k<limit; k++)
     {
      Buffer1[k]=0.0;
     }
   ObjectDelete("TL1");
   ObjectDelete("TL2");
   ObjectDelete("MIDL");
//----
   return(0);
  }
//----
int start()
  {
//---- check inputs
   if (Bars<=CalcBars || CalcBars<1)
     {
      Print("ERROR: Bars("+Bars+")<=CalcBars("+CalcBars+") or CalcBars("+CalcBars+")<1");
      return(-1);
     }
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) {Print("Error at counted_bars..."); return(-1);}
//---- Calc. area
   if (CalcBars==0 || CalcBars>Bars) NumBars=Bars; else NumBars=CalcBars;
   limit=NumBars-1;
//----
   if(counted_bars<1)
     {
      for(k=limit; k>=0; k--)
        {
         Buffer1[k]=0.0;
        }
     }
   if(counted_bars>0) counted_bars--;
//----
   CurrentBar=2; //start counting from the third bar as the fractal is "pinned down"
   B1=-1; B2=-1; UpDown=0;
   while((B1==-1 || B2==-1) && CurrentBar<NumBars)
     {
      //UpDown=1 means the 1st fractal has been found on top,
      //UpDown=-1 means the 1st fractal has been found at the bottom,
      //UpDown=0 means a fractal has not yet been found
      //б1 Х б2 - base line fractal bars
      //п1 Х п2 - prices for this line
      //
      // Low section
      //
      if (UpDown<1 && CurrentBar==Lowest(NULL,0,MODE_LOW,BFF*2+1,CurrentBar))
        {
         if (UpDown==0) { UpDown=-1; B1=CurrentBar; P1=Low[B1];}
         else            { B2=CurrentBar; P2=Low[B2];}
        }
      //
      // High section
      //
      if (UpDown>-1 && CurrentBar==Highest(NULL,0,MODE_HIGH,BFF*2+1,CurrentBar))
        {
         if (UpDown==0) { UpDown=1; B1=CurrentBar; P1=High[B1];}
         else            { B2=CurrentBar; P2=High[B2];}
        }
      CurrentBar++;
     } // end while
//----
   if   (B1==-1 || B2==-1) return(-1); // No fractals have been found in 300 bar range 8-)
   Step=(P2-P1)/(B2-B1);             //step calculated, if positive then the channel is descending 
   P1=P1-B1*Step; B1=0;              //price and the 1st bar are being restored to zero
   //
   //Reference point for opposite trendline
   //
   ishift=0; iprice=0;
   if (UpDown==1)
     {
      PP=Low[2]-2*Step;
      for(i=3; i<=B2; i++)
        {
         if (Low[i]<PP+Step*i) {PP=Low[i]-i*Step;}
         if (Low[0]<PP) {ishift=0; iprice=PP;}
         if (Low[1]<PP+Step) {ishift=1; iprice=PP+Step;}
         if (High[0]>P1) {ishift=0; iprice=P1;}
         if (High[1]>P1+Step) {ishift=1; iprice=P1+Step;}
        }
     }
   else
     {
      PP=High[2]-2*Step;
      for(i=3; i<=B2; i++)
        {
         if (High[i]>PP+Step*i) {PP=High[i]-i*Step;}
         if (Low[0]<P1) {ishift=0; iprice=P1;}
         if (Low[1]<P1+Step) {ishift=1; iprice=P1+Step;}
         if (High[0]>PP) {ishift=0; iprice=PP;}
         if (High[1]>PP+Step) {ishift=1; iprice=PP+Step;}
        }
     }
//----
   //Last price and bar to be set on юб to draw the line to the upmost right
   P2=P1+NumBars*Step;
   B1=Time[B1]; B2=Time[NumBars];
   // 0 (zero) means the channel line remains intact, dot means the channel is broken
   Buffer1[ishift]=iprice;
//----
   ObjectCreate("TL1",OBJ_TREND,0,B2,PP+Step*NumBars,B1,PP);
   ObjectCreate("TL2",OBJ_TREND,0,B2,P2,B1,P1);
   ObjectCreate("MIDL",OBJ_TREND,0,B2,(P2+PP+Step*NumBars)/2,B1,(P1+PP)/2);
//----
   return(0);
  }
//+------------------------------------------------------------------+