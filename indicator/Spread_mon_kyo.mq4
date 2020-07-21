//+---------------------------------------------------------------+
//|                                            Spread_mon_kyo.mq4 |
//| 2010/02/27 by kyojee                                          |
//+---------------------------------------------------------------+
#property copyright "Copyright(c) 2009-2010, kyojee"
#property link      "http://kyojee.ps.land.to/"

#property indicator_separate_window
//---- input parameters
extern bool Logon = false;
extern string suffix_str = "";

string Currencies[] = {"AUDUSD","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP",
                       "EURJPY","EURUSD","GBPCHF","GBPJPY","GBPUSD","USDCAD",
                       "USDCHF","USDJPY"};
int      Vol, Spr, Lfp;
double   Pair[14];
string   Lofile;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorShortName("Spread_mon_kyo");
   for (int i = 0; i < ArraySize(Currencies); i++) {
      Pair[i] = 0;
   }
   Vol = 0;
   if (Logon) {
      Lofile = "Spr_mon_kyo" + TimeToStr(TimeCurrent(),TIME_DATE) + ".csv";
      Lfp = FileOpen(Lofile, FILE_CSV|FILE_WRITE, ';');
      if (Lfp < 0) {
         Print(Lofile + " could not make log_file: ", GetLastError());
         return (-1);
      } else {
         FileWrite(Lfp,"Time","AUDUSD","CHFJPY","EURAUD","EURCAD","EURCHF","EURGBP",
                              "EURJPY","EURUSD","GBPCHF","GBPJPY","GBPUSD","USDCAD",
                              "USDCHF","USDJPY");
         FileFlush(Lfp);
      }
   }
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
  for (int i = 0; i < ArraySize(Currencies); i++) {
     delete_text(Currencies[i] + suffix_str);
     delete_text(Currencies[i] + suffix_str + "2");
     delete_text("Log");
     delete_text("Log2");
  }
  if (Lfp > 0) {
        FileClose(Lfp);
  }
  return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int      i, siz;
   string   spm[14];
   siz = ArraySize(Currencies);

   if (Newbar()) {
      if (Vol != 0  && Logon) {
         for (i = 0; i < siz; i++) {
            //Print(Currencies[i] + suffix_str + ":", DoubleToStr(Pair[i] / Vol, 2), "  vol:", Vol);
            spm[i] = DoubleToStr(Pair[i] / Vol, 2);
         }
         FileWrite(Lfp, TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS),
            spm[0],spm[1],spm[2],spm[3],spm[4],spm[5],spm[6],
            spm[7],spm[8],spm[9],spm[10],spm[11],spm[12],spm[13]
         );
         FileFlush(Lfp);
         // Print(TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
      }
      Vol = 0;
      for (i = 0; i < siz; i++) {
         Pair[i] = 0;
      }
   } else {
      for (i = 0; i < siz; i++) {
         Spr = MarketInfo(Currencies[i] + suffix_str, MODE_SPREAD);
         disp_text("Log", 100, 2);
         disp_spread(Currencies[i] + suffix_str, (i % 7) * 90 + 20, 18 + 12 * MathFloor(i / 7));
         sum_cur(Currencies[i] + suffix_str, i);      
      }
      Vol += 1;
   }
   return(0);
}

void sum_cur(string cur, int i)
{
   Pair[i] += Spr;
   // Print(cur+ ":",i,": ", Pair[i]);
}

void disp_spread(string cur, int x, int y)
{
   ObjectCreate(cur, OBJ_LABEL, WindowFind("Spread_mon_kyo"), 0, 0);
   ObjectSetText(cur, cur + " : ", 9, "Arial Bold", LightGray);
   ObjectSet(cur, OBJPROP_CORNER, 0);
   ObjectSet(cur, OBJPROP_XDISTANCE, x);
   ObjectSet(cur, OBJPROP_YDISTANCE, y);

   ObjectCreate(cur + "2", OBJ_LABEL, WindowFind("Spread_mon_kyo"), 0, 0);
   ObjectSetText(cur + "2", DoubleToStr(Spr,0), 9, "Arial Bold", Lime);
   ObjectSet(cur + "2", OBJPROP_CORNER, 0);
   ObjectSet(cur + "2", OBJPROP_XDISTANCE, x + 65);
   ObjectSet(cur + "2", OBJPROP_YDISTANCE, y);
}

void disp_text(string cur, int x, int y)
{
   ObjectCreate(cur, OBJ_LABEL, WindowFind("Spread_mon_kyo"), 0, 0);
   ObjectSetText(cur, cur + " : ", 9, "Arial Bold", LightGray);
   ObjectSet(cur, OBJPROP_CORNER, 0);
   ObjectSet(cur, OBJPROP_XDISTANCE, x);
   ObjectSet(cur, OBJPROP_YDISTANCE, y);

   ObjectCreate(cur + "2", OBJ_LABEL, WindowFind("Spread_mon_kyo"), 0, 0);
   if (Logon) {
      ObjectSetText(cur + "2", "On", 9, "Arial Bold", Red);
   } else {
      ObjectSetText(cur + "2", "Off", 9, "Arial Bold", Gray);
   }
   ObjectSet(cur + "2", OBJPROP_CORNER, 0);
   ObjectSet(cur + "2", OBJPROP_XDISTANCE, x + 40);
   ObjectSet(cur + "2", OBJPROP_YDISTANCE, y);
}

void delete_text(string cur) {
   ObjectDelete(cur);
}

bool Newbar()
{
   static datetime dt = 0;
   if (iTime(NULL, PERIOD_M1, 0) != dt)
   {
      dt = iTime(NULL, PERIOD_M1, 0);
      return(true);
   }
   return(false);
}