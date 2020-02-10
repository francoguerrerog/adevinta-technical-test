import UIKit
import RxSwift

class ItemCellView: UITableViewCell {

    static let cellIdentifier = "ItemCellView"
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
