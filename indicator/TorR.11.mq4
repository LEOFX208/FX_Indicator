//+------------------------------------------------------------------+
//|                                             Trending or Ranging? |
//|                                                     ToR_1.11.mq4 |
//|                                       Copyright © 2008 Tom Balfe |
//|                                                                  |
//| This indicator shows you whether a pair is trending or ranging.  | 
//| For trending markets use moving averages and for ranging         |
//| market use oscillators.                                          |
//|                                                                  |
//| Best of luck in all your trades...                               |
//|                                                                  |
//| Special thanks to whereswaldo!                                   |
//|                                                                  |
//|                                                                  |
//| Version: 1.11                                                    |
//|                                                                  |
//| Changelog:                                                       |
//|     1.11 - adjusted fonts, spacing, added ranging                |
//|     1.10 - added ADX increasing and decreasing notice            |
//|     1.03 - adjusted spacing, fonts, unreleased                   |
//|     1.02 - added arrows, ranging icon, no zero space state       |
//|            for icons/arrows, spacing got messed up, now          | 
//|            fixed                                                 |
//|     1.01 - unreleased, Reduced number of colors, functional      |
//|     1.0  - unreleased, too many colors for ADX values            |
//|                                                                  |
//|                   http://www.forex-tsd.com/members/nittany1.html |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007-2008 Tom Balfe"
#property link      "http://www.forex-tsd.com/members/nittany1.html"
#property link      "redcarsarasota@yahoo.com"
#property indicator_separate_window

int spread;
//---- user selectable stuff
extern int  SpreadThreshold   = 6;
extern bool Show_h1_ADX       = true;
extern bool Show_h4_ADX       = true;
extern int  ADX_trend_level   = 23;
extern int  ADX_trend_strong  = 28;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //---- indicator short name
   IndicatorShortName("ToR 1.11 ");

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   //---- need to delete objects should user remove indicator
   ObjectsDeleteAll(0,OBJ_LABEL);
     ObjectDelete("ToR111-1");ObjectDelete("ToR111-2");ObjectDelete("ToR111-3");
     ObjectDelete("ToR111-3a");
     ObjectDelete("ToR111-4");ObjectDelete("ToR111-4a");ObjectDelete("ToR111-4b");
     ObjectDelete("ToR111-4c"); ObjectDelete("ToR111-4d");
     ObjectDelete("ToR111-5");ObjectDelete("ToR111-6");ObjectDelete("ToR111-6a");
     ObjectDelete("ToR111-6b");ObjectDelete("ToR111-6c");ObjectDelete("ToR111-6d");
     ObjectDelete("ToR111-7");ObjectDelete("ToR111-8");ObjectDelete("ToR111-8a");
     ObjectDelete("ToR111-8b");ObjectDelete("ToR111-8c");ObjectDelete("ToR111-8d");
     ObjectDelete("ToR111-9");
     ObjectDelete("ToR111-10");ObjectDelete("ToR111-10a");ObjectDelete("ToR111-10b");
     ObjectDelete("ToR111-10c");ObjectDelete("ToR111-10d");
     ObjectDelete("ToR111-11");ObjectDelete("ToR111-12");ObjectDelete("ToR111-12a");
     ObjectDelete("ToR111-12b");ObjectDelete("ToR111-12c");   
     ObjectDelete("ToR111-13");ObjectDelete("ToR111-14");ObjectDelete("ToR111-15");
     ObjectDelete("ToR111-16");ObjectDelete("ToR111-17");ObjectDelete("ToR111-18");
          
   return(0);
  }

int start()
  {
   //---- let's define some stuff 
   // M1 ADX data
   double adx_m1 = iADX(NULL,1,14,PRICE_CLOSE,0,0); // ADX 1 min
   double adx_1ago_m1 = iADX(NULL,1,14,PRICE_CLOSE,0,1); // ADX 1 min 1 bar ago
   double di_p_m1 = iADX(NULL,1,14,PRICE_CLOSE,1,0); // DI+ 1 min
   double di_m_m1 = iADX(NULL,1,14,PRICE_CLOSE,2,0); // DI- 1 min
   // M5 ADX data
   double adx_m5 = iADX(NULL,5,14,PRICE_CLOSE,0,0); // ADX 5 min
   double adx_1ago_m5 = iADX(NULL,5,14,PRICE_CLOSE,0,1); // ADX 5 min 1 bar ago
   double di_p_m5 = iADX(NULL,5,14,PRICE_CLOSE,1,0); // DI+ 5 min
   double di_m_m5 = iADX(NULL,5,14,PRICE_CLOSE,2,0); // DI- 5 min
   // M15 ADX data
   double adx_m15 = iADX(NULL,15,14,PRICE_CLOSE,0,0); // ADX 15 min
   double adx_1ago_m15 = iADX(NULL,15,14,PRICE_CLOSE,0,1); // ADX 15 min 1 bar ago
   double di_p_m15 = iADX(NULL,15,14,PRICE_CLOSE,1,0); // DI+ 15 min
   double di_m_m15 = iADX(NULL,15,14,PRICE_CLOSE,2,0); // DI- 15 min
   // M30 ADX data
   double adx_m30 = iADX(NULL,30,14,PRICE_CLOSE,0,0); // ADX 30 min
   double adx_1ago_m30 = iADX(NULL,30,14,PRICE_CLOSE,0,1); // ADX 30 min 1 bar ago
   double di_p_m30 = iADX(NULL,30,14,PRICE_CLOSE,1,0); // DI+ 30 min
   double di_m_m30 = iADX(NULL,30,14,PRICE_CLOSE,2,0); // DI- 30 min
   // h1 ADX data
   double adx_h1 = iADX(NULL,60,14,PRICE_CLOSE,0,0); // ADX 1 hour
   double adx_1ago_h1 = iADX(NULL,60,14,PRICE_CLOSE,0,1); // ADX 1 hr 1 bar ago
   double di_p_h1 = iADX(NULL,60,14,PRICE_CLOSE,1,0); // DI+ 1 hour
   double di_m_h1 = iADX(NULL,60,14,PRICE_CLOSE,2,0); // DI- 1 hour
   // h4 ADX data
   double adx_h4 = iADX(NULL,240,14,PRICE_CLOSE,0,0); // ADX 4 hour
   double adx_1ago_h4 = iADX(NULL,240,14,PRICE_CLOSE,0,1); // ADX 4 hr 1 bar ago
   double di_p_h4 = iADX(NULL,240,14,PRICE_CLOSE,1,0); // DI+ 4 hour
   double di_m_h4 = iADX(NULL,240,14,PRICE_CLOSE,2,0); // DI- 4 hour
   
   
   //---- define colors and arrows 
   color adx_color_m1,adx_color_m5,adx_color_m15,adx_color_m30,adx_color_h1,adx_color_h4;
         
   string  adx_arrow_m1,adx_arrow_m5,adx_arrow_m15,adx_arrow_m30,adx_arrow_h1,adx_arrow_h4;
           
      
   //---- assign color
   // m1 colors
   if ((adx_m1 < ADX_trend_level) && (adx_m1 != 0)) { adx_color_m1 = LightSkyBlue; }
   if ((adx_m1 >=ADX_trend_level) && (di_p_m1 > di_m_m1)) { adx_color_m1 = Lime; }
   if ((adx_m1 >=ADX_trend_level) && (di_p_m1 < di_m_m1)) { adx_color_m1 = Red; }
           
   // m5 colors
   if ((adx_m5 < ADX_trend_level) && (adx_m5 != 0)) { adx_color_m5 = LightSkyBlue; }
   if ((adx_m5 >=ADX_trend_level) && (di_p_m5 > di_m_m5)) { adx_color_m5 = Lime; }
   if ((adx_m5 >=ADX_trend_level) && (di_p_m5 < di_m_m5)) { adx_color_m5 = Red; }
      
   // m15 colors
   if ((adx_m15 < ADX_trend_level) && (adx_m15 != 0)) { adx_color_m15 = LightSkyBlue; }  
   if ((adx_m15 >=ADX_trend_level) && (di_p_m15 > di_m_m15)) { adx_color_m15 = Lime; }
   if ((adx_m15 >=ADX_trend_level) && (di_p_m15 < di_m_m15)) { adx_color_m15 = Red; }
      
   // m30 colors
   if ((adx_m30 < ADX_trend_level) && (adx_m30 != 0)) { adx_color_m30 = LightSkyBlue; }
   if ((adx_m30 >=ADX_trend_level) && (di_p_m30 > di_m_m30)) { adx_color_m30 = Lime; }
   if ((adx_m30 >=ADX_trend_level) && (di_p_m30 < di_m_m30)) { adx_color_m30 = Red; }
      
   // h1 colors 
   if ((adx_h1 < ADX_trend_level) && (adx_h1 != 0)) { adx_color_h1 = LightSkyBlue; }
   if ((adx_h1 >=ADX_trend_level) && (di_p_h1 > di_m_h1)) { adx_color_h1 = Lime; }
   if ((adx_h1 >=ADX_trend_level) && (di_p_h1 < di_m_h1)) { adx_color_h1 = Red; }
   
   // h4 colors 
   if ((adx_h4 < ADX_trend_level) && (adx_h4 != 0)) { adx_color_h4 = LightSkyBlue; }
   if ((adx_h4 >=ADX_trend_level) && (di_p_h4 > di_m_h4)) { adx_color_h4 = Lime; }
   if ((adx_h4 >=ADX_trend_level) && (di_p_h4 < di_m_h4)) { adx_color_h4 = Red; }
   
   //---- feed all the ADX values into strings      
   string adx_value_m1 = adx_m1;
   string adx_value_m5 = adx_m5;
   string adx_value_m15 = adx_m15;
   string adx_value_m30 = adx_m30;
   string adx_value_h1 = adx_h1;
   string adx_value_h4 = adx_h4;
   
   //---- assign arrows strong up: { adx_arrow_ = "é"; } strong down: { adx_arrow_ = "ê"; }
   //                   up: { adx_arrow_ = "ì"; } down: { adx_arrow_ = "î"; }
   //                   range: { adx_arrow_ = "h"; }
   //                   use wingdings for these, the h is squiggly line
   
   // m1 arrows
   if (adx_m1 < ADX_trend_level && adx_m1 != 0) { adx_arrow_m1 = "h"; }
   if ((adx_m1 >= ADX_trend_level && adx_m1 < ADX_trend_strong) && (di_p_m1 > di_m_m1)) { adx_arrow_m1 = "ì"; }
   if ((adx_m1 >= ADX_trend_level && adx_m1 < ADX_trend_strong) && (di_p_m1 < di_m_m1)) { adx_arrow_m1 = "î"; }
   if ((adx_m1 >=ADX_trend_strong) && (di_p_m1 > di_m_m1)) { adx_arrow_m1 = "é"; }
   if ((adx_m1 >=ADX_trend_strong) && (di_p_m1 < di_m_m1)) { adx_arrow_m1 = "ê"; }
   
   // m5 arrows
   if (adx_m5 < ADX_trend_level && adx_m5 != 0) { adx_arrow_m5 = "h"; }
   if ((adx_m5 >= ADX_trend_level && adx_m5 < ADX_trend_strong) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "ì"; }
   if ((adx_m5 >= ADX_trend_level && adx_m5 < ADX_trend_strong) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "î"; }
   if ((adx_m5 >=ADX_trend_strong) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "é"; }
   if ((adx_m5 >=ADX_trend_strong) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "ê"; }
   
   // m15 arrows
   if (adx_m15 < ADX_trend_level && adx_m15 != 0) { adx_arrow_m15 = "h"; }
   if ((adx_m15 >= ADX_trend_level && adx_m15 < ADX_trend_strong) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "ì"; }
   if ((adx_m15 >= ADX_trend_level && adx_m15 < ADX_trend_strong) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "î"; }
   if ((adx_m15 >=ADX_trend_strong) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "é"; }
   if ((adx_m15 >=ADX_trend_strong) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "ê"; }
   
   // m30 arrows
   if (adx_m30 < ADX_trend_level && adx_m30 != 0) { adx_arrow_m30 = "h"; }
   if ((adx_m30 >= ADX_trend_level && adx_m30 < ADX_trend_strong) && (di_p_m30 > di_m_m30)) { adx_arrow_m30 = "ì"; }
   if ((adx_m30 >= ADX_trend_level && adx_m30 < ADX_trend_strong) && (di_p_m30 < di_m_m30)) { adx_arrow_m30 = "î"; }
   if ((adx_m30 >=ADX_trend_strong) && (di_p_m30 > di_m_m30)) { adx_arrow_m30 = "é"; }
   if ((adx_m30 >=ADX_trend_strong) && (di_p_m30 < di_m_m30)) { adx_arrow_m30 = "ê"; }
   
   // h1 arrows
   if (adx_h1 < ADX_trend_level && adx_h1 != 0) { adx_arrow_h1 = "h"; }
   if ((adx_h1 >= ADX_trend_level && adx_h1 < ADX_trend_strong) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "ì"; }
   if ((adx_h1 >= ADX_trend_level && adx_h1 < ADX_trend_strong) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "î"; }
   if ((adx_h1 >=ADX_trend_strong) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "é"; }
   if ((adx_h1 >=ADX_trend_strong) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "ê"; }
    
   // h4 arrows
   if (adx_h4 < ADX_trend_level && adx_h4 != 0) { adx_arrow_h4 = "h"; }
   if ((adx_h4 >= ADX_trend_level && adx_h4 < ADX_trend_strong) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "ì"; }
   if ((adx_h4 >= ADX_trend_level && adx_h4 < ADX_trend_strong) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "î"; }
   if ((adx_h4 >=ADX_trend_strong) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "é"; }
   if ((adx_h4 >=ADX_trend_strong) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "ê"; } 
     
   //---- defines what spread is 
   spread=MarketInfo(Symbol(),MODE_SPREAD);
    
   //+------------------------------------------------------------------+
   //|  Spread                                                          |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-1", OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-1","SPREAD:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-1", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-1", OBJPROP_XDISTANCE, 65);
     ObjectSet("ToR111-1", OBJPROP_YDISTANCE, 2);
   //---- creates spread number, Lime if less than threshold, Red if above it
   ObjectCreate("ToR111-2", OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     if (spread<=SpreadThreshold)
     {
     ObjectSetText("ToR111-2",DoubleToStr(spread ,0),10, "Arial Bold", Lime);
     }
     else
     ObjectSetText("ToR111-2",DoubleToStr(spread ,0),10, "Arial Bold", Red);
     ObjectSet("ToR111-2", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-2", OBJPROP_XDISTANCE, 115);
     ObjectSet("ToR111-2", OBJPROP_YDISTANCE, 2);
   
   //+------------------------------------------------------------------+
   //|  1 MIN                                                           |
   //+------------------------------------------------------------------+ 
   ObjectCreate("ToR111-3",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-3","1 MIN:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-3", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-3", OBJPROP_XDISTANCE, 150);
     ObjectSet("ToR111-3", OBJPROP_YDISTANCE, 2);
   //---- create text "Getting: "
   ObjectCreate("ToR111-3a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-3a","CHANGE:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-3a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-3a", OBJPROP_XDISTANCE, 135);
     ObjectSet("ToR111-3a", OBJPROP_YDISTANCE, 17);
   
   //---- create 1 min value
   ObjectCreate("ToR111-4",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-4", " ADX "+StringSubstr(adx_value_m1,0,5)+" ",9, "Arial Bold",adx_color_m1);
     ObjectSet("ToR111-4", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-4", OBJPROP_XDISTANCE, 185);
     ObjectSet("ToR111-4", OBJPROP_YDISTANCE, 2);
   //---- create 1 min arrow, squiggle if ranging
   ObjectCreate("ToR111-4a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-4a",adx_arrow_m1,9, "Wingdings",adx_color_m1);
     ObjectSet("ToR111-4a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-4a", OBJPROP_XDISTANCE, 250);
     ObjectSet("ToR111-4a", OBJPROP_YDISTANCE, 2); 
   
   if (adx_m1 < ADX_trend_level)
   {
   ObjectCreate("ToR111-4d",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-4d", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-4d", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-4d", OBJPROP_XDISTANCE, 190);
     ObjectSet("ToR111-4d", OBJPROP_YDISTANCE, 17); 
   }  
   else if (adx_m1 > adx_1ago_m1)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-4b",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-4b", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-4b", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-4b", OBJPROP_XDISTANCE, 190);
     ObjectSet("ToR111-4b", OBJPROP_YDISTANCE, 17); 
   }   
   else 
   {
   ObjectCreate("ToR111-4c",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-4c", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-4c", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-4c", OBJPROP_XDISTANCE, 190);
     ObjectSet("ToR111-4c", OBJPROP_YDISTANCE, 17); 
   }
   
   
   
   //+------------------------------------------------------------------+
   //|  5 MIN                                                           |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-5",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-5","5 MIN:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-5", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-5", OBJPROP_XDISTANCE, 270);
     ObjectSet("ToR111-5", OBJPROP_YDISTANCE, 2);
   //---- create 5 min value
   ObjectCreate("ToR111-6",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-6", " ADX "+StringSubstr(adx_value_m5,0,5)+" ",9, "Arial Bold",adx_color_m5);
     ObjectSet("ToR111-6", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-6", OBJPROP_XDISTANCE, 305);
     ObjectSet("ToR111-6", OBJPROP_YDISTANCE, 2);
   //---- create 5 min arrow, squiggle if ranging
   ObjectCreate("ToR111-6a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-6a",adx_arrow_m5,9, "Wingdings",adx_color_m5);
     ObjectSet("ToR111-6a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-6a", OBJPROP_XDISTANCE, 370);
     ObjectSet("ToR111-6a", OBJPROP_YDISTANCE, 2); 
   
   if (adx_m5 < ADX_trend_level)
   {
   ObjectCreate("ToR111-6d",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-6d", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-6d", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-6d", OBJPROP_XDISTANCE, 310);
     ObjectSet("ToR111-6d", OBJPROP_YDISTANCE, 17); 
   }  
   else if (adx_m5 > adx_1ago_m5)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-6b",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-6b", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-6b", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-6b", OBJPROP_XDISTANCE, 310);
     ObjectSet("ToR111-6b", OBJPROP_YDISTANCE, 17); 
   }   
   else
   {
   ObjectCreate("ToR111-6c",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-6c", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-6c", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-6c", OBJPROP_XDISTANCE, 310);
     ObjectSet("ToR111-6c", OBJPROP_YDISTANCE, 17); 
   }   
   
   
   //+------------------------------------------------------------------+
   //|  15 MIN                                                          |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-7",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-7","15 MIN:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-7", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-7", OBJPROP_XDISTANCE, 390);
     ObjectSet("ToR111-7", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR111-8",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-8", " ADX "+StringSubstr(adx_value_m15,0,5)+" ",9, "Arial Bold",adx_color_m15);
     ObjectSet("ToR111-8", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-8", OBJPROP_XDISTANCE, 430);
     ObjectSet("ToR111-8", OBJPROP_YDISTANCE, 2);
   //---- create 15 min arrow, squiggle if ranging
   ObjectCreate("ToR111-8a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-8a",adx_arrow_m15,9, "Wingdings",adx_color_m15);
     ObjectSet("ToR111-8a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-8a", OBJPROP_XDISTANCE, 495);
     ObjectSet("ToR111-8a", OBJPROP_YDISTANCE, 2); 
   
   if (adx_m15 < ADX_trend_level)
   {
   ObjectCreate("ToR111-8d",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-8d", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-8d", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-8d", OBJPROP_XDISTANCE, 435);
     ObjectSet("ToR111-8d", OBJPROP_YDISTANCE, 17); 
   }  
   else if (adx_m15 > adx_1ago_m15)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-8b",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-8b", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-8b", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-8b", OBJPROP_XDISTANCE, 435);
     ObjectSet("ToR111-8b", OBJPROP_YDISTANCE, 17); 
   }   
   else
   {
   ObjectCreate("ToR111-8c",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-8c", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-8c", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-8c", OBJPROP_XDISTANCE, 435);
     ObjectSet("ToR111-8c", OBJPROP_YDISTANCE, 17); 
   }     
   
   
   //+------------------------------------------------------------------+
   //|  30 MIN                                                          |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-9",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-9","30 MIN:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-9", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-9", OBJPROP_XDISTANCE, 515);
     ObjectSet("ToR111-9", OBJPROP_YDISTANCE, 2);
   //---- create 30 min value
   ObjectCreate("ToR111-10",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-10", " ADX "+StringSubstr(adx_value_m30,0,5)+" ",9, "Arial Bold",adx_color_m30);
     ObjectSet("ToR111-10", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-10", OBJPROP_XDISTANCE, 555);
     ObjectSet("ToR111-10", OBJPROP_YDISTANCE, 2);
   //---- create 30 min arrow, squiggle if ranging
   ObjectCreate("ToR111-10a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-10a",adx_arrow_m30,9, "Wingdings",adx_color_m30);
     ObjectSet("ToR111-10a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-10a", OBJPROP_XDISTANCE, 620);
     ObjectSet("ToR111-10a", OBJPROP_YDISTANCE, 2); 
   
   if (adx_m30 < ADX_trend_level)
   {
   ObjectCreate("ToR111-10d",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-10d", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-10d", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-10d", OBJPROP_XDISTANCE, 560);
     ObjectSet("ToR111-10d", OBJPROP_YDISTANCE, 17); 
   }  
   else if (adx_m30 > adx_1ago_m30)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-10b",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-10b", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-10b", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-10b", OBJPROP_XDISTANCE, 560);
     ObjectSet("ToR111-10b", OBJPROP_YDISTANCE, 17); 
   }   
   else
   {
   ObjectCreate("ToR111-10c",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-10c", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-10c", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-10c", OBJPROP_XDISTANCE, 560);
     ObjectSet("ToR111-10c", OBJPROP_YDISTANCE, 17); 
   }     
   
         
   if (Show_h1_ADX==true)
   {
   //+------------------------------------------------------------------+
   //|  1 HOUR                                                          |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-11",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-11","1 HR:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-11", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-11", OBJPROP_XDISTANCE, 640);
     ObjectSet("ToR111-11", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR111-12",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-12", " ADX "+StringSubstr(adx_value_h1,0,5)+" ",9, "Arial Bold",adx_color_h1);
     ObjectSet("ToR111-12", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-12", OBJPROP_XDISTANCE, 670);
     ObjectSet("ToR111-12", OBJPROP_YDISTANCE, 2);
   ObjectCreate("ToR111-12a",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-12a",adx_arrow_h1,9, "Wingdings",adx_color_h1);
     ObjectSet("ToR111-12a", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-12a", OBJPROP_XDISTANCE, 735);
     ObjectSet("ToR111-12a", OBJPROP_YDISTANCE, 2);
   
   if (adx_h1 < ADX_trend_level)
   {
   ObjectCreate("ToR111-12d",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-12d", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-12d", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-12d", OBJPROP_XDISTANCE, 675);
     ObjectSet("ToR111-12d", OBJPROP_YDISTANCE, 17); 
    }  
   else if (adx_h1 > adx_1ago_h1)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-12b",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-12b", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-12b", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-12b", OBJPROP_XDISTANCE, 675);
     ObjectSet("ToR111-12b", OBJPROP_YDISTANCE, 17); 
   }   
   else
   {
   ObjectCreate("ToR111-12c",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-12c", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-12c", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-12c", OBJPROP_XDISTANCE, 675);
     ObjectSet("ToR111-12c", OBJPROP_YDISTANCE, 17); 
    }     
   }
      
   if (Show_h4_ADX==true)
   {
   //+------------------------------------------------------------------+
   //|  4 HOUR                                                          |
   //+------------------------------------------------------------------+
   ObjectCreate("ToR111-13",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-13","4 HR:", 8, "Arial Bold", LightSteelBlue);
     ObjectSet("ToR111-13", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-13", OBJPROP_XDISTANCE, 760);
     ObjectSet("ToR111-13", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR111-14",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-14", " ADX "+StringSubstr(adx_value_h4,0,5)+" ",9, "Arial Bold",adx_color_h4);
     ObjectSet("ToR111-14", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-14", OBJPROP_XDISTANCE, 790);
     ObjectSet("ToR111-14", OBJPROP_YDISTANCE, 2);
   ObjectCreate("ToR111-15",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-15",adx_arrow_h4,9, "Wingdings",adx_color_h4);
     ObjectSet("ToR111-15", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-15", OBJPROP_XDISTANCE, 855);
     ObjectSet("ToR111-15", OBJPROP_YDISTANCE, 2);
   
   if (adx_h4 < ADX_trend_level)
   {
   ObjectCreate("ToR111-18",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-18", " RANGING ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-18", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-18", OBJPROP_XDISTANCE, 795);
     ObjectSet("ToR111-18", OBJPROP_YDISTANCE, 17); 
    }  
   else if (adx_h4 > adx_1ago_h4)
   {
   //---- create text "STRONGER, WEAKER"
   ObjectCreate("ToR111-16",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-16", " STRONGER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-16", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-16", OBJPROP_XDISTANCE, 795);
     ObjectSet("ToR111-16", OBJPROP_YDISTANCE, 17); 
   }   
   else
   {
   ObjectCreate("ToR111-17",OBJ_LABEL, WindowFind("ToR 1.11 "), 0, 0);
     ObjectSetText("ToR111-17", " WEAKER ",8, "Arial Bold",Silver);
     ObjectSet("ToR111-17", OBJPROP_CORNER, 0);
     ObjectSet("ToR111-17", OBJPROP_XDISTANCE, 795);
     ObjectSet("ToR111-17", OBJPROP_YDISTANCE, 17); 
    }     
   }
    
   return(0);
  }
//+------------------------------------------------------------------+

