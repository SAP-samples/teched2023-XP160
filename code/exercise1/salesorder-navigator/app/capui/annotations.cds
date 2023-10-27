using OrderService as service from '../../srv/salesorder-service';

annotate service.SalesOrderSet with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'SalesOrderID',
            Value : SalesOrderID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Note',
            Value : Note,
        },
        {
            $Type : 'UI.DataField',
            Label : 'CustomerName',
            Value : CustomerName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'GrossAmount',
            Value : GrossAmount,
        },
        {
            $Type : 'UI.DataField',
            Label : 'CurrencyCode',
            Value : CurrencyCode,
        }
    ]
);
annotate service.SalesOrderSet with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'SalesOrderID',
                Value : SalesOrderID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Note',
                Value : Note,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CustomerName',
                Value : CustomerName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GrossAmount',
                Value : GrossAmount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CurrencyCode',
                Value : CurrencyCode,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
