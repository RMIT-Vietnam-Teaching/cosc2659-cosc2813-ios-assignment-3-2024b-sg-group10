import Foundation
import Combine

class APIManager {
    static let shared = APIManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTrafficReports(completion: @escaping (Result<[TrafficReport], Error>) -> Void) {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.getReportsEndpoint) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TrafficReport].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { reports in
                completion(.success(reports))
            })
            .store(in: &cancellables)
    }
}
