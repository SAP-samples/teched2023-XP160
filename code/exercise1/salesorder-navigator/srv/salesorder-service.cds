using { gwsample as external } from './external/gwsample';

service OrderService {
    @cds.persistence.skip
    entity SalesOrderSet as projection on external.SalesOrderSet {
        key SalesOrderID, Note, CustomerName, GrossAmount, CurrencyCode
    };
}