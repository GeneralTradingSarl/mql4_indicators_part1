//+------------------------------------------------------------------+
//|                                                 BW-wiseMan-1.mq4 |
//|                                          Copyright © 2005, wellx |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, wellx"
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 OrangeRed
//----
extern int  updown=5; //смещение индикатора чтобы не налезална другие значки
extern int  back=2;   // кол-во баров для анализа назад
//---- buffers
double BWWM1Up[];
double BWWM1Down[];
//----
int pos=0;
int i=0;
bool contup=true,contdown=true;
//+-----------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,140);
   SetIndexBuffer(0,BWWM1Up);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,140);
   SetIndexBuffer(1,BWWM1Down);
   SetIndexEmptyValue(1,0.0);
   IndicatorDigits(6);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int  cbars=IndicatorCounted();
   if  (cbars<0) return(-1);
   if  (cbars>0) cbars--;
//---- TODO: add your code here
   //if (cbars == 0) return(0);
   pos=cbars;
   while(pos > 0)
     {
      BWWM1Up[pos]=NULL;
      BWWM1Down[pos]=NULL;
      if (
          (Low[pos]> iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORLIPS, pos))
           &&
          (Low[pos]> iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORTEETH, pos))
           &&
          (Low[pos]> iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, pos))
           &&
          (Close[pos]<((High[pos]+Low[pos])/2))
         )
        {
         contup=true;
         for(i=1; i<=back ;i++)
           {
            if (High[pos]<=High[pos+i])
              {
               contup=false;
               break;
              }
           }
         if (contup) BWWM1Up[pos]=(High[pos]+updown*Point);
        }
//----
      if (
          (High[pos]< iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORLIPS, pos))
           &&
          (High[pos]< iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORTEETH, pos))
           &&
          (High[pos]< iAlligator(NULL,0,13,8,8,5,5,3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, pos))
           &&
          (Close[pos]>((High[pos]+Low[pos])/2))
         )
        {
         contdown=true;
         for(i=1; i<=back ;i++)
           {
            if (Low[pos]>=Low[pos+i])
              {
               contdown=false;
               break;
              }
           }
         if (contdown) BWWM1Down[pos]=(Low[pos]-updown*Point);
        }
      pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+