//+------------------------------------------------------------------+
//|                                         Dinapoli ZZ (ZigZag).mq4 |
//|                                          rewritten by CrazyChart |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "rewritten by CrazyChart"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int       barn=300;
extern int       Length=6;
//---- buffers
double ExtMapBuffer1[];
//double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexEmptyValue(0,0.0);
  //SetIndexDrawBegin(0, barn);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,ExtMapBuffer1);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int shift,Swing,Swing_n,uzl,i,zu,zd,mv;
   double LL,HH,BH,BL,NH,NL; 
   double Uzel[10000][3]; 
   string text;
// loop from first bar to current bar (with shift=0) 
      Swing_n=0;Swing=0;uzl=0; 
      BH =High[barn];BL=Low[barn];zu=barn;zd=barn; 

for (shift=barn;shift>=0;shift--) { 
      LL=10000000;HH=-100000000; 
   for (i=shift+Length;i>=shift+1;i--) { 
         if (Low[i]< LL) {LL=Low[i];} 
         if (High[i]>HH) {HH=High[i];} 
   } 


   if (Low[shift]<LL && High[shift]>HH){ 
      Swing=2; 
      if (Swing_n==1) {zu=shift+1;} 
      if (Swing_n==-1) {zd=shift+1;} 
   } else { 
      if (Low[shift]<LL) {Swing=-1;} 
      if (High[shift]>HH) {Swing=1;} 
   } 

   if (Swing!=Swing_n && Swing_n!=0) { 
   if (Swing==2) {
      Swing=-Swing_n;BH = High[shift];BL = Low[shift]; 
   } 
      uzl=uzl+1; 
   if (Swing==1) {
      Uzel[uzl][1]=zd;
      Uzel[uzl][2]=BL;
   } 
   if (Swing==-1) {
      Uzel[uzl][1]=zu;
      Uzel[uzl][2]=BH; 
   } 
      BH = High[shift];
      BL = Low[shift]; 
   } 

   if (Swing==1) { 
      if (High[shift]>=BH) {BH=High[shift];zu=shift;}} 
      if (Swing==-1) {
          if (Low[shift]<=BL) {BL=Low[shift]; zd=shift;}} 
      Swing_n=Swing; 
   } 
   for (i=1;i<=uzl;i++) { 
      //text=DoubleToStr(Uzel[i][1],0);
      //text=;
         mv=StrToInteger(DoubleToStr(Uzel[i][1],0));
      ExtMapBuffer1[mv]=Uzel[i][2];
   } 





   return(0);
  }
//+------------------------------------------------------------------+