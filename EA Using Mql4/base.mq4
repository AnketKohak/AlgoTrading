
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

int openOrderIDb;
int openOrderIDs;
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

      double O=(Open[0]);
      double O1=(Open[1]);
      double O2=(Open[2]);
      double O3=(Open[3]);
      double O4=(Open[4]);
      double H=(High[0]);
      double H1=(High[1]);
      double H2=(High[2]);
      double H3=(High[3]);
      double H4=(High[4]);
      double L=(Low[0]);
      double L1=(Low[1]);
      double L2=(Low[2]);
      double L3=(Low[3]);
      double L4=(Low[4]);
      double C=(Close[0]);
      double C1=(Close[1]);
      double C2=(Close[2]);
      double C3=(Close[3]);
      double C4=(Close[4]);
   double BullishEngulfing=((O4>C4 && H3<H2 && L3>L2 && O3>C3) && (C2>O2) && (C2>=O3) && (C3>=O2) && ((C2-O2)>(O3-C3 && C1>C2)));
   double BullishHarami   = ((O4>C4 && H3>H2 && L3<L2 && O3>C3) && (C2>O2) && (C2<=O3) && (C3<=O2) && ((C2-O2)<(O3-C3 && C1>C2)));
   if(!CheckIfOpenOrderByMagicNB(magicNB))//if no open orders try to enter new position
     {
      if((BullishEngulfing == true))//buying
        {
         double stoploss;
         double takeprofit;
         double stopLossPrice = Low[2];
         double takeProfitPrice = ((Bid-Low[2])*2)+Bid;

         openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
         if(openOrderIDb < 0)
            Alert("order rejected. Order error: " + GetLastError());
        }
      else
         if(BullishHarami == true)
           {
            double stoploss=50;
            double stopLossPrice = Low[3];
            double takeProfitPrice = ((Bid-Low[3])*2)+Bid;

            openOrderIDb = OrderSend(NULL,OP_BUY,lotsize,Ask,10,0,0,NULL,magicNB);
            if(openOrderIDb < 0)
               Alert("order rejected. Order error: " + GetLastError());
           }
     }
   else //else if you already have a position, update orders if need too.
     {
    
      if(Low[3]<Bid)
        {
         double takeprofit=(Open[0]-Low[3])+Open[0];
         OrderModify(openOrderIDb,0,Low[3],takeprofit,0,);
        }
     }
  }



//+------------------------------------------------------------------+