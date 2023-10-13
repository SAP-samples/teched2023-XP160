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
});