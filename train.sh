#cat traindb/train.csv | python binary.py > traindb/vw_train
#cat traindb/test.csv | python binary.py > traindb/vw_test
cat traindb/train.csv | python reg.py > traindb/vw_train
cat traindb/test.csv | python reg.py > traindb/vw_test
cat traindb/vw_train| python format_svm.py > traindb/svm_train
cat traindb/vw_test| python format_svm.py > traindb/svm_test


rm -rf traindb/*.cache
rm model/model.txt
rm model/mode.vw

#vw -d traindb/vw_pair -c \
#--passes 1000 \
#--holdout_off \
#-f model_pair.vw \
#--readable_model model_pair.txt \
#--ngram 2 \
#-l 0.001 \
#--l2 0.001 \
#--passes 10000 \  
#--bfgs  
#--ngram 5 \
#--holdout_off \
#--loss_function hinge \
#-q ss \

/usr/local/bin/vw -d traindb/vw_train \
-c \
--passes 10000 \
-f model/model.vw \
--holdout_off \
--ngram 5 \
--readable_model model/model.txt 


cat traindb/vw_test | awk -F'|' '{print $1}'  > traindb/gold
#cat traindb/vw_test | awk -F'|' '{print $1}' | python cmp.py > traindb/gold
/usr/local/bin/vw -d traindb/vw_test -t -i model/model.vw -p traindb/pred_test
cat traindb/test.csv |  awk -F',' '{print $1}' > traindb/id
paste traindb/id traindb/gold traindb/pred_test > traindb/pred_test_cv
cat traindb/pred_test_cv | python rmse.py > model/auc
#/usr/local/bin/perf -roc -files traindb/gold traindb/pred_test > model/auc 
#cat model/auc


#--loss_function hinge \
#--bfgs 
#--ngram 2 \
#--ngram 2 \
    #-l 0.001 \
    #--ect 10 \
    #--error 2 \
    #--l2 0.001 \
#--normalized \
#--adaptive \

cat traindb/predict.csv | tr -d '"' | sed 's/,/ | /g' > traindb/vw_pred	
cat traindb/vw_pred |  awk -F'|' '{print $1}' > traindb/id
/usr/local/bin/vw -d traindb/vw_pred -t -i model/model.vw -p traindb/pred_day
paste traindb/id traindb/pred_day > traindb/pred_final


