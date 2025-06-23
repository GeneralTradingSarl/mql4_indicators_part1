//+------------------------------------------------------------------+
//|                                                Elliott_Waves.mq4 |
//|                                Copyright © 2009, Хлыстов Владимр |
//|                                                сmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Хлыстов Владимр"
#property link      "сmillion@narod.ru"
 
#property indicator_chart_window
 
   datetime X1,X2;
   double   Y1,Y2,LINE[11][6];
   int СТИЛЬ,Т_ЛИНИИ,ВОЛНА,ЦВЕТ;
   double High_Win,Low_Win,shift_X,shift_Y;
   string Name[11]={ "-",
                     "1 ВОЛНА ","2 ВОЛНА ","3 ВОЛНА ","4 ВОЛНА ","5 ВОЛНА ",
                     "a ВОЛНА ","b ВОЛНА ","c ВОЛНА ","d ВОЛНА ","e ВОЛНА "};
   string текст,Obj_Name,ИНФО;
   int per;
   extern bool  показать_все_периоды = true;
   extern color Ц1=White;
   extern color Ц2=DeepSkyBlue;
   extern color Ц3=Yellow;
   extern color Ц4=Turquoise;
   extern color Ц5=Magenta;
   extern color Ц6=Yellow;
   extern color Ц7=MediumSpringGreen;
   extern color Ц8=Violet;
   extern color Ц9=DarkOrchid;
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
int init()
{
   ObjectCreate ("бар", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("бар", OBJPROP_XDISTANCE, 500);      
   ObjectSet    ("бар", OBJPROP_YDISTANCE, 0);
   ObjectSet    ("бар", OBJPROP_CORNER, 1); //угол_вывода_ордеров
   per =Period();
   Obj_Name = string_пер(per);
   for(int k=0; k<=10; k++) Name[k] = Name[k]+Obj_Name;
   Comment("ВОЛНЫ ЭЛЛИОТА "+Obj_Name+" "+время(CurTime()));
   return(0);
}
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int deinit()
  {
      ObjectDelete("бар");
      удалить_обьекты("Ц");
      удалить_обьекты("Name");
      удалить_обьекты("Инфо");
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
int start()
{
   High_Win = WindowPriceMax();
   Low_Win  = WindowPriceMin();
   shift_X = WindowBarsPerChart();
   ObjectSetText("бар","Бар на экране "+DoubleToStr(shift_X,0),8,"Arial",White);   
   shift_X = shift_X/80*per;
   shift_Y = (High_Win-Low_Win) / 50;
   for(int k=0; k<=ObjectsTotal(); k++) 
   {
      Obj_Name = ObjectName(k);                           // Запрашиваем имя объекта
      if (Obj_Name=="") continue;
      ВОЛНА = N_Волны(Obj_Name);
      if (ВОЛНА>0&&ВОЛНА<11)
      {
         if (Obj_Name != Name[ВОЛНА]) redraw_LINE(Obj_Name,Name[ВОЛНА]);
         X1 =    ObjectGet(Name[ВОЛНА], OBJPROP_TIME1); 
         Y1 =    ObjectGet(Name[ВОЛНА], OBJPROP_PRICE1);
         X2 =    ObjectGet(Name[ВОЛНА], OBJPROP_TIME2); 
         Y2 =    ObjectGet(Name[ВОЛНА], OBJPROP_PRICE2);
         ЦВЕТ  = ObjectGet(Name[ВОЛНА], OBJPROP_COLOR);
         СТИЛЬ = ObjectGet(Name[ВОЛНА], OBJPROP_STYLE);
         Т_ЛИНИИ=ObjectGet(Name[ВОЛНА], OBJPROP_WIDTH);
         if (X1 > X2) redraw_LINE(Name[ВОЛНА],Name[ВОЛНА]+" r ");
         if (Y1 < Y2) LINE[ВОЛНА][0]=1; else LINE[ВОЛНА][0]=-1;//направление волны
         ObjectDelete("Ц "+Name[ВОЛНА]);
         ObjectDelete("Цель "+Name[ВОЛНА]);
         LINE[ВОЛНА][1]=X1;//начало волны
         LINE[ВОЛНА][2]=Y1;
         LINE[ВОЛНА][3]=X2;//конец волны
         LINE[ВОЛНА][4]=Y2;
         LINE[ВОЛНА][5]=Обьем_Волны(Name[ВОЛНА]);
         if ((MathAbs(LINE[ВОЛНА][3]-LINE[ВОЛНА+1][1])<per*120) || (MathAbs(LINE[ВОЛНА][4]-LINE[ВОЛНА+1][2])/Point<=MarketInfo(Symbol(),MODE_STOPLEVEL)))
         {
            ObjectSet   (Name[ВОЛНА+1], OBJPROP_COLOR, ЦВЕТ); //стыковка - выделение цвета
            ObjectSet   (Name[ВОЛНА+1], OBJPROP_STYLE, СТИЛЬ);// Стиль   
            ObjectSet   (Name[ВОЛНА+1], OBJPROP_WIDTH, Т_ЛИНИИ);
            ObjectSet   (Name[ВОЛНА+1], OBJPROP_PRICE1 ,LINE[ВОЛНА][4]);//Привязка следующей волны к текущей PRICE1
            ObjectSet   (Name[ВОЛНА+1], OBJPROP_TIME1  ,LINE[ВОЛНА][3]);//Привязка следующей волны к текущей TIME1
         }
         ИНФО = "Инфо "+Name[ВОЛНА]+" рычаг "+DoubleToStr(MathAbs(LINE[ВОЛНА][2]-LINE[ВОЛНА][4])/Point,0);
         if (ВОЛНА==3&&(LINE[3][5]<LINE[2][5]||LINE[3][5]<LINE[1][5]||LINE[3][5]<LINE[4][5]||LINE[3][5]<LINE[5][5])) текст = "Обьем не может быть меньше в 3 волне "+DoubleToStr(LINE[ВОЛНА][5],0);
         else текст = "V = "+DoubleToStr(LINE[ВОЛНА][5],0);
         удалить_обьекты("Инфо");
         ObjectCreate (ИНФО, OBJ_TEXT  ,0,LINE[ВОЛНА][3], LINE[ВОЛНА][4]+shift_Y*Т_ЛИНИИ*3*LINE[ВОЛНА][0],0,0,0,0);
         ObjectSetText(ИНФО,текст ,8,"Arial");
         ObjectSet    (ИНФО, OBJPROP_COLOR, ЦВЕТ);
         
         ObjectDelete ("Name "+Name[ВОЛНА]);
         ObjectCreate ("Name "+Name[ВОЛНА], OBJ_TEXT  ,0,LINE[ВОЛНА][3], LINE[ВОЛНА][4]+shift_Y*Т_ЛИНИИ*2*LINE[ВОЛНА][0]+0.7*shift_Y,0,0,0,0);
         if (ФРАКТАЛ(LINE[ВОЛНА][3],Name[ВОЛНА])==true)
         {
            ObjectSetText("Name "+Name[ВОЛНА], StringSubstr(Name[ВОЛНА],0,1),10*Т_ЛИНИИ,"Arial");
            ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, ЦВЕТ);
         }
         else
         {
            ObjectSetText("Name "+Name[ВОЛНА], "нет фрактала" ,10,"Arial");
            ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
         }
         if (LINE[ВОЛНА][3]!=LINE[ВОЛНА+1][1]) // если нет следующей волны
         {
               if (LINE[ВОЛНА][1]!=LINE[ВОЛНА-1][3]) // если нет предыдущей волны
               {
                  X1=LINE[ВОЛНА][3]+(LINE[ВОЛНА][3]-LINE[ВОЛНА][1])*0.38;
                  X2=LINE[ВОЛНА][3]+(LINE[ВОЛНА][3]-LINE[ВОЛНА][1])*0.62;
                  Y1=LINE[ВОЛНА][4]+(LINE[ВОЛНА][2]-LINE[ВОЛНА][4])*0.38; 
                  Y2=LINE[ВОЛНА][4]+(LINE[ВОЛНА][2]-LINE[ВОЛНА][4])*0.62;
 
                  if (ВОЛНА==6) //текущая Волна a
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
 
               }
               else//есть пред волна
               {
                  switch(ВОЛНА)
                  {
                     case 2 ://текущая Волна 2
                        X2=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.38;
                        X1=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.62;
                        Y1=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.00; 
                        Y2=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.62;
                        break;
                     case 3 ://текущая Волна 3
                        X1=LINE[2][1]+(LINE[3][3]-LINE[1][3])*1.38;
                        X2=LINE[3][1]+(LINE[3][3]-LINE[1][3])*1.62;
                        Y1=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.38; 
                        Y2=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.50;
                        if ((Y2<LINE[1][4] && LINE[3][0]==1)||(Y2>LINE[1][4] && LINE[3][0]==-1))
                        {
                           ObjectSetText("Name "+Name[ВОЛНА],"4 ВОЛНА не может лежать ниже 1 ВОЛНЫ",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        if (LINE[1][3]!=LINE[2][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ 1",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 4 ://текущая Волна 4
                        X1=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.38;
                        X2=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.62;
                        Y1=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*0.62; 
                        Y2=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*1.00;
                        текст="--4 ВОЛНА <> 1 ВОЛНЫ--";
                        ObjectDelete(текст);
                        if ((LINE[4][4]<LINE[1][4] && LINE[4][0]==-1)||(LINE[4][4]>LINE[1][4] && LINE[4][0]==1))
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"4 ВОЛНА не может лежать ниже 1 ВОЛНЫ",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectCreate(текст, OBJ_TREND, 0,LINE[1][3],LINE[1][4],LINE[4][3],LINE[1][4]);
                           ObjectSet   (текст, OBJPROP_COLOR, Red);    // Цвет   
                           ObjectSet   (текст, OBJPROP_STYLE, STYLE_DASH);// Стиль   
                           ObjectSet   (текст, OBJPROP_WIDTH, 0);
                           ObjectSet   (текст, OBJPROP_BACK,  true);
                           ObjectSet   (текст, OBJPROP_RAY,   false);     // Луч   
                        }
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ 1 или 2",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 5 ://текущая Волна 5
                        X1=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.38;
                        X2=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.62;
                        Y1=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.38; 
                        Y2=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.62;
                        double MFI_3=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[3][3],FALSE));
                        double MFI_5=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[5][3],FALSE));
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1] || LINE[3][3]!=LINE[4][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ 1,2 или 3",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        if ((MFI_3 < MFI_5 && LINE[5][0]==1)||(MFI_3 > MFI_5 && LINE[5][0]==-1))
                        {
                           ObjectDelete ("MFI "+время(LINE[3][3]));
                           ObjectCreate ("MFI "+время(LINE[3][3]),OBJ_TEXT,0,LINE[3][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+время(LINE[3][3]),DoubleToStr(MFI_3,0),8,"Arial");
                           ObjectSet    ("MFI "+время(LINE[3][3]),OBJPROP_COLOR, ЦВЕТ);
                           ObjectDelete ("MFI "+время(LINE[5][3]));
                           ObjectCreate ("MFI "+время(LINE[5][3]),OBJ_TEXT,0,LINE[5][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+время(LINE[5][3]),DoubleToStr(MFI_5,0),8,"Arial");
                           ObjectSet    ("MFI "+время(LINE[5][3]),OBJPROP_COLOR, ЦВЕТ);
                           ObjectSetText("Name "+Name[ВОЛНА],"Нет дивергенции MFI 3 и 5 ВОЛНЫ",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 6 ://текущая Волна a
                        X1=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.38;
                        X2=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.62;
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
                        Y2=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.62;
                        break;
                     case 7 ://текущая Волна b
                        X2=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.38;
                        X1=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.62;
                        Y1=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.00; 
                        Y2=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.62;
                        break;
                     case 8 ://текущая Волна c
                        X1=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.38;
                        X2=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.62;
                        Y1=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.38; 
                        Y2=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.50;
                        if (LINE[6][3]!=LINE[7][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ a",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 9 ://текущая Волна d
                        X1=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.38;
                        X2=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.62;
                        Y1=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*0.62; 
                        Y2=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*1.00;
                         if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ a или b ",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 10 ://текущая Волна e
                        X1=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.38;
                        X2=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.62;
                        Y1=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.38; 
                        Y2=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.62;
                        if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1] || LINE[8][3]!=LINE[9][1])
                        {
                           ObjectSet(Name[ВОЛНА], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[ВОЛНА],"нет ВОЛНЫ a,b или c",8,"Arial");
                           ObjectSet    ("Name "+Name[ВОЛНА], OBJPROP_COLOR, Red);
                        }
                        break;
                  }//switch
            }
            ObjectCreate("Ц "+Name[ВОЛНА], OBJ_TREND, 0,LINE[ВОЛНА][3],LINE[ВОЛНА][4],X1,Y1);
            ObjectSet   ("Ц "+Name[ВОЛНА], OBJPROP_COLOR, ЦВЕТ);    // Цвет   
            ObjectSet   ("Ц "+Name[ВОЛНА], OBJPROP_STYLE, STYLE_DASH);// Стиль   
            ObjectSet   ("Ц "+Name[ВОЛНА], OBJPROP_WIDTH, 0);
            ObjectSet   ("Ц "+Name[ВОЛНА], OBJPROP_BACK,  true);
            ObjectSet   ("Ц "+Name[ВОЛНА], OBJPROP_RAY,   false);     // Луч   
               
            ObjectCreate("Цель "+Name[ВОЛНА], OBJ_RECTANGLE,0,0,0,0,0);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_STYLE, STYLE_DASH);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_COLOR, ЦВЕТ);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_BACK,  false);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_TIME1 ,X1);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_PRICE1,Y1);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_TIME2 ,X2);
            ObjectSet   ("Цель "+Name[ВОЛНА], OBJPROP_PRICE2,Y2);
         }
      }//-Волны 1 - е --------------------------------------------------------------------------------------------------------+
   }//for
  
   ЦВЕТ = color_per(per);
   for(k=1; k<=10; k++) 
   {
      ObjectDelete ("Name "+k);
      if (ObjectFind(Name[k])==0)
      {
         ObjectCreate ("Name "+k, OBJ_LABEL, 0, 0, 0);// Создание объ.
         ObjectSetText("Name "+k, Name[k]+время(LINE[k][1])+" "+DoubleToStr(LINE[k][2],Digits)+" "+время(LINE[k][3])+" "+DoubleToStr(LINE[k][4],Digits)     ,8,"Arial");
         ObjectSet    ("Name "+k, OBJPROP_CORNER, 3);
         ObjectSet    ("Name "+k, OBJPROP_XDISTANCE, 300);
         ObjectSet    ("Name "+k, OBJPROP_YDISTANCE, 10+10*k);
         ObjectSet    ("Name "+k, OBJPROP_COLOR, ЦВЕТ);    // Цвет 
      }
      else //очистка значений удаленной волны
      {
         LINE[k][0]=0;LINE[k][1]=0;LINE[k][2]=0;LINE[k][3]=0;LINE[k][4]=0;LINE[k][5]=0;
         //удалить_обьекты("Name");
         //удалить_обьекты("MFI");
         ObjectDelete("Ц "+Name[k]);
         ObjectDelete("ФРАКТАЛ "+Name[k]);
         ObjectDelete("color_MFI "+Name[k]+"1");
         ObjectDelete("color_MFI "+Name[k]+"2");
         ObjectDelete("color_MFI "+Name[k]+"3");
         ObjectDelete("color_MFI "+Name[k]+"4");
         ObjectDelete("color_MFI "+Name[k]+"5");
         удалить_обьекты("Инфо "+Name[k]);
         ObjectDelete("Цель "+Name[k]);
         ObjectDelete("Name "+Name[k]);
      } //очистка значений удаленной волны
   }
return;
}
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
//////////////////////////////////////////////////////////////////////
void redraw_LINE(string old, string ИМЯ)
{
   datetime x1,x2;
   double   y1,y2;
   СТИЛЬ = ObjectGet(old, OBJPROP_STYLE);
   ЦВЕТ = ObjectGet(old, OBJPROP_COLOR);
   Т_ЛИНИИ = ObjectGet(old, OBJPROP_WIDTH);    // Т ЛИНИИ
   x1 =     ObjectGet(old, OBJPROP_TIME1);
   y1 =     ObjectGet(old, OBJPROP_PRICE1);
   x2 =     ObjectGet(old, OBJPROP_TIME2);
   y2 =     ObjectGet(old, OBJPROP_PRICE2);
   if (x1>x2)
   {
      x2 =     ObjectGet(old, OBJPROP_TIME1);
      y2 =     ObjectGet(old, OBJPROP_PRICE1);
      x1 =     ObjectGet(old, OBJPROP_TIME2);
      y1 =     ObjectGet(old, OBJPROP_PRICE2);
   }
   ObjectDelete(ИМЯ); //удаляет двойника
   ObjectCreate(ИМЯ, OBJ_TREND, 0,  x1,y1,x2,y2);
   ObjectSet   (ИМЯ, OBJPROP_COLOR, ЦВЕТ);    // Цвет   
   ObjectSet   (ИМЯ, OBJPROP_STYLE, СТИЛЬ);    // Стиль   
   ObjectSet   (ИМЯ, OBJPROP_WIDTH, Т_ЛИНИИ);    // Т ЛИНИИ
   ObjectSet   (ИМЯ, OBJPROP_BACK,  true);
   ObjectSet   (ИМЯ, OBJPROP_RAY,   false);    // Луч   
   ObjectDelete(old);
 
return;
}
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
//////////////////////////////////////////////////////////////////////
//-- ФРАКТАЛ -------------------------------------------------------------------------
bool ФРАКТАЛ(datetime t,string ИМЯ)
{
   int i=0,KOD;
   int ТЕК_БАР=iBarShift(NULL,0,t,FALSE);
   double fr_DN = iFractals(NULL,0,MODE_LOWER,ТЕК_БАР);
   double fr_UP = iFractals(NULL,0,MODE_UPPER,ТЕК_БАР);
   if (fr_UP==0 &&fr_DN ==0) return(false);
   ObjectDelete("ФРАКТАЛ "+ИМЯ);
   double y,Y,fr;
   if (ObjectFind(ИМЯ)==0)
   {
      if (fr_DN!=0) fr=fr_DN; else fr=fr_UP;
      if (t==ObjectGet(ИМЯ, OBJPROP_TIME2)) ObjectSet(ИМЯ, OBJPROP_PRICE2,fr);//Привязка волны к ФРАКТАЛУ
      if (t==ObjectGet(ИМЯ, OBJPROP_TIME1)) ObjectSet(ИМЯ, OBJPROP_PRICE1,fr);//Привязка волны к ФРАКТАЛУ
      ЦВЕТ  = ObjectGet(ИМЯ, OBJPROP_COLOR);
      Т_ЛИНИИ = ObjectGet(ИМЯ, OBJPROP_WIDTH);    // Т ЛИНИИ
   }
   else
   {
      ЦВЕТ  = Yellow;
      Т_ЛИНИИ = 1;    // Т ЛИНИИ
   }
   if (fr_DN != 0) {Y = fr_DN-shift_Y * Т_ЛИНИИ + 0.5 * shift_Y; y = Y + 0.7 * shift_Y; KOD=218;} 
   if (fr_UP != 0) {Y = fr_UP+shift_Y * Т_ЛИНИИ + 0.5 * shift_Y; y = Y - 1.2 * shift_Y; KOD=217;}
   ObjectCreate("ФРАКТАЛ "+ИМЯ, OBJ_ARROW,0,t,Y,0,0,0,0);
   ObjectSet   ("ФРАКТАЛ "+ИМЯ, OBJPROP_ARROWCODE,KOD);
   ObjectSet   ("ФРАКТАЛ "+ИМЯ, OBJPROP_COLOR,ЦВЕТ );
   for(int k=ТЕК_БАР-2; k<=ТЕК_БАР+2; k++) 
   {
      i++;
      ObjectDelete("color_MFI "+ИМЯ+i);
      ObjectCreate("color_MFI "+ИМЯ+i, OBJ_ARROW,0,Time[k],y,0,0,0,0);
      ObjectSet   ("color_MFI "+ИМЯ+i, OBJPROP_ARROWCODE,117);
      ObjectSet   ("color_MFI "+ИМЯ+i, OBJPROP_WIDTH, 0);    // Т ЛИНИИ
      ObjectSet   ("color_MFI "+ИМЯ+i, OBJPROP_BACK, true);
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ИМЯ+i, OBJPROP_COLOR,Lime); //Зеленый
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ИМЯ+i, OBJPROP_COLOR,Brown); //Увядающий
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ИМЯ+i, OBJPROP_COLOR,Blue); //Фальшивый
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+ИМЯ+i, OBJPROP_COLOR,Pink); //Приседающий
      ObjectSet("ФРАКТАЛ "+ИМЯ, OBJPROP_WIDTH,Т_ЛИНИИ);    // Т ЛИНИИ
   }
return(true);
}
   //-- ФРАКТАЛ -------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
///////////////////////////////////////////////////////////////////
string время(int taim)
{
   string sTaim;
   //int YY=TimeYear(taim);   // Year         
   int MN=TimeMonth(taim);  // Month                  
   int DD=TimeDay(taim);    // Day         
   int HH=TimeHour(taim);   // Hour                  
   int MM=TimeMinute(taim); // Minute   
 
   if (DD<10) sTaim = "0"+DoubleToStr(DD,0);
   else sTaim = DoubleToStr(DD,0);
   sTaim = sTaim+"/";
   if (MN<10) sTaim = sTaim+"0"+DoubleToStr(MN,0);
   else sTaim = sTaim+DoubleToStr(MN,0);
   sTaim = sTaim+" ";
   if (HH<10) sTaim = sTaim+"0"+DoubleToStr(HH,0);
   else sTaim = sTaim+DoubleToStr(HH,0);
   if (MM<10) sTaim = sTaim+":0"+DoubleToStr(MM,0);
   else sTaim = sTaim+":"+DoubleToStr(MM,0);
   return(sTaim);
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
int N_Волны(string Obj_Name)
{
   if (ObjectType(Obj_Name)!=2) return(-1);//тип обьекта не линия
   int V=-1;
   string volna = StringSubstr( Obj_Name, 0, 2);
   if (volna=="1 ") V=1; 
   if (volna=="2 ") V=2; 
   if (volna=="3 ") V=3; 
   if (volna=="4 ") V=4; 
   if (volna=="5 ") V=5; 
   if (volna=="a ") V=6; 
   if (volna=="b ") V=7; 
   if (volna=="c ") V=8; 
   if (volna=="d ") V=9; 
   if (volna=="e ") V=10;
   if (V<0) return(-1);
   if (StringFind(Obj_Name,"ВОЛНА",2) != 2) return(V);
   //Остались только ВОЛНы обозначенные "ВОЛНА"
   if (StringFind(Obj_Name,string_пер(per),8) == 8) //волна создана в этом временном периоде
   {
      ЦВЕТ = color_per(per);
      ObjectSet(Obj_Name,OBJPROP_COLOR,ЦВЕТ);
      return(V);
   }
return(-1);
}
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
color color_per(int per)
{
      switch(per)
      {
         case 1    :  //1 минута
            return(Ц1);
         case 5    :  //5 минут 
            return(Ц2);
         case 15   :  //15 минут
            return(Ц3);
         case 30   :  //30 минут
            return(Ц4);
         case 60   :  //1 час
            return(Ц5);
         case 240  :  //4 часа
            return(Ц6);
         case 1440 :  //1 день
            return(Ц7);
         case 10080:  //1 неделя
            return(Ц8);
         case 43200:  //1 месяц
            return(Ц9);
      }
return(Gray);
}
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
double Обьем_Волны(string Name)
{
   double vol=0;
   int Нач_БАР,Кон_БАР;
   int i=0;
   Нач_БАР=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME1),FALSE);
   Кон_БАР=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME2),FALSE);
   for(int n=Кон_БАР; n<=Нач_БАР; n++) 
   {
      vol = vol + iVolume(NULL,0,n);
      i++;
   }
   vol = vol/i;
//   vol = iVolume(NULL,0,Нач_БАР);
return(vol);
}
//////////////////////////////////////////////////////////////////////
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж*/
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
string string_пер(int per)
{
   switch(per)
   {
      case 1    : return("M_1");   //1 минута
         break;
      case 5    : return("M_5");   //5 минут 
         break;
      case 15   : return("M15");  //15 минут
         break;
      case 30   : return("M30");  //30 минут
         break;
      case 60   : return("H 1");   //1 час
         break;
      case 240  : return("H_4");   //4 часа
         break;
      case 1440 : return("D_1");   //1 день
         break;
      case 10080: return("W_1");   //1 неделя
         break;
      case 43200: return("MN1");  //1 месяц
         break;
   }
return("ошибка периода");
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
 
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int удалить_обьекты(string PreName)                                     //удаляет обьекты начинающиеся на PreName
  {
   for(int k=ObjectsTotal()-1; k>=0; k--) 
     {
      string Obj_Name=ObjectName(k);                           // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(PreName)); // Извлекаем первые симолы
 
      if (Head==PreName)// Найден объект, ..
         {
         ObjectDelete(Obj_Name);
         }                  
     }
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж