const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
    const { SalesOrderSet } = this.entities;
    
	this.on('READ', SalesOrderSet, async request => {
        try{
            const service = await cds.connect.to('gwsample');
            return await service.tx(request).run(request.query);
        } catch (err) {
            request.reject(err);
        }
    });

    this.on('checkSalesOrderShipping', async (req, data) => {
        var response = {};
        try {
            //const { tenant } = req;
            const shippingState = await cds.connect.to("DHL_SHIPPING_FUNC_ON_AZURE") ;
            response = shippingState.tx(req).post("/", data);
        } catch (error) {
            console.error(`Error: ${error?.message}`);
        }
        return { response }
     });

});