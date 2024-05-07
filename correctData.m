function [y,X,n,p] = correctData(y, X, options)
% If nocheck=true, then skip checks on y and X
if options.nocheck
    [n,p]=size(X);
else
    
    % The first argument which is passed is y

    
    [m,q]=size(y);
    if min(m,q)>1
        error('FSDA:chkinputR:Wrongy','y is not one-dimensional.');
    elseif q~=1
        
        % If y is a row vector it is transformed in a column vector
        y=y';
    end
       
    
    % Check dimension consistency of X and y
    na.X=~isfinite(X*ones(size(X,2),1));
    na.y=~isfinite(y);
    if size(na.X,1)~=size(na.y,1)
        error('FSDA:chkinputR:NxDiffNy','Number of observations in X and y not equal.');
    end
    
    % Observations with missing or infinite values are removed from X and y
    ok=~(na.X|na.y);
    X=X(ok,:);
    y=y(ok,:);
    
    % Now n is the new number of non missing observations
    n=length(y);
    
    
    % Now add to matrix X a column of ones for the intercept.
    if true % This needs to be fixed nnargin <= stdargin
        
        % If the user has not specified a value for the intercept than add
        % a column of ones.
        X = cat(2,ones(n,1),X);
    else
        
        % If a value for the intercept has not been specified or if this value is
        % equal to 1, add to matrix X the column of ones. The position of
        % the option intercept in chklist, which contains the optional is
        % given in chkint. chkint is empty if the option intercept is not
        % specified.
        %if coder.target('MATLAB')
            interceptPresent=options.intercept;
        %else
        %    interceptPresent=vvarargin{2*chkint}==true;
        %end
        
        if  interceptPresent==true
            X = cat(2,ones(n,1),X);
        end
    end
    
    
    % constcols = scalar vector of the indices of possible constant columns.
    constcols = find(max(X,[],1)-min(X,[],1) == 0);
    if numel(constcols)>1
        X(:,constcols(2:end))=[];
        if coder.target('MATLAB')
           disp(['Warning: columns ' num2str(constcols) ' are constant and just col ' num2str(constcols(1)) ' has been kept!']);
        end
    end
    
    
    % p is the number of parameters to be estimated
    p=size(X,2);
    
    if n < p
        error('FSDA:chkinputR:NSmallerP',['Need more observations than variables: n=' ...
            int2str(size(X,1)) ' and p=' int2str(size(X,2)) ]);
    end
    
    rk=rank(X);
    if rk < p
        error('FSDA:chkinputR:NoFullRank','Matrix X is singular');
    end
end

end