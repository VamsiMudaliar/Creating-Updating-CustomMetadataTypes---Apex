/**
 * @description       : 
 * @author            : Vamsi Mudaliar 
 * @group             : 
 * @last modified on  : 04-25-2022
 * @last modified by  : Vamsi Mudaliar 
**/
public with sharing class Asset_InsertUpdateMetadataRecords implements Metadata.DeployCallback{
   // Orgnamespace__CustomMetaDataTypeName
    private static String metadataTypeName = 'vamsiDemoOrg__Student';

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {

        if (result.status == Metadata.DeployStatus.Succeeded) {    
            System.debug('Deployment Success :'+result);
        } else {
            System.debug('Deployment Error :'+result);
        }
    }

    @AuraEnabled
    public static Id handleOperation(String jsonData) {

        Map<String,Object> fieldsToValueMap =  (Map<String, Object>) JSON.deserializeUntyped(jsonData);

        Blob targetBlob = Blob.valueOf('ExampleMD5String');
        Blob testVal = Crypto.generateDigest('SHA-256',targetBlob);
        String labelName = EncodingUtil.base64Encode(testVal).substring(0, 5);
        metadataTypeName+='.'+labelName;

        Metadata.CustomMetadata metadataObj = new Metadata.CustomMetadata();
        metadataObj.fullName = metadataTypeName;
        metadataObj.label = labelName;

        for(String fields:fieldsToValueMap.keySet()) {

            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = fields;
            customField.value = fieldsToValueMap.get(fields);
            metadataObj.values.add(customField);
        }

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(metadataObj);

        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);            

        return jobId; 
    }

    @AuraEnabled
    public static List<Student__mdt> fetchRecords() {

          Map<String,Student__mdt> studentRecords = Student__mdt.getAll();

            if(studentRecords.isEmpty()) {
                return null;
            }
            return studentRecords.values();
    }

    @AuraEnabled
    public static Student__mdt fetchSingleRecord(Id metadataRecId) {
        return Student__mdt.getInstance(metadataRecId);
    }



}