/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Team 10
  ID: s3978826, s3978481, s388418, s3979367
  Created  date: 3/9/2024
  Last modified: 23/9/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/rt Foundation
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
