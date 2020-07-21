//+------------------------------------------------------------------+
//|                                      Alert SMA-EMA CrossOver.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Aqua
#property indicator_color3 DodgerBlue
#property indicator_color4 Magenta

//---- Variables Externes
extern int SMAPeriod = 13;
extern int EMAPeriod = 6;
extern int TimeFrame = 240;
extern bool Email    = True;

//---- Indicateurs
double SMACurrent, SMAPrevious, EMACurrent, EMAPrevious;
int    nShift, digit, digits;
int    i,j,limit,counted_bars;

//---- Buffers
double ExtMapBuffer1[];    //SMA
double ExtMapBuffer2[];    //EMA
double ExtMapBuffer3[];    //Fleche Haut
double ExtMapBuffer4[];    //Fleche Bas
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
   {
//---- indicators
//---- Styles et couleur des Lignes
      SetIndexStyle(0,DRAW_LINE);
      SetIndexBuffer(0,ExtMapBuffer1);
      SetIndexStyle(1,DRAW_LINE);
      SetIndexBuffer(1,ExtMapBuffer2);
//---- Styles et couleur des Fleches      
      SetIndexStyle(2, DRAW_ARROW, 0, 1);    // Fleche vers le haut
      SetIndexArrow(2, 233);
      SetIndexBuffer(2, ExtMapBuffer3);
      SetIndexStyle(3, DRAW_ARROW, 0, 1);    // Fleche vers le bas
      SetIndexArrow(3, 234);
      SetIndexBuffer(3, ExtMapBuffer4);
//----       
      switch(Period())
         {
            case     1: nShift = 1;   break;
            case     5: nShift = 3;   break;
            case    15: nShift = 5;   break;
            case    30: nShift = 10;  break;
            case    60: nShift = 15;  break;
            case   240: nShift = 20;  break;
            case  1440: nShift = 80;  break;
            case 10080: nShift = 100; break;
            case 43200: nShift = 200; break;
         }
//----
      digits = MarketInfo(Symbol(),MODE_DIGITS);
//----
      return(0);
   }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
   {
//----
   
//----
      return(0);
   }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
   {
      counted_bars=IndicatorCounted();
//----
      if(counted_bars<0) 
         return(-1);
      if(counted_bars>0) 
         counted_bars--;
      limit=Bars-counted_bars;
   
      for(i=0; i<limit; i++)
         {
            SMACurrent=iMA(NULL,TimeFrame,SMAPeriod,0,MODE_SMA,PRICE_CLOSE,i);
            SMAPrevious=iMA(NULL,TimeFrame,SMAPeriod,0,MODE_SMA,PRICE_CLOSE,i+1);
            ExtMapBuffer1[i]=SMACurrent;
            EMACurrent=iMA(NULL,TimeFrame,EMAPeriod,0,MODE_EMA,PRICE_CLOSE,i);
            EMAPrevious=iMA(NULL,TimeFrame,EMAPeriod,0,MODE_EMA,PRICE_CLOSE,i+1);
            ExtMapBuffer2[i]=EMACurrent;
//---- Dessin des fleches, future entré en trade
//---- Buy
            if((EMACurrent > SMACurrent+ digit*Point) && ( EMAPrevious <= SMACurrent))  // Croisement WMA8  up bord supérieur du tunnel
               {
                  ExtMapBuffer3[i] = Low[i] - nShift*Point;
                  Alert("SMA-EMA CrossOver Going for a BUY Trend Sesion ",SMACurrent," Price ",Close[1]," for ", Symbol(),"-",Period());
                  PlaySound("alert.wav");
                  if (Email)
                     {
                        SendMail("SMA-EMA CrossOver", "SMA-EMA CrossOver Going for a BUY Trend Sesion "+DoubleToStr(SMACurrent, digits)+" Price "+DoubleToStr(Close[1], digits)+" for "+Symbol()+"-"+Period());
                     }
               }
//---- Sell
            if((SMACurrent > EMACurrent+ digit*Point) && ( EMAPrevious >= SMACurrent))  // Croisement WMA8  down bord inférieur du tunnel
               {
                  ExtMapBuffer4[i] = High[i] + nShift*Point;
                  Alert("SMA-EMA CrossOver Going for a SELL Trend Sesion ",SMACurrent," Price ",Close[1]," for ", Symbol(),"-",Period());
                  PlaySound("alert.wav");
                  if (Email)
                     {
                        SendMail("SMA-EMA CrossOver", "SMA-EMA CrossOver Going for a SELL Trend Sesion "+DoubleToStr(SMACurrent, digits)+" Price "+DoubleToStr(Close[1], digits)+" for "+Symbol()+"-"+Period());
                     }
               }
         }
//----
      return(0);
   }
//+------------------------------------------------------------------+