//+------------------------------------------------------------------+
//|                                                 ForexSession.mq4 |
//|                   2011-1-18 16:30:18 oldz.cn@qq.com         OldZ |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
// The design idea is from http://www.forexmarkethours.com/ 

#property copyright "OldZ"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Gold
#property indicator_color3 Green
#property indicator_color4 OrangeRed
//---- input parameters
extern int       LocalGMT=8; // Local time zone GMT offset
extern int       BrokerGMT=1; // Broker MT4's GMT offset
extern bool      ShowText = true; // Show each session on the left top corner.
int      SessionLocal[8],SessionBroker[8];
//---- buffers

double Sydney[];
double Tokyo[];
double London[];
double NewYork[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,110);
   SetIndexBuffer(0,Sydney);
   SetIndexLabel(0,"Sydney");
   SetIndexEmptyValue(0,0.0);
   
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,110);
   SetIndexBuffer(1,Tokyo);
   SetIndexLabel(1,"Tokyo");
   SetIndexEmptyValue(1,0.0);
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,110);
   SetIndexBuffer(2,London);
   SetIndexLabel(2,"London");
   SetIndexEmptyValue(2,0.0);
   
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,110);
   SetIndexBuffer(3,NewYork);
   SetIndexLabel(3,"NewYork");
   SetIndexEmptyValue(3,0.0);
   
   IndicatorDigits(Digits);
   
   SessionLocal(LocalGMT);
   SessionBroker(BrokerGMT);   
  
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
         if(counted_bars<0) return(-1);
         if(counted_bars>0) counted_bars--;
   int   limit = Bars-counted_bars;
//----
   int i;
   int hr;
   datetime t5 = iTime(NULL,PERIOD_D1,4);// 4 : draw 5 days 
   for(i=0;i<limit && Time[i]>=t5 ;i++)
   {     
      hr = TimeHour(Time[i]);
      DrawBrokerSession(hr,i);
   }
   
    if(ShowText)
    ShowSessionLocal();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void SessionLocal(int LocalGMT)
   {
      int gmt_diff = 8-LocalGMT;// 
            
      SessionLocal[0] =  6 - gmt_diff;
      SessionLocal[1] =  14 - gmt_diff;
      
      SessionLocal[2] =  8 - gmt_diff;
      SessionLocal[3] =  16 - gmt_diff;
      
      SessionLocal[4] =  16 - gmt_diff;
      SessionLocal[5] =  0 - gmt_diff;// 
      
      SessionLocal[6] =  21 - gmt_diff;
      SessionLocal[7] =  5 - gmt_diff;
      
      for( int i=0;i<8;i++)      
         if(SessionLocal[i]<0) SessionLocal[i]+=24;
      
   }
     
void SessionBroker(int BrokerGMT)
   {
      int gmt_diff = 1-BrokerGMT;// 
            
      SessionBroker[0] =  23 - gmt_diff;
      SessionBroker[1] =  7 - gmt_diff;
      
      SessionBroker[2] =  1 - gmt_diff;
      SessionBroker[3] =  9 - gmt_diff;
      
      SessionBroker[4] =  9 - gmt_diff;
      SessionBroker[5] =  17 - gmt_diff;
      
      SessionBroker[6] =  14 - gmt_diff;
      SessionBroker[7] =  22 - gmt_diff;
      
      for( int i=0;i<8;i++)      
         if(SessionBroker[i]<0) SessionBroker[i]+=24;      
   }  


void DrawBrokerSession(int hr,int i)
{
   if(SessionBroker[0]<SessionBroker[1])  
      if(SessionBroker[0]<=hr && hr <=SessionBroker[1]) Sydney[i]=0.8;
   if(SessionBroker[0]>SessionBroker[1]) 
     { 
       if(hr>=SessionBroker[0] && hr<=23)  Sydney[i] = 0.8;
       if(hr>=0 && hr<=SessionBroker[1])   Sydney[i] = 0.8;
      }
      
      
   if(SessionBroker[2]<SessionBroker[3])  
      if(SessionBroker[2]<=hr && hr <=SessionBroker[3]) Tokyo[i]=0.6;
   if(SessionBroker[2]>SessionBroker[3]) 
      { 
       if(hr>=SessionBroker[2] && hr<=23)  Tokyo[i] = 0.6;
       if(hr>=0 && hr<=SessionBroker[3])   Tokyo[i] = 0.6;
      }
      
   
   if(SessionBroker[4]<SessionBroker[5])  
      if(SessionBroker[4]<=hr && hr <=SessionBroker[5]) London[i]=0.4;
   if(SessionBroker[4]>SessionBroker[5]) 
       { 
       if(hr>=SessionBroker[4] && hr<=23)  London[i] = 0.4;
       if(hr>=0 && hr<=SessionBroker[5])   London[i] = 0.4;
      }
   
   if(SessionBroker[6]<SessionBroker[7])  
      if(SessionBroker[6]<=hr && hr <=SessionBroker[7]) NewYork[i]=0.2;
   if(SessionBroker[6]>SessionBroker[7]) 
       { 
       if(hr>=SessionBroker[6] && hr<=23)  NewYork[i] = 0.2;
       if(hr>=0 && hr<=SessionBroker[7])   NewYork[i] = 0.2;
      }    
   
}
   
void ShowSessionLocal()
   {
      Comment("\n", 
              "Forex market session on local time (GMT ",LocalGMT,")   ",TimeToStr(TimeLocal(),TIME_SECONDS),"\n",
              "Sydney   session:  ",SessionLocal[0]+":00 ----",SessionLocal[1]+":59","\n",
              "Tokyo    session:  ",SessionLocal[2]+":00 ----",SessionLocal[3]+":59","\n",
              "London   session:  ",SessionLocal[4]+":00 ----",SessionLocal[5]+":59","\n",
              "NewYork  session:  ",SessionLocal[6]+":00 ----",SessionLocal[7]+":59","\n");              
   }