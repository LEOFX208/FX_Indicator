<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- saved from url=(0037)http://codebase.mql4.com/source/24158 -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   
   <meta name="DESCRIPTION" content="MultiMA.mq4 - MQL4 Code Base: expert advisors, custom indicators, scripts and libraries">
   <meta name="KEYWORDS" content="MultiMA.mq4 mql4 automated forex trading strategy tester MetaTrader MetaQuotes language Code Base Expert advisors, custom indicators, scripts and libraries">
   <title>MultiMA.mq4 - MQL4 Code Base</title>
   <link href="http://codebase.mql4.com/fav/codebase.ico" rel="icon" type="image/x-icon">

   <link href="./MultiMA.mq4 - MQL4 Code Base_files/s.u1268217226.css" rel="stylesheet" type="text/css">
</head>
<body>
<pre class="code2"><span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-comment">//|                                                      MultiMA.mq4 |</span>
<span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">copyright</span> <span class="hl-quotes">"</span><span class="hl-string">karceWZROKIEM</span><span class="hl-quotes">"</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">link</span>      <span class="hl-quotes">"</span><span class="hl-string">http://www.gkma.pl</span><span class="hl-quotes">"</span><span class="hl-prepro"></span>
<span class="hl-comment">//---- indicator settings</span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_chart_window</span><span class="hl-prepro"></span>
<span class="hl-comment">//#property  indicator_separate_window</span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_buffers</span> <span class="hl-number">8</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color1</span>  <span class="hl-identifier">Black</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width1</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color2</span>  <span class="hl-identifier">Black</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_style2</span>  <span class="hl-consts">STYLE_DOT</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width2</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color3</span>  <span class="hl-identifier">Red</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width3</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color4</span>  <span class="hl-identifier">Green</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width4</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color5</span>  <span class="hl-identifier">Red</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width5</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color6</span>  <span class="hl-identifier">Green</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width6</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color7</span>  <span class="hl-identifier">Red</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width7</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
 
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_color8</span>  <span class="hl-identifier">Red</span><span class="hl-prepro"></span>
<span class="hl-prepro">#property</span>  <span class="hl-reserved">indicator_width8</span>  <span class="hl-number">1</span><span class="hl-prepro"></span>
<span class="hl-comment">//---- indicator parameters</span>
<span class="hl-reserved">extern</span> <span class="hl-reserved">int</span> <span class="hl-identifier">MA_Period</span><span class="hl-code">=</span><span class="hl-number">233</span><span class="hl-code">;
 
</span><span class="hl-comment">//---- indicator buffers</span>
<span class="hl-reserved">double</span>     <span class="hl-identifier">MABuffer</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer2</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer3</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer4</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer5</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer6</span><span class="hl-brackets">[]</span><span class="hl-code">;
</span><span class="hl-reserved">double</span>     <span class="hl-identifier">MAMABuffer7</span><span class="hl-brackets">[]</span><span class="hl-code">;
 
</span><span class="hl-reserved">int</span> <span class="hl-identifier">ExtCountedBars</span><span class="hl-code">, </span><span class="hl-identifier">limit</span><span class="hl-code">;
 
</span><span class="hl-reserved">int</span> <span class="hl-identifier">WEIGHTS</span><span class="hl-brackets">[</span><span class="hl-number">10</span><span class="hl-brackets">][</span><span class="hl-number">9</span><span class="hl-brackets">]</span><span class="hl-code"> =</span><span class="hl-brackets">{</span>
                     <span class="hl-number">0</span><span class="hl-code">, </span><span class="hl-number">0</span><span class="hl-code">, </span><span class="hl-number">0</span><span class="hl-code"> ,</span><span class="hl-number">0</span><span class="hl-code"> ,</span><span class="hl-number">0</span><span class="hl-code"> ,</span><span class="hl-number">0</span><span class="hl-code"> ,</span><span class="hl-number">0</span><span class="hl-code"> ,</span><span class="hl-number">0</span><span class="hl-code"> , </span><span class="hl-number">0</span><span class="hl-code">,
                     </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, 
                     </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-number">08</span><span class="hl-code">, 
                     </span><span class="hl-brackets">}</span><span class="hl-code">;
</span><span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-comment">//| Custom indicator initialization function                         |</span>
<span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-reserved">int</span> <span class="hl-identifier">init</span><span class="hl-brackets">()</span>
  <span class="hl-brackets">{</span>
<span class="hl-comment">//---- indicators</span>
   <span class="hl-predfunc">IndicatorBuffers</span><span class="hl-brackets">(</span><span class="hl-number">8</span><span class="hl-brackets">)</span><span class="hl-code">;
</span><span class="hl-comment">//---- drawing settings</span>
   <span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">1</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">2</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">3</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">4</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">5</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">6</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexStyle</span><span class="hl-brackets">(</span><span class="hl-number">7</span><span class="hl-code">,</span><span class="hl-consts">DRAW_LINE</span><span class="hl-brackets">)</span><span class="hl-code">;
 
   </span><span class="hl-predfunc">IndicatorDigits</span><span class="hl-brackets">(</span><span class="hl-predvars">Digits</span><span class="hl-code">+</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-reserved">if</span><span class="hl-brackets">(</span><span class="hl-identifier">MA_Period</span><span class="hl-code">&lt;</span><span class="hl-number">2</span><span class="hl-brackets">)</span> <span class="hl-identifier">MA_Period</span><span class="hl-code">=</span><span class="hl-number">13</span><span class="hl-code">;
   
   </span><span class="hl-predfunc">SetIndexDrawBegin</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-code">,</span><span class="hl-identifier">MA_Period</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
</span><span class="hl-comment">//---- indicator buffers mapping</span>
   <span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-code">, </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">1</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">2</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer2</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">3</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer3</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">4</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer4</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">5</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer5</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">6</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer6</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexBuffer</span><span class="hl-brackets">(</span><span class="hl-number">7</span><span class="hl-code">, </span><span class="hl-identifier">MAMABuffer7</span><span class="hl-brackets">)</span><span class="hl-code">;
</span><span class="hl-comment">//---- name for DataWindow and indicator subwindow label</span>
   <span class="hl-predfunc">IndicatorShortName</span><span class="hl-brackets">(</span><span class="hl-quotes">"</span><span class="hl-string">MultiMA(</span><span class="hl-quotes">"</span><span class="hl-code">+</span><span class="hl-identifier">MA_Period</span><span class="hl-code">+</span><span class="hl-quotes">"</span><span class="hl-string">)</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
</span><span class="hl-comment">//---- initialization done</span>
   <span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">MA</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">1</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">MAMA</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">2</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 0.2364</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">3</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 0.3824</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">4</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 0.5000</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">5</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 0.6180</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">6</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 1,3820</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-predfunc">SetIndexLabel</span><span class="hl-brackets">(</span><span class="hl-number">7</span><span class="hl-code">,</span><span class="hl-quotes">"</span><span class="hl-string">Fib 1.6180</span><span class="hl-quotes">"</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-reserved">return</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-brackets">)</span><span class="hl-code">;
  </span><span class="hl-brackets">}</span>
<span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-comment">//| Moving Averages Convergence/Divergence                           |</span>
<span class="hl-comment">//+------------------------------------------------------------------+</span>
<span class="hl-reserved">int</span> <span class="hl-identifier">start</span><span class="hl-brackets">()</span>
  <span class="hl-brackets">{</span>
   <span class="hl-reserved">int</span> <span class="hl-identifier">timeframe</span><span class="hl-code">;
   </span><span class="hl-reserved">double</span> <span class="hl-identifier">w</span><span class="hl-code">, </span><span class="hl-identifier">pip</span><span class="hl-code">;
   </span><span class="hl-reserved">int</span> <span class="hl-identifier">ShiftC</span><span class="hl-code">, </span><span class="hl-identifier">ShiftP</span><span class="hl-code">;
 
   </span><span class="hl-reserved">int</span> <span class="hl-identifier">MAtrend</span><span class="hl-code"> = </span><span class="hl-number">0</span><span class="hl-code">;
   
   </span><span class="hl-reserved">double</span> <span class="hl-identifier">MAc</span><span class="hl-code">, </span><span class="hl-identifier">MAp</span><span class="hl-code">;
   </span><span class="hl-reserved">if</span><span class="hl-brackets">(</span><span class="hl-predvars">Bars</span><span class="hl-code">&lt;=</span><span class="hl-identifier">MA_Period</span><span class="hl-brackets">)</span> <span class="hl-reserved">return</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-brackets">)</span><span class="hl-code">;
   
   </span><span class="hl-identifier">ExtCountedBars</span><span class="hl-code">=</span><span class="hl-predfunc">IndicatorCounted</span><span class="hl-brackets">()</span><span class="hl-code">;
</span><span class="hl-comment">//---- check for possible errors</span>
   <span class="hl-reserved">if</span> <span class="hl-brackets">(</span><span class="hl-identifier">ExtCountedBars</span><span class="hl-code">&lt;</span><span class="hl-number">0</span><span class="hl-brackets">)</span> <span class="hl-reserved">return</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
</span><span class="hl-comment">//---- last counted bar will be recounted</span>
   <span class="hl-reserved">if</span> <span class="hl-brackets">(</span><span class="hl-identifier">ExtCountedBars</span><span class="hl-code">&gt;</span><span class="hl-number">0</span><span class="hl-brackets">)</span> <span class="hl-identifier">ExtCountedBars</span><span class="hl-code">--;
</span><span class="hl-comment">//----</span>
   <span class="hl-identifier">limit</span><span class="hl-code">=</span><span class="hl-predvars">Bars</span><span class="hl-code">-</span><span class="hl-identifier">ExtCountedBars</span><span class="hl-code">;
   </span><span class="hl-comment">//mit=500;</span>
   <span class="hl-reserved">for</span><span class="hl-brackets">(</span><span class="hl-reserved">int</span> <span class="hl-identifier">i</span><span class="hl-code">=</span><span class="hl-number">0</span><span class="hl-code">; </span><span class="hl-identifier">i</span><span class="hl-code">&lt;</span><span class="hl-identifier">limit</span><span class="hl-code">; </span><span class="hl-identifier">i</span><span class="hl-code">++</span><span class="hl-brackets">)</span>
   <span class="hl-brackets">{</span>
      <span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-tech_inds">iMA</span><span class="hl-brackets">(</span><span class="hl-consts">NULL</span><span class="hl-code">, </span><span class="hl-number">0</span><span class="hl-code">, </span><span class="hl-identifier">MA_Period</span><span class="hl-code">, </span><span class="hl-number">0</span><span class="hl-code">, </span><span class="hl-consts">MODE_SMA</span><span class="hl-code">, </span><span class="hl-consts">PRICE_CLOSE</span><span class="hl-code">, </span><span class="hl-identifier">i</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-number">0</span><span class="hl-code">;
      </span><span class="hl-identifier">w</span><span class="hl-code">=</span><span class="hl-number">0</span><span class="hl-code">;
      </span><span class="hl-identifier">pip</span><span class="hl-code">=</span><span class="hl-number">1</span><span class="hl-code">;
      </span><span class="hl-reserved">for</span><span class="hl-brackets">(</span><span class="hl-reserved">int</span> <span class="hl-identifier">ii</span><span class="hl-code">=</span><span class="hl-number">1</span><span class="hl-code">; </span><span class="hl-identifier">ii</span><span class="hl-code">&lt;</span><span class="hl-number">5</span><span class="hl-code">; </span><span class="hl-identifier">ii</span><span class="hl-code">++</span><span class="hl-brackets">)</span>
      <span class="hl-reserved">if</span><span class="hl-brackets">(</span><span class="hl-identifier">int2period</span><span class="hl-brackets">(</span><span class="hl-identifier">ii</span><span class="hl-brackets">)</span><span class="hl-code"> != </span><span class="hl-predfunc">Period</span><span class="hl-brackets">())</span>
      <span class="hl-brackets">{</span>
         <span class="hl-identifier">timeframe</span><span class="hl-code"> = </span><span class="hl-identifier">int2period</span><span class="hl-brackets">(</span><span class="hl-identifier">ii</span><span class="hl-brackets">)</span><span class="hl-code">;
         
         </span><span class="hl-identifier">ShiftC</span><span class="hl-code"> = </span><span class="hl-tech_inds">iBarShift</span><span class="hl-brackets">(</span><span class="hl-consts">NULL</span><span class="hl-code">,</span><span class="hl-identifier">timeframe</span><span class="hl-code">,</span><span class="hl-predvars">Time</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">;
         </span><span class="hl-comment">//ShiftP = iBarShift(NULL,timeframe,Time[i+1]);</span>
         <span class="hl-comment">//ShiftP = ShiftC +1;</span>
 
         <span class="hl-identifier">MAc</span><span class="hl-code"> = </span><span class="hl-tech_inds">iMA</span><span class="hl-brackets">(</span><span class="hl-consts">NULL</span><span class="hl-code">,</span><span class="hl-identifier">timeframe</span><span class="hl-code">,</span><span class="hl-identifier">MA_Period</span><span class="hl-code">,</span><span class="hl-number">0</span><span class="hl-code">,</span><span class="hl-consts">MODE_SMA</span><span class="hl-code">,</span><span class="hl-consts">PRICE_CLOSE</span><span class="hl-code">,</span><span class="hl-identifier">ShiftC</span><span class="hl-brackets">)</span><span class="hl-code">;
         </span><span class="hl-identifier">MAp</span><span class="hl-code"> = </span><span class="hl-tech_inds">iMA</span><span class="hl-brackets">(</span><span class="hl-consts">NULL</span><span class="hl-code">,</span><span class="hl-identifier">timeframe</span><span class="hl-code">,</span><span class="hl-identifier">MA_Period</span><span class="hl-code">,</span><span class="hl-number">0</span><span class="hl-code">,</span><span class="hl-consts">MODE_SMA</span><span class="hl-code">,</span><span class="hl-consts">PRICE_CLOSE</span><span class="hl-code">,</span><span class="hl-identifier">ShiftP</span><span class="hl-brackets">)</span><span class="hl-code">;
      
         </span><span class="hl-comment">//if(MAc&gt;MAp)             MAtrend = 1;   else MAtrend = -1;</span>
         
         <span class="hl-comment">//pip = WEIGHTS[period2int(Period())][ii];</span>
         <span class="hl-comment">//pip = Point/MathAbs( (MAc-iClose(NULL,timeframe,ShiftC)) ) * (1+MathAbs(iHigh(NULL,timeframe,ShiftC)-iLow(NULL,timeframe,ShiftC))) ;</span>
         <span class="hl-identifier">pip</span><span class="hl-code"> = </span><span class="hl-identifier">pip</span><span class="hl-code">*</span><span class="hl-number">1.50</span><span class="hl-code">;
         </span><span class="hl-identifier">w</span><span class="hl-code"> += </span><span class="hl-identifier">pip</span><span class="hl-code">;
         </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> += </span><span class="hl-identifier">MAc</span><span class="hl-code"> * </span><span class="hl-identifier">pip</span><span class="hl-code">;
      </span><span class="hl-brackets">}</span>
 
      <span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> /= </span><span class="hl-identifier">w</span><span class="hl-code">;
      </span><span class="hl-comment">//MABuffer2[i] = (MABuffer[i] + MAMABuffer[i])/2;</span>
      <span class="hl-identifier">MAMABuffer2</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">0.2360</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer3</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">0.3820</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer4</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">0.5000</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer5</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">0.6180</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer6</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">1.3820</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-identifier">MAMABuffer7</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> = </span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> + </span><span class="hl-brackets">(</span><span class="hl-identifier">MABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">]</span><span class="hl-code"> - </span><span class="hl-identifier">MAMABuffer</span><span class="hl-brackets">[</span><span class="hl-identifier">i</span><span class="hl-brackets">])</span><span class="hl-code">* </span><span class="hl-number">1.6180</span><span class="hl-code"> *</span><span class="hl-brackets">(</span><span class="hl-code">-</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-brackets">}</span>
   <span class="hl-comment">//for(i=0; i&lt;limit; i++)</span>
   <span class="hl-comment">//{</span>
   <span class="hl-comment">//   Buffer1[i]=iMAOnArray(Buffer,Bars,MAsmooth1,0,MODE_SMA,i);</span>
   <span class="hl-comment">//   Buffer2[i]=iMAOnArray(Buffer,Bars,MAsmooth2,0,MODE_SMA,i);</span>
   <span class="hl-comment">//}</span>
 
 
<span class="hl-comment">//----</span>
   <span class="hl-reserved">return</span><span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-brackets">)</span><span class="hl-code">;
  </span><span class="hl-brackets">}</span>
<span class="hl-comment">//+------------------------------------------------------------------+</span>
 
 
<span class="hl-reserved">double</span> <span class="hl-identifier">int2period</span><span class="hl-brackets">(</span><span class="hl-reserved">int</span> <span class="hl-identifier">cnt</span><span class="hl-brackets">)</span>
<span class="hl-brackets">{</span>
   <span class="hl-reserved">switch</span><span class="hl-brackets">(</span><span class="hl-identifier">cnt</span><span class="hl-brackets">)</span>
   <span class="hl-brackets">{</span>
      <span class="hl-reserved">case</span> <span class="hl-number">1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_M1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">2</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_M5</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">3</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_M15</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">4</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_M30</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">5</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_H1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">6</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_H4</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">7</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_D1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">8</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_W1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-number">9</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-consts">PERIOD_MN1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">default</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-brackets">}</span>
<span class="hl-brackets">}</span>
<span class="hl-reserved">int</span> <span class="hl-identifier">period2int</span><span class="hl-brackets">(</span><span class="hl-reserved">double</span> <span class="hl-identifier">cnt</span><span class="hl-brackets">)</span>
<span class="hl-brackets">{</span>
   <span class="hl-reserved">switch</span><span class="hl-brackets">(</span><span class="hl-identifier">cnt</span><span class="hl-brackets">)</span>
   <span class="hl-brackets">{</span>
      <span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_M1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">1</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_M5</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">2</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_M15</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">3</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_M30</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">4</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_H1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">5</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_H4</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">6</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_D1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">7</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_W1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">8</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">case</span> <span class="hl-consts">PERIOD_MN1</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">9</span><span class="hl-brackets">)</span><span class="hl-code">;
      </span><span class="hl-reserved">default</span><span class="hl-code">:
         </span><span class="hl-reserved">return</span> <span class="hl-brackets">(</span><span class="hl-number">0</span><span class="hl-brackets">)</span><span class="hl-code">;
   </span><span class="hl-brackets">}</span>
<span class="hl-brackets">}</span></pre>
</body></html>