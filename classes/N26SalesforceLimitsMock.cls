global class N26SalesforceLimitsMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"SingleEmail" : {"Max" : 15,"Remaining" : 5}}');
        res.setStatusCode(200);
        return res;
    }
}