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

int openOrderID;

double stopLossPrice;
double takeProfitPrice;
double targetprice;
double highprofit;
input int tralingstoploss=50;
input int day=0;
int a=1;
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
   int  highest = iHighest(NULL,0,MODE_HIGH,day,0);
   int lowest  =iLowest(NULL,0,MODE_LOW,day,0);
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if(a==1) //buying
        {
        a=0;
        

         openOrderID = OrderSend(NULL,OP_BUY,lotsize,Bid,10,0,0,NULL,magicNB);
         highprofit=-10;
         if(openOrderID < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(a==0)
           {
           a=1;
            openOrderID = OrderSend(NULL,OP_SELL,lotsize,Ask,10,0,0,NULL,magicNB);
            highprofit=-10;
            if(openOrderID < 0)
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
               stopLossPrice=Bid-(tralingstoploss*pipvlaue());
               OrderModify(openOrderID,Bid,stopLossPrice,0,0);

              }

           }
         else
            if(OrderType()==1)
              {
               if(OrderProfit()>=highprofit)
                 {
                  highprofit=OrderProfit();
                  stopLossPrice=Bid+(tralingstoploss*pipvlaue());
                  OrderModify(openOrderID,Bid,stopLossPrice,0,0);

                 }
              }

        }



  }









//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
