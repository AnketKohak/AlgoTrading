//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
// Define input parameters
// Define input parameters
// Define input parameters
int redCandleCount = 0;    // Variable to count red candles
int greenCandleCount = 0;  // Variable to count green candles
int maPeriod = 200;         // Period for the moving average
double maValue;            // Value of the moving average
bool countedCandle = false; // Variable to avoid multiple counting
datetime premin= 0;
bool gc2=Open[2]<Close[2];
bool gc1=Open[1]<Close[1];
bool rc2=Open[2]>Close[2];
bool rc1=Open[1]>Close[1];



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime min=Minute();
// Calculate the moving average value
   maValue = iMA(Symbol(), PERIOD_M1, maPeriod, 0, MODE_SMA, PRICE_CLOSE,2);

// Check the current candle's color and its position relative to the moving average
   if(Open[2]>Close[2] && Open[1]>Close[1] && premin!=min)
     {
      premin=min;
      redCandleCount++;
     }
   else
      if(Open[2]<Close[2] &&Open[1]<Close[1] &&premin!=min)
        {
         premin=min;
         greenCandleCount++;
        }

// Do something with the counts
   Comment("Previous Red Candles: ", redCandleCount,"\n",
           "Previous Green Candles: ", greenCandleCount);
  }
//+------------------------------------------------------------------+
