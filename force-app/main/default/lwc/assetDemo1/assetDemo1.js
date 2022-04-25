import { LightningElement } from 'lwc';
import fetchRecords from '@salesforce/apex/Asset_InsertUpdateMetadataRecords.fetchRecords';
import handleOperation from '@salesforce/apex/Asset_InsertUpdateMetadataRecords.handleOperation';
import fetchSingleRecord from '@salesforce/apex/Asset_InsertUpdateMetadataRecords.fetchSingleRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AssetDemo1 extends LightningElement {

    clearFilters() {
        return {
            firstName:'',
            lastName:'',
            email:'',
            phone:''
        };
    }

    studentRecord=this.clearFilters();
    studentList=[];

    toggleModal = false;

    connectedCallback() {
        this.fetchData();
    }

    handleModalClick() {
        this.toggleModal = !this.toggleModal;
    }

   async fetchData() {
        try {
            this.studentList = await fetchRecords();
            console.log('JSON DATA >>>',JSON.stringify(this.studentList));
        }   
        catch(err) {
            console.log('ERROR',err);
        } 
    }


    // following factory pattern
    handleOperation(event) {
        const operation = event.currentTarget.name;
        console.log('Operation');
        switch(operation) {
            case 'save' :  this.handleSave(event);
                console.log('Handle Saved');
                break;
            case 'update': this.handleUpdate(event);
                console.log('Handle Update');
                break;
            default :
            break;
        }
    }
    handleChange(event) {
        const element = event.target.name;

        switch(element) {
            case 'fname' :  this.studentRecord.firstName = event.target.value;
                break;
            case 'lname' : this.studentRecord.lastName = event.target.value;
                break;
                
            case 'email' : this.studentRecord.email = event.target.value;
                break;
            case 'phone' : this.studentRecord.phone = event.target.value;
                break;
            default :break;
        }
    }

    showNotification(message,variant) {

        this.dispatchEvent(new ShowToastEvent({
            message: message,
            variant: variant,
        }));
    }

    handleUpdate(event) {
        let labelValue = event.currentTarget.dataset.value;
        console.log('LABEL VALUE '+labelValue);

        fetchSingleRecord({metadataRecId:labelValue})
        .then(data=>{
            console.log('SINGLE DATA FETCHED >>',JSON.stringify(data));
            this.studentRecord = {
                'firstName' : data.vamsiDemoOrg__First_Name__c,
                'lastName': data.vamsiDemoOrg__Last_Name__c,
                'phone': data.vamsiDemoOrg__Phone__c,
                'email': data.vamsiDemoOrg__Email__c
            }
        })
        this.toggleModal = true;
       this.fetchData();
    }

    handleSave(event) {

        const objToPass = {
            'First_Name__c' : this.studentRecord.firstName,
            'Last_Name__c': this.studentRecord.lastName,
            'Phone__c': this.studentRecord.phone,
            'Email__c': this.studentRecord.email
        }

        handleOperation({
            jsonData:JSON.stringify(objToPass)
        })
        .then(result=>{
            console.log('RESULTS FETCHED SUCCESS',result);
            this.studentRecord = this.clearFilters(); 
            this.showNotification('Record Created/Updated Successfully !','success');
        })
        .catch(err=>{
            console.log('ERRORR ',err);
            this.showNotification('Something Went Wrong','error');
        })
        this.studentRecord=this.clearFilters();
        this.toggleModal = false;
        this.fetchData();

    }
    
}