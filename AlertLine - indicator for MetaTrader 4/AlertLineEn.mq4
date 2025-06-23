//+------------------------------------------------------------------+
//|                                                    AlertLine.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "http://cmillion.narod.ru"
#property indicator_chart_window
//+------------------------------------------------------------------+
int start()
{
   double Support,Rezistans;
   string txt;
   if (ObjectFind("Support")==-1) txt="No line <Support>\n";
   else 
   {
      Support = ObjectGetValueByShift("Support", 0);
      if (Bid<Support) 
      {
         Alert("Price below the support line ");
         txt=StringConcatenate(txt,"Price below the support line \n");
      }
      else txt=StringConcatenate(txt,"Distance to the line of support ",DoubleToStr((Bid-Support)/Point,0),"\n");
   }
   if (ObjectFind("Rezistans")==-1) txt=StringConcatenate(txt,"No line <Rezistans>\n");
   else 
   {
      Rezistans = ObjectGetValueByShift("Rezistans", 0);
      if (Ask>Rezistans) 
      {
         Alert("Price above the resistance line");
         txt=StringConcatenate(txt,"Price above the resistance line");
      }
      else txt=StringConcatenate(txt,"Distance to the line of support ",DoubleToStr((Rezistans-Ask)/Point,0));
   }
   Comment(txt);
   return(0);
}
//+------------------------------------------------------------------+

