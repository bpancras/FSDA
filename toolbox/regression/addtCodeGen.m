function out = addtCodeGen(y, X, w, options)

arguments
    y (:, :) double {validateY(y)}
    X (:, :) double {validateX(y,X)}
    w (:, :) double {validateW(y,w)}
    options (1,1) addtOptions
end

[y,X,n,p] = correctData(y, X, options);

la=options.la;
plots=options.plots;
units=options.units;
textlab=options.textlab;

% FontSize = font size of the axes labels
FontSize =options.FontSize;
% FontSizeAxes = font size for the axes numbers
SizeAxesNum=options.SizeAxesNum;

%% t test for an additional explanatory variable

[~, R] = qr(X,0);
E = X/R;
A = -E*E';
sel=1:n;
siz = size(A);
% Find linear indexes
% It is better to compute linind directly rather than calling sub2ind
% linind=sub2ind(siz,sel,sel);
linind = sel + (sel - 1).*siz(1);


A(linind)=1+A(linind);
% Notice that:
% -E*E' = matrix -H = -X*inv(X'X)*X' computed through qr decomposition
% A = Matrix I - H


if ~isnan(la)
    la1=la(1);
    %geometric mean of the y
    G=exp(mean(log(y)));
    %  if la1==0
    if la==0
        z=G*log(y);
    else
        z=(y.^la1-1)/(la*G^(la1-1));
    end
else
    z=y;
end

Az=A*z;
r=z'*Az;
Aw=A*w;
zAw=z'*Aw;
wAw=w'*Aw;

if wAw <1e-12
    Sz_square=NaN;
    Tl=NaN;
    b=NaN;
    pval=NaN;
    if coder.target('MATLAB')
        warning('FSDA:addt:NearlySingularMatrix','The augmented X matrix is nearly singular');
    end
else
    % b=regress(Az,Aw);
    b=zAw/wAw;

    Sz=sqrt(r-zAw^2/wAw); % See Atkinson (1985) p. 98
    Sz_square=Sz^2/(n-p-1);

    if abs(real(Sz)) > 0.0000001
        % Compute t-statistic
        Tl=zAw*sqrt(n-p-1)/(Sz*sqrt(wAw));
        % Compute p-value of t-statistic
        pval=2*(1-tcdf(abs(Tl),n-p-1));
    else
        Tl=NaN;
        pval=NaN;
    end
end


% Store results in structure out.
out.b=b;
out.S2add=Sz_square;
out.Tadd=Tl;
out.pval=pval;


%% Added variable plot

if coder.target('MATLAB')
    if plots==1
        if ~isempty(units)
            sel=setdiffFS(1:length(y),units);
            [outsel]=addt(y(sel),X(sel,2:end),w(sel),'plots',0);

            plot(Aw(sel),Az(sel),'+b','MarkerSize',FontSize);
            hold('on');
            plot(Aw(units),Az(units),'or','MarkerSize',6,'MarkerFaceColor','r');

            xlimits = get(gca,'Xlim');
            % Superimpose line based on all units
            line(xlimits , b.*xlimits,'Color','r','LineWidth',2);
            % Superimposed line based on reduced set of units
            line(xlimits , outsel.b.*xlimits,'LineWidth',2);
            if textlab==true
                text(Aw(units)+0.05,Az(units),num2str(units),'FontSize',FontSize);
            end
            set(gca,'FontSize',SizeAxesNum)

            xlabel('Aw','Fontsize',FontSize);
            ylabel('Ay','Fontsize',FontSize);
            % Format for the legend
            forleg='%11.3g';
            forleg1='%3.2g';

            legend('Normal units','Excluded units',['Fit on all units tstat=' num2str(Tl,forleg) ' (pval=' num2str(pval,forleg1) ')'],...
                ['Fit on subset tstat=' num2str(outsel.Tadd,forleg) ' (pval=' num2str(outsel.pval,forleg1) ')'])
            hold('off');

            %olsline(2)
        else
            plot(Aw,Az,'+');
            xlimits = get(gca,'Xlim');
            % Superimpose line based on all units
            line(xlimits, b.*xlimits,'LineWidth',3);
            set(gca,'FontSize',SizeAxesNum)

            xlabel('Aw','Fontsize',FontSize);
            ylabel('Ay','Fontsize',FontSize);

        end

        % Make the legends clickable.
        hLines = findobj(gca, 'type', 'line');
        eLegend = cell(length(hLines), 1);
        for iLines = 1:length(hLines)
            eLegend{iLines} = get(hLines(iLines), 'DisplayName');
        end
        clickableMultiLegend(hLines, eLegend{:});

        % and freeze the scaling at the current limits
        axis(axis); % equivalent to "axis manual";

    end
end
end

function validateY(y)
[m,q]=size(y);
if min(m,q)>1 || isempty(y)
    error('FSDA:chkinputR:Wrongy','y is not one-dimensional.');
end
end

function validateX(y, X)
if ~ismatrix(X) || isempty(X)
    error('FSDA:chkinputR:WrongX','Invalid data set X.');
end

if isequal(y,X)
    error('FSDA:chkinputR:yXequal','Invalid input: y and X are equal.');
end

% Check dimension consistency of X and y
na.X=~isfinite(X*ones(size(X,2),1));
na.y=~isfinite(y);
if size(na.X,1)~=size(na.y,1)
    error('FSDA:chkinputR:NxDiffNy','Number of observations in X and y not equal.');
end

end

function validateW(y,w)
na.y=~isfinite(y);
if size(w,1)~=size(na.y,1)
    error('FSDA:chkinputR:NxDiffNy','Number of observations in X and y not equal.');
end
end