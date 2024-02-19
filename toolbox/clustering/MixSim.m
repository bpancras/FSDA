function [out]  = MixSim(k,v,options)%#codegen
%MixSim generates k clusters in v dimensions with given overlap
%
%<a href="matlab: docsearchFS('MixSim')">Link to the help function</a>
%
%
%  Required input arguments:
%
%            k: number of groups (components). Scalar.
%               Desired number of groups.
%               Data Types - int16|int32|int64|single|double
%            v: number of dimensions (variables). Scalar.
%               Desired number of variables.
%               Data Types - int16|int32|int64|single|double
%
%  Optional input arguments:
%
%    BarOmega : Requested average overlap. Scalar. Value of desired average
%               overlap. The default value is ''
%               Example - 'BarOmega',0.05
%               Data Types - double
%    MaxOmega : Requested maximum overlap. Scalar. Value of desired maximum
%               overlap. If BarOmega is empty the default value of MaxOmega
%               is 0.15.
%               Example - 'MaxOmega',0.05
%               Data Types - double
%    StdOmega : Requested std of overlap. Scalar. Value of desired standard
%               deviation of overlap.
%               Remark1 - The probability of overlapping between two
%               clusters $i$ and $j$, ($i \ne j =1, 2, ..., k$), called
%               $p_{ij}$, is defined as the sum of the two misclassification
%               probabilities
%               $p_ij=w_{j|i} + w_{i|j}$
%               Remark2- it is possible to specify up to two values among
%               BarOmega MaxOmega and StdOmega.
%               Example - 'StdOmega',0.05
%               Data Types - double
%         sph : Spherical covariances. Scalar logical or structure.
%               Scalar boolean or structure which specifies covariance
%               matrix. When sph is logical value, if:
%               sph=false (default) ==> non-spherical clusters;
%               sph=true            ==> spherical clusters= const*I.
%               The following options "hom", "ecc" and "restrfactor" have
%               an effect just if sph is a scalar boolean. The default
%               value of sph is false that is non spherical clusters are
%               generated.
%               If sph is a structure it may contain the following fields.
%               sph.pars = a 3 letter character in the set:
%                'VVE','EVE','VVV','EVV','VEE','EEE','VEV','EEV','VVI',
%                'EVI','VEI','EEI','VII','EII' which
%                specifies the type of Gaussian Parsimonious Clustering
%                Model which needs to be generated.
%               sph.exactrestriction = boolean. If sph.exactrestriction is
%                true the covariance matrices have to be generated with the
%                exact values of the restrictions specified in sph.cdet,
%                sph.shw and sph.shb. For example if sph.pars='VVE' and
%                sph.exactrestriction=true model with varying determinants,
%                varying shape and varying rotation matrix is generated.
%                The max ratio of the determinants is equal to sph.cdet.
%                The maximum ratio between the shape elements in each group
%                is sph.shw. The maximum ratio among the ordered elements
%                across the groups is and sph.shb. On the other hand, if
%                sph.exactrestriction is false and for example
%                sph.pars='VVE' covariance matrices are generated assuming varying
%                determinants, varying shape and equal rotation matrix and
%                with ratio of determinants which satisfy the inequality
%                constraint <= sph.cdet and shape matrices which satisfy
%                the inequality constraints <= sph.shw and <= sph.shb.
%              sph.cdet = scalar which specifies the restriction factor
%                for determinants across groups. If this field is empty or
%                if this field is missing no contraint is imposed among
%                determinants.
%              sph.shw = scalar which specifies the restriction factor for
%                shape matrices within each group. If this field is empty
%                or if this field is missing, no contraint is imposed among
%                the elements of each shape matrix of a particular group.
%               sph.shb = scalar which specifies the restriction factor for
%                shape matrices between each group. If this field is empty
%                or if this field is missing, no contraint is imposed
%                across the elements of each shape matrix between the
%                groups.
%               Example - 'sph',false
%               Data Types - boolean
%         hom : Equal Sigmas. Scalar logical.
%               Scalar boolean which specifies heterogeneous or homogeneous
%               clusters. This option has an effect just if previous option
%               sph is a scalar boolean.
%               hom=false (default) ==> heterogeneous;
%               hom=true            ==> homogeneous $\Sigma_1 = ... =
%               \Sigma_k$
%               Example - 'hom',false
%               Data Types - boolean
%         ecc : maximum eccentricity. Scalar.
%               Scalar in the interval (0, 1] which defines maximum eccentricity.
%               For example, if ecc=0.9 (default value), we require for
%               each group that sqrt(1 - minL / maxL) <= 0.9 where minL and
%               maxL are respectively the min and max eigenvalue of the cov
%               matrix of a particular group. This option has an effect
%               just if previous option sph is a scalar boolean.
%               Example - 'ecc',0.8
%               Data Types - double
%  restrfactor: eigenvalue restriction factor. Scalar.
%               Scalar in the interval [1 \infty] which specifies the
%               maximum ratio to allow between the largest eigenvalue and
%               the smallest eigenvalue of the k covariance matrices which
%               are generated. The default value is ''. More in details if
%               for example restrfactor=10 after generating the covariance
%               matrices we
%               check that the ratio
%               \[
%                 \frac{   \max_{l=1, \ldots, v} \max_{j=1, \ldots, k}  \lambda_l(\hat \Sigma_j)}{   \min_{l=1, \ldots, v} \min_{j=1, \ldots, k}  \lambda_l(\hat \Sigma_j)}.
%               \]
%               between the largest eigenvalue of the k cov matrices
%               and the smallest eigenvalue of the k cov matrices is not
%               larger than restrfactor. In order to apply this restriction
%               (which is typical of tclust.m) we call routine
%               restreigen.m.
%               This option has an effect just if previous option sph is a
%               scalar boolean.
%               Example - 'restrfactor',8
%               Data Types - double
%       PiLow : Smallest mixing proportion. Scalar.
%               Value of the smallest mixing proportion (if 'PiLow'
%               is not reachable with respect to k, equal proportions are
%               taken; PiLow = 1.0 implies equal proportions by default).
%               PiLow must be a number in the interval (0 1]. Default value
%               0.
%               Example - 'PiLow',0.1
%               Data Types - double
%         int : Simulation interval of mean vectors. vector of length 2.
%               Mean vectors are simulated uniformly on a hypercube with
%               sides specified by int = [lower.bound, upper.bound].
%               The default value of int is [0 1].
%               Example - 'int',[0 2]
%               Data Types - double
%        resN : number of simulations. Scalar.
%               Maximum number of mixture resimulations to find a
%               similation setting with prespecified level of overlapping.
%               The default value of resN is 100
%               Example - 'resN',20
%               Data Types - double
%         tol : Tolerances. Vector of length 2.
%               tol(1) (which will be called tolmap) specifies
%               the tolerance between the requested and empirical
%               misclassification probabilities (default is 1e-06)
%               tol(2) (which will be called tolnxc2) specifies the
%               tolerance to use in routine ncx2mixtcdf.m (which computes cdf
%               of linear combinations of non central chi2 distributions).
%               The default value of tol(2) 1e-06.
%               Example - 'tol',[1e-06 1e-08]
%               Data Types - double
%         lim : Precision in the calculation of probabilities of overlapping.
%               Scalar. Maximum number of integration terms to use inside routine
%               ncx2mixtcdf.m. Default is 1e06.
%               REMARK - Optional parameters tolncx2=tol(2) and lim will be
%               used by function ncx2mixtcdf.m which computes the cdf of a
%               linear combination of non central chi2 r.v.. This is the
%               probability of misclassification
%               Example - 'lim',1e6
%               Data Types - double
%     Display : Level of display. Character.
%               'off' displays no output;
%               'notify' (default) displays output if requested
%               overlap cannot be reached in a particular simulation
%               'iter' displays output at each iteration of each
%               simulation
%               Example - 'Display','off'
%               Data Types - character
%      R_seed : use random numbers from R. scalar.
%               If scalar > 0 for the seed to be used to generate random numbers
%               in a R instance. This is used to check consistency of the
%               results obtained with the R package MixSim. See file
%               Connect_Matlab_with_R_HELP.m to know how to connect MATLAB
%               with R.  This option requires the installation of the
%               R-(D)COM Interface. Default is 0, i.e. random numbers are
%               generated by matlab.
%               Example - 'R_seed',0
%               Data Types - double
%
%       Remark: The user should only give the input arguments that have to
%               change their default value. The name of the input arguments
%               needs to be followed by their value. The order of the input
%               arguments is of no importance.
%       Remark: If 'BarOmega', 'MaxOmega' and 'StdOmega' are not specified,
%               the function generates a mixture solely based on
%               'MaxOmega'=0.15. If both BarOmega, StdOmega and MaxOmega are
%               empty values as follows
%               out=MixSim(3,4,'MaxOmega','','BarOmega','') the following
%               message appears on the screen Error: At least one overlap
%               characteristic between BarOmega, MaxOmega and StdOmega
%               should be specified...
%
%  Output:
%
%         out:   structure which contains the following fields
%
%            out.Pi  = vector of length k containing mixing proportions.
%                       sum(out.Pi)=1
%            out.Mu  = k-by-v matrix consisting of components' mean vectors
%                      Each row of this matrix is a centroid of a group
%             out.S  = v-by-v-by-k array containing covariances for the k
%                      groups
%       out.OmegaMap = matrix of misclassification probabilities (k-by-k);
%                      OmegaMap(i,j) = w_{j|i} is the probability that X
%                      coming from the i-th component (group) is classified
%                      to the j-th component.
%       out.BarOmega = scalar. Value of average overlap.
%                      BarOmega is computed as
%                      (sum(sum(OmegaMap))-k)/(0.5*k(k-1))
%       out.MaxOmega = scalar. Value of maximum overlap. MaxOmega is the
%                       maximum of OmegaMap(i,j)+OmegaMap(j,i)
%                       (i ~= j)=1, 2, ..., k. In other words MaxOmega=
%                      OmegaMap(rcMax(1),rcMax(2))+OmegaMap(rcMax(2),rcMax(1))
%       out.StdOmega = scalar. Value of standard deviation (std) of overlap.
%                      StdOmega is the standard deviation of k*(k-1)/2
%                      probabilities of overlapping
%         out.rcMax  = vector of length 2. It containes the row and column
%                      numbers associated with  the pair of components
%                      producing maximum overlap 'MaxOmega'
%          out.fail  = scalar, flag value. 0 represents successful mixture
%                      generation, 1 represents failure.
%
%  More About:
%
%  MixSim(k,v) generates k groups in v dimensions. It is possible to
%  control the average and maximum or standard deviation of overlapping.
%
%  Given two generic clusters $i$ and $j$ with $i \ne j =1, ..., k$,
%  indexed by $\phi(x; \mu_i,\Sigma_i)$ and $\phi(x; \mu_j,\Sigma_j)$ with
%  probabilities of occurrence $\pi_i$ and $\pi_j$, the misclassification
%  probability with respect to cluster $i$ (that is conditionally on $x$
%  belonging to cluster $i$,  which is called  $w_{j|i}$) is defined as
%  $Pr[ \pi_i \phi(x;\mu_i,\Sigma_i) < \pi_j \phi(x;\mu_j,\Sigma_j)]$.
%  The matrix containing the misclassification probabilities $w_{j|i}$ is
%  called OmegaMap
%  The probability of overlapping between groups $i$ and $j$ is given by:
%  \[
%            w_{j|i} + w_{i|j}    \qquad      i,j=1,2, ..., k
%  \]
%  The diagonal elements of OmegaMap are equal to 1.
%  The average overlap (which in the code is called below BarOmega) is
%  defined as the sum of the off diagonal elements of OmegaMap (matrix of
%  misclassification probabilities) divided by 0.5*k*(k-1)
%  The maximum overlap (which in the code is called MaxOmega) is defined as
%  $\max(w_{j|i} + w_{i|j}$),  $i \ne j=1,2, ..., k$.
%  The probability of misclassification $w_{j|i}$ is nothing but the cdf of a linear
%  combination of non central $\chi^2$ distributions with 1 degree of freedom
%  + a linear combination of $N(0,1)$ evaluated in a
%  point c.  The coefficients of the linear combinations of non central
%  $\chi^2$ and $N(0,1)$ depend on the eigenvalues and eigenvectors of matrix
%  $\Sigma_{j|i} = \Sigma^{0.5}_i \Sigma^{-1}_j \Sigma^{0.5}_i$.
%  Point $c$ depends on the same eigenvalues and eigenvectors
%  of matrix $\Sigma_{j|i}$, the mixing proportions $\pi_i$ and $\pi_j$ and the
%  determinants $|\Sigma_i|$ and $|\Sigma_j|$.
%  This probability is computed using routine ncx2mixtcdf.m
%
%
% See also: tkmeans, tclust, tclustreg, lga, rlga, ncx2mixtcdf, restreigen
%
% References:
%
% Maitra, R. and Melnykov, V. (2010), Simulating data to study performance
% of finite mixture modeling and clustering algorithms, "The Journal of
% Computational and Graphical Statistics", Vol. 19, pp. 354-376. [to refer to
% this publication we will use "MM2010 JCGS"]
%
% Melnykov, V., Chen, W.-C. and Maitra, R. (2012), MixSim: An R Package
% for Simulating Data to Study Performance of Clustering Algorithms,
% "Journal of Statistical Software", Vol. 51, pp. 1-25.
%
% Davies, R. (1980), The distribution of a linear combination of
% chi-square random variables, "Applied Statistics", Vol. 29, pp. 323-333.
%
% Garcia-Escudero, L.A., Gordaliza, A., Matran, C. and Mayo-Iscar, A. (2008),
% A General Trimming Approach to Robust Cluster Analysis. Annals
% of Statistics, Vol. 36, 1324-1345. 
%
% Riani, M., Cerioli, A., Perrotta, D. and Torti, F. (2015), Simulating
% mixtures of multivariate data with fixed cluster overlap in FSDA,
% "Advances in data analysis and classification", Vol. 9, pp. 461-481.
% Parlett, B.N. and Reinsch, C. (1969), Balancing a matrix for calculation
% of eigenvalues and eigenvectors, "Numerische Mathematik", Vol. 13,
% pp. 293-304.
%
% Parlett, B.N. and Reinsch, C. (1971), Balancing a Matrix for Calculation of
% Eigenvalues and Eigenvectors, in Bauer, F.L. Eds, "Handbook for Automatic
% Computation", Vol. 2, pp. 315-326, Springer.
%
% Copyright 2008-2024.
% Written by FSDA team
%
%
%<a href="matlab: docsearchFS('MixSim')">Link to the help function</a>
%
%$LastChangedDate::                      $: Date of the last commit
%

% Examples:
%
%{
	%% Generate 3 groups in 4 dimensions.
    % Use a maximum overlap equal to 0.15.
    rng(10,'twister')
    out=MixSim(3,4)
    n=200;
    [X,id]=simdataset(n, out.Pi, out.Mu, out.S);
    spmplot(X,id)
%}
%
%{
    % Generate 4 groups in 5 dimensions with prefixed average and maximum overlap.
    % Use average overlap of 0.05 and
    % maximum overlap equal to 0.15.
    k=4;
    v=5;
    BarOmega=0.05;
    out=MixSim(4,5,'BarOmega',BarOmega, 'MaxOmega',0.15)

	% Check a posteriori the average overlap
    disp('Posterior average overlap')
    disp((sum(sum(out.OmegaMap))-k)/(0.5*k*(k-1)))
    
    % Check a posteriori the maximum overlap
    % Extract elements above the diagonal and sum them with the transpose
    % of the elements below the diagonal. The maximum of all these numbers
    % must be very close to the required maximum overlap
    cand=triu(out.OmegaMap,1)+(tril(out.OmegaMap,-1))'
    disp('Posterior average overlap')
    max(cand(:))
%}

%{
    % Example of use of optional input option restrfactor. In the first case
    % restrfactor is 1.1 and the clusters are roughly homogeneous. In the
    % second case no constraint is imposed on the ratio of maximum and
    % minimum eigevalue among clusters so elliptical shape clusters are
    % allowed. In both cases the same random seed together with the same level
    % of average and maximum overlapping is used
    state1=2;
    randn('state', state1);
    rand('state', state1);
    out=MixSim(3,5,'BarOmega',0.1, 'MaxOmega',0.2, 'restrfactor',1.1);
    state1=2;
    randn('state', state1);
    rand('state', state1);
    out1=MixSim(3,5,'BarOmega',0.1, 'MaxOmega',0.2);

    n=200;
    [X,id]=simdataset(n, out.Pi, out.Mu, out.S);
    [H,AX,BigAx] = spmplot(X,id,[],'box');
    set(gcf,'Name','restrfactor=1.1: almost homogeneous groups')
    title(BigAx,'\texttt{restrfactor=1.1}: almost homogeneous groups','fontsize',17,'interpreter','latex');

    [X1,id1]=simdataset(n, out1.Pi, out1.Mu, out1.S);
    figure;
    [H,AX,BigAx] = spmplot(X1,id1,[],'box')
    set(gcf,'Name','Heterogeneous groups')
    title(BigAx,'\texttt{restrfactor=`''}: heterogeneous groups','fontsize',17,'interpreter','latex')
    cascade
%}

%{
    % Control of average and standard deviation of overlap. Given an
    % average value of overlap, we explore the differences between imposing a
    % small or a large value of standard deviation of overlap.
    clc
    close all
    rng(10,'twister')
    k=4;
    v=5;
    n=200;
    BarOmega=0.10;
    StdOmega=0.15;
    out=MixSim(k,v,'BarOmega',BarOmega, 'StdOmega',StdOmega,'resN',10, 'Display', 'iter');
    [X,id]=simdataset(n, out.Pi, out.Mu, out.S);

    rng(10,'twister')
    StdOmega1=0.05;
    out1=MixSim(k,v,'BarOmega',BarOmega, 'StdOmega',StdOmega1,'resN',10, 'Display', 'iter');
    [X1,id1]=simdataset(n, out1.Pi, out1.Mu, out1.S);
    disp('Comparison using OmegaMap')
    disp('When StdOmega is large in this example groups 3 are 4 do show a strong overlap')
    disp('When StdOmega is large in this example groups 1, 2, 3 are quite separate')
    disp(out.OmegaMap)
    disp('When StdOmega is small the probabilities of overlapping are much more similar')
    disp(out1.OmegaMap)

    disp('Comparison using interactive scatter plot matrices')
    [H,AX,BigAx] = spmplot(X,id,[],'box');
    set(gcf,'name',['BarOmega=' num2str(BarOmega) ' StdOmega=' num2str(StdOmega)])
    title(BigAx,['BarOmega=' num2str(BarOmega) ' StdOmega=' num2str(StdOmega)])
    figure
    [H,AX,BigAx] = spmplot(X1,id1,[],'box');
    set(gcf,'name',['BarOmega=' num2str(BarOmega) ' StdOmega=' num2str(StdOmega1)])
    title(BigAx,['BarOmega=' num2str(BarOmega) ' StdOmega=' num2str(StdOmega1)])
    cascade
%}

%% Beginning of code

% User options

arguments
    k (1,1) double
    v (1,1) double
    options.R_seed
    options.BarOmega (1,1) double
    options.MaxOmega (:,:) double
    options.StdOmega (:,:) double
    options.Display (1,:) char
    options.sph (1,1) logical
    options.hom (1,1) logical
    options.ecc (1,1) double
    options.PiLow (1,1) double
    options.int (1,2) double
    options.resN (1,1) double
    options.tol (1,2) double
    options.lim (1,1) double
    options.restrfactor (1,1)
end

% Default
if nargin<2
    error('FSDA:MixSim:Missingv','k=number of components and v = number of dimensions must be specified');
end

if (v < 1)
    error('FSDA:MixSim:Wrongv','Wrong number of dimensions v')
end

if k<=1
    error('FSDA:MixSim:Wrongk','Wrong number of mixture components k')
end

mixSimOptions = MixSimOptions();
mFields = fields(options);
if ~isempty(mFields)
    
    for idx = 1:numel(mFields)
        mixSimOptions.(mFields{idx}) = options.(mFields{idx}); 
    end
end

out = MixSimCodeGen(k, v, mixSimOptions);
end
%FScategory:CLUS-MixSim
