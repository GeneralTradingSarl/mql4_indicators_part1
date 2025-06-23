//+------------------------------------------------------------------+
//|Account+Balance+Magin-Indi  copyright Mar 2011 @ File45
//+------------------------------------------------------------------+
#property indicator_chart_window
// ++++++++++++++++++++++++++++++++ START OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Account: Balance - Equity - Margin - FreeMargin - Profit 
extern string ACCOUNT_OPTIONS;
extern string Acc_Currency_Symbol="$";
extern int    Acc_Corner=2;
extern string ______="";
extern bool   Acc_X_distance_Control_All_X=false;
extern int    Acc_X_distance_Set_All_X=1400;
extern string _______="";
extern int    Acc_X_distance_Balance= 420;
extern int    Acc_X_distance_Equity = 650;
extern int    Acc_X_distance_Margin = 850;
extern int    Acc_X_distance_Free_Margin=1050;
extern int    Acc_X_distance_Profit=1310;
extern string ________="";
extern string ACC_Y_DISTANCE_VIRTICAL;
extern bool   Acc_Y_distance_Control_All_Y=true;
extern int    Acc_Y_distance_Set_All_Y=1;
extern string _________="";
extern int    Acc_Y_distance_Balance= 86;
extern int    Acc_Y_distance_Equity = 69;
extern int    Acc_Y_distance_Margin = 52;
extern int    Acc_Y_distance_Free_Margin=35;
extern int    Acc_Y_distance_Profit=10;
extern string __________="";
extern color  Acc_Color_Balance= Yellow;
extern color  Acc_Color_Equity = DodgerBlue;
extern color  Acc_Color_Margin = DodgerBlue;
extern color  Acc_Color_Free_Margin=DodgerBlue;
extern color  Acc_Color_Profit=LimeGreen;
extern color  Acc_Color_Loss=Red;
extern color  Acc_Color_PnL_Closed=LightSlateGray;
extern string ___________="";
extern int    Acc_Font_Size=10;
extern string Acc_Font_Type="Arial";
extern string ____________ = "";
extern bool   Acc_HIDE_ALL=false;
extern bool   Acc_HIDE_Balance=false;
extern bool   Acc_HIDE_Equity=false;
extern bool   Acc_HIDE_Margin=false;
extern bool   Acc_HIDE_Free_Margin=false;
extern bool   Acc_HIDE_Profit=false;

// ++++++++++++++++++++++++++++++++ END OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Balance - Profit alternative color
color PnL_Color;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
// Balance - deletes 
   ObjectDelete("Acc_Balance_Label");
   ObjectDelete("Acc_Equity_Label");
   ObjectDelete("Acc_Margin_Label");
   ObjectDelete("Acc_Free_Margin_Label");
   ObjectDelete("Acc_Profit_Label");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
// Balance:  Account Balance, Equity, Margin, Free Margin and Profit.     
   if(Acc_HIDE_ALL==false)
     {
      if(Acc_HIDE_Balance==false)
        {
         //string Acc_Balance = DoubleToStr(AccountBalance(),2);
         string Acc_Balance=NumberToStr(AccountBalance(),",T12.2");
         ObjectCreate("Acc_Balance_Label",OBJ_LABEL,0,0,0);
         ObjectSetText("Acc_Balance_Label"," Balance : "+Acc_Currency_Symbol+" "+Acc_Balance,Acc_Font_Size,Acc_Font_Type,Acc_Color_Balance);
         ObjectSet("Acc_Balance_Label",OBJPROP_CORNER,Acc_Corner);
         if(Acc_X_distance_Control_All_X==true)
           {
            Acc_X_distance_Balance=Acc_X_distance_Set_All_X;
           }
         ObjectSet("Acc_Balance_Label",OBJPROP_XDISTANCE,Acc_X_distance_Balance);
         if(Acc_Y_distance_Control_All_Y==true)
           {
            Acc_Y_distance_Balance=Acc_Y_distance_Set_All_Y;
           }
         ObjectSet("Acc_Balance_Label",OBJPROP_YDISTANCE,Acc_Y_distance_Balance);
        }

      if(Acc_HIDE_Equity==false)
        {
         //string Acc_Equity = DoubleToStr(AccountEquity(), 2);
         string Acc_Equity=NumberToStr(AccountEquity(),",T12.2");
         ObjectCreate("Acc_Equity_Label",OBJ_LABEL,0,0,0);
         ObjectSetText("Acc_Equity_Label"," Equity : "+Acc_Currency_Symbol+" "+Acc_Equity,Acc_Font_Size,Acc_Font_Type,Acc_Color_Equity);
         ObjectSet("Acc_Equity_Label",OBJPROP_CORNER,Acc_Corner);
         if(Acc_X_distance_Control_All_X==true)
           {
            Acc_X_distance_Equity=Acc_X_distance_Set_All_X;
           }
         ObjectSet("Acc_Equity_Label",OBJPROP_XDISTANCE,Acc_X_distance_Equity);
         if(Acc_Y_distance_Control_All_Y==true)
           {
            Acc_Y_distance_Equity=Acc_Y_distance_Set_All_Y;
           }
         ObjectSet("Acc_Equity_Label",OBJPROP_YDISTANCE,Acc_Y_distance_Equity);
        }

      if(Acc_HIDE_Margin==false)
        {
         //string Acc_Margin = DoubleToStr(AccountMargin(),2);
         string Acc_Margin=NumberToStr(AccountMargin(),",T12.2");
         ObjectCreate("Acc_Margin_Label",OBJ_LABEL,0,0,0);
         ObjectSetText("Acc_Margin_Label"," Margin : "+Acc_Currency_Symbol+" "+Acc_Margin,Acc_Font_Size,Acc_Font_Type,Acc_Color_Margin);
         ObjectSet("Acc_Margin_Label",OBJPROP_CORNER,Acc_Corner);
         if(Acc_X_distance_Control_All_X==true)
           {
            Acc_X_distance_Margin=Acc_X_distance_Set_All_X;
           }
         ObjectSet("Acc_Margin_Label",OBJPROP_XDISTANCE,Acc_X_distance_Margin);
         if(Acc_Y_distance_Control_All_Y==true)
           {
            Acc_Y_distance_Margin=Acc_Y_distance_Set_All_Y;
           }
         ObjectSet("Acc_Margin_Label",OBJPROP_YDISTANCE,Acc_Y_distance_Margin);
        }

      if(Acc_HIDE_Free_Margin==false)
        {
         //string Acc_Free_Margin = DoubleToStr(AccountFreeMargin(),2);
         string Acc_Free_Margin=NumberToStr(AccountFreeMargin(),",T12.2");
         ObjectCreate("Acc_Free_Margin_Label",OBJ_LABEL,0,0,0);
         ObjectSetText("Acc_Free_Margin_Label"," FreeMargin : "+Acc_Currency_Symbol+" "+Acc_Free_Margin,Acc_Font_Size,Acc_Font_Type,Acc_Color_Free_Margin);
         ObjectSet("Acc_Free_Margin_Label",OBJPROP_CORNER,Acc_Corner);
         if(Acc_X_distance_Control_All_X==true)
           {
            Acc_X_distance_Free_Margin=Acc_X_distance_Set_All_X;
           }
         ObjectSet("Acc_Free_Margin_Label",OBJPROP_XDISTANCE,Acc_X_distance_Free_Margin);
         if(Acc_Y_distance_Control_All_Y==true)
           {
            Acc_Y_distance_Free_Margin=Acc_Y_distance_Set_All_Y;
           }
         ObjectSet("Acc_Free_Margin_Label",OBJPROP_YDISTANCE,Acc_Y_distance_Free_Margin);
        }

      if(Acc_HIDE_Profit==false)
        {
         //string Acc_Profit = DoubleToStr(AccountProfit(),2);
         string Acc_Profit=NumberToStr(AccountProfit(),",T12.2");
         ObjectCreate("Acc_Profit_Label",OBJ_LABEL,0,0,0);

         if(AccountProfit()>=0.01){PnL_Color=Acc_Color_Profit;}
         else if(AccountProfit()<=-0.01){PnL_Color=Acc_Color_Loss;}
         else {PnL_Color=Acc_Color_PnL_Closed;}

         ObjectSetText("Acc_Profit_Label"," Acc Profit : "+Acc_Currency_Symbol+" "+Acc_Profit,Acc_Font_Size,Acc_Font_Type,PnL_Color);
         ObjectSet("Acc_Profit_Label",OBJPROP_CORNER,Acc_Corner);
         if(Acc_X_distance_Control_All_X==true)
           {
            Acc_X_distance_Profit=Acc_X_distance_Set_All_X;
           }
         ObjectSet("Acc_Profit_Label",OBJPROP_XDISTANCE,Acc_X_distance_Profit);
         if(Acc_Y_distance_Control_All_Y==true)
           {
            Acc_Y_distance_Profit=Acc_Y_distance_Set_All_Y;
           }
         ObjectSet("Acc_Profit_Label",OBJPROP_YDISTANCE,Acc_Y_distance_Profit);
        }
     }

   return(0);

  }
//+------------------------------------------------------------------+
string NumberToStr(double n,string mask)
//+------------------------------------------------------------------+
// Formats a number using a mask, and returns the resulting string
// Usage:    string result = NumberToStr(number,mask)
// 
// Mask parameters:
// n = number of digits to output, to the left of the decimal point
// n.d = output n digits to left of decimal point; d digits to the right
// -n.d = floating minus sign at left of output
// n.d- = minus sign at right of output
// +n.d = floating plus/minus sign at left of output
// ( or ) = enclose negative number in parentheses
// $ or £ or ¥ or € = include floating currency symbol at left of output
// % = include trailing % sign
// , = use commas to separate thousands
// Z or z = left fill with zeros instead of spaces
// R or r = round result in rightmost displayed digit
// B or b = blank entire field if number is 0
// * = show asterisk in leftmost position if overflow occurs
// ; = switch use of comma and period (European format)
// L or l = left align final string 
// T ot t = trim end result
  {
  
  return(DoubleToStr(n,2));
  /*
   if(MathAbs(n)==2147483647)
      n=0;

   mask=StringUpper(mask);
   int dotadj = 0;
   int dot    = StringFind(mask,".",0);
   if(dot<0) 
     {
      dot    = StringLen(mask);
      dotadj = 1;
     }

   int nleft  = 0;
   int nright = 0;
   for(int i=0; i<dot; i++) 
     {
      string char1=StringSubstr(mask,i,1);
      if(char1>="0" && char1<="9") nleft=10*nleft+StrToInteger(char1);
     }
   if(dotadj==0) 
     {
      for(i=dot+1; i<=StringLen(mask); i++) 
        {
         char1=StringSubstr(mask,i,1);
         if(char1>="0" && char1<="9") nright=10*nright+StrToInteger(char1);
        }
     }
   nright=MathMin(nright,7);

   if(dotadj==1) 
     {
      for(i=0; i<StringLen(mask); i++) 
        {
         char1=StringSubstr(mask,i,1);
         if(char1>="0" && char1<="9") 
           {
            dot=i;
            break;
           }
        }
     }

   string csym="";
   if(StringFind(mask,"$",0) >= 0)   csym = "$";
   if(StringFind(mask,"£",0) >= 0)   csym = "£";
   if(StringFind(mask,"€",0) >= 0)   csym = "€";
   if(StringFind(mask,"¥",0) >= 0)   csym = "¥";

   string leadsign  = "";
   string trailsign = "";
   if(StringFind(mask,"+",0)>=0 && StringFind(mask,"+",0)<dot) 
     {
      leadsign=" ";
      if(n > 0)   leadsign  = "+";
      if(n < 0)   leadsign  = "-";
     }
   if(StringFind(mask,"-",0)>=0 && StringFind(mask,"-",0)<dot)
      if(n<0) leadsign="-"; else leadsign=" ";
   if(StringFind(mask,"-",0)>=0 && StringFind(mask,"-",0)>dot)
      if(n<0) trailsign="-"; else trailsign=" ";
   if(StringFind(mask,"(",0)>=0 || StringFind(mask,")",0)>=0) 
     {
      leadsign  = " ";
      trailsign = " ";
      if(n<0) 
        {
         leadsign  = "(";
         trailsign = ")";
        }
     }

   if(StringFind(mask,"%",0)>=0) trailsign="%";

   if(StringFind(mask,",",0) >= 0) bool comma = true; else comma = false;
   if(StringFind(mask,"Z",0) >= 0) bool zeros = true; else zeros = false;
   if(StringFind(mask,"B",0) >= 0) bool blank = true; else blank = false;
   if(StringFind(mask,"R",0) >= 0) bool round = true; else round = false;
   if(StringFind(mask,"*",0) >= 0) bool overf = true; else overf = false;
   if(StringFind(mask,"L",0) >= 0) bool lftsh = true; else lftsh = false;
   if(StringFind(mask,";",0) >= 0) bool swtch = true; else swtch = false;
   if(StringFind(mask,"T",0) >= 0) bool trimf = true; else trimf = false;

   if(round) n=MathFix(n,nright);
   string outstr=n;

   int dleft=0;
   for(i=0; i<StringLen(outstr); i++) 
     {
      char1=StringSubstr(outstr,i,1);
      if(char1>= "0" && char1 <= "9") dleft++;
      if(char1 == ".") break;
     }

// Insert fill char1acters.......
   if(zeros) string fill="0"; else fill=" ";
   if(n<0)
      outstr="-"+StringRepeat(fill,nleft-dleft)+StringSubstr(outstr,1,StringLen(outstr)-1);
   else
      outstr=StringRepeat(fill,nleft-dleft)+StringSubstr(outstr,0,StringLen(outstr));

   outstr=StringSubstr(outstr,StringLen(outstr)-9-nleft,nleft+1+nright-dotadj);

// Insert the commas.......  
   if(comma) 
     {
      bool digflg = false;
      bool stpflg = false;
      string out1 = "";
      string out2 = "";
      for(i=0; i<StringLen(outstr); i++) 
        {
         char1=StringSubstr(outstr,i,1);
         if(char1==".") stpflg=true;
         if(!stpflg && (nleft-i==3 || nleft-i==6 || nleft-i==9))
            if(digflg) out1=out1+","; else out1=out1+" ";
         out1=out1+char1;
         if(char1>="0" && char1<="9") digflg=true;
        }
      outstr=out1;
     }
// Add currency symbol and signs........  
   outstr=csym+leadsign+outstr+trailsign;

// 'Float' the currency symbol/sign.......
   out1 = "";
   out2 = "";
   bool fltflg=true;
   for(i=0; i<StringLen(outstr); i++) 
     {
      char1=StringSubstr(outstr,i,1);
      if(char1 >= "0" && char1 <= "9")   fltflg = false;
      if((char1 == " " && fltflg) || (blank && n == 0) )   out1 = out1 + " ";   else   out2 = out2 + char1;
     }
   outstr=out1+out2;

// Overflow........  
   if(overf && dleft>nleft) outstr="*"+StringSubstr(outstr,1,StringLen(outstr)-1);

// Left shift.......
   if(lftsh) 
     {
      int len= StringLen(outstr);
      outstr = StringLeftTrim(outstr);
      outstr = outstr + StringRepeat(" ",len-StringLen(outstr));
     }

// Switch period and comma.......
   if(swtch) 
     {
      out1 = "";
      for(i=0; i<StringLen(outstr); i++) 
        {
         char1=StringSubstr(outstr,i,1);
         if(char1 == ".")   out1 = out1 + ",";     else
         if(char1 == ",")   out1 = out1 + ".";     else
         out1=out1+char1;
        }
      outstr=out1;
     }

   if(trimf) outstr=StringTrim(outstr);
   return(outstr);
*/   
  }
/*  
//+------------------------------------------------------------------+
string StringRepeat(string str,int n)
//+------------------------------------------------------------------+
// Repeats the string STR N times
// Usage:    string x=StringRepeat("-",10)  returns x = "----------"
  {
   string outstr="";
   for(int i=0; i<n; i++) 
     {
      outstr = outstr + str;
     }
   return(outstr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StringUpper(string str)
//+------------------------------------------------------------------+
// Converts any lowercase char1acters in a string to uppercase
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "THE QUICK BROWN FOX"
  {
   string outstr = "";
   string lower  = "abcdefghijklmnopqrstuvwxyz";
   string upper  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   for(int i=0; i<StringLen(str); i++) 
     {
      int t1 = StringFind(lower,StringSubstr(str,i,1),0);
      if(t1 >=0)
         outstr=outstr+StringSubstr(upper,t1,1);
      else
         outstr=outstr+StringSubstr(str,i,1);
     }
   return(outstr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MathFix(double n,int d)
//+------------------------------------------------------------------+
// Returns N rounded to D decimals - works around a precision bug in MQL4
  {
   return(MathRound(n*MathPow(10,d)+0.000000000001*MathSign(n))/MathPow(10,d));
  }
//+------------------------------------------------------------------+
string StringLeftTrim(string str)
//+------------------------------------------------------------------+
// Removes all leading spaces from a string
// Usage:    string x=StringLeftTrim("  XX YY  ")  returns x = "XX  YY  "
  {
   bool   left=true;
   string outstr="";
   for(int i=0; i<StringLen(str); i++) 
     {
      if(StringSubstr(str,i,1)!=" " || !left) 
        {
         outstr=outstr+StringSubstr(str,i,1);
         left=false;
        }
     }
   return(outstr);
  }
//+------------------------------------------------------------------+
string StringTrim(string str)
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
  {
   string outstr="";
   for(int i=0; i<StringLen(str); i++) 
     {
      if(StringSubstr(str,i,1)!=" ")
         outstr=outstr+StringSubstr(str,i,1);
     }
   return(outstr);
  }
//+------------------------------------------------------------------+
int MathSign(double n)
//+------------------------------------------------------------------+
// Returns the sign of a number (i.e. -1, 0, +1)
// Usage:   int x=MathSign(-25)   returns x=-1
  {
   if(n > 0) return(1);
   else if(n < 0) return (-1);
   else return(0);
  }   
//+------------------------------------------------------------------+
*/