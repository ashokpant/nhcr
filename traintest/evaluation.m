function [out] = evaluation(targets, outputs)
[c,cm,ind,per] = confusion(targets, outputs);

out.confusion.c = c;
out.confusion.cm = cm;
out.confusion.ind = ind;
out.confusion.per = per;

nClasses=size(outputs,1);
beta=1;

avgAccuray=0.0;

errRate=0.0;

numeratorP=0.0;
denominatorP=0.0;

numeratorR=0.0;
denominatorR=0.0;

precisionMacro=0.0;

recallMacro=0.0;
for i=1:nClasses
    fn=per(i,1);
    fp=per(i,2);
    tp=per(i,3);
    tn=per(i,4);
    
    avgAccuray=+avgAccuray+((tp+tn)/(tp+fn+fp+tn));
    
    errRate=+errRate+((fp+fn)/(tp+fn+fp+tn));
    
    numeratorP=numeratorP+tp;
    denominatorP=denominatorP+ (tp+fp);
    
    numeratorR=numeratorR+tp;
    denominatorR=denominatorR + (tp+fn);
    
    precisionMacro=precisionMacro+(tp/(tp+fp));
    
    recallMacro=recallMacro+(tp/(tp+fn));
end
%Average Accuracy (The average per-class effectiveness of a classifier)
avgAccuray=avgAccuray/nClasses;

%Error Rate (The average per-class classification error)
errRate=errRate/nClasses;

%Precision-Micro (Agreement of the data class labels with those of a
%classifiers if calculated from sums of per-text decisions)
precisionMicro=numeratorP/denominatorP;

%Recall-Micro (Effectiveness of a classifier to identify class labels if
%calculated from sums of per-text decisions)
recallMicro=numeratorR/denominatorR;

%Fscore-Micro (Relations between data's positive labels and those given by a classifier based on sums of per-text decisions)
fscoreMicro= ((beta^2+1)*precisionMicro*recallMicro)/(beta^2*precisionMicro+recallMicro);

%Precision-Macro (An average per-class agreement of the data class labels with those of a classifiers)
precisionMacro=precisionMacro/nClasses;

%Recall-Micro (An average per-class effectiveness of a classifier to identify class labels)
recallMacro=recallMacro/nClasses;

%Fscore-Macro (Relations between data's positive labels and those given by a classifier based on a per-class average)
fscoreMacro=((beta^2+1)*precisionMacro*recallMacro)/(beta^2*precisionMacro+recallMacro);

out.avgAccuracy = avgAccuray*100;
out.errRate = errRate*100;
out.precisionMicro = precisionMicro*100;
out.recallMicro = recallMicro*100;
out.fscoreMicro = fscoreMicro*100;

out.precisionMacro = precisionMacro*100;
out.recallMacro = recallMacro*100;
out.fscoreMacro = fscoreMacro*100;
end
