//+--------------------------------------------------------------------------------------+
//|                                                                   BPNN Predictor.mq4 |
//|                                                               Copyright © 2009, gpwr |
//|                                                                   vlad1004@yahoo.com |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright © 2009, gpwr"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_width1 2
#property indicator_color2 Blue
#property indicator_width2 2
#property indicator_color3 Yellow
#property indicator_width3 2

//======================================= DLL ============================================
#import "BPNN.dll"
string Train(
   double inpTrain[], // Input trainumInputsg data (1D array carrying 2D data, old first)
   double outTarget[],// Output target data for trainumInputsg (2D data as 1D array, oldest 1st)
   double outTrain[], // Output 1D array to hold net outputs from trainumInputsg
   int    ntraining,        // # of trainumInputsg sets
   int    UEW,        // Use Ext. Weights for initialization (1=use extInitWt, 0=use rnd)
   double extInitWt[],// Input 1D array to hold 3D array of external initial weights
   double trainedWt[],// Output 1D array to hold 3D array of trained weights
	int    numLayers,  // # of layers including input, hidden and output
	int    layerStruct[],      // # of neurons in layers. layerStruct[0] is # of net inputs
	int    AFT,        // Type of neuron activation function (0:sigm, 1:tanh, 2:x/(1+x))
	int    OAF,        // 1 enables activation function for output layer; 0 disables
	int    nep,        // Max # of trainumInputsg epochs
	double maxMSE      // Max MSE; trainumInputsg stops once maxMSE is reached
	);

string Test(
   double inpTest[],  // Input test data (2D data as 1D array, oldest first)
   double outTest[],  // Output 1D array to hold net outputs from trainumInputsg (oldest first)
   int    ntt,        // # of test sets
   double extInitWt[],// Input 1D array to hold 3D array of external initial weights
	int    numLayers,  // # of layers including input, hidden and output
	int    layerStruct[],      // # of neurons in layers. layerStruct[0] is # of net inputs
   int    AFT,        // Type of neuron activation function (0:sigm, 1:tanh, 2:x/(1+x))
	int    OAF         // 1 enables activation function for output layer; 0 disables
	);
#import

//===================================== INPUTS ===========================================

extern int    lastBar     =5;     // Last bar in the past data
extern int    futBars     =5;     // # of future bars to predict
extern int    numLayers   =3;     // # of layers including input, hidden & output (2..6)
extern int    numInputs   =12;    // # of inputs
extern int    numNeurons1 =5;     // # of neurons in the first hidden or output layer
extern int    numNeurons2 =1;     // # of neurons in the second hidden or output layer
extern int    numNeurons3 =0;     // # of neurons in the third hidden or output layer
extern int    numNeurons4 =0;     // # of neurons in the fourth hidden or output layer
extern int    numNeurons5 =0;     // # of neurons in the fifth hidden or output layer
extern int    ntraining   =300;   // # of trainumInputsg sets
extern int    nep         =1000;  // Max # of epochs
extern int    maxMSEpwr   =-20;   // sets maxMSE=10^maxMSEpwr; trainumInputsg stops < maxMSE
extern int    AFT         =2;     // Type of activ. function (0:sigm, 1:tanh, 2:x/(1+x))

//======================================= INIT ===========================================
//Indicator buffers
double pred[],trainedOut[],realOut[];

//Global variables
int nout,layerStruct[],prevBars;
double maxMSE;

int init()
{
// Create 1D array describing NN --------------------------------------------------------+
   ArrayResize(layerStruct,numLayers);
   layerStruct[0]=numInputs;
   layerStruct[1]=numNeurons1;
   if(numLayers>2)
   {
      layerStruct[2]=numNeurons2;
      if(numLayers>3)
      {
         layerStruct[3]=numNeurons3;
         if(numLayers>4)
         {
            layerStruct[4]=numNeurons4;
            if(numLayers>5) layerStruct[5]=numNeurons5;
         }
      }
   }
   
// Use shorter names for some external inputs -------------------------------------------+
   nout=layerStruct[numLayers-1];
   maxMSE=MathPow(10.0,maxMSEpwr);
   prevBars=Bars-1;

// Set indicator properties -------------------------------------------------------------+
   IndicatorBuffers(3);
   SetIndexBuffer(0,pred);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(1,trainedOut);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(2,realOut);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   SetIndexShift(0,futBars-lastBar); // future data vector i=0..futBars; futBars corresponds to bar=lastBar
   IndicatorShortName("Custom BPNN");  
   return(0);
}

//===================================== DEINIT ===========================================
int deinit(){return(0);}

//===================================== START ============================================
int start()
{
   if(prevBars<Bars){
   prevBars=Bars;
// Check NN and find the total number of weights ----------------------------------------+
   if(numLayers>6)
   {
      Print("The maximum number of layers is 6");
      return;
   }
   for(int i=0;i<numLayers;i++)
   {
      if(layerStruct[i]<=0)
      {
         Print("No neurons in layer # "+DoubleToStr(i,0)+
            ". Either reduce # of layers or add neurons to this layer");
         return;
      }
   }
   int nWeights=0; // total number of weights
   for(i=1;i<numLayers;i++)			   // for each layer except input
      for(int j=0;j<layerStruct[i];j++)			// for each neuron in current layer
         for(int k=0;k<=layerStruct[i-1];k++)	// for each input of current neuron including bias
				nWeights++;
      
// Prepare input data for trainumInputsg ------------------------------------------------------+
   double inpTrain[],outTarget[],extInitWt[];
   ArrayResize(inpTrain,ntraining*numInputs);
   ArrayResize(outTarget,ntraining*nout);
   ArrayResize(extInitWt,nWeights);
   
	// The input data is arranged as follows:
	//
	// inpTrain[i*numInputs+j]
	//------------------
	//      j= 0...numInputs-1
	//            |
	// i=0     <inputs>
	// ...     <inputs>
	// i=ntraining-1 <inputs> 
	//
	// outTarget[i*nout+j]
	//--------------------
	//      j= 0...nout-1
	//             |
	// i=0     <targets>
	// ...     <targets>
	// i=ntraining-1 <targets> 
   //
	// <inputs> start with the oldest value first
	
	// Fill in the input arrays with data; in this example nout=1 
   for(i=ntraining-1;i>=0;i--)
   {
      outTarget[i]=(getValue(lastBar+ntraining-1-i)/getValue(lastBar+ntraining-i)-1.0);
      int fd2=0;
      int fd1=1;
      for(j=numInputs-1;j>=0;j--)
      {
         int fd=fd1+fd2; // use Fibonacci delays: 1,2,3,5,8,13,21,34,55,89,144...
         fd2=fd1;
         fd1=fd;
         inpTrain[i*numInputs+j]=getValue(lastBar+ntraining-i)/getValue(lastBar+ntraining-i+fd)-1.0;
      }
   }

// Train NN -----------------------------------------------------------------------------+
   double outTrain[],trainedWt[];
   ArrayResize(outTrain,ntraining*nout);
   ArrayResize(trainedWt,nWeights);
   
   // The output data is arranged as follows:
	//
	// outTrain[i*nout+j]
	//      j= 0...nout-1
	//             |
	// i=0     <outputs>
	// ...     <outputs>
	// i=ntraining-1 <outputs>  
   
   string status=Train(inpTrain,outTarget,outTrain,ntraining,0,extInitWt,trainedWt,numLayers,layerStruct,AFT,0,nep,maxMSE);
   Print(status);
   // Store trainedWt[] as extInitWt[] for next trainumInputsg
   int iw=0;
   for(i=1;i<numLayers;i++)			// for each layer except input
      for(j=0;j<layerStruct[i];j++)			// for each neuron in current layer
         for(k=0;k<=layerStruct[i-1];k++)	// for each input of current neuron including bias
         {
				extInitWt[iw]=trainedWt[iw];
				//Print("w = "+DoubleToStr(extInitWt[iw],5));
				iw++;
		   }
		   
   // Show how individual net outputs match targets
   for(i=0;i<ntraining;i++)
   {
      realOut[lastBar+i]=getValue(lastBar+i);
      trainedOut[lastBar+i]=(1.0+outTrain[ntraining-1-i])*getValue(lastBar+i+1);
      //Print("Net output: "+DoubleToStr(outTrain[i],5)+", target: "+DoubleToStr(outTarget[i],5));
   }
      

// Test NN ------------------------------------------------------------------------------+
   double inpTest[],outTest[];
   ArrayResize(inpTest,numInputs);
   ArrayResize(outTest,nout);
   
   // The input data is arranged as follows:
	//
   // inpTest[i*numInputs+j]
	//-----------------
	//      j= 0...numInputs-1
	//            |
	// i=0     <inputs>
	// ...     <inputs>
	// i=ntt-1 <inputs>
	//
	// <inputs> start with the oldest value first
	//
   // The output data is arranged as follows:
	//
	// outTest[i*nout+j]
	//------------------
	//      j= 0...nout-1
	//             |
	// i=0     <outputs>
	// ...     <outputs>
	// i=ntt-1 <outputs> 
	
	pred[futBars]=getValue(lastBar);
	for(i=0;i<futBars;i++)
	{
      fd2=0;
      fd1=1;
      for(j=numInputs-1;j>=0;j--)
      {
         fd=fd1+fd2; // use Fibonacci delays: 1,2,3,5,8,13,21,34,55,89,144...
         fd2=fd1;
         fd1=fd;
         double o,od;
         if(i>0) o=pred[futBars-i];
         else o=getValue(lastBar-i);
         if(i-fd>0) od=pred[futBars-i+fd];
         else od=getValue(lastBar-i+fd);
         inpTest[j]=o/od-1.0;
      }
      status=Test(inpTest,outTest,1,extInitWt,numLayers,layerStruct,AFT,0);
      pred[futBars-i-1]=pred[futBars-i]*(outTest[0]+1.0); // predicted next open
      Print("Bar -"+DoubleToStr(i+1,0)+": predicted open = "+DoubleToStr(pred[futBars-i-1],5));
   }
   }
   return;
}

double getValue(int i) {
   /*
   How to adapt any indicator as a Neural network Indicator:
      This code, originally posted on http://codebase.mql4.com/5738/,
      has been modified in order to adapt easily any indicator as a neural network indicator.
      All you have to do is change the return function of this function.
      In this example, the neural network is using a Moving Average.
      Just think about using the variable "i" as the shift of the indicator.
   */
   return(iMA(NULL,0,15,0,MODE_SMMA,PRICE_OPEN,i));
}