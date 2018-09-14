import UIKit
import RxCocoa
import RxSwift

class TopPostsViewController: UIViewController {
    
    private let viewModel = TopPostsViewModel(api: APIService())
    private let disposeBag = DisposeBag()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TopPostCell.self, forCellReuseIdentifier: TopPostCell.identifier)
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupSubviews()
        setupBinding()
        load()
    }
    
    func load() {
        viewModel.load().publish().connect().disposed(by: disposeBag)
    }
    
    func loadNext() {
        viewModel.loadNext().publish().connect().disposed(by: disposeBag)
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top)
            $0.bottom.equalTo(view.safeArea.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setupBinding() {
        let output = viewModel.output()
        
        output
            .data
            .drive(tableView.rx.items(cellIdentifier: TopPostCell.identifier)) { (_, postModel, cell) in
                if let postCell = cell as? TopPostCell {
                    postCell.updateWithModel(model: postModel)
                }
            }.disposed(by: disposeBag)
        
        output
            .data
            .map { String($0.count) }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .debounce(0.7, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let weakSelf = self else { return }
                if weakSelf.nearBottomEdge(contentOffset: offset, weakSelf.tableView) {
                    weakSelf.loadNext()
                }
            }).disposed(by: disposeBag)
    }

    func nearBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        let loadingNextPageOffset: CGFloat = 100
        return contentOffset.y + tableView.frame.size.height + loadingNextPageOffset > tableView.contentSize.height
    }
}
