//+------------------------------------------------------------------+
//|                                                LocalTimeLine.mq4 |
//|                                                                  |
//|                                                      By KumaKuma |
//+------------------------------------------------------------------+
// V.1.0.0 2010.05.16
//    First release
//
// V.1.0.1 2010.05.17
//    Bug Fix
//        Fixed not to be drawn lines on weekend and holiday.
//
// V.1.0.2 2010.05.17
//    Bug Fix
//        Fixed not to be drawn wrong lines on MN-frame.
//
#property copyright ""
#property link      "http://gp7g73hp.seesaa.net/"
#property indicator_chart_window

//extern color LabelColor = DimGray;
//extern int LabelFontSize = 12;
extern int LineNumber = 10;
extern color LineColor = DimGray;

extern int TextAngle = 0;
extern double TextLocationByRatio = 0.05;
extern color TextColor = DimGray;
extern int TextFontSize = 8;

bool flg = false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if( LineNumber > 50 ){
      LineNumber = 50;
   }
   
   switch(Period())
     {
      case PERIOD_M1 :
         DrawLineByHour( 1, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M5 :
         DrawLineByHour( 6, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M15 :
         DrawLineByHour( 12, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M30 :
         DrawLineByHour( 24, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_H1 :
         DrawLineByHour( 24 * 7, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_H4 :
         DrawLineByHour( 24 * 14, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_D1 :
         DrawLineByMonth( 3, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_W1 :
         DrawLineByYear( 1, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_MN1 :
         DrawLineByYear( 3, TimeLocal(), TimeCurrent() );
         break;
     }

   flg = true;

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   int i;

//   ObjectDelete("LocalTimeLineLabel");

   for( i = 0; i < LineNumber; i++ )
      {
         ObjectDelete("LocalTimeLineText" + i);
      }

   for( i = 0; i < LineNumber; i++ )
      {
         ObjectDelete("LocalTimeLineLine" + i);
      }

   flg = false;
   
   return(0);

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   switch(Period())
     {
      case PERIOD_M1 :
         DrawLineByHour( 1, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M5 :
         DrawLineByHour( 6, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M15 :
         DrawLineByHour( 12, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_M30 :
         DrawLineByHour( 24, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_H1 :
         DrawLineByHour( 24 * 7, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_H4 :
         DrawLineByHour( 24 * 14, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_D1 :
         DrawLineByMonth( 3, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_W1 :
         DrawLineByYear( 1, TimeLocal(), TimeCurrent() );
         break;
      case PERIOD_MN1 :
         DrawLineByYear( 3, TimeLocal(), TimeCurrent() );
         break;
     }

   flg = true;

   return(0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DrawLineByHour                                                   |
//+------------------------------------------------------------------+
void DrawLineByHour(int n, int t_local, int t_current)
  {
   int temp_second;
   int HourDifference;
   int i;
   double TextPos;

   TextPos = WindowPriceMin() + (WindowPriceMax() - WindowPriceMin()) * TextLocationByRatio;

   HourDifference = NormalizeDouble( ( t_local - t_current ) / 60.0 / 60.0, 0 );
   
   temp_second = t_local;
   temp_second = ( temp_second / 60 / 60 / n ) * 60 * 60 * n;       //This is the second for the first line

/*   
   if( flg == false ){
      ObjectCreate("LocalTimeLineLabel", OBJ_LABEL, 0, 0, 0);
      ObjectSet("LocalTimeLineLabel",OBJPROP_XDISTANCE, PosX);
      ObjectSet("LocalTimeLineLabel",OBJPROP_YDISTANCE, PosY);
      ObjectSet("LocalTimeLineLabel", OBJPROP_BACK, false);
      ObjectSetText("LocalTimeLineLabel", " JST:" + TimeToStr( temp_second ), LabelFontSize, "Arial", LabelColor);
      ObjectSet("LocalTimeLineLabel", OBJPROP_CORNER, 1);
   }
*/
//   for( i = 0 ; i < LineNumber ; i++ ){
   i = 0;
   while( i < LineNumber ){
      if( iBarShift(NULL, 0, temp_second - 60 * 60 * HourDifference, true) != -1 ){
      
         if( flg == false ){
            //Creating text objects and setting properties.
            ObjectCreate("LocalTimeLineText" + i, OBJ_TEXT, 0, temp_second - 60 * 60 * HourDifference, TextPos);
            ObjectSetText("LocalTimeLineText" + i, TimeToStr( temp_second ) , TextFontSize, "Arial", TextColor);

            //Creating line objects and setting the properties
            ObjectCreate("LocalTimeLineLine" + i, OBJ_VLINE, 0, temp_second - 60 * 60 * HourDifference , 0, 0, 0);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_STYLE,STYLE_DOT);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_COLOR,LineColor);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_BACK, true);
            ObjectSetText("LocalTimeLineLine" + i, TimeToStr( temp_second ), 0, "Arial", 0);
         }else{
            //Moving text objects and setting properties.
            ObjectSet("LocalTimeLineText" + i, OBJPROP_PRICE1, TextPos);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_TIME1, temp_second - 60 * 60 * HourDifference);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_ANGLE, TextAngle);
            ObjectSetText("LocalTimeLineText" + i, TimeToStr( temp_second ), 0, 0, 0);

            //Moving line objects and setting the properties
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_TIME1, temp_second - 60 * 60 * HourDifference);
            ObjectSetText("LocalTimeLineLine" + i, TimeToStr( temp_second ), 0, 0, 0);
         }
                  
         i++;      

      }
      temp_second = temp_second - 60 * 60 * n;
   }
   return;
  }

//+------------------------------------------------------------------+
//| DrawLineByMonth                                                  |
//+------------------------------------------------------------------+
void DrawLineByMonth(int n, int t_local, int t_current){
   int temp_year;
   int temp_month;
   int HourDifference;
   int i;
   string t;
   double TextPos;

   TextPos = WindowPriceMin() + (WindowPriceMax() - WindowPriceMin()) * TextLocationByRatio;
   
   HourDifference = NormalizeDouble( ( t_local - t_current ) / 60.0 / 60.0, 0 );
   temp_year  = TimeYear(t_local);
   temp_month = TimeMonth(t_local) / n * n + 1;      //This is the second for the first line

/*
   if( flg == false ){
      ObjectCreate("LocalTimeLineLabel", OBJ_LABEL, 0, 0, 0);
      ObjectSet("LocalTimeLineLabel",OBJPROP_XDISTANCE, PosX);
      ObjectSet("LocalTimeLineLabel",OBJPROP_YDISTANCE, PosY);
      ObjectSet("LocalTimeLineLabel", OBJPROP_BACK, false);
      ObjectSetText("LocalTimeLineLabel", " JST:" + temp_year + "." + temp_month + ".1", LabelFontSize, "Arial", LabelColor);
      ObjectSet("LocalTimeLineLabel", OBJPROP_CORNER, 1);
   }
*/   
   i = 0;
//   for( i = 0 ; i < LineNumber ; i++ ){
   while( i < LineNumber ){
      t = temp_year + "." + PadLeft( temp_month, "0", 2 ) + ".01";

      if( iBarShift(NULL, 0, StrToTime(t) - 60 * 60 * HourDifference, true) != -1 ){
         if( flg == false ){
            //Creating text objects and setting properties.
            ObjectCreate("LocalTimeLineText" + i, OBJ_TEXT, 0, StrToTime(t) - 60 * 60 * HourDifference, TextPos);
            ObjectSetText("LocalTimeLineText" + i, t, TextFontSize, "Arial", TextColor);

            //Creating line objects and setting the properties
            ObjectCreate("LocalTimeLineLine" + i, OBJ_VLINE, 0, StrToTime(t) - 60 * 60 * HourDifference , 0, 0, 0);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_STYLE,STYLE_DOT);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_COLOR,LineColor);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_BACK, true);
            ObjectSetText("LocalTimeLineLine" + i, t, 0, "Arial", 0);
         }else{
            //Moving text objects and setting properties.
            ObjectSet("LocalTimeLineText" + i, OBJPROP_PRICE1, TextPos);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_TIME1, StrToTime(t) - 60 * 60 * HourDifference);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_ANGLE, TextAngle);
            ObjectSetText("LocalTimeLineText" + i, t, 0, 0, 0);

            //Moving line objects and setting the properties
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_TIME1, StrToTime(t) - 60 * 60 * HourDifference);
            ObjectSetText("LocalTimeLineLine" + i, t, 0, 0, 0);
         }
         i++;
      }
      
      temp_month = temp_month - n;
      if( temp_month <= 0 ){
         temp_year = temp_year - 1;
         temp_month = temp_month + 12;
      }

   }
   return;
}

//+------------------------------------------------------------------+
//| DrawLineByMonth                                                  |
//+------------------------------------------------------------------+
void DrawLineByYear(int n, int t_local, int t_current){
   int temp_year;
   int temp_month;
   int HourDifference;
   int i;
   string t;
   double TextPos;

   TextPos = WindowPriceMin() + (WindowPriceMax() - WindowPriceMin()) * TextLocationByRatio;
   
   HourDifference = NormalizeDouble( ( t_local - t_current ) / 60.0 / 60.0, 0 );
   temp_year  = TimeYear(t_local);     //This is the second for the first line

/*
   if( flg == false ){
      ObjectCreate("LocalTimeLineLabel", OBJ_LABEL, 0, 0, 0);
      ObjectSet("LocalTimeLineLabel",OBJPROP_XDISTANCE, PosX);
      ObjectSet("LocalTimeLineLabel",OBJPROP_YDISTANCE, PosY);
      ObjectSet("LocalTimeLineLabel", OBJPROP_BACK, false);
      ObjectSetText("LocalTimeLineLabel", " JST:" + temp_year + "." + temp_month + ".1", LabelFontSize, "Arial", LabelColor);
      ObjectSet("LocalTimeLineLabel", OBJPROP_CORNER, 1);
   }
*/   
   i = 0;
   //for( i = 0 ; i < LineNumber ; i++ ){
   while( i < LineNumber ){
      t = temp_year + ".01.01";
      
      if( StrToTime(t) - 60 * 60 * HourDifference < iTime(NULL, 0, WindowFirstVisibleBar())){ 
         Comment(WindowFirstVisibleBar());
         break;
      }

      if( iBarShift(NULL, 0, StrToTime(t) - 60 * 60 * HourDifference, true) != -1 ){
         if( flg == false ){
            //Creating text objects and setting properties.
            ObjectCreate("LocalTimeLineText" + i, OBJ_TEXT, 0, StrToTime(t) - 60 * 60 * HourDifference, TextPos);
            ObjectSetText("LocalTimeLineText" + i, t, TextFontSize, "Arial", TextColor);

            //Creating line objects and setting the properties
            ObjectCreate("LocalTimeLineLine" + i, OBJ_VLINE, 0, StrToTime(t) - 60 * 60 * HourDifference , 0, 0, 0);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_STYLE,STYLE_DOT);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_COLOR,LineColor);
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_BACK, true);
            ObjectSetText("LocalTimeLineLine" + i, t, 0, "Arial", 0);
         }else{
            //Moving text objects and setting properties.
            ObjectSet("LocalTimeLineText" + i, OBJPROP_PRICE1, TextPos);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_TIME1, StrToTime(t) - 60 * 60 * HourDifference);
            ObjectSet("LocalTimeLineText" + i, OBJPROP_ANGLE, TextAngle);
            ObjectSetText("LocalTimeLineText" + i, t, 0, 0, 0);

            //Moving line objects and setting the properties
            ObjectSet("LocalTimeLineLine" + i, OBJPROP_TIME1, StrToTime(t) - 60 * 60 * HourDifference);
            ObjectSetText("LocalTimeLineLine" + i, t, 0, 0, 0);
         }
         i++;
      }
      
      temp_year = temp_year - n;

   }
   return;
}

string PadLeft(string p1, string p2, int p3 ){

   string temp;
   int i;
   int len;
   
   temp = p1;
   len = StringLen( p1 );
   
   for( i = 0 ; i < p3 - len; i++ ){
       temp = StringConcatenate( p2, temp );
   }

   return(temp);
   
}