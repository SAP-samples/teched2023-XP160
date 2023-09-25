import { app } from "@azure/functions";

app.http("fetchTrackingStatus", {
	methods: ["GET"],
	authLevel: "function",
	handler: async (request, context) => {
		context.log(
			`HTTP triggered function processed request for url "${request.url}"`,
		);

		const trackingId = request.query.get("trackingId");

		if (!trackingId) {
			return {
				status: 400,
				body: "Missing trackingId",
			};
		}

		const responseBody = getTrackingStatus(trackingId);

		context.log(`Response body: ${JSON.stringify(responseBody)}`);
		return {
			status: 200,
			jsonBody: responseBody,
		};
	},
});

function getTrackingStatus(trackingId: string) {
		const random = Math.floor(Math.random() * 4);
		return getEntryById(random, trackingId);
}

function getEntryById(id: number, trackingId: string) {
	const deliveryStatusMock = [
		{
			id: "",
			service: "express",
			statusCode: "transit",
			status: "customs inspection",
			remark: "The shipment is pending completion of customs inspection.",
			nextSteps: "The status will be updated following customs inspection.",
			estimatedTimeOfDelivery: "2023-11-06T00:00:00Z",
		},
		{
			id: "",
			service: "express",
			statusCode: "delivered",
			status: "delivered",
			remark: "The shipment is successfully delivered.",
			nextSteps: "",
			estimatedTimeOfDelivery: "2023-11-02T00:00:00Z",
		},
		{
			id: "",
			service: "freight",
			statusCode: "delivered",
			status: "delivered",
			remark: "The shipment is successfully delivered.",
			nextSteps: "",
			estimatedTimeOfDelivery: "2023-10-30T00:00:00Z",
		},
		{
			id: "",
			service: "express",
			statusCode: "announced",
			status: "sender announced shipment",
			remark: "The shipment was announced by the sender at pick up station.",
			nextSteps: "package to be picked up",
			estimatedTimeOfDelivery: "2023-11-17T00:00:00Z",
		},
	];

	const entry = deliveryStatusMock[id];
	entry.id = trackingId;
	return entry;
}
