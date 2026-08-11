import Vapor

struct CertRequest: Content {
    let bundleId: String
    let commonName: String?
    let email: String?
}

struct WorkerResponse: Content {
    let status: String
    let message: String?
    let downloadUrl: String?
}

final class CertController {
    func generate(_ req: Request) throws -> EventLoopFuture<WorkerResponse> {
        let payload = try req.content.decode(CertRequest.self)
        return req.client.post("http://worker:4567/generate") { workerReq in
            try workerReq.content.encode(payload)
        }.flatMapThrowing { resp in
            try resp.content.decode(WorkerResponse.self)
        }
    }
}
