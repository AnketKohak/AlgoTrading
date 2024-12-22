//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include  <custom.mqh>

int magicNB = 55555;
double lotsize=0.01;
input int stop=50;
input int  take=50;

int openOrderIDb;
int openOrderIDb1;
int openOrderIDb2;

int openOrderIDs;
int openOrderIDs1;
int openOrderIDs2;
double stopLossPrice;
double takeProfitPrice;
double targetprice;
double highprofit;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("");
   Alert("Starting Strategy BB 2Bans MR");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Alert("Stopping Strategy BB 2Bans MR");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int target=1.20;
   double ma = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0);
   double atr = iATR(NULL,0,14,0);
   int  highest = iHighest(NULL,0,MODE_HIGH,14,0);
   int lowest  =iLowest(NULL,0,MODE_LOW,14,0);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(High[highest] <= Close[0] && ma<Bid)//buying
        {
         double stoploss;
         double takeprofit;

         stopLossPrice = Bid-(stop*pipvlaue());
         takeProfitPrice = Bid+(take*pipvlaue());
         openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Bid,10,0,0,NULL,magicNB);
         highprofit=-10;
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(Low[lowest] >= Close[0] && ma>Bid)
           {
            double stoploss=50;
            stopLossPrice = Bid+(stop*pipvlaue());
            takeProfitPrice = Bid-(take*pipvlaue());

            openOrderIDs = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            highprofit=-10;
            if(openOrderIDs < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else
      if(OrderSelect(0, SELECT_BY_POS)==true)
        {
         if(OrderType()==0)
           {

            if(OrderProfit()>=highprofit)
              {
               highprofit=OrderProfit();
               stopLossPrice=Bid-(50*pipvlaue());
               OrderModify(openOrderIDb,Bid,stopLossPrice,0,0);

              }

           }
         else
            if(OrderType()==1)
              {
               if(OrderProfit()>=highprofit)
                 {
                  highprofit=OrderProfit();
                  stopLossPrice=Bid+(50*pipvlaue());
                  OrderModify(openOrderIDs,Bid,stopLossPrice,0,0);

                 }
              }

        }



  }









//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
