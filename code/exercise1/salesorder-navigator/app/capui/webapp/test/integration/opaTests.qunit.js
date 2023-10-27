sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'capui/test/integration/FirstJourney',
		'capui/test/integration/pages/SalesOrderSetList',
		'capui/test/integration/pages/SalesOrderSetObjectPage'
    ],
    function(JourneyRunner, opaJourney, SalesOrderSetList, SalesOrderSetObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('capui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSalesOrderSetList: SalesOrderSetList,
					onTheSalesOrderSetObjectPage: SalesOrderSetObjectPage
                }
            },
            opaJourney.run
        );
    }
);