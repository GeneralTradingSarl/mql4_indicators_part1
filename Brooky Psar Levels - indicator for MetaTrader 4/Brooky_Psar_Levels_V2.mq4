//+------------------------------------------------------------------+
//|                                        Brooky_Psar_Levels_V2.mq4 |
//|                     Copyright © 2010, www.Brooky-Indicators.com. |
//|                             http://www.www.Brooky-Indicators.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, www.Brooky-Indicators.com."
#property link      "http://www.www.Brooky-Indicators.com"
extern string Hello_From=" www.Brooky-Indicators.com ";

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 DarkOrange
#property indicator_color2 DodgerBlue

#property indicator_width1 2
#property indicator_width2 2
#import "shell32.dll"
int ShellExecuteA(int hwnd,string lpOperation,string lpFile,string lpParameters,string lpDirectory,int nShowCmd);
#import
//---- input parameters
extern int          bars_back= 240;
extern double       sar_step = 0.006;
extern double       sar_max=0.03;
extern int          level_style= 0;
extern int          price_size = 2;
extern color        lowpsar=  DodgerBlue;
extern color        hipsar = DarkOrange;
extern bool          show_psar = true;
extern bool          see_price = false;

//--- netlink
extern bool   Check_Latest=true;
extern string Your_Internet_Browser="firefox.exe";//iexplore.exe
extern int    Link_Corner = 2;
extern int    Link_Offset = 20;

string              indi="Brooky-Psar V2";

//---- buffers
double plow[];
double phi[];

string book="www.Brooky-Indicators.com.Updates.";//
string bookrg="www.brooky-indicators.com/products-page/";//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,158);
   SetIndexBuffer(0,plow);
   SetIndexEmptyValue(0,0.0);

   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,158);
   SetIndexBuffer(1,phi);
   SetIndexEmptyValue(1,0.0);

   IndicatorShortName(indi);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete(book);
   ObjectDelete(bookrg);

   for(int j=0; j<bars_back; j++)
     {
      string timedelete=TimeToStr(iTime(NULL,0,j));

      ObjectDelete(indi+"Sup"+timedelete);
      ObjectDelete(indi+"Res"+timedelete);
      ObjectDelete(indi+"aUp"+timedelete);
      ObjectDelete(indi+"aDn"+timedelete);
      ObjectDelete(indi+"Sup2"+timedelete);
      ObjectDelete(indi+"Res2"+timedelete);
     }
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   if(limit>bars_back)limit=bars_back;
//---- main loop
   double mysarnow,myopen,mysarb4,myopenb4,mysarb42,myopenb42;

   for(int i=0; i<limit; i++)
     {

      string bardelete=TimeToStr(iTime(NULL,0,i));
      string firstbardelete=TimeToStr(iTime(NULL,0,bars_back));
      //Comment("firstbardelete  ",firstbardelete);

      ObjectDelete(indi+"Sup"+firstbardelete);
      ObjectDelete(indi+"Res"+firstbardelete);
      ObjectDelete(indi+"aUp"+firstbardelete);
      ObjectDelete(indi+"aDn"+firstbardelete);

      mysarnow= iSAR(NULL,0,sar_step,sar_max,i);
      mysarb4 = iSAR(NULL,0,sar_step,sar_max,i+1);
      mysarb42= iSAR(NULL,0,sar_step,sar_max,i+2);

      myopen=iOpen(NULL,0,i);
      myopenb4=iOpen(NULL,0,i+1);
      myopenb42=iOpen(NULL,0,i+2);

      if(mysarnow>=myopen && mysarb4<myopenb4)
        {
         plow[i]=mysarnow;
         string  res=indi+"Res"+bardelete;
         ObjectCreate(res,OBJ_HLINE,0,Time[i],mysarnow);
         ObjectSet(res,OBJPROP_STYLE,level_style);
         ObjectSet(res,OBJPROP_COLOR,hipsar);
         ObjectSet(res,OBJPROP_RAY,1);

         string  res2=indi+"Res2"+bardelete;
         ObjectCreate(res2,OBJ_HLINE,0,Time[i],mysarb4);
         ObjectSet(res2,OBJPROP_STYLE,level_style);
         ObjectSet(res2,OBJPROP_COLOR,hipsar);
         ObjectSet(res2,OBJPROP_RAY,1);

         if(see_price)
           {
            string named=indi+"aDn"+bardelete;

            ObjectCreate(named,OBJ_ARROW,0,Time[i],mysarnow);
            ObjectSet(named,OBJPROP_STYLE,STYLE_SOLID);
            ObjectSet(named,OBJPROP_ARROWCODE,5);
            ObjectSet(named,OBJPROP_COLOR,hipsar);
            ObjectSet(named,OBJPROP_WIDTH,price_size);
           }

           }else if(show_psar){plow[i]=iSAR(NULL,0,sar_step,sar_max,i);
        }
      else plow[i]=0.0;

      if(mysarnow<=myopen && mysarb4>myopenb4)
        {

         phi[i]=mysarnow;
         string sup=indi+"Sup"+bardelete;
         ObjectCreate(sup,OBJ_HLINE,0,Time[i],mysarnow);
         ObjectSet(sup,OBJPROP_STYLE,level_style);
         ObjectSet(sup,OBJPROP_COLOR,lowpsar);
         ObjectSet(sup,OBJPROP_RAY,1);

         string sup2=indi+"Sup2"+bardelete;
         ObjectCreate(sup2,OBJ_HLINE,0,Time[i],mysarb4);
         ObjectSet(sup2,OBJPROP_STYLE,level_style);
         ObjectSet(sup2,OBJPROP_COLOR,lowpsar);
         ObjectSet(sup2,OBJPROP_RAY,1);

         if(see_price)
           {
            string nameu=indi+"aUp"+bardelete;

            ObjectCreate(nameu,OBJ_ARROW,0,Time[i],mysarnow);
            ObjectSet(nameu,OBJPROP_STYLE,STYLE_SOLID);
            ObjectSet(nameu,OBJPROP_ARROWCODE,5);
            ObjectSet(nameu,OBJPROP_COLOR,lowpsar);
            ObjectSet(nameu,OBJPROP_WIDTH,price_size);
           }

           }else if(show_psar && iSAR(NULL,0,sar_step,sar_max,i)<Low[i]){phi[i]=iSAR(NULL,0,sar_step,sar_max,i);
        }
      else phi[i]=0.0;

     }
   if(Check_Latest==true)
     {
      if(ObjectFind(book)==-1)
        {
         ObjectCreate(book,OBJ_LABEL,0,0,0);
         ObjectSet(book,OBJPROP_BACK,0);
         ObjectSet(book,OBJPROP_CORNER,Link_Corner);
         ObjectSet(book,OBJPROP_XDISTANCE,Link_Offset);
         ObjectSet(book,OBJPROP_YDISTANCE,Link_Offset);
         ObjectSetText(book,CharToStr(255),40,"Wingdings",DodgerBlue);

         ObjectCreate(bookrg,OBJ_LABEL,0,0,0);
         ObjectSet(bookrg,OBJPROP_BACK,0);
         ObjectSet(bookrg,OBJPROP_CORNER,Link_Corner);
         ObjectSet(bookrg,OBJPROP_XDISTANCE,Link_Offset-10);
         ObjectSet(bookrg,OBJPROP_YDISTANCE,Link_Offset-10);
         ObjectSetText(bookrg,"Move Flag To Check Latest Brooky Indis",8,"Times New Roman",DodgerBlue);
        }

      if(ObjectFind(book)!=-1 && ObjectGet(book,OBJPROP_XDISTANCE)!=Link_Offset && dNewBar(1))

        {
         ObjectSet(book,OBJPROP_CORNER,Link_Corner);
         ObjectSet(book,OBJPROP_XDISTANCE,Link_Offset);
         ObjectSet(book,OBJPROP_YDISTANCE,Link_Offset);

         ShellExecuteA(0,"Open",Your_Internet_Browser,bookrg,"",5);

         ObjectSet(book,OBJPROP_CORNER,Link_Corner);
         ObjectSet(book,OBJPROP_XDISTANCE,Link_Offset);
         ObjectSet(book,OBJPROP_YDISTANCE,Link_Offset);
         //WindowRedraw();
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+

//----------------
bool dNewBar(int ddelay)
  {
   static datetime dlastbar;
   datetime dcurbar=TimeLocal();

   if((dcurbar-dlastbar)>ddelay)
     {
      dlastbar=dcurbar;
      return (true);
     }
   else
     {
      return(false);
     }
  }
//+------------------------------------------------------------------+
