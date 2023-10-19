import Foundation
func getData(urlRequest: URL?, completion: @escaping ((String) -> Void)) {

    guard let url = urlRequest else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            completion("code:\((response as? HTTPURLResponse)?.statusCode), \(error)")
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            guard let data = data else { return }
            do {
                var cards = try JSONDecoder().decode(Cards.self, from: data)
                var result = ""
                cards.cards.forEach {
                    result += """
                    
                     Имя карты: \($0.name)
                     Затраты маны: \($0.manaCost)
                     СМС: \($0.cmc)
                     Тип: \($0.type)
                     Редкость: \($0.rarity)
                     Набор: \($0.set)
                    _________________________
                    """
                }
                completion(result)
            }
            catch {
                
            }
        }
        else {
            completion("code:\((response as? HTTPURLResponse)?.statusCode)")
        }
    }.resume()
}

func makeRequest(host: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = "/v1/cards"
    urlComponents.queryItems = {
        [URLQueryItem(name: "name", value: "Black Lotus")]
    }()

    guard let url = urlComponents.url else {
        return nil
    }
    
    return url
}

getData(urlRequest: makeRequest(host: "api.magicthegathering.io"), completion: {info in print(info)})

struct Cards: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let name: String
    let manaCost: String
    let cmc: Int
    let type: String
    let types: [String]
    let rarity: String
    let set: String
    let setName: String
    let text: String
    let artist: String
    let number: String
    let layout: String
    let multiverseid: String?
    let imageUrl: String?
    let printings: [String]
    let originalText: String?
    let originalType: String?
    let legalities: [LegalitiesRow]?
    let id: String
    
}

struct LegalitiesRow: Codable {
    let format: String
    let legality: String
}
