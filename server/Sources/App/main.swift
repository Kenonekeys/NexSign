import Vapor

var env = try Environment.detect()
let app = Application(env)

defer { app.shutdown() }

// Simple route registrations
app.post("api","generate") { req -> EventLoopFuture<ClientResponse> in
    struct Payload: Content {
        var bundleId: String
        var commonName: String?
        var email: String?
    }

    let payload = try req.content.decode(Payload.self)

    // Forward the request to the fastlane worker service
    let client = req.client
    return client.post(URI(string: "http://worker:4567/generate")) { workerReq in
        try workerReq.content.encode(payload)
    }
}

app.get { req in
    return req.eventLoop.makeSucceededFuture("NexSign Apple ID Signing Service is running")
}

try app.run()
