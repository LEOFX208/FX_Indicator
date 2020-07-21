//+------------------------------------------------------------------+
//|                                               FerruFx_Trend+.mq4 |
//|                                        Copyright © 2007, FerruFx |
//|                                                                  |
//+------------------------------------------------------------------+



#property indicator_separate_window

#property indicator_minimum 0
#property indicator_maximum 1

#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red

//---- buffers
double UPBuffer[];
double DOWNBuffer[];

//---- Calculation of the trend. Let's give high TFs more "force"
extern string    Coefs_high_TF         = "=== SUM must be = 7 ===";
extern double    coef_m1               =      1.0;
extern double    coef_m5               =      1.0;
extern double    coef_m15              =      1.0;
extern double    coef_m30              =      1.0;
extern double    coef_H1               =      1.0;
extern double    coef_H4               =      1.0;
extern double    coef_D1               =      1.0;
// extern double    coef_W1               =      1.0;

//---- Indicators parameters
extern string    Shift_Settings_test_only        = "=== Format: 2007.05.07 00:00 ===";
extern datetime  look_time_shift       = D'2007.05.07 00:00';  // Shift for test if "test" is true
extern double    shift_indicators      =                   0;  // Shift for indicators if "test" is false
extern bool      test                  =               false;

string    MA_Settings           = "=== Moving Average Settings ===";
int       FastMAPeriod          =           20;  // Fast Moving Average period
int       MediumMAPeriod        =           50;  // Medium Moving Average period
int       SlowMAPeriod          =          100;  // Slow Moving Average period
int       MAMethod              =     MODE_EMA;  // Moving Average method
int       MAPrice               =  PRICE_CLOSE;  // Moving Average price

string    CCI_Settings          = "=== CCI Settings ===";
int       CCIPeriod             =           14;  // Commodity Channel Index  period
int       CCIPrice              =  PRICE_CLOSE;  // CCI price

string    MACD_Settings         = "=== MACD Settings ===";
int       MACDFast              =           12;  // MACD fast EMA period
int       MACDSlow              =           26;  // MACD slow EMA period
int       MACDSignal            =            9;  // MACD signal SMA period

string    ADX_Settings          = "=== ADX Settings ===";
int       ADXPeriod             =           14;  // Average Directional movement  period
int       ADXPrice              =  PRICE_CLOSE;  // ADX price

string    BULLS_Settings        = "=== BULLS Settings ===";
int       BULLSPeriod           =           13;  // Bulls Power  period
int       BULLSPrice            =  PRICE_CLOSE;  // Bulls Power price

string    BEARS_Settings        = "=== BEARS Settings ===";
int       BEARSPeriod           =           13;  // Bears Power  period
int       BEARSPrice            =  PRICE_CLOSE;  // Bears Power price

double UP_1, UP_2, UP_3, UP_4, UP_5, UP_6, UP_7, UP_8, UP_9, UP_10;
double UP_11, UP_12, UP_13, UP_14, UP_15, UP_16, UP_17, UP_18, UP_19, UP_20;
double UP_21, UP_22, UP_23, UP_24, UP_25, UP_26, UP_27, UP_28, UP_29, UP_30;
double UP_31, UP_32, UP_33, UP_34, UP_35, UP_36, UP_37, UP_38, UP_39, UP_40;
double UP_41, UP_42, UP_43, UP_44, UP_45, UP_46, UP_47, UP_48, UP_49, UP_50;
double UP_51, UP_52, UP_53, UP_54, UP_55, UP_56, UP_57, UP_58, UP_59, UP_60;
double UP_61, UP_62, UP_63, UP_64;

double DOWN_1, DOWN_2, DOWN_3, DOWN_4, DOWN_5, DOWN_6, DOWN_7, DOWN_8, DOWN_9, DOWN_10;
double DOWN_11, DOWN_12, DOWN_13, DOWN_14, DOWN_15, DOWN_16, DOWN_17, DOWN_18, DOWN_19, DOWN_20;
double DOWN_21, DOWN_22, DOWN_23, DOWN_24, DOWN_25, DOWN_26, DOWN_27, DOWN_28, DOWN_29, DOWN_30;
double DOWN_31, DOWN_32, DOWN_33, DOWN_34, DOWN_35, DOWN_36, DOWN_37, DOWN_38, DOWN_39, DOWN_40;
double DOWN_41, DOWN_42, DOWN_43, DOWN_44, DOWN_45, DOWN_46, DOWN_47, DOWN_48, DOWN_49, DOWN_50;
double DOWN_51, DOWN_52, DOWN_53, DOWN_54, DOWN_55, DOWN_56, DOWN_57, DOWN_58, DOWN_59, DOWN_60;
double DOWN_61, DOWN_62, DOWN_63, DOWN_64;



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- name for indicator window

   string short_name="FerruFx_Trend+";
   IndicatorShortName(short_name);

   SetIndexBuffer(0,UPBuffer);
   SetIndexBuffer(1,DOWNBuffer);

   

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
  
  double coef = coef_m1 + coef_m5 + coef_m15 + coef_m30 + coef_H1 + coef_H4 + coef_D1;
  if( coef != 7 ) { Alert("The sum of the coefs must be 7. Your setting is ", coef,"!!!"); }
  
   color color_common_line = White;
   color color_common_text = White;
   color color_connection;
   
//---- calculation for the label's X/Y

   int add_x, add_y;
   
    add_x = -160;
    add_y = 25;
   
   
// Timeframes
 
   color color_tf = PaleGoldenrod;

   ObjectCreate("m1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("m1","M1",9, "Verdana", color_tf);
   ObjectSet("m1", OBJPROP_CORNER, 0);
   ObjectSet("m1", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("m1", OBJPROP_YDISTANCE, 21+add_y);
   
   ObjectCreate("m5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("m5","M5",9, "Verdana", color_tf);
   ObjectSet("m5", OBJPROP_CORNER, 0);
   ObjectSet("m5", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("m5", OBJPROP_YDISTANCE, 36+add_y);
   
   ObjectCreate("m15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("m15","M15",9, "Verdana", color_tf);
   ObjectSet("m15", OBJPROP_CORNER, 0);
   ObjectSet("m15", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("m15", OBJPROP_YDISTANCE, 51+add_y);
   
   ObjectCreate("m30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("m30","M30",9, "Verdana", color_tf);
   ObjectSet("m30", OBJPROP_CORNER, 0);
   ObjectSet("m30", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("m30", OBJPROP_YDISTANCE, 66+add_y);
   
   ObjectCreate("h1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("h1","H1",9, "Verdana", color_tf);
   ObjectSet("h1", OBJPROP_CORNER, 0);
   ObjectSet("h1", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("h1", OBJPROP_YDISTANCE, 81+add_y);
   
   ObjectCreate("h4", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("h4","H4",9, "Verdana", color_tf);
   ObjectSet("h4", OBJPROP_CORNER, 0);
   ObjectSet("h4", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("h4", OBJPROP_YDISTANCE, 96+add_y);
   
   ObjectCreate("d1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("d1","D1",9, "Verdana", color_tf);
   ObjectSet("d1", OBJPROP_CORNER, 0);
   ObjectSet("d1", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("d1", OBJPROP_YDISTANCE, 111+add_y);
   
   /*
   ObjectCreate("w1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("w1","W1",9, "Verdana", color_tf);
   ObjectSet("w1", OBJPROP_CORNER, 0);
   ObjectSet("w1", OBJPROP_XDISTANCE, 170+add_x);
   ObjectSet("w1", OBJPROP_YDISTANCE, 126+add_y);
   */
   
// Shift calculation for indicators (tests only)

   double shift_1, shift_5, shift_15, shift_30, shift_60, shift_240, shift_1440, shift_10080;
   
   if( test == true )
   {
    shift_1=iBarShift(NULL,PERIOD_M1,look_time_shift,false);
    shift_5=iBarShift(NULL,PERIOD_M5,look_time_shift,false);
    shift_15=iBarShift(NULL,PERIOD_M15,look_time_shift,false);
    shift_30=iBarShift(NULL,PERIOD_M30,look_time_shift,false);
    shift_60=iBarShift(NULL,PERIOD_H1,look_time_shift,false);
    shift_240=iBarShift(NULL,PERIOD_H4,look_time_shift,false);
    shift_1440=iBarShift(NULL,PERIOD_D1,look_time_shift,false);
    shift_10080=iBarShift(NULL,PERIOD_W1,look_time_shift,false);
   }
   else
   {
    shift_1=shift_indicators;
    shift_5=shift_indicators;
    shift_15=shift_indicators;
    shift_30=shift_indicators;
    shift_60=shift_indicators;
    shift_240=shift_indicators;
    shift_1440=shift_indicators;
    shift_10080=shift_indicators;
  }
   
// Indicator (Moving Average)

   color color_ind = PowderBlue;
   
   string MAfast_Trend_1, MAfast_Trend_5, MAfast_Trend_15, MAfast_Trend_30, MAfast_Trend_60, MAfast_Trend_240, MAfast_Trend_1440, MAfast_Trend_10080;
   string MAmedium_Trend_1, MAmedium_Trend_5, MAmedium_Trend_15, MAmedium_Trend_30, MAmedium_Trend_60, MAmedium_Trend_240, MAmedium_Trend_1440, MAmedium_Trend_10080;
   string MAslow_Trend_1, MAslow_Trend_5, MAslow_Trend_15, MAslow_Trend_30, MAslow_Trend_60, MAslow_Trend_240, MAslow_Trend_1440, MAslow_Trend_10080;
   double x;
   color color_indic;
   
   // FAST
   
   double l;
   if(FastMAPeriod < 10) { l=210; }
   if(FastMAPeriod >= 10) { l=206; }
   if(FastMAPeriod >= 100) { l=202; }
   
   ObjectCreate("mafast", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("mafast","MA"+DoubleToStr(FastMAPeriod,0),9, "Verdana", color_ind);
   ObjectSet("mafast", OBJPROP_CORNER, 0);
   ObjectSet("mafast", OBJPROP_XDISTANCE, l+add_x);
   ObjectSet("mafast", OBJPROP_YDISTANCE, -5+add_y);

   double FastMA_1_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1);
   double FastMA_2_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   
   if ((FastMA_1_1 > FastMA_2_1)) { MAfast_Trend_1 = "UP"; x = 216; color_indic = Lime; UP_1 = 1; DOWN_1 = 0; }
   if ((FastMA_1_1 < FastMA_2_1)) { MAfast_Trend_1 = "DOWN"; x = 206; color_indic = Red; UP_1 = 0; DOWN_1 = 1; }
   ObjectCreate("Trend_MAfast_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_1",MAfast_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double FastMA_1_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5);
   double FastMA_2_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   
   if ((FastMA_1_5 > FastMA_2_5)) { MAfast_Trend_5 = "UP"; x = 216; color_indic = Lime; UP_2 = 1; DOWN_2 = 0; }
   if ((FastMA_1_5 < FastMA_2_5)) { MAfast_Trend_5 = "DOWN"; x = 206; color_indic = Red; UP_2 = 0; DOWN_2 = 1; }
   ObjectCreate("Trend_MAfast_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_5",MAfast_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double FastMA_1_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15);
   double FastMA_2_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   
   if ((FastMA_1_15 > FastMA_2_15)) { MAfast_Trend_15 = "UP"; x = 216; color_indic = Lime; UP_3 = 1; DOWN_3 = 0; }
   if ((FastMA_1_15 < FastMA_2_15)) { MAfast_Trend_15 = "DOWN"; x = 206; color_indic = Red; UP_3 = 0; DOWN_3 = 1; }
   ObjectCreate("Trend_MAfast_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_15",MAfast_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double FastMA_1_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30);
   double FastMA_2_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   
   if ((FastMA_1_30 > FastMA_2_30)) { MAfast_Trend_30 = "UP"; x = 216; color_indic = Lime; UP_4 = 1; DOWN_4 = 0; }
   if ((FastMA_1_30 < FastMA_2_30)) { MAfast_Trend_30 = "DOWN"; x = 206; color_indic = Red; UP_4 = 0; DOWN_4 = 1; }
   ObjectCreate("Trend_MAfast_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_30",MAfast_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double FastMA_1_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60);
   double FastMA_2_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   
   if ((FastMA_1_60 > FastMA_2_60)) { MAfast_Trend_60 = "UP"; x = 216; color_indic = Lime; UP_5 = 1; DOWN_5 = 0; }
   if ((FastMA_1_60 < FastMA_2_60)) { MAfast_Trend_60 = "DOWN"; x = 206; color_indic = Red; UP_5 = 0; DOWN_5 = 1; }
   ObjectCreate("Trend_MAfast_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_60",MAfast_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double FastMA_1_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240);
   double FastMA_2_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   
   if ((FastMA_1_240 > FastMA_2_240)) { MAfast_Trend_240 = "UP"; x = 216; color_indic = Lime; UP_6 = 1; DOWN_6 = 0; }
   if ((FastMA_1_240 < FastMA_2_240)) { MAfast_Trend_240 = "DOWN"; x = 206; color_indic = Red; UP_6 = 0; DOWN_6 = 1; }
   ObjectCreate("Trend_MAfast_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_240",MAfast_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double FastMA_1_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double FastMA_2_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   
   if ((FastMA_1_1440 > FastMA_2_1440)) { MAfast_Trend_1440 = "UP"; x = 216; color_indic = Lime; UP_7 = 1; DOWN_7 = 0; }
   if ((FastMA_1_1440 < FastMA_2_1440)) { MAfast_Trend_1440 = "DOWN"; x = 206; color_indic = Red; UP_7 = 0; DOWN_7 = 1; }
   ObjectCreate("Trend_MAfast_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_1440",MAfast_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double FastMA_1_10080 = iMA(NULL,PERIOD_W1,FastMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double FastMA_2_10080 = iMA(NULL,PERIOD_W1,FastMAPeriod,0,MAMethod,MAPrice,shift_10080+1);
   
   if ((FastMA_1_10080 > FastMA_2_10080)) { MAfast_Trend_10080 = "UP"; x = 216; color_indic = Lime; UP_8 = 1; DOWN_8 = 0; }
   if ((FastMA_1_10080 < FastMA_2_10080)) { MAfast_Trend_10080 = "DOWN"; x = 206; color_indic = Red; UP_8 = 0; DOWN_8 = 1; }
   ObjectCreate("Trend_MAfast_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAfast_10080",MAfast_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_MAfast_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAfast_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAfast_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
   // MEDIUM
   
   double m;
   if(MediumMAPeriod < 10) { m=260; }
   if(MediumMAPeriod >= 10) { m=256; }
   if(MediumMAPeriod >= 100) { m=252; }
   
   ObjectCreate("mamedium", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("mamedium","MA"+DoubleToStr(MediumMAPeriod,0),9, "Verdana", color_ind);
   ObjectSet("mamedium", OBJPROP_CORNER, 0);
   ObjectSet("mamedium", OBJPROP_XDISTANCE, m+add_x);
   ObjectSet("mamedium", OBJPROP_YDISTANCE, -5+add_y);
   
   double MediumMA_1_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1);
   double MediumMA_2_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   
   if ((MediumMA_1_1 > MediumMA_2_1)) { MAmedium_Trend_1 = "UP"; x = 266; color_indic = Lime; UP_9 = 1; DOWN_9 = 0; }
   if ((MediumMA_1_1 < MediumMA_2_1)) { MAmedium_Trend_1 = "DOWN"; x = 256; color_indic = Red; UP_9 = 0; DOWN_9 = 1; }
   ObjectCreate("Trend_MAmedium_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_1",MAmedium_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double MediumMA_1_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5);
   double MediumMA_2_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   
   if ((MediumMA_1_5 > MediumMA_2_5)) { MAmedium_Trend_5 = "UP"; x = 266; color_indic = Lime; UP_10 = 1; DOWN_10 = 0; }
   if ((MediumMA_1_5 < MediumMA_2_5)) { MAmedium_Trend_5 = "DOWN"; x = 256; color_indic = Red; UP_10 = 0; DOWN_10 = 1; }
   ObjectCreate("Trend_MAmedium_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_5",MAmedium_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double MediumMA_1_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15);
   double MediumMA_2_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   
   if ((MediumMA_1_15 > MediumMA_2_15)) { MAmedium_Trend_15 = "UP"; x = 266; color_indic = Lime; UP_11 = 1; DOWN_11 = 0; }
   if ((MediumMA_1_15 < MediumMA_2_15)) { MAmedium_Trend_15 = "DOWN"; x = 256; color_indic = Red; UP_11 = 0; DOWN_11 = 1; }
   ObjectCreate("Trend_MAmedium_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_15",MAmedium_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double MediumMA_1_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30);
   double MediumMA_2_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   
   if ((MediumMA_1_30 > MediumMA_2_30)) { MAmedium_Trend_30 = "UP"; x = 266; color_indic = Lime; UP_12 = 1; DOWN_12 = 0; }
   if ((MediumMA_1_30 < MediumMA_2_30)) { MAmedium_Trend_30 = "DOWN"; x = 256; color_indic = Red; UP_12 = 0; DOWN_12 = 1; }
   ObjectCreate("Trend_MAmedium_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_30",MAmedium_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double MediumMA_1_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60);
   double MediumMA_2_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   
   if ((MediumMA_1_60 > MediumMA_2_60)) { MAmedium_Trend_60 = "UP"; x = 266; color_indic = Lime; UP_13 = 1; DOWN_13 = 0; }
   if ((MediumMA_1_60 < MediumMA_2_60)) { MAmedium_Trend_60 = "DOWN"; x = 256; color_indic = Red; UP_13 = 0; DOWN_13 = 1; }
   ObjectCreate("Trend_MAmedium_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_60",MAmedium_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double MediumMA_1_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240);
   double MediumMA_2_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   
   if ((MediumMA_1_240 > MediumMA_2_240)) { MAmedium_Trend_240 = "UP"; x = 266; color_indic = Lime; UP_14 = 1; DOWN_14 = 0; }
   if ((MediumMA_1_240 < MediumMA_2_240)) { MAmedium_Trend_240 = "DOWN"; x = 256; color_indic = Red; UP_14 = 0; DOWN_14 = 1; }
   ObjectCreate("Trend_MAmedium_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_240",MAmedium_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double MediumMA_1_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double MediumMA_2_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   
   if ((MediumMA_1_1440 > MediumMA_2_1440)) { MAmedium_Trend_1440 = "UP"; x = 266; color_indic = Lime; UP_15 = 1; DOWN_15 = 0; }
   if ((MediumMA_1_1440 < MediumMA_2_1440)) { MAmedium_Trend_1440 = "DOWN"; x = 256; color_indic = Red; UP_15 = 0; DOWN_15 = 1; }
   ObjectCreate("Trend_MAmedium_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_1440",MAmedium_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double MediumMA_1_10080 = iMA(NULL,PERIOD_W1,MediumMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double MediumMA_2_10080 = iMA(NULL,PERIOD_W1,MediumMAPeriod,0,MAMethod,MAPrice,shift_10080+1);
   
   if ((MediumMA_1_10080 > MediumMA_2_10080)) { MAmedium_Trend_10080 = "UP"; x = 266; color_indic = Lime; UP_16 = 1; DOWN_16 = 0; }
   if ((MediumMA_1_10080 < MediumMA_2_10080)) { MAmedium_Trend_10080 = "DOWN"; x = 256; color_indic = Red; UP_16 = 0; DOWN_16 = 1; }
   ObjectCreate("Trend_MAmedium_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAmedium_10080",MAmedium_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAmedium_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
   // SLOW
   
   double n;
   if(SlowMAPeriod < 10) { n=310; }
   if(SlowMAPeriod >= 10) { n=306; }
   if(SlowMAPeriod >= 100) { n=302; }
   
   ObjectCreate("maslow", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("maslow","MA"+DoubleToStr(SlowMAPeriod,0),9, "Verdana", color_ind);
   ObjectSet("maslow", OBJPROP_CORNER, 0);
   ObjectSet("maslow", OBJPROP_XDISTANCE, n+add_x);
   ObjectSet("maslow", OBJPROP_YDISTANCE, -5+add_y);
   
   double SlowMA_1_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1);
   double SlowMA_2_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   
   if ((SlowMA_1_1 > SlowMA_2_1)) { MAslow_Trend_1 = "UP"; x = 316; color_indic = Lime; UP_17 = 1; DOWN_17 = 0; }
   if ((SlowMA_1_1 < SlowMA_2_1)) { MAslow_Trend_1 = "DOWN"; x = 306; color_indic = Red; UP_17 = 0; DOWN_17 = 1; }
   ObjectCreate("Trend_MAslow_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_1",MAslow_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double SlowMA_1_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5);
   double SlowMA_2_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   
   if ((SlowMA_1_5 > SlowMA_2_5)) { MAslow_Trend_5 = "UP"; x = 316; color_indic = Lime; UP_18 = 1; DOWN_18 = 0; }
   if ((SlowMA_1_5 < SlowMA_2_5)) { MAslow_Trend_5 = "DOWN"; x = 306; color_indic = Red; UP_18 = 0; DOWN_18 = 1; }
   ObjectCreate("Trend_MAslow_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_5",MAslow_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double SlowMA_1_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15);
   double SlowMA_2_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   
   if ((SlowMA_1_15 > SlowMA_2_15)) { MAslow_Trend_15 = "UP"; x = 316; color_indic = Lime; UP_19 = 1; DOWN_19 = 0; }
   if ((SlowMA_1_15 < SlowMA_2_15)) { MAslow_Trend_15 = "DOWN"; x = 306; color_indic = Red; UP_19 = 0; DOWN_19 = 1; }
   ObjectCreate("Trend_MAslow_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_15",MAslow_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double SlowMA_1_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30);
   double SlowMA_2_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   
   if ((SlowMA_1_30 > SlowMA_2_30)) { MAslow_Trend_30 = "UP"; x = 316; color_indic = Lime; UP_20 = 1; DOWN_20 = 0; }
   if ((SlowMA_1_30 < SlowMA_2_30)) { MAslow_Trend_30 = "DOWN"; x = 306; color_indic = Red; UP_20 = 0; DOWN_20 = 1; }
   ObjectCreate("Trend_MAslow_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_30",MAslow_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double SlowMA_1_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60);
   double SlowMA_2_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   
   if ((SlowMA_1_60 > SlowMA_2_60)) { MAslow_Trend_60 = "UP"; x = 316; color_indic = Lime; UP_21 = 1; DOWN_21 = 0; }
   if ((SlowMA_1_60 < SlowMA_2_60)) { MAslow_Trend_60 = "DOWN"; x = 306; color_indic = Red; UP_21 = 0; DOWN_21 = 1; }
   ObjectCreate("Trend_MAslow_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_60",MAslow_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double SlowMA_1_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240);
   double SlowMA_2_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   
   if ((SlowMA_1_240 > SlowMA_2_240)) { MAslow_Trend_240 = "UP"; x = 316; color_indic = Lime; UP_22 = 1; DOWN_22 = 0; }
   if ((SlowMA_1_240 < SlowMA_2_240)) { MAslow_Trend_240 = "DOWN"; x = 306; color_indic = Red; UP_22 = 0; DOWN_22 = 1; }
   ObjectCreate("Trend_MAslow_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_240",MAslow_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double SlowMA_1_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double SlowMA_2_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   
   if ((SlowMA_1_1440 > SlowMA_2_1440)) { MAslow_Trend_1440 = "UP"; x = 316; color_indic = Lime; UP_23 = 1; DOWN_23 = 0; }
   if ((SlowMA_1_1440 < SlowMA_2_1440)) { MAslow_Trend_1440 = "DOWN"; x = 306; color_indic = Red; UP_23 = 0; DOWN_23 = 1; }
   ObjectCreate("Trend_MAslow_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_1440",MAslow_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double SlowMA_1_10080 = iMA(NULL,PERIOD_W1,SlowMAPeriod,0,MAMethod,MAPrice,shift_10080);
   double SlowMA_2_10080 = iMA(NULL,PERIOD_W1,SlowMAPeriod,0,MAMethod,MAPrice,shift_10080+1);
   
   if ((SlowMA_1_10080 > SlowMA_2_10080)) { MAslow_Trend_10080 = "UP"; x = 316; color_indic = Lime; UP_24 = 1; DOWN_24 = 0; }
   if ((SlowMA_1_10080 < SlowMA_2_10080)) { MAslow_Trend_10080 = "DOWN"; x = 306; color_indic = Red; UP_24 = 0; DOWN_24 = 1; }
   ObjectCreate("Trend_MAslow_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MAslow_10080",MAslow_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_MAslow_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MAslow_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MAslow_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
// Indicator (CCI)

   ObjectCreate("cci", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("cci","CCI"+DoubleToStr(CCIPeriod,0),9, "Verdana", color_ind);
   ObjectSet("cci", OBJPROP_CORNER, 0);
   ObjectSet("cci", OBJPROP_XDISTANCE, 353+add_x);
   ObjectSet("cci", OBJPROP_YDISTANCE, -5+add_y);

   string CCI_Trend_1, CCI_Trend_5, CCI_Trend_15, CCI_Trend_30, CCI_Trend_60, CCI_Trend_240, CCI_Trend_1440, CCI_Trend_10080;

   double CCI_1=iCCI(NULL,PERIOD_M1,CCIPeriod,CCIPrice,shift_1);
   
   if ((CCI_1 > 0)) { CCI_Trend_1 = "UP"; x = 366; color_indic = Lime; UP_25 = 1; DOWN_25 = 0; }
   if ((CCI_1 < 0)) { CCI_Trend_1 = "DOWN"; x = 356; color_indic = Red; UP_25 = 0; DOWN_25 = 1; }
   ObjectCreate("Trend_CCI_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_1",CCI_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double CCI_5=iCCI(NULL,PERIOD_M5,CCIPeriod,CCIPrice,shift_5);
   
   if ((CCI_5 > 0)) { CCI_Trend_5 = "UP"; x = 366; color_indic = Lime; UP_26 = 1; DOWN_26 = 0; }
   if ((CCI_5 < 0)) { CCI_Trend_5 = "DOWN"; x = 356; color_indic = Red; UP_26 = 0; DOWN_26 = 1; }
   ObjectCreate("Trend_CCI_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_5",CCI_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double CCI_15=iCCI(NULL,PERIOD_M15,CCIPeriod,CCIPrice,shift_15);
   
   if ((CCI_15 > 0)) { CCI_Trend_15 = "UP"; x = 366; color_indic = Lime; UP_27 = 1; DOWN_27 = 0; }
   if ((CCI_15 < 0)) { CCI_Trend_15 = "DOWN"; x = 356; color_indic = Red; UP_27 = 0; DOWN_27 = 1; }
   ObjectCreate("Trend_CCI_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_15",CCI_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double CCI_30=iCCI(NULL,PERIOD_M30,CCIPeriod,CCIPrice,shift_30);
   
   if ((CCI_30 > 0)) { CCI_Trend_30 = "UP"; x = 366; color_indic = Lime; UP_28 = 1; DOWN_28 = 0; }
   if ((CCI_30 < 0)) { CCI_Trend_30 = "DOWN"; x = 356; color_indic = Red; UP_28 = 0; DOWN_28 = 1; }
   ObjectCreate("Trend_CCI_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_30",CCI_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double CCI_60=iCCI(NULL,PERIOD_H1,CCIPeriod,CCIPrice,shift_60);
   
   if ((CCI_60 > 0)) { CCI_Trend_60 = "UP"; x = 366; color_indic = Lime; UP_29 = 1; DOWN_29 = 0; }
   if ((CCI_60 < 0)) { CCI_Trend_60 = "DOWN"; x = 356; color_indic = Red; UP_29 = 0; DOWN_29 = 1; }
   ObjectCreate("Trend_CCI_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_60",CCI_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double CCI_240=iCCI(NULL,PERIOD_H4,CCIPeriod,CCIPrice,shift_240);
   
   if ((CCI_240 > 0)) { CCI_Trend_240 = "UP"; x = 366; color_indic = Lime; UP_30 = 1; DOWN_30 = 0; }
   if ((CCI_240 < 0)) { CCI_Trend_240 = "DOWN"; x = 356; color_indic = Red; UP_30 = 0; DOWN_30 = 1; }
   ObjectCreate("Trend_CCI_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_240",CCI_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double CCI_1440=iCCI(NULL,PERIOD_D1,CCIPeriod,CCIPrice,shift_1440);
   
   if ((CCI_1440 > 0)) { CCI_Trend_1440 = "UP"; x = 366; color_indic = Lime; UP_31 = 1; DOWN_31 = 0; }
   if ((CCI_1440 < 0)) { CCI_Trend_1440 = "DOWN"; x = 356; color_indic = Red; UP_31 = 0; DOWN_31 = 1; }
   ObjectCreate("Trend_CCI_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_1440",CCI_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double CCI_10080=iCCI(NULL,PERIOD_W1,CCIPeriod,CCIPrice,shift_10080);
   
   if ((CCI_10080 > 0)) { CCI_Trend_10080 = "UP"; x = 366; color_indic = Lime; UP_32 = 1; DOWN_32 = 0; }
   if ((CCI_10080 < 0)) { CCI_Trend_10080 = "DOWN"; x = 356; color_indic = Red; UP_32 = 0; DOWN_32 = 1; }
   ObjectCreate("Trend_CCI_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_CCI_10080",CCI_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_CCI_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_CCI_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_CCI_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
// Indicator (MACD)

   ObjectCreate("macd", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("macd","MACD",9, "Verdana", color_ind);
   ObjectSet("macd", OBJPROP_CORNER, 0);
   ObjectSet("macd", OBJPROP_XDISTANCE, 405+add_x);
   ObjectSet("macd", OBJPROP_YDISTANCE, -5+add_y);
   
   string MACD_Trend_1, MACD_Trend_5, MACD_Trend_15, MACD_Trend_30, MACD_Trend_60, MACD_Trend_240, MACD_Trend_1440, MACD_Trend_10080;
   
   
   double MACD_m_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1);
   double MACD_s_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1);
   
   if ((MACD_m_1 > MACD_s_1)) { MACD_Trend_1 = "UP"; x = 416; color_indic = Lime; UP_33 = 1; DOWN_33 = 0; }
   if ((MACD_m_1 < MACD_s_1)) { MACD_Trend_1 = "DOWN"; x = 406; color_indic = Red; UP_33 = 0; DOWN_33 = 1; }
   ObjectCreate("Trend_MACD_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_1",MACD_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double MACD_m_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_5);
   double MACD_s_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_5);
   
   if ((MACD_m_5 > MACD_s_5)) { MACD_Trend_5 = "UP"; x = 416; color_indic = Lime; UP_34 = 1; DOWN_34 = 0; }
   if ((MACD_m_5 < MACD_s_5)) { MACD_Trend_5 = "DOWN"; x = 406; color_indic = Red; UP_34 = 0; DOWN_34 = 1; }
   ObjectCreate("Trend_MACD_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_5",MACD_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double MACD_m_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_15);
   double MACD_s_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_15);
   
   if ((MACD_m_15 > MACD_s_15)) { MACD_Trend_15 = "UP"; x = 416; color_indic = Lime; UP_35 = 1; DOWN_35 = 0; }
   if ((MACD_m_15 < MACD_s_15)) { MACD_Trend_15 = "DOWN"; x = 406; color_indic = Red; UP_35 = 0; DOWN_35 = 1; }
   ObjectCreate("Trend_MACD_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_15",MACD_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double MACD_m_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_30);
   double MACD_s_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_30);
   
   if ((MACD_m_30 > MACD_s_30)) { MACD_Trend_30 = "UP"; x = 416; color_indic = Lime; UP_36 = 1; DOWN_36 = 0; }
   if ((MACD_m_30 < MACD_s_30)) { MACD_Trend_30 = "DOWN"; x = 406; color_indic = Red; UP_36 = 0; DOWN_36 = 1; }
   ObjectCreate("Trend_MACD_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_30",MACD_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double MACD_m_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_60);
   double MACD_s_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_60);
   
   if ((MACD_m_60 > MACD_s_60)) { MACD_Trend_60 = "UP"; x = 416; color_indic = Lime; UP_37 = 1; DOWN_37 = 0; }
   if ((MACD_m_60 < MACD_s_60)) { MACD_Trend_60 = "DOWN"; x = 406; color_indic = Red; UP_37 = 0; DOWN_37 = 1; }
   ObjectCreate("Trend_MACD_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_60",MACD_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double MACD_m_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_240);
   double MACD_s_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_240);
   
   if ((MACD_m_240 > MACD_s_240)) { MACD_Trend_240 = "UP"; x = 416; color_indic = Lime; UP_38 = 1; DOWN_38 = 0; }
   if ((MACD_m_240 < MACD_s_240)) { MACD_Trend_240 = "DOWN"; x = 406; color_indic = Red; UP_38 = 0; DOWN_38 = 1; }
   ObjectCreate("Trend_MACD_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_240",MACD_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double MACD_m_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1440);
   double MACD_s_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1440);
   
   if ((MACD_m_1440 > MACD_s_1440)) { MACD_Trend_1440 = "UP"; x = 416; color_indic = Lime; UP_39 = 1; DOWN_39 = 0; }
   if ((MACD_m_1440 < MACD_s_1440)) { MACD_Trend_1440 = "DOWN"; x = 406; color_indic = Red; UP_39 = 0; DOWN_39 = 1; }
   ObjectCreate("Trend_MACD_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_1440",MACD_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double MACD_m_10080=iMACD(NULL,PERIOD_W1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_10080);
   double MACD_s_10080=iMACD(NULL,PERIOD_W1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_10080);
   
   if ((MACD_m_10080 > MACD_s_10080)) { MACD_Trend_10080 = "UP"; x = 416; color_indic = Lime; UP_40 = 1; DOWN_40 = 0; }
   if ((MACD_m_10080 < MACD_s_10080)) { MACD_Trend_10080 = "DOWN"; x = 406; color_indic = Red; UP_40 = 0; DOWN_40 = 1; }
   ObjectCreate("Trend_MACD_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_MACD_10080",MACD_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_MACD_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_MACD_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_MACD_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
// Indicator (ADX)

   ObjectCreate("adx", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("adx","ADX"+DoubleToStr(ADXPeriod,0),9, "Verdana", color_ind);
   ObjectSet("adx", OBJPROP_CORNER, 0);
   ObjectSet("adx", OBJPROP_XDISTANCE, 453+add_x);
   ObjectSet("adx", OBJPROP_YDISTANCE, -5+add_y);

   string ADX_Trend_1, ADX_Trend_5, ADX_Trend_15, ADX_Trend_30, ADX_Trend_60, ADX_Trend_240, ADX_Trend_1440, ADX_Trend_10080;
   
   double ADX_plus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1);
   double ADX_minus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1);
   
   if ((ADX_plus_1 > ADX_minus_1)) { ADX_Trend_1 = "UP"; x = 466; color_indic = Lime; UP_41 = 1; DOWN_41 = 0; }
   if ((ADX_plus_1 < ADX_minus_1)) { ADX_Trend_1 = "DOWN"; x = 456; color_indic = Red; UP_41 = 0; DOWN_41 = 1; }
   ObjectCreate("Trend_ADX_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_1",ADX_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double ADX_plus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_5);
   double ADX_minus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_5);
   
   if ((ADX_plus_5 > ADX_minus_5)) { ADX_Trend_5 = "UP"; x = 466; color_indic = Lime; UP_42 = 1; DOWN_42 = 0; }
   if ((ADX_plus_5 < ADX_minus_5)) { ADX_Trend_5 = "DOWN"; x = 456; color_indic = Red; UP_42 = 0; DOWN_42 = 1; }
   ObjectCreate("Trend_ADX_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_5",ADX_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double ADX_plus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_15);
   double ADX_minus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_15);
   
   if ((ADX_plus_15 > ADX_minus_15)) { ADX_Trend_15 = "UP"; x = 466; color_indic = Lime; UP_43 = 1; DOWN_43 = 0; }
   if ((ADX_plus_15 < ADX_minus_15)) { ADX_Trend_15 = "DOWN"; x = 456; color_indic = Red; UP_43 = 0; DOWN_43 = 1; }
   ObjectCreate("Trend_ADX_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_15",ADX_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double ADX_plus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_30);
   double ADX_minus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_30);
   
   if ((ADX_plus_30 > ADX_minus_30)) { ADX_Trend_30 = "UP"; x = 466; color_indic = Lime; UP_44 = 1; DOWN_44 = 0; }
   if ((ADX_plus_30 < ADX_minus_30)) { ADX_Trend_30 = "DOWN"; x = 456; color_indic = Red; UP_44 = 0; DOWN_44 = 1; }
   ObjectCreate("Trend_ADX_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_30",ADX_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double ADX_plus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_60);
   double ADX_minus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_60);
   
   if ((ADX_plus_60 > ADX_minus_60)) { ADX_Trend_60 = "UP"; x = 466; color_indic = Lime; UP_45 = 1; DOWN_45 = 0; }
   if ((ADX_plus_60 < ADX_minus_60)) { ADX_Trend_60 = "DOWN"; x = 456; color_indic = Red; UP_45 = 0; DOWN_45 = 1; }
   ObjectCreate("Trend_ADX_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_60",ADX_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double ADX_plus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_240);
   double ADX_minus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_240);
   
   if ((ADX_plus_240 > ADX_minus_240)) { ADX_Trend_240 = "UP"; x = 466; color_indic = Lime; UP_46 = 1; DOWN_46 = 0; }
   if ((ADX_plus_240 < ADX_minus_240)) { ADX_Trend_240 = "DOWN"; x = 456; color_indic = Red; UP_46 = 0; DOWN_46 = 1; }
   ObjectCreate("Trend_ADX_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_240",ADX_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double ADX_plus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1440);
   double ADX_minus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1440);
   
   if ((ADX_plus_1440 > ADX_minus_1440)) { ADX_Trend_1440 = "UP"; x = 466; color_indic = Lime; UP_47 = 1; DOWN_47 = 0; }
   if ((ADX_plus_1440 < ADX_minus_1440)) { ADX_Trend_1440 = "DOWN"; x = 456; color_indic = Red; UP_47 = 0; DOWN_47 = 1; }
   ObjectCreate("Trend_ADX_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_1440",ADX_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double ADX_plus_10080=iADX(NULL,PERIOD_W1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_10080);
   double ADX_minus_10080=iADX(NULL,PERIOD_W1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_10080);
   
   if ((ADX_plus_10080 > ADX_minus_10080)) { ADX_Trend_10080 = "UP"; x = 466; color_indic = Lime; UP_48 = 1; DOWN_48 = 0; }
   if ((ADX_plus_10080 < ADX_minus_10080)) { ADX_Trend_10080 = "DOWN"; x = 456; color_indic = Red; UP_48 = 0; DOWN_48 = 1; }
   ObjectCreate("Trend_ADX_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_ADX_10080",ADX_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_ADX_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_ADX_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_ADX_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
// Indicator (BULLS)

   ObjectCreate("bulls", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("bulls","BULLS",9, "Verdana", color_ind);
   ObjectSet("bulls", OBJPROP_CORNER, 0);
   ObjectSet("bulls", OBJPROP_XDISTANCE, 503+add_x);
   ObjectSet("bulls", OBJPROP_YDISTANCE, -5+add_y);
   
   string BULLS_Trend_1, BULLS_Trend_5, BULLS_Trend_15, BULLS_Trend_30, BULLS_Trend_60, BULLS_Trend_240, BULLS_Trend_1440, BULLS_Trend_10080;
   
   double bulls_1=iBullsPower(NULL,PERIOD_M1,BULLSPeriod,BULLSPrice,shift_1);
   
   if ((bulls_1 > 0)) { BULLS_Trend_1 = "UP"; x = 516; color_indic = Lime; UP_49 = 1; DOWN_49 = 0; }
   if ((bulls_1 < 0)) { BULLS_Trend_1 = "DOWN"; x = 506; color_indic = Red; UP_49 = 0; DOWN_49 = 1; }
   ObjectCreate("Trend_BULLS_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_1",BULLS_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double bulls_5=iBullsPower(NULL,PERIOD_M5,BULLSPeriod,BULLSPrice,shift_5);
   
   if ((bulls_5 > 0)) { BULLS_Trend_5 = "UP"; x = 516; color_indic = Lime; UP_50 = 1; DOWN_50 = 0; }
   if ((bulls_5 < 0)) { BULLS_Trend_5 = "DOWN"; x = 506; color_indic = Red; UP_50 = 0; DOWN_50 = 1; }
   ObjectCreate("Trend_BULLS_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_5",BULLS_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double bulls_15=iBullsPower(NULL,PERIOD_M15,BULLSPeriod,BULLSPrice,shift_15);
   
   if ((bulls_15 > 0)) { BULLS_Trend_15 = "UP"; x = 516; color_indic = Lime; UP_51 = 1; DOWN_51 = 0; }
   if ((bulls_15 < 0)) { BULLS_Trend_15 = "DOWN"; x = 506; color_indic = Red; UP_51 = 0; DOWN_51 = 1; }
   ObjectCreate("Trend_BULLS_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_15",BULLS_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double bulls_30=iBullsPower(NULL,PERIOD_M30,BULLSPeriod,BULLSPrice,shift_30);
   
   if ((bulls_30 > 0)) { BULLS_Trend_30 = "UP"; x = 516; color_indic = Lime; UP_52 = 1; DOWN_52 = 0; }
   if ((bulls_30 < 0)) { BULLS_Trend_30 = "DOWN"; x = 506; color_indic = Red; UP_52 = 0; DOWN_52 = 1; }
   ObjectCreate("Trend_BULLS_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_30",BULLS_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double bulls_60=iBullsPower(NULL,PERIOD_H1,BULLSPeriod,BULLSPrice,shift_60);
   
   if ((bulls_60 > 0)) { BULLS_Trend_60 = "UP"; x = 516; color_indic = Lime; UP_53 = 1; DOWN_53 = 0; }
   if ((bulls_60 < 0)) { BULLS_Trend_60 = "DOWN"; x = 506; color_indic = Red; UP_53 = 0; DOWN_53 = 1; }
   ObjectCreate("Trend_BULLS_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_60",BULLS_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double bulls_240=iBullsPower(NULL,PERIOD_H4,BULLSPeriod,BULLSPrice,shift_240);
   
   if ((bulls_240 > 0)) { BULLS_Trend_240 = "UP"; x = 516; color_indic = Lime; UP_54 = 1; DOWN_54 = 0; }
   if ((bulls_240 < 0)) { BULLS_Trend_240 = "DOWN"; x = 506; color_indic = Red; UP_54 = 0; DOWN_54 = 1; }
   ObjectCreate("Trend_BULLS_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_240",BULLS_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double bulls_1440=iBullsPower(NULL,PERIOD_D1,BULLSPeriod,BULLSPrice,shift_1440);
   
   if ((bulls_1440 > 0)) { BULLS_Trend_1440 = "UP"; x = 516; color_indic = Lime; UP_55 = 1; DOWN_55 = 0; }
   if ((bulls_1440 < 0)) { BULLS_Trend_1440 = "DOWN"; x = 506; color_indic = Red; UP_55 = 0; DOWN_55 = 1; }
   ObjectCreate("Trend_BULLS_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_1440",BULLS_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double bulls_10080=iBullsPower(NULL,PERIOD_W1,BULLSPeriod,BULLSPrice,shift_10080);
   
   if ((bulls_10080 > 0)) { BULLS_Trend_10080 = "UP"; x = 516; color_indic = Lime; UP_56 = 1; DOWN_56 = 0; }
   if ((bulls_10080 < 0)) { BULLS_Trend_10080 = "DOWN"; x = 506; color_indic = Red; UP_56 = 0; DOWN_56 = 1; }
   ObjectCreate("Trend_BULLS_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BULLS_10080",BULLS_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_BULLS_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BULLS_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BULLS_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
// Indicator (BEARS)

   ObjectCreate("bears", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("bears","BEARS",9, "Verdana", color_ind);
   ObjectSet("bears", OBJPROP_CORNER, 0);
   ObjectSet("bears", OBJPROP_XDISTANCE, 553+add_x);
   ObjectSet("bears", OBJPROP_YDISTANCE, -5+add_y);
   
   string BEARS_Trend_1, BEARS_Trend_5, BEARS_Trend_15, BEARS_Trend_30, BEARS_Trend_60, BEARS_Trend_240, BEARS_Trend_1440, BEARS_Trend_10080;
   
   double bears_1=iBearsPower(NULL,PERIOD_M1,BEARSPeriod,BEARSPrice,shift_1);
   
   if ((bears_1 > 0)) { BEARS_Trend_1 = "UP"; x = 566; color_indic = Lime; UP_57 = 1; DOWN_57 = 0; }
   if ((bears_1 < 0)) { BEARS_Trend_1 = "DOWN"; x = 556; color_indic = Red; UP_57 = 0; DOWN_57 = 1; }
   ObjectCreate("Trend_BEARS_1", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_1",BEARS_Trend_1,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_1", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_1", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_1", OBJPROP_YDISTANCE, 22+add_y);
   
   double bears_5=iBearsPower(NULL,PERIOD_M5,BEARSPeriod,BEARSPrice,shift_5);
   
   if ((bears_5 > 0)) { BEARS_Trend_5 = "UP"; x = 566; color_indic = Lime; UP_58 = 1; DOWN_58 = 0; }
   if ((bears_5 < 0)) { BEARS_Trend_5 = "DOWN"; x = 556; color_indic = Red; UP_58 = 0; DOWN_58 = 1; }
   ObjectCreate("Trend_BEARS_5", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_5",BEARS_Trend_5,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_5", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_5", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_5", OBJPROP_YDISTANCE, 37+add_y);
   
   double bears_15=iBearsPower(NULL,PERIOD_M15,BEARSPeriod,BEARSPrice,shift_15);
   
   if ((bears_15 > 0)) { BEARS_Trend_15 = "UP"; x = 566; color_indic = Lime; UP_59 = 1; DOWN_59 = 0; }
   if ((bears_15 < 0)) { BEARS_Trend_15 = "DOWN"; x = 556; color_indic = Red; UP_59 = 0; DOWN_59 = 1; }
   ObjectCreate("Trend_BEARS_15", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_15",BEARS_Trend_15,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_15", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_15", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_15", OBJPROP_YDISTANCE, 52+add_y);
   
   double bears_30=iBearsPower(NULL,PERIOD_M30,BEARSPeriod,BEARSPrice,shift_30);
   
   if ((bears_30 > 0)) { BEARS_Trend_30 = "UP"; x = 566; color_indic = Lime; UP_60 = 1; DOWN_60 = 0; }
   if ((bears_30 < 0)) { BEARS_Trend_30 = "DOWN"; x = 556; color_indic = Red; UP_60 = 0; DOWN_60 = 1; }
   ObjectCreate("Trend_BEARS_30", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_30",BEARS_Trend_30,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_30", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_30", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_30", OBJPROP_YDISTANCE, 67+add_y);
   
   double bears_60=iBearsPower(NULL,PERIOD_H1,BEARSPeriod,BEARSPrice,shift_60);
   
   if ((bears_60 > 0)) { BEARS_Trend_60 = "UP"; x = 566; color_indic = Lime; UP_61 = 1; DOWN_61 = 0; }
   if ((bears_60 < 0)) { BEARS_Trend_60 = "DOWN"; x = 556; color_indic = Red; UP_61 = 0; DOWN_61 = 1; }
   ObjectCreate("Trend_BEARS_60", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_60",BEARS_Trend_60,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_60", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_60", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_60", OBJPROP_YDISTANCE, 82+add_y);
   
   double bears_240=iBearsPower(NULL,PERIOD_H4,BEARSPeriod,BEARSPrice,shift_240);
   
   if ((bears_240 > 0)) { BEARS_Trend_240 = "UP"; x = 566; color_indic = Lime; UP_62 = 1; DOWN_62 = 0; }
   if ((bears_240 < 0)) { BEARS_Trend_240 = "DOWN"; x = 556; color_indic = Red; UP_62 = 0; DOWN_62 = 1; }
   ObjectCreate("Trend_BEARS_240", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_240",BEARS_Trend_240,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_240", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_240", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_240", OBJPROP_YDISTANCE, 97+add_y);
   
   double bears_1440=iBearsPower(NULL,PERIOD_D1,BEARSPeriod,BEARSPrice,shift_1440);
   
   if ((bears_1440 > 0)) { BEARS_Trend_1440 = "UP"; x = 566; color_indic = Lime; UP_63 = 1; DOWN_63 = 0; }
   if ((bears_1440 < 0)) { BEARS_Trend_1440 = "DOWN"; x = 556; color_indic = Red; UP_63 = 0; DOWN_63 = 1; }
   ObjectCreate("Trend_BEARS_1440", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_1440",BEARS_Trend_1440,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_1440", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_1440", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_1440", OBJPROP_YDISTANCE, 112+add_y);
   
   /*
   double bears_10080=iBearsPower(NULL,PERIOD_W1,BEARSPeriod,BEARSPrice,shift_10080);
   
   if ((bears_10080 > 0)) { BEARS_Trend_10080 = "UP"; x = 566; color_indic = Lime; UP_64 = 1; DOWN_64 = 0; }
   if ((bears_10080 < 0)) { BEARS_Trend_10080 = "DOWN"; x = 556; color_indic = Red; UP_64 = 0; DOWN_64 = 1; }
   ObjectCreate("Trend_BEARS_10080", OBJ_LABEL, WindowFind("FerruFx_Trend+"), 0, 0);
   ObjectSetText("Trend_BEARS_10080",BEARS_Trend_10080,7, "Verdana", color_indic);
   ObjectSet("Trend_BEARS_10080", OBJPROP_CORNER, 0);
   ObjectSet("Trend_BEARS_10080", OBJPROP_XDISTANCE, x+add_x);
   ObjectSet("Trend_BEARS_10080", OBJPROP_YDISTANCE, 127+add_y);
   */
   
//---- Calculation of the trend
   
   double UP_m1 = (UP_1 + UP_9 + UP_17 + UP_25 + UP_33 + UP_41 + UP_49 + UP_57) * coef_m1;
   double UP_m5 = (UP_2 + UP_10 + UP_18 + UP_26 + UP_34 + UP_42 + UP_50 + UP_58) * coef_m5;
   double UP_m15 = (UP_3 + UP_11 + UP_19 + UP_27 + UP_35 + UP_43 + UP_51 + UP_59) * coef_m15;
   double UP_m30 = (UP_4 + UP_12 + UP_20 + UP_28 + UP_36 + UP_44 + UP_52 + UP_60) * coef_m30;
   double UP_H1 = (UP_5 + UP_13 + UP_21 + UP_29 + UP_37 + UP_45 + UP_53 + UP_61) * coef_H1;
   double UP_H4 = (UP_6 + UP_14 + UP_22 + UP_30 + UP_38 + UP_46 + UP_54 + UP_62) * coef_H4;
   double UP_D1 = (UP_7 + UP_15 + UP_23 + UP_31 + UP_39 + UP_47 + UP_55 + UP_63) * coef_D1;
   // double UP_W1 = (UP_8 + UP_16 + UP_24 + UP_32 + UP_40 + UP_48 + UP_56 + UP_64) * coef_W1;

   double Trend_UP = UP_m1 + UP_m5 + UP_m15 + UP_m30 + UP_H1 + UP_H4 + UP_D1 /* + UP_W1 */ ;
   
   double DOWN_m1 = (DOWN_1 + DOWN_9 + DOWN_17 + DOWN_25 + DOWN_33 + DOWN_41 + DOWN_49 + DOWN_57) * coef_m1;
   double DOWN_m5 = (DOWN_2 + DOWN_10 + DOWN_18 + DOWN_26 + DOWN_34 + DOWN_42 + DOWN_50 + DOWN_58) * coef_m5;
   double DOWN_m15 = (DOWN_3 + DOWN_11 + DOWN_19 + DOWN_27 + DOWN_35 + DOWN_43 + DOWN_51 + DOWN_59) * coef_m15;
   double DOWN_m30 = (DOWN_4 + DOWN_12 + DOWN_20 + DOWN_28 + DOWN_36 + DOWN_44 + DOWN_52 + DOWN_60) * coef_m30;
   double DOWN_H1 = (DOWN_5 + DOWN_13 + DOWN_21 + DOWN_29 + DOWN_37 + DOWN_45 + DOWN_53 + DOWN_61) * coef_H1;
   double DOWN_H4 = (DOWN_6 + DOWN_14 + DOWN_22 + DOWN_30 + DOWN_38 + DOWN_46 + DOWN_54 + DOWN_62) * coef_H4;
   double DOWN_D1 = (DOWN_7 + DOWN_15 + DOWN_23 + DOWN_31 + DOWN_39 + DOWN_47 + DOWN_55 + DOWN_63) * coef_D1;
   // double DOWN_W1 = (DOWN_8 + DOWN_16 + DOWN_24 + DOWN_32 + DOWN_40 + DOWN_48 + DOWN_56 + DOWN_64) * coef_W1;
   
   double Trend_DOWN = DOWN_m1 + DOWN_m5 + DOWN_m15 + DOWN_m30 + DOWN_H1 + DOWN_H4 + DOWN_D1 /*+ DOWN_W1*/ ;
                                  
   UPBuffer[0] = Trend_UP;
   DOWNBuffer[0] = Trend_DOWN;
   
      
   return(0);
  }