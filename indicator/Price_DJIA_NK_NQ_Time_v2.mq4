//+------------------------------------------------------------------+
//|                                      Price_DJIA_NK_NQ_Time_.mq4  |
//|                                          Copyright   |
//|                                     http://orthodox.seesaa.net/  |
//+------------------------------------------------------------------+
//Orthodox_v2 USDJPY EURJPY GBPJPY éÊìæÉfÅ[É^èCê≥
#property copyright "Orthodox"
#property link      "http://orthodox.seesaa.net/"
#property indicator_chart_window

extern bool Remaining_Time = true;
extern bool DJIA_Price = true;
extern bool NK_Price = true;
extern bool NQ_Price = true;
extern bool USDJPY_Price = true;
extern bool EURJPY_Price = true;
extern bool GBPJPY_Price = true;
extern color Main_Price_Color = Chartreuse;
extern color Remaining_Time_Color = White;
extern color Sub_Price_Color = YellowGreen;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      ObjectsDeleteAll(0,OBJ_LABEL); 
//----
   return(0);
  }
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   bool Corner_of_Chart_RIGHT_TOP = true;
   int Shift_UP_DN =0; 
   int Adjust_Side_to_side  = 0;

   // Main_Price
   string Main_Price = DoubleToStr(Bid,Digits);  
   if (StringLen(Main_Price) == 4){
      double Main_Width;
      Main_Width = 82;
      }
   if (StringLen(Main_Price) == 5){
      Main_Width = 92;
      }
   if (StringLen(Main_Price) == 6){
      Main_Width = 110;
      }
   if (StringLen(Main_Price) == 7){
      Main_Width = 130;
      }
   ObjectCreate("Main_Price", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Main_Price", Main_Price, 27, "Arial", Main_Price_Color);
   ObjectSet("Main_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("Main_Price", OBJPROP_XDISTANCE, 1+Adjust_Side_to_side);
   ObjectSet("Main_Price", OBJPROP_YDISTANCE, Shift_UP_DN);

   // Remaining_Time
   if (Remaining_Time){   
      double Remaining_Time_Height;
      Remaining_Time_Height = 35;
      double g;
   	int m, s, k, h;
   	m = Time[0] + Period()*60 - TimeCurrent();
   	g = m/60.0;
   	s = m%60;
   	m = (m - m%60) / 60;
   	string text;
   	if (Period() <= PERIOD_H1) {
   		text = "écÇË" + m + "ï™" + s + "ïb";
   	}
   	else {
   		if (m >= 60) h = m/60;
   		else h = 0;
   		k = m - (h*60);
   		text = "écÇË" + h + "éûä‘" + k + "ï™" + s + "ïb";
   	}
   	ObjectCreate("Remaning_Time", OBJ_LABEL, 0, 0, 0);
   	ObjectSetText("Remaning_Time", text, 8, "Arisaka", Remaining_Time_Color);
      ObjectSet("Remaning_Time", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("Remaning_Time", OBJPROP_XDISTANCE, 3+Adjust_Side_to_side);
      ObjectSet("Remaning_Time", OBJPROP_YDISTANCE, Remaining_Time_Height+Shift_UP_DN);
   }

   // DJIA_Price
   if (DJIA_Price){
      double DJIA_Bid   =MarketInfo("YM_CONT",MODE_BID);
      int    DJIA_Digits=MarketInfo("YM_CONT",MODE_DIGITS);
      string DJIA_Price;
      DJIA_Price = DoubleToStr(DJIA_Bid,DJIA_Digits);  
      text = "DJIA: " + DJIA_Price;
      double DJIA_Price_Height;
      DJIA_Price_Height = 5;

      ObjectCreate("DJIA_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("DJIA_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("DJIA_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("DJIA_Price", OBJPROP_XDISTANCE, Main_Width+Adjust_Side_to_side);
      ObjectSet("DJIA_Price", OBJPROP_YDISTANCE, DJIA_Price_Height+Shift_UP_DN); 
   }

   // NK_Price
   if (NK_Price){
      double NK_Bid   =MarketInfo("NKD_CONT",MODE_BID);
      int    NK_Digits=MarketInfo("NKD_CONT",MODE_DIGITS);
      string NK_Price;
      NK_Price = DoubleToStr(NK_Bid,NK_Digits);  
      text = "NK: " + NK_Price;
      double NK_Price_Height;
      NK_Price_Height = 9;

      ObjectCreate("NK_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("NK_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("NK_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("NK_Price", OBJPROP_XDISTANCE, Main_Width+Adjust_Side_to_side);
      ObjectSet("NK_Price", OBJPROP_YDISTANCE, NK_Price_Height+DJIA_Price_Height+Shift_UP_DN); 
   }

   // NQ_Price
   if (NQ_Price){
      double NQ_Bid   =MarketInfo("NQ_CONT",MODE_BID);
      int    NQ_Digits=MarketInfo("NQ_CONT",MODE_DIGITS);
      string NQ_Price;
      NQ_Price = DoubleToStr(NQ_Bid,NQ_Digits);  
      text = "NQ: " + NQ_Price;
      double NQ_Price_Height;
      NQ_Price_Height = 9;

      ObjectCreate("NQ_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("NQ_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("NQ_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("NQ_Price", OBJPROP_XDISTANCE, Main_Width+Adjust_Side_to_side);
      ObjectSet("NQ_Price", OBJPROP_YDISTANCE, NQ_Price_Height+NK_Price_Height+DJIA_Price_Height+Shift_UP_DN); 
   }

   // USDJPY_Price
   if (USDJPY_Price){
      double USDJPY_Bid   =MarketInfo("USDJPY",MODE_BID);
      int    USDJPY_Digits=MarketInfo("USDJPY",MODE_DIGITS);
      string USDJPY_Price;
      USDJPY_Price = DoubleToStr(USDJPY_Bid,USDJPY_Digits);  
      text = "USDJPY: " + USDJPY_Price;
      double USDJPY_Price_Height ,USDJPY_Price_Width;
      USDJPY_Price_Height = 5;
      USDJPY_Price_Width = 62;
      
      ObjectCreate("USDJPY_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("USDJPY_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("USDJPY_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("USDJPY_Price", OBJPROP_XDISTANCE, USDJPY_Price_Width+Main_Width+Adjust_Side_to_side);
      ObjectSet("USDJPY_Price", OBJPROP_YDISTANCE, USDJPY_Price_Height+Shift_UP_DN); 
   }
   // EURJPY_Price
   if (EURJPY_Price){
      double EURJPY_Bid   =MarketInfo("EURJPY",MODE_BID);
      int    EURJPY_Digits=MarketInfo("EURJPY",MODE_DIGITS);
      string EURJPY_Price;
      EURJPY_Price = DoubleToStr(EURJPY_Bid,EURJPY_Digits);  
      text = "EURJPY: " + EURJPY_Price;
      double EURJPY_Price_Height ,EURJPY_Price_Width;
      EURJPY_Price_Height = 9;
      EURJPY_Price_Width = 62;
      
      ObjectCreate("EURJPY_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("EURJPY_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("EURJPY_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("EURJPY_Price", OBJPROP_XDISTANCE, EURJPY_Price_Width+Main_Width+Adjust_Side_to_side);
      ObjectSet("EURJPY_Price", OBJPROP_YDISTANCE, EURJPY_Price_Height+USDJPY_Price_Height+Shift_UP_DN); 
   }
   // GBPJPY_Price
   if (GBPJPY_Price){
      double GBPJPY_Bid   =MarketInfo("GBPJPY",MODE_BID);
      int    GBPJPY_Digits=MarketInfo("GBPJPY",MODE_DIGITS);
      string GBPJPY_Price;
      GBPJPY_Price = DoubleToStr(GBPJPY_Bid,GBPJPY_Digits);  
      text = "GBPJPY: " + GBPJPY_Price;
      double GBPJPY_Price_Height ,GBPJPY_Price_Width;
      GBPJPY_Price_Height = 9;
      GBPJPY_Price_Width = 62;
      
      ObjectCreate("GBPJPY_Price", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("GBPJPY_Price",text, 8, "Arial", Sub_Price_Color);
      ObjectSet("GBPJPY_Price", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("GBPJPY_Price", OBJPROP_XDISTANCE, GBPJPY_Price_Width+Main_Width+Adjust_Side_to_side);
      ObjectSet("GBPJPY_Price", OBJPROP_YDISTANCE, GBPJPY_Price_Height+EURJPY_Price_Height+USDJPY_Price_Height+Shift_UP_DN); 

   }
   return(0);
}
//+------------------------------------------------------------------+