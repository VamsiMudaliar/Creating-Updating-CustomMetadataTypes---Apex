# Inserting/Updating-CustomMetadataTypes Apex
Inserting/Updating Custom MetaData Records via Apex. Salesforce Spring Release.

In Salesforce, Custom metadata is metadata that can be customized, deployed, packaged, and upgraded. Records in custom metadata type are considered as metadata rather than data and we can deploy records of Custom Metadata Type with Change Set and other deployment tools. 
We can issue an unlimited number of Salesforce Object Query Language (SOQL) queries for each Apex transaction using custom metadata types.

From Setup we can Read, Create, Update & Delete records of Custom Metadata Type but DML operations on custom metadata are not permitted in Apex. 

## But we can perform DML operations with the Apex Metadata API.

In Order to Use this ApexClass/ LWC into your **Salesforce** org.

Make Sure you follow these steps: 

- [x] Replace metadatatypename and label name from the apex class with your coresponding custommetadata type.
- [x] Change the FieldApiNames in the LWC According to your Fields from the Custom Metadata Type. 

That's it 🚀

Before, jumping right onto the code, make sure you understand about Salesforce Metadata API and what it has to offer. 

Here's a quick go-through of above Interfaces/Classes which I used to implement. 


  > DeployCallback interface : An interface for metadata deployment callback classes. 
  Used when inserting/Updating Metadata record from Apex to handle result of deployment.
  
  > Metadata.DeployResult : is class that represents results of a metadata deployment.
 
  > Metadata.DeployCallbackContext: Contains context information for a deployment job (that is Id of the asynchronous job).
  
  > Metadata.DeployStatus.Succeeded: salesforce uses this enum to describe the status of the deployment.
  
  > CustomMetadata Class: it represents records of custom metadata type in apex class.

  > CustomMetadata.fullname: we need to provide the Qualified Name. For example, if the object name of Metadata is OfficesAsPerCountry then and you wanted to create a record named Test then the full name will look like ‘OfficesAsPerCountry.Test’.

  > CustomMetadata.label: Name of record you want to set. For example, Test.

  > CustomMetadataValue: is used to set Field and Value of Custom Metadata Type record.

  > DeployContainer: it is container of custom metadata components that will deploy.

  > Metadata.Operations.enqueueDeployment: return ID of deployment request.

