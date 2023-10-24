sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        onPress: function(oEvent) {
            //MessageToast.show("Custom handler invoked.");
            this.editFlow
            .invokeAction("OrderService.checkSalesOrderShipping", {
                contexts: oEvent.getSource().getBindingContext()
            })
            .then(function (response) {
                MessageToast.show(response.getObject().value);
            });
        }
    };
});
