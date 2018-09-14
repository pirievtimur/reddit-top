import UIKit
import SnapKit
import Kingfisher

class TopPostCell: UITableViewCell {
    static let identifier = "TopPostCell"
    
    private lazy var titleLabel = createLabel(fontSize: 17, color: .black)
    private lazy var authorTimeLabel = createLabel(fontSize: 12, color: .lightGray)
    private lazy var postImageView = createImageView()
    private lazy var commentsNumberLabel = createLabel(fontSize: 12, color: .lightGray)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        authorTimeLabel.text = nil
        postImageView.image = nil
        commentsNumberLabel.text = nil
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(authorTimeLabel)
        addSubview(postImageView)
        addSubview(commentsNumberLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        authorTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        postImageView.snp.makeConstraints {
            $0.top.equalTo(authorTimeLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        commentsNumberLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func updateWithModel(model: TopPostModel) {
        titleLabel.text = model.title
        authorTimeLabel.text = "Posted by \(model.author)"
        
        if let urlString = model.imageURLString, let url = URL(string: urlString) {
            postImageView.kf.setImage(with: url)
        }
        
        if let comments = model.commentsCount, comments > 0 {
            let commentsString = comments == 1 ? "comment" : "comments"
            commentsNumberLabel.text = "\(comments) \(commentsString)"
        }
    }
}

private extension TopPostCell {
    func createLabel(fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = color
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
}
