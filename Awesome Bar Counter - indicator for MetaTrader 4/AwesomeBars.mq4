//+------------------------------------------------------------------+
//|                                                  AwesomeBars.mq4 |
//|                                     http://www.lightsites.co.za/ |
//+------------------------------------------------------------------+
#property link      "http://www.lightsites.co.za/"


#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
//---- input parameters
extern int aBarsPeriod=14;
//---- buffers
double aBarsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,aBarsBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="aBars("+aBarsPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,aBarsPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| aBarsentum                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=aBarsPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=aBarsPeriod;i++) aBarsBuffer[Bars-i]=0.0;
//----
   i=Bars-aBarsPeriod-1;
   if(counted_bars>=aBarsPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
               static int pbars = 0;      
          
               double hh1 = 0, hh2 = 0;                 
                  
               if (iCustom(Symbol(),Period(),"Awesome",0,i) < iCustom(Symbol(),Period(),"Awesome",0,i+1) )
               {    
                  pbars = 0;
                  int n=0;
                  while(n<200)
                  {

                    hh1 = iCustom(Symbol(),Period(),"Awesome",0,i+n); 
                    hh2 = iCustom(Symbol(),Period(),"Awesome",0,i+n+1); 
                    n++;                    

                    if (hh1 > hh2)break; 
                    pbars++;
                 }               
               }  

                if (iCustom(Symbol(),Period(),"Awesome",0,i) > iCustom(Symbol(),Period(),"Awesome",0,i+1) )
               {    
                  pbars = 0;
                  n=0;
                  while(n<200)
                  {

                    hh1 = iCustom(Symbol(),Period(),"Awesome",0,i+n); 
                    hh2 = iCustom(Symbol(),Period(),"Awesome",0,i+n+1); 
                    n++;                    

                    if (hh1 < hh2)break; 
                    pbars++;
                 }               
               }   
      aBarsBuffer[i]=pbars;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+