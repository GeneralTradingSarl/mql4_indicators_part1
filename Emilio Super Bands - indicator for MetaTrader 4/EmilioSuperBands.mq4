#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 DodgerBlue
#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_DOT

extern int __EPeriod=20;
extern double mul = 1.5;
extern int ma_mode = MODE_SMMA;

double __EBufferUp[];
double __EBufferDown[];

double TempBuffer[];

int init() {
   string short_name;

   IndicatorBuffers(3);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,__EBufferUp);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,__EBufferDown);

   
   SetIndexBuffer(2,TempBuffer);

   short_name="__E("+__EPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name + "Up");
   SetIndexLabel(1,short_name + "Down");   
   
   SetIndexDrawBegin(0,__EPeriod);

   return(0);
}

int start() {
   int i,counted_bars=IndicatorCounted();
   if(Bars<=__EPeriod) return(0);

   // inizializzazione nel caso di refresh basso
   if(counted_bars < 1)
      for(i=1;i<=__EPeriod;i++) {
         __EBufferUp[Bars-i]=0.0;
         __EBufferDown[Bars-i]=0.0;

      }

   i=Bars-counted_bars-1;
   while(i>=0) {
      double high=High[i];
      double low =Low[i];
      if(i==Bars-1) TempBuffer[i]=high-low;
      else {
         double prevclose=Close[i+1];
         TempBuffer[i]=MathMax(high,prevclose)-MathMin(low,prevclose);
      }
      i--;
   }

   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++) {
      __EBufferUp[i]=High[i] + (iMAOnArray(TempBuffer,Bars,__EPeriod,0,ma_mode,i) * mul);
      __EBufferDown[i]=Low[i] - (iMAOnArray(TempBuffer,Bars,__EPeriod,0,ma_mode,i) * mul);
     
   }
   return(0);
}