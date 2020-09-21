

#### Queries for monitor datas #### 

query_select_prediction <- as.character("SELECT * FROM log_predictions
                                        WHERE data_as_of >= '2019-05-02'")

query_select_batchid <- as.character("SELECT * FROM log_batchid
                                     WHERE data_as_of  >= '2019-05-02'")

query_select_execution <- as.character("SELECT * FROM log_execution
                                       WHERE test_as_of  >= '2019-05-02'")


#### Queries for maintenance data #### 

query_select_min_preds <- as.character("
SELECT lp.LegalCaseID
    , CAST(lp.data_as_of AS DATE) AS pred_date_first
    , lp.preds_rr_init AS pred_init_first
    , lp.preds_rr_hear AS pred_hear_first
 FROM log_predictions lp
 RIGHT JOIN (SELECT MIN(data_as_of) AS data_as_of
               , LegalCaseID
               FROM log_predictions 
               GROUP BY LegalCaseID
             ) min_df ON lp.LegalCaseID = min_df.LegalCaseID AND lp.data_as_of = min_df.data_as_of
 WHERE lp.data_as_of >= '2019-05-02'")


query_select_max_preds <- as.character("
SELECT lp.LegalCaseID
   , CAST(lp.data_as_of AS DATE) AS pred_date_last
   , lp.preds_rr_init AS pred_init_last
   , lp.preds_rr_hear AS pred_hear_last
FROM log_predictions lp
RIGHT JOIN (SELECT MAX(data_as_of) AS data_as_of
             , LegalCaseID
             FROM log_predictions 
             GROUP BY LegalCaseID
           ) max_df ON lp.LegalCaseID = max_df.LegalCaseID AND lp.data_as_of = max_df.data_as_of
WHERE lp.data_as_of >= '2019-05-02'")


query_select_result_init <- as.character("
SELECT Id AS LegalCaseID
  , ApplicationDecision__c AS result_init
  , CAST(ApplicationDecisionDate__c AS DATE) AS date_init   
  , NetThisCase__c AS net_init
FROM legalcase__c
WHERE ApplicationDecisionDate__c BETWEEN '2019-05-02' AND getdate()")


query_select_result_hear <- as.character("
SELECT Id AS LegalCaseID
  , HearingDecision__c AS result_hear
  , CAST(HearingDecisionDate__c AS DATE) AS date_hear    
  , NetThisCase__c AS net_hear
FROM legalcase__c
WHERE HearingDecisionDate__c BETWEEN '2019-05-02' AND getdate()")



