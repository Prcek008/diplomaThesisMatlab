/* Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved. */
/*
   Changes:
   Jan Novák (novak110@fel.cvut.cz, officialjannovak@gmail.com), 2017-11-02T16:25:24+00:00
	   - change "less than or equal" limit comparison in if statement to "less than" since
		   A) it is comparing to double anyway
		   B) comparisons with input limit == 1 were causing the overshoot limitation to not be
			  taken into account
		- change iterators to standard format (int i, k, ...), cause this is a C source file, not Matlab or Pascal, etc.
		- note: I received this implementation with 'Tau' constants hardcoded and tau params deleted from function declaractions
	   
*/

#include "math.h"

void adaptloop(double *insig, int fs, int siglen, int nsigs,
			   double limit, double minlvl, double *outsig)
{
	double tau[5], corr, mult, tmp1;
	double state[5], b0[5], a1[5], stateinit[5];
	double maxvalue, factor[5], expfac[5], offset[5];
	int n_loops, i, k, l, m, w;

	n_loops = 5;

	tau[0] = 0.005;
	tau[1] = 0.050;
	tau[2] = 0.129;
	tau[3] = 0.253;
	tau[4] = 0.500;

	// printf("ADAPTLOOP: minlvl: %f\n", minlvl);
	// printf("ADAPTLOOP: limit: %f\n", limit);

	/* get the b0 and a1 of the RC-lowpass recursion relation y(n) = b0 * x(n) + a1 * y(n - 1) and the steady state */

	for (i = 0; i < n_loops; i++)
	{
		a1[i] = exp(-1 / (tau[i] * ((double)fs)));
		b0[i] = 1 - a1[i];

		/* This is a clever way of avoiding exponents by taking the sqrt of the previous entry */
		if (i == 0)
		{
			state[i] = sqrt(minlvl);
		}
		else
		{
			state[i] = sqrt(state[i - 1]);
		}
		/* backup state, because it is overwritten. */
		stateinit[i] = state[i];
	}

	corr = state[n_loops - 1];
	mult = 100.0 / (1 - corr);

	if (limit < 1.0)
	{
		/* Main loop, no overshoot limitation */

		for (w = 0; w < nsigs; w++)
		{
			/* Reset the state to the initial values */
			for (k = 0; k < n_loops; k++)
			{
				state[k] = stateinit[k];
			}

			for (k = 0; k < siglen; k++)
			{
				tmp1 = insig[k + w * siglen];

				if (tmp1 < minlvl)
				{
					tmp1 = minlvl;
				}
				/* printf("tmp1: %f\n",tmp1); */

				/* for each aloop */
				for (m = 0; m < n_loops; m++)
				{
					tmp1 /= state[m];
					state[m] = a1[m] * state[m] + b0[m] * tmp1;
				}

				/* Scale to model units */
				outsig[k + w * siglen] = (tmp1 - corr) * mult;
			}
		}
	}
	else
	{
		/* Main loop, overshoot limitation */

		/* Calculate constants for overshoot limitation */
		for (i = 0; i < n_loops; i++)
		{
			/* Max. possible output value */
			maxvalue = (1.0 - state[i] * state[i]) * limit - 1.0;

			/* Factor in formula to speed it up  */
			factor[i] = maxvalue * 2;

			/*Exponential factor in output limiting function*/
			expfac[i] = -2. / maxvalue;
			offset[i] = maxvalue - 1.0;
		}

		for (w = 0; w < nsigs; w++)
		{
			/* Reset the state to the initial values */
			for (i = 0; i < n_loops; i++)
			{
				state[i] = stateinit[i];
			}

			for (k = 0; k < siglen; k++)
			{
				tmp1 = insig[k + w * siglen];

				if (tmp1 < minlvl)
				{
					tmp1 = minlvl;
				}
				/* printf("tmp1: %f\n",tmp1); */

				/* compute the adaptation n_loops */
				for (i = 0; i < n_loops; i++)
				{
					tmp1 /= state[i];

					if (tmp1 > 1.0)
					{
						tmp1 = factor[i] / (1 + exp(expfac[i] * (tmp1 - 1))) - offset[i];
					}
					state[i] = a1[i] * state[i] + b0[i] * tmp1;
				}

				/* Scale to model units */
				outsig[k + w * siglen] = (tmp1 - corr) * mult;
			}
		}
	}
}
