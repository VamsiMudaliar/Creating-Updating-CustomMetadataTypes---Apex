/**
 * @description       : 
 * @author            : Vamsi Mudaliar 
 * @group             : 
 * @last modified on  : 04-25-2022
 * @last modified by  : Vamsi Mudaliar 
**/
public with sharing class Asset_InsertUpdateMetadataRecords implements Metadata.DeployCallback{
    // Orgnamespace__CustomMetaDataTypeName
     private static String metadataTypeName = '{ADD YOUR NAMESPACE PREFIX HERE}__{ADD YOUR CUSTOM METADATA TYPE WITHOUT __mdt}';
     private static String labelName = '{ADD ANY LABEL HERE OF YOUR CHOICE}';
 
     /**
     * @description : this is an implementation method from Metadata.DeployCallback Interface which can be passed as a second parameter in line 59.
     * @author Vamsi Mudaliar  | 04-25-2022 
     * @param result 
     * @param context 
     **/
     public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
 
         if (result.status == Metadata.DeployStatus.Succeeded) {    
             System.debug('Deployment Success :'+result);
         } else {
             System.debug('Deployment Error :'+result);
         }
     }
 
     /**
     * @description : Performs Upsert Operation and Returns ApexAsyncJob Id to monitor the status of deployment.
     * @author Vamsi Mudaliar  | 04-25-2022 
     * @param jsonData 
     * @return Id 
     **/
     @AuraEnabled
     public static Id handleOperation(String jsonData) {
 
         Map<String,Object> fieldsToValueMap =  (Map<String, Object>) JSON.deserializeUntyped(jsonData);
         
         // appending with metadatatypeName to get the fullName
         metadataTypeName+='.'+labelName;
        // populating out CustomMetaDataType. 
         Metadata.CustomMetadata metadataObj = new Metadata.CustomMetadata();
         metadataObj.fullName = metadataTypeName;
         metadataObj.label = labelName;
 
         for(String fields:fieldsToValueMap.keySet()) {
            // adding fields passed from the UI
             Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
             customField.field = fields;
             customField.value = fieldsToValueMap.get(fields);
             metadataObj.values.add(customField);
         }
         // creating a container, to prepare for deploying the metadata record.
         Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
         mdContainer.addMetadata(metadataObj);

         // Retrieve AsyncApexJob Job Id to monitor the status of deployment.
         // Since the deployment is async process, We can addtionally pass a callback (handleResult) as the second parameter to get more details about the status. 
         Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);            
 
         return jobId; 
     }
 
     /**
     * @description : Used to fetch the metadata records for a given metadatatype.
     * @author Vamsi Mudaliar  | 04-25-2022 
     * @return List<Student__mdt> 
     **/
     @AuraEnabled
     public static List<Student__mdt> fetchRecords() {
 
           Map<String,Student__mdt> studentRecords = Student__mdt.getAll();
 
             if(studentRecords.isEmpty()) {
                 return null;
             }
             return studentRecords.values();
     }
 
     /**
     * @description : Fetching Metadata record Information for given MetadataRecordId.
     * @author Vamsi Mudaliar  | 04-25-2022 
     * @param metadataRecId 
     * @return Student__mdt 
     **/
     @AuraEnabled
     public static Student__mdt fetchSingleRecord(Id metadataRecId) {
         return Student__mdt.getInstance(metadataRecId);
     }
 
 
 
 }