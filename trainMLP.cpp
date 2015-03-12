/*Author : Ayush Minocha
 * University of California, Los Angeles*/

#include<vector>
#include<climits>
#include<math.h>
#include <sys/time.h>
#include<cstdlib>
#include<iostream>
#include <numeric>

using namespace std;

#include<mex.h>

/**Input
 ** rhs[0] = inputs
 ** rhs[1] = targets
 ** rhs[2] = options
 **/

/**Output
 ** lhs[0] = cell of Weights
 **/


/**A[m + M*n] (where 0 ≤ m ≤ M − 1 and
 * 0 ≤ n ≤ N − 1) corresponds to matrix element A(m+1,n+1)**/

struct activations{
	int neurons;
	double *act;
};

struct delta{
	int neurons;
	double *del;
};

struct weights{
	int inpNeurons;
	int outNeurons;
	double **weight;
};

mxArray * getMexArray(weights wt){
	    mxArray * mx = mxCreateDoubleMatrix(wt.inpNeurons,wt.outNeurons, mxREAL);
	    double * temp = mxGetPr(mx);
	    for(int i=0;i<wt.inpNeurons;i++){
	    	for(int j=0;j<wt.outNeurons;j++){
			temp[i+j*wt.inpNeurons] = wt.weight[i][j];
		}
	    }
	  //  copy(wt.weight, wt.weight+(wt.inpNeurons*wt.outNeurons), mxGetPr(mx));
		    return mx;
}

vector<vector<double> > convertInputTo2D(const mxArray *arr){
	mwSize mrows = mxGetM(arr);
	mwSize ncols = mxGetN(arr);
	double *inp = (double *)mxGetPr(arr);
	vector<vector<double> > output(mrows,vector<double>(ncols+1,0));
	for(int i=0;i<mrows;i++){
		for(int j=0;j<ncols;j++){
			output[i][j] = inp[i+j*mrows];
		}
		output[i][ncols] = -1;
	}

	return output;
}

vector<vector<double> > convertTargetTo2D(const mxArray *arr){
	mwSize mrows = mxGetM(arr);
	mwSize ncols = mxGetN(arr);
	double *inp = (double *)mxGetPr(arr);
	vector<vector<double> > output(mrows,vector<double>(ncols,0));
	for(int i=0;i<mrows;i++){
		for(int j=0;j<ncols;j++){
			output[i][j] = inp[i+j*mrows];
		}
	}

	return output;
}

void dotProduct(activations at,weights wt,double *activation,double beta){
	int m1 = at.neurons;
	int m2 = wt.inpNeurons;
	int n2 = wt.outNeurons;

	for(int i=0;i<n2;i++){
		activation[i] = 0;
		for(int j=0;j<m1;j++){
			activation[i] += at.act[j]*wt.weight[j][i];
		}
		activation[i] = 1/(1+exp(-1*beta*activation[i]));
//		mexPrintf("%f ",activation[i]);
	}
//	mexPrintf("\n");
	activation[n2] = -1;
}

void mexFunction(int nlhs, mxArray *plhs[], /* Output variables */
		                                int nrhs, const mxArray *prhs[]) /* Input variables */{

	vector<vector<double> > inputs;
	inputs = convertInputTo2D(prhs[0]);

	vector<vector<double> > targets;
	targets = convertTargetTo2D(prhs[1]);

	mxArray *tmp = mxGetField(prhs[2],0,"T");
	double *tm;
	tm = (double *)mxGetPr(tmp);
	int T = tm[0];

	tmp = mxGetField(prhs[2],0,"numHiddenLayers");
	tm = (double *)mxGetPr(tmp);
	int numLayers = tm[0];

	tmp = mxGetField(prhs[2],0,"beta");
	tm = (double *)mxGetPr(tmp);
	double beta = tm[0];

	tmp = mxGetField(prhs[2],0,"eta");
	tm = (double *)mxGetPr(tmp);
	double eta = tm[0];
	
	tmp = mxGetField(prhs[2],0,"numNeurons");
	double *numNeurons;
	numNeurons = (double *)mxGetPr(tmp);

//	mexPrintf("%f %f %d %d %f %f\n",inputs[10][1],inputs[10][2],T,numLayers,beta,eta);

//	for(int i=0;i<numLayers;i++){
//		mexPrintf("%f ",numNeurons[i]);
//	}
//	mexPrintf("\n");
//	mexPrintf("\n");

	activations layerAct[numLayers];
	delta layerDel[numLayers];

	for(int i=0;i<numLayers;i++){
		layerAct[i].neurons = numNeurons[i]+1;
		layerAct[i].act = new double[(int)numNeurons[i]+1];
		layerDel[i].neurons = numNeurons[i];
		layerDel[i].del = new double[(int)numNeurons[i]];
	}

	weights layerWts[numLayers-1];
	srand(time(NULL));

	struct timeval time; 
	gettimeofday(&time,NULL);

        srand((time.tv_sec * 1000) + (time.tv_usec / 1000));

	for(int i=0;i<numLayers-1;i++){
		layerWts[i].weight = new double*[(int)numNeurons[i]+1];
		layerWts[i].inpNeurons = (int)numNeurons[i]+1;
		layerWts[i].outNeurons = (int)numNeurons[i+1];
		for(int prevL=0;prevL<(int)numNeurons[i]+1;prevL++){
			layerWts[i].weight[prevL] = new double[(int)numNeurons[i+1]];
			for(int nextL=0;nextL<(int)numNeurons[i+1];nextL++){
			//	srand(i+prevL+nextL);
				layerWts[i].weight[prevL][nextL] = (double)rand()/RAND_MAX - 0.5;
				//layerWts[i].weight[prevL][nextL] /= 100;
//				mexPrintf("%f ",layerWts[i].weight[prevL][nextL]);
			}
//			mexPrintf("\n");
		}
	//	mexPrintf("\n");
	//	mexPrintf("\n");
	}
	vector<int> indexOrder;
	for(int i=0;i<inputs.size();i++) indexOrder.push_back(i);
	random_shuffle(indexOrder.begin(),indexOrder.end());
	
	int inp;
	double h;
	for(int iter=0;iter<T;iter++){
		for(int ordering=0;ordering<inputs.size();ordering++){
			inp = indexOrder[ordering];
			for(int i=0;i<inputs[inp].size();i++) layerAct[0].act[i] = inputs[inp][i];

			for(int levels=1;levels<numLayers;levels++){
				dotProduct(layerAct[levels-1],layerWts[levels-1],layerAct[levels].act,beta);	
			//	for(int i=0;i<layerAct[levels].neurons;i++)
			//		mexPrintf("%f ",layerAct[levels].act[i]);
			//	mexPrintf("\n");
			}

			//mexPrintf("\n");
			for(int i=0;i<layerWts[numLayers-2].inpNeurons;i++){
				for(int j=0;j<layerWts[numLayers-2].outNeurons;j++){
					layerDel[numLayers-1].del[j] = (layerAct[numLayers-1].act[j] - targets[inp][j])*layerAct[numLayers-1].act[j]*(1 - layerAct[numLayers-1].act[j]);
					
					layerWts[numLayers-2].weight[i][j] -= eta*layerDel[numLayers-1].del[j]*layerAct[numLayers-2].act[i];	
			//		mexPrintf("%f ",layerWts[numLayers-2].weight[i][j]);
				}
			//	mexPrintf("\n");
			}
//			mexPrintf("\n");

			for(int levels=numLayers-3;levels>=0;levels--){
				for(int i=0;i<layerWts[levels].inpNeurons;i++){
					for(int j=0;j<layerWts[levels].outNeurons;j++){
						h = 0;
						for(int k=0;k<layerWts[levels+1].outNeurons;k++)
							h += layerWts[levels+1].weight[j][k] * layerDel[levels+2].del[k];	
						layerDel[levels+1].del[j] = layerAct[levels+1].act[j] * (1 - layerAct[levels+1].act[j]) * h;
						layerWts[levels].weight[i][j] -= eta*layerDel[levels+1].del[j]*layerAct[levels].act[i];
					}
				}
			}
		}
        	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
		random_shuffle(indexOrder.begin(),indexOrder.end());
	}

	int dim = numLayers - 1;  
	plhs[0] = mxCreateCellMatrix(1,dim);
	mxArray *temp;
	for(int i=0;i<dim;i++){
//		mexPrintf("%d %d\n",layerWts[i].inpNeurons,layerWts[i].outNeurons);
		temp = getMexArray(layerWts[i]);
		mxSetCell(plhs[0], i, mxDuplicateArray(temp));
	}
	/**
	plhs[2] = mxCreateNumericMatrix(100,numFeatures, mxDOUBLE_CLASS,mxREAL);
	double *outputMatrix = (double *)mxGetData(plhs[2]);

	for(int i=0;i<numFeatures;i++){
		for(int j=0;j<100;j++){
			outputMatrix[j+i*100] = allErrors[j][i];
		}
	}
**/	
	return;
}
