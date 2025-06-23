//+------------------------------------------------------------------+
//|                                               Price and Time.mq4 |
//|                                         Copyright © 2011, newpip |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, dibosh"
#property link      "dibosh@gmail.com"

#property indicator_chart_window

//+------------------------------------------------------------------+

extern string CreatedBy     = "dibosh *** dibosh@gmail.com";
//===================================================
extern string note0     = "// B-Clock";
extern int fontSize = 8;
 bool  attachment=true;
 color ClockColor = C'21,115,166'; //'21,115,166';

//===================================================
 string note00         = "// Dollar Calculation";
extern string DollarFont     ="Arial";
extern int    DollarFontSize =9;
 color  DollarColor    = C'17,90,130';

//===================================================

extern string note1         = "// MAS";
extern int MACorner         = 1;
extern int MA1_value        = 8;
extern int MA2_value        = 14;
extern int MA1_type         = 1;
extern int MA2_type         = 0;
extern int MAYpos           = 75; 

//===================================================
extern string note5     = "// Spread";
extern bool   spreadShow     =true;
extern int    spreadfontSize = 13;
extern color  spreadColor    = C'128,128,128';
extern string spreadFont     = "Arial";
extern int    spreadCorner   =3;
extern int    spreadPosX     =5;
extern int    spreadPosY     =5;
//===================================================
extern string note2     = "// ASK-BID";
extern bool   AskP    =true;
extern bool   BidP    =true;
extern bool   ABText  =false;
extern int    AfontSize = 8;
extern int    BfontSize = 8;
extern int    MainFontBigger = 4; // (AfontSize or BfontSize) + MainFontBigger
extern int    LastDigitFontSmaller = 0; // (AfontSize or BfontSize) - MainFontBigger
extern color  AskBidColor  = C'105,105,105';
extern color  MainDigitAsk = C'30,144,255';
extern color  LastDigitAsk = C'105,105,105';
extern color  MainDigitBid = C'17,90,130';
extern color  LastDigitBid = C'105,105,105';
extern int    Corner       =3;
extern int    AskPosX      =85;
extern int    AskPosY      =25;
extern int    BidPosX      =85;
extern int    BidPosY      =5;

//===================================================
extern string note4       = "// Period";
extern bool   PRShow      =true;
extern int    PRfontSize  =15;
extern string PRFont      = "impact";
extern color  PRColor     = C'11,57,83';
extern int    PRCorner    =1;
extern int    PRPosX      =5;
extern int    PRPosY      =38;
//===================================================
extern string note3         = "// Pair";
extern bool   PaiRShow      =true;
extern int    PaiRfontSize  = 20;
extern string PairFont      = "Impact";
extern color  PaiRColor     = C'60,60,60';
extern int    PaiRCorner    =1;
extern int    PairPosX      =5;
extern int    PairPosY      =10;






//+------------------------------------------------------------------+
double s1[];
//+------------------------------------------------------------------+
int deinit() {
   ObjectDelete("time");
   ObjectDelete("Market_Label"); 
   ObjectDelete("Market_LabelB");
   ObjectDelete("PR_Label");
   ObjectDelete("pair");
   ObjectDelete("sp");
   ObjectDelete("spt");
   ObjectDelete("Trend");
   ObjectDelete("Flow");
   ObjectDelete("50Cross100");
   ObjectDelete("ask1");
   ObjectDelete("ask2");
   ObjectDelete("ask3");
   ObjectDelete("bid1");
   ObjectDelete("bid2");
   ObjectDelete("bid3");
   ObjectDelete("dollar1");
   ObjectDelete("dollar2");
   ObjectDelete("dollar3");
   ObjectDelete("marginR1");
   ObjectDelete("marginR2");
   ObjectDelete("marginR3");
   ObjectDelete("note1");
   ObjectDelete("note2");
}

//+------------------------------------------------------------------+
int init(){
   return(0);
}
//+------------------------------------------------------------------+

int start()
  {

	double i;
   int sec,d,h,m,s,k;
   sec=Time[0]+Period()*60-CurTime();
   i=sec/60;
   s=sec%60;
   m=(sec-sec%60)/60;
   h=(m-m%60)/60;
   d=(h-h%24)/24;
   
      
//   Comment( m + " minutes " + s + " seconds left to bar end");


   string Bid_Price, Ask_Price; 
	Bid_Price = DoubleToStr (Bid,Digits);
   Ask_Price = DoubleToStr (Ask,Digits);
	
   ObjectDelete("time");
   
   if(ObjectFind("time") != 0)
   {
   
            string time=m+":"+s;
            
            //4h, 1D TIME FRAME
            if (Period()==240 || Period()==1440){
               m=m-(h*60);
               if (h>=1){
                  time=h+":"+m+":"+s;
               }else{
                  time=m+":"+s;
               }
            }
            
            //1W, 1M TIME FRAME
            if (Period()==10080 || Period()==43200){
               m=m-(h*60);
               h=h-(d*24);
               d=d-1;
               if (d>=1){
                  time="                          "+h+":"+m+":"+s+" ("+d+"d)";
               }else{
                  if (h>=1){
                     time=h+":"+m+":"+s;
                  }else{
                     time=m+":"+s;
                  }
               }
            }
   
      if (attachment){
         ObjectCreate("time", OBJ_TEXT, 0, Time[1], Close[0]+ 0.0000);
         ObjectSetText("time", "                     "+time, fontSize, "Arial", ClockColor);
      }else{
         ObjectCreate("time", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("time", time, fontSize, "Arial", ClockColor);
         ObjectSet("time", OBJPROP_CORNER, 3);
         ObjectSet("time", OBJPROP_XDISTANCE, spreadPosX);
         ObjectSet("time", OBJPROP_YDISTANCE, spreadPosY+13*10);
      }
   }
   else
   {
   ObjectMove("time", 0, Time[0], Close[0]+0.0005);
   }
int gap1, gap2;
if (AskP){   
   string ap1, ap2, ap3;
   
   ap1=Ask_Price;
   if (Digits==5){
      ap1=StringSubstr(Ask_Price,0,4)+" "; ap2=StringSubstr(Ask_Price,4,2)+" "; ap3=StringSubstr(Ask_Price,6,0);
      gap1=25; gap2=3;
   }else if(Digits==4){
      ap1=StringSubstr(Ask_Price,0,4)+" "; ap2=StringSubstr(Ask_Price,4,2); ap3="";
      gap1=25; gap2=3;
   }else if(Digits==3){
      if(Symbol()=="EURJPY" || Symbol()=="GBPJPY"){
         ap1=StringSubstr(Ask_Price,0,4)+" "; ap2=StringSubstr(Ask_Price,4,2)+""; ap3=StringSubstr(Ask_Price,6,1);
         gap1=25; gap2=9;
       }else{
         ap1=StringSubstr(Ask_Price,0,3)+" "; ap2=StringSubstr(Ask_Price,3,2)+""; ap3=StringSubstr(Ask_Price,5,1);
         gap1=25; gap2=9;
       }
   }
   
   //MainDigit
   
   
   ObjectCreate("ask1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("ask1", ap1, BfontSize, "tahoma", AskBidColor);
   ObjectSet("ask1", OBJPROP_CORNER, Corner);
   ObjectSet("ask1", OBJPROP_XDISTANCE, AskPosX+gap1);
   ObjectSet("ask1", OBJPROP_YDISTANCE, AskPosY);
   
   ObjectCreate("ask2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("ask2", ap2, BfontSize+MainFontBigger, "tahoma", MainDigitAsk);
   ObjectSet("ask2", OBJPROP_CORNER, Corner);
   ObjectSet("ask2", OBJPROP_XDISTANCE, AskPosX+gap2);
   ObjectSet("ask2", OBJPROP_YDISTANCE, AskPosY);
   
   ObjectCreate("ask3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("ask3", ap3, BfontSize-LastDigitFontSmaller, "tahoma", LastDigitAsk);
   ObjectSet("ask3", OBJPROP_CORNER, Corner);
   ObjectSet("ask3", OBJPROP_XDISTANCE, AskPosX+00);
   ObjectSet("ask3", OBJPROP_YDISTANCE, AskPosY+5);

   if (ABText){
       ObjectCreate("t2", OBJ_LABEL, 0, 0, 0);
       ObjectSetText("t2", "BUY PRICE", 8, "tahoma", MainDigitAsk);
       ObjectSet("t2", OBJPROP_CORNER, Corner);
       ObjectSet("t2", OBJPROP_XDISTANCE, AskPosX);
       ObjectSet("t2", OBJPROP_YDISTANCE, AskPosY-8);
   }
}
if (BidP){
   string bp1, bp2, bp3;
   bp1=Bid_Price;
   if (Digits==5){
      bp1=StringSubstr(Bid_Price,0,4)+" "; bp2=StringSubstr(Bid_Price,4,2)+" "; bp3=StringSubstr(Bid_Price,6,0);
      gap1=25; gap2=3;
   }else if(Digits==4){
      bp1=StringSubstr(Bid_Price,0,4)+" "; bp2=StringSubstr(Bid_Price,4,2); bp3="";
      gap1=25; gap2=3;
   }else if(Digits==3){
      if(Symbol()=="EURJPY" || Symbol()=="GBPJPY"){
         bp1=StringSubstr(Bid_Price,0,4)+" "; bp2=StringSubstr(Bid_Price,4,2)+""; bp3=StringSubstr(Bid_Price,6,1);
         gap1=25; gap2=9;
       }else{
         bp1=StringSubstr(Bid_Price,0,3)+" "; bp2=StringSubstr(Bid_Price,3,2)+""; bp3=StringSubstr(Bid_Price,5,1);
         gap1=25; gap2=9;
       }
   }
   
   ObjectCreate("bid1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("bid1", bp1, BfontSize, "tahoma", AskBidColor);
   ObjectSet("bid1", OBJPROP_CORNER, Corner);
   ObjectSet("bid1", OBJPROP_XDISTANCE, BidPosX+gap1);
   ObjectSet("bid1", OBJPROP_YDISTANCE, BidPosY);
   
   ObjectCreate("bid2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("bid2", bp2, BfontSize+MainFontBigger, "tahoma", MainDigitBid);
   ObjectSet("bid2", OBJPROP_CORNER, Corner);
   ObjectSet("bid2", OBJPROP_XDISTANCE, BidPosX+gap2);
   ObjectSet("bid2", OBJPROP_YDISTANCE, BidPosY);
   
   ObjectCreate("bid3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("bid3", bp3, BfontSize-LastDigitFontSmaller, "tahoma", LastDigitBid);
   ObjectSet("bid3", OBJPROP_CORNER, Corner);
   ObjectSet("bid3", OBJPROP_XDISTANCE, BidPosX+00);
   ObjectSet("bid3", OBJPROP_YDISTANCE, BidPosY+5);
   
   
   if (ABText){
       ObjectCreate("t1", OBJ_LABEL, 0, 0, 0);
       ObjectSetText("t1", "SELL PRICE", 8, "tahoma", AskBidColor);
       ObjectSet("t1", OBJPROP_CORNER, Corner);
       ObjectSet("t1", OBJPROP_XDISTANCE, BidPosX);
       ObjectSet("t1", OBJPROP_YDISTANCE, BidPosY-8);
   }
}
   
if (PRShow){
   ObjectCreate("PR_Label", OBJ_LABEL, 0, 0, 0);
   if (Period()==43200){
      ObjectSetText("PR_Label", "Monthly", PRfontSize, PRFont, PRColor);
   }else if (Period()==10080){
      ObjectSetText("PR_Label", "Weekly", PRfontSize, PRFont, PRColor);
   }else if (Period()==1440){
      ObjectSetText("PR_Label", "Daily", PRfontSize, PRFont, PRColor);
   }else if (Period()>30){
      ObjectSetText("PR_Label", (Period()/60)+" Hour", PRfontSize, PRFont, PRColor);
   }else{
      ObjectSetText("PR_Label", Period()+" Min", PRfontSize, PRFont, PRColor);
   }
   ObjectSet("PR_Label", OBJPROP_CORNER, PRCorner);
   ObjectSet("PR_Label", OBJPROP_XDISTANCE, PRPosX);
   ObjectSet("PR_Label", OBJPROP_YDISTANCE, PRPosY);
}      
if (PaiRShow){
   ObjectCreate("pair", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("pair", Symbol(), PaiRfontSize, PairFont, PaiRColor);
   ObjectSet("pair", OBJPROP_CORNER, PaiRCorner);
   ObjectSet("pair", OBJPROP_XDISTANCE, PairPosX);
   ObjectSet("pair", OBJPROP_YDISTANCE, PairPosY);
}
if (spreadShow){
   //Spread Counter
   string spreadCount, echo, micro, standared, mega;
   double diff=Ask-Bid, margineRequired= (MarketInfo(Symbol(), MODE_MARGINREQUIRED));
   
   switch (Digits){
      case 0:
         spreadCount=DoubleToStr(diff,0);
         micro=DoubleToStr((diff)*10,2);
         standared=DoubleToStr((diff)*1,2);
         mega=DoubleToStr((diff)/10,2);
         echo = "0";
         break;
      case 1:
         spreadCount=DoubleToStr(diff*10,0);
         micro=DoubleToStr((diff*10)*10,2);
         standared=DoubleToStr((diff*10)*1,2);
         mega=DoubleToStr((diff*10)/10,2);
         echo = "1";
         break;
      case 2:
         spreadCount=DoubleToStr(diff*100,0);
         micro=DoubleToStr((diff*100)*10,2);
         standared=DoubleToStr((diff*100)*1,2);
         mega=DoubleToStr((diff*100)/10,2);
         echo = "2";
         break;
      case 3:
         spreadCount=DoubleToStr(diff*100,1);
         micro=DoubleToStr((diff*100)*10,2);
         standared=DoubleToStr((diff*100)*1,2);
         mega=DoubleToStr((diff*100)/10,2);
         echo = "3";
         break;
      case 4:
         spreadCount=DoubleToStr(diff*10000,0);
         micro=DoubleToStr((diff*10000)*10,2);
         standared=DoubleToStr((diff*10000)*1,2);
         mega=DoubleToStr((diff*10000)/10,2);
         echo = "4";
         break;
      case 5:
         spreadCount=DoubleToStr(diff*10000,1);
         micro=DoubleToStr((diff*10000)*10,2);
         standared=DoubleToStr((diff*10000)*1,2);
         mega=DoubleToStr((diff*10000)/10,2);
         echo = "5";
         break;
      default:
         spreadCount=DoubleToStr(diff*1000000,0);
         micro=DoubleToStr((diff*1000000)*10,2);
         standared=DoubleToStr((diff*1000000)*1,2);
         mega=DoubleToStr((diff*1000000)/10,2);
         echo = "";
         break;
   }
   
   
   // Comment ("PAIR COUNT "+ echo+ " DIGITS AFTER DOT");
   
   ObjectCreate("sp", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("sp", spreadCount, spreadfontSize, spreadFont, DollarColor);
   ObjectSet("sp", OBJPROP_CORNER, spreadCorner);
   ObjectSet("sp", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("sp", OBJPROP_YDISTANCE, spreadPosY+13*8+9);
   
   ObjectCreate("spt", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("spt", "SPREAD", 7, "tahoma", spreadColor);
   ObjectSet("spt", OBJPROP_CORNER, spreadCorner);
   ObjectSet("spt", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("spt", OBJPROP_YDISTANCE, spreadPosY+13*8);
   
   ObjectCreate("note1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("note1", "COST", 7, DollarFont, DollarColor);
   ObjectSet("note1", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("note1", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("note1", OBJPROP_YDISTANCE, spreadPosY+13*7);
   
   ObjectCreate("dollar3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("dollar3", micro+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("dollar3", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("dollar3", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("dollar3", OBJPROP_YDISTANCE, spreadPosY+13*6);
   
   ObjectCreate("dollar2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("dollar2", standared+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("dollar2", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("dollar2", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("dollar2", OBJPROP_YDISTANCE, spreadPosY+13*5);
   
   ObjectCreate("dollar1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("dollar1", mega+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("dollar1", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("dollar1", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("dollar1", OBJPROP_YDISTANCE, spreadPosY+13*4);
   
   ObjectCreate("note2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("note2", "MARGIN", 7, DollarFont, DollarColor);
   ObjectSet("note2", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("note2", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("note2", OBJPROP_YDISTANCE, spreadPosY+13*3);
   
   ObjectCreate("marginR3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("marginR3", DoubleToStr(margineRequired,2)+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("marginR3", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("marginR3", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("marginR3", OBJPROP_YDISTANCE, spreadPosY+13*2);
   
   ObjectCreate("marginR2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("marginR2", DoubleToStr(margineRequired/10,2)+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("marginR2", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("marginR2", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("marginR2", OBJPROP_YDISTANCE, spreadPosY+13);
   
   ObjectCreate("marginR1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("marginR1", DoubleToStr(margineRequired/100,2)+" $", DollarFontSize, DollarFont, spreadColor);
   ObjectSet("marginR1", OBJPROP_CORNER,    spreadCorner);
   ObjectSet("marginR1", OBJPROP_XDISTANCE, spreadPosX);
   ObjectSet("marginR1", OBJPROP_YDISTANCE, spreadPosY);
   
   

}

      
      double MA1, MA2, MA50, MA100, MA200; color mas_color;
      MA1 = iMA(NULL, 0, MA1_value, 0, MA1_type, PRICE_CLOSE, 0);
      MA2 = iMA(NULL, 0, MA2_value, 0, MA2_type, PRICE_CLOSE, 0);
      MA50 = iMA(NULL, 0, 50, 0, 0, PRICE_CLOSE, 0);
      MA100 = iMA(NULL, 0, 100, 0, 0, PRICE_CLOSE, 0);
      MA200 = iMA(NULL, 0, 200, 0, 0, PRICE_CLOSE, 0);
      
      ObjectCreate("Flow", OBJ_LABEL, 0, 0, 0);
      ObjectSet("Flow", OBJPROP_CORNER, MACorner);
      ObjectSet("Flow", OBJPROP_XDISTANCE, spreadPosX+24);
      ObjectSet("Flow", OBJPROP_YDISTANCE, MAYpos);
      
      ObjectCreate("50Cross100", OBJ_LABEL, 0, 0, 0);
      ObjectSet("50Cross100", OBJPROP_CORNER, MACorner);
      ObjectSet("50Cross100", OBJPROP_XDISTANCE, spreadPosX+12);
      ObjectSet("50Cross100", OBJPROP_YDISTANCE, MAYpos);
      
      ObjectCreate("Trend", OBJ_LABEL, 0, 0, 0);
      ObjectSet("Trend", OBJPROP_CORNER, MACorner);
      ObjectSet("Trend", OBJPROP_XDISTANCE, spreadPosX);
      ObjectSet("Trend", OBJPROP_YDISTANCE, MAYpos);
      
      if       (MA50 > MA200 && MA1 > MA200 && MA1 > MA50){
         ObjectSetText("Trend", "p", 8, "Wingdings 3", C'73,74,86');
      }else if (MA50 < MA200 && MA1 < MA200 && MA1 < MA50){
         ObjectSetText("Trend", "q", 8, "Wingdings 3", C'73,74,86');
      }else{
         if (MA50>MA200){
            ObjectSetText("Trend", "{", 8, "Wingdings 3", C'73,74,86');
         }else if(MA50<MA200){
            ObjectSetText("Trend", "y", 8, "Wingdings 3", C'73,74,86');
         }
      }

      if      (MA1>MA2){
         ObjectSetText("Flow", "p", 8, "Wingdings 3", C'21,115,166');
      }else if(MA1<MA2){
         ObjectSetText("Flow", "q", 8, "Wingdings 3", C'179,0,4');
      }
      
      if      (MA50>MA100){
         ObjectSetText("50Cross100", "p", 8, "Wingdings 3", C'0,111,94');
      }else if(MA50<MA100){
         ObjectSetText("50Cross100", "q", 8, "Wingdings 3", C'111,94,0');
      }

   return(0);
}