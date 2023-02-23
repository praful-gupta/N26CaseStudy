import { LightningElement, api, wire, track} from 'lwc';
import fetchProductFeesDetails from '@salesforce/apex/ProductFeesDetailsController.fetchClientFees';

const columns = [
    { label: 'Cost Type', fieldName: 'costType' },
    { label: 'Product', fieldName: 'productType' },
    { label: 'Fees', fieldName: 'fees'},
    { label: 'Home Country', fieldName: 'homeCountry'},
];


export default class ContactOnCaseProductFees extends LightningElement {

    @api recordId;
    @track productFeesDetails;
    error;
    columns = columns;

    @wire(fetchProductFeesDetails , { caseId: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        if (data) {
            this.productFeesDetails  = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.productFeesDetails  = undefined;
        }
    }
}