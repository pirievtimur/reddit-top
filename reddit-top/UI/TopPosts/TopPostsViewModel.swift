import RxSwift
import RxCocoa

class TopPostsViewModel {
    
    struct Output {
        var data: Driver<[TopPostModel]>
    }
    
    private let disposeBag = DisposeBag()
    private let data = PublishSubject<[TopPostModel]>()
    private var posts: [TopPostModel] = []
    private var loadMore: Bool = true

    private var itemsPerPage: UInt {
        return 10
    }
    
    private let topPostsAPI: TopPostsAPI
    
    init(api: TopPostsAPI) {
        self.topPostsAPI = api
    }
    
    func load() -> Observable<Void> {
        posts = []
        return loadPosts()
    }
    
    func loadNext() -> Observable<Void> {
        return loadMore ? loadPosts() : Observable.empty()
    }
    
    private func loadPosts() -> Observable<Void> {
        return topPostsAPI
            .load(items: itemsPerPage, after: posts.first?.periodKey)
            .do(onNext: { [weak self] items in
                guard let weakSelf = self else { return }
                weakSelf.loadMore = items.count == weakSelf.itemsPerPage
                weakSelf.posts.append(contentsOf: items)
                weakSelf.data.onNext(weakSelf.posts)
            })
            .mapToVoid()
    }
    
    func output() -> Output {
        return Output(data: data.asDriver(onErrorJustReturn: []))
    }
}
