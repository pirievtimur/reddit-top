import UIKit
import RxCocoa
import RxSwift

class TopPostsViewController: UIViewController {
    
    private let viewModel = TopPostsViewModel(api: APIService())
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupBinding()
        load()
    }
    
    func load() {
        viewModel.load().publish().connect().disposed(by: disposeBag)
    }
    
    func loadNext() {
        viewModel.loadNext().publish().connect().disposed(by: disposeBag)
    }

    func setupBinding() {
        let output = viewModel.output()
        
        output.data.drive(tableView.rx.items(cellIdentifier: "Cell")) { (_, postModel, cell) in
            cell.textLabel?.text = postModel.title
        }.disposed(by: disposeBag)
        
        output.data.map { String($0.count) }.drive(navigationItem.rx.title).disposed(by: disposeBag)
        
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
        let loadingNextPageOffset: CGFloat = 20.0
        return contentOffset.y + tableView.frame.size.height + loadingNextPageOffset > tableView.contentSize.height
    }
}
