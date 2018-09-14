import RxSwift
import RxCocoa
import Foundation

protocol TopPostsAPI {
    func load(items: UInt, after afterMark: String?) -> Observable<[TopPostModel]>
}

class APIService {}

extension APIService: TopPostsAPI {
    
    private var mainURLString: String {
        return "https://www.reddit.com/top.json"
    }
    
    func load(items: UInt, after afterMark: String? = nil) -> Observable<[TopPostModel]> {
        guard var urlComponents = URLComponents(string: mainURLString) else { return Observable.just([]) }
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "limit", value: String(items))]
        if let mark = afterMark {
            queryItems.append(URLQueryItem(name: "after", value: mark))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return Observable.just([]) }
        
        return URLSession.shared.rx.json(url: url).retry(2)
            .map {
                var items: [TopPostModel] = []
                guard let json = $0 as? [String:AnyObject],
                    let data = json["data"] as? [String:AnyObject],
                    let children = data["children"] as? [[String:AnyObject]] else { return items }
                
                let periodKey: String? = data["after"] as? String
                
                children.forEach {
                    guard let data = $0["data"] as? [String:AnyObject],
                        let title = data["title"] as? String else { return }
                    
                    let post = TopPostModel(title: title, periodKey: periodKey)
                    
                    items.append(post)
                }
                
                return items
        }
    }
}

