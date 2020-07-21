//+------------------------------------------------------------------+
//|                                                       nyoron.mq4 |
//|                           Copyright (c) 2010, Fai Software Corp. |
//|                                    http://d.hatena.ne.jp/fai_fx/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010, Fai Software Corp."
#property link      "http://d.hatena.ne.jp/fai_fx/"

#property indicator_chart_window
// http://useyan.x0.com/s/html/mono-font.htm 等幅フォントの例
extern string FontName = "ＭＳ Ｐゴシック";  //"ＭＳ ゴシック"　"ＭＳ 明朝" "HG行書体" "GungsuhChe"
extern color  FontColor = White; 
extern int    FontSize = 12;   
extern int    LineSpace = 4;//行間

extern int    XShift = 350;//オブジェクト群の左側スペース
extern int    YShift = 10;//オブジェクト群の上側スペース

extern int    BlockShift = 0;// 60文字毎のブロックの配置ズレ調整用

// OS によって60文字ブロックのサイズが違うので要注意。
// フォントサイズ 7～18 を想定。

// for Vista
//int BlockSize[] = {0,1,2,3,4,5,6,360,420,480,480,540,600,660,720,780,780,840,900};

// for WindowsXP
int BlockSize[] = {0,1,2,3,4,5,6,300/*7*/,300,300,420/*10*/,420,480,540,540/*14*/,600,660,660,720/*18*/};

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if(FontSize > 18 ) FontSize = 18;
   if(FontSize <  7 ) FontSize =  7;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   DelObj();
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
string msg = 
"　　　　　　　　　　 　 -‐ '´￣￣｀ヽ､"+"\n"+
"　　 　 　 　 　 　 ／　／\" ｀ヽ ヽ　　＼"+"\n"+
"　　　　　　　　　//, '/　　　　 ヽﾊ 　､　ヽ"+"\n"+
"　　　　　　　　 〃 {_{　　　 　　　ﾘ| ｌ.│ i| 　に"+"\n"+
"　　　　　　　　 ﾚ!小ｌノ　　　 ｀ヽ 从　|、i|　　ょ"+"\n"+
"　　　　　　　 　 ヽ|l　●　　　●　 |　.|ﾉ│　 ろ"+"\n"+
"　 　 　 　　　　　 |ﾍ⊃ ､_,､_,⊂⊃j 　|　, |.　　l"+"\n"+
"　　　　　　　　　　|　/⌒l,､ __,　イァト |/ |　 ん"+"\n"+
".　　　　　　　　　 | /　 /::|三/::/／　 ヽ |"+"\n"+
"　　　　　　　　　 | |　　l ヾ∨:::/ ヒ::::彡, |";

CommentOBJ(msg);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// 改行で区切って処理する。
string CommentOBJ(string msg){
   DelObj();
   int start = 0;
   int i = 0;
   msg = msg + "\n";
   string msg_unit;
   while(i<500){  // 500行以下を想定
      int n = StringFind(msg,"\n",start);
      if(n!=-1){
         if(n-start > 0){
            msg_unit = StringSubstr(msg,start, n-start);
         }else{
            msg_unit =" ";
         }
         start = n+1;
         //Print(start," ",n," ",msg_unit);
         DrawTXTLine("TXT-"+i,msg_unit,XShift,YShift+i*FontSize+i*LineSpace);
      }else{
         break;
      }
      i++;
   }
}
//+------------------------------------------------------------------+
// TXT- で始まるオブジェクトを全削除する
void DelObj(){
   string objname;
   for(int i=ObjectsTotal();i>=0;i--){
      objname = ObjectName(i);
      if( StringFind(objname,"TXT-")>=0) ObjectDelete(objname);
   }
}
//+------------------------------------------------------------------+
// 60文字毎に区切ってラベルオブジェクトを作成する。
void DrawTXTLine(string objname, string msg, int X, int Y)   
{   
   int len = StringLen(msg);
   for(int i=0;i*60<len;i++){
      string submsg = StringSubstr(msg,60*i,60);
      ObjectCreate(objname+i,OBJ_LABEL,0,0,0);   
      ObjectSet(objname+i,OBJPROP_XDISTANCE, X+(BlockSize[FontSize]+BlockShift)*i);   
      ObjectSet(objname+i,OBJPROP_YDISTANCE, Y);  
      ObjectSetText(objname+i,submsg,FontSize,FontName,FontColor);   
   }
}  
//+------------------------------------------------------------------+

