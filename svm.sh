cat traindb/predict.csv | tr -d '"' | sed 's/,/ | /g' > traindb/vw_pred	
cat traindb/vw_train| python format_svm.py > traindb/svm_train
cat traindb/vw_test| python format_svm.py > traindb/svm_test
cat traindb/vw_pred | python format_svm.py > traindb/svm_pred

svm_rank_learn -c 1   traindb/svm_train model/svm_model
cat traindb/test.csv | python binary.py > traindb/vw_test

cat traindb/vw_test | awk -F'|' '{print $1}'  > traindb/gold

svm_rank_classify traindb/svm_test model/svm_model traindb/svm_test_pred

perf -roc -files traindb/gold traindb/svm_test_pred  | grep ROC >model/auc

cat traindb/vw_pred |  awk -F'|' '{print $1}' > traindb/id
svm_rank_classify traindb/svm_pred model/svm_model traindb/svm_pred_daily
paste traindb/id traindb/svm_pred_daily > traindb/pred_final



