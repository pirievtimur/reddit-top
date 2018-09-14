import ObjectMapper

struct TopPostModel: Mappable {
    var title: String
    var author: String
    var dateInSeconds: Int
    var postImages: PostImages?
    var commentsCount: Int?
    var imageURLString: String?
    var periodKey: String?
    
    init(title: String, author: String, dateInSeconds: Int) {
        self.title = title
        self.author = author
        self.dateInSeconds = dateInSeconds
    }
    
    init?(map: Map) {
        title = ""
        author = ""
        dateInSeconds = 0
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
        dateInSeconds <- map["created"]
        postImages <- map["preview"]
        commentsCount <- map["num_comments"]
        imageURLString <- map["url"]
    }
}

struct PostImages: Mappable {
    var sourceImage: PostImage?
    var images: [PostImage] = []

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        sourceImage <- map["images.0.source"]
        images <- map["images.0.resolutions"]
    }
}

struct PostImage: Mappable {
    var url: String
    var width: Float
    var height: Float
    
    init(url: String, width: Float, height: Float) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    init?(map: Map) {
        url = ""
        width = 0
        height = 0
    }
    
    mutating func mapping(map: Map) {
        url <- map["url"]
        width <- map["width"]
        height <- map["height"]
    }
}
