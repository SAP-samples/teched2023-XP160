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

    this.on('checkSalesOrderShipping', async (req) => {
        var response = {};
        var tmp = req.params;
        try {
            //const { tenant } = req;
            const shippingState = await cds.connect.to("dhl-shipping-function-on-azure") ;
            response = await shippingState.tx(req).post("/", {"key":"value"});
            console.log(`DHL STATE: ${JSON.stringify(response.data)}`)
        } catch (error) {
            console.error(`Error: ${error?.message}`);
        }
        return { response }
     });

});