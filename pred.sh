cat traindb/predict.csv | tr -d '"' | sed 's/,/ | /g' > traindb/vw_pred	
cat traindb/vw_pred |  awk -F'|' '{print $1}' > traindb/id
vw -d traindb/vw_pred -t -i model.vw -p traindb/pred_day
paste traindb/id traindb/pred_day > traindb/pred_final


