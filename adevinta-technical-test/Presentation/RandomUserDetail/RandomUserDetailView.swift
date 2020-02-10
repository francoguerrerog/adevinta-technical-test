import UIKit

class RandomUserDetailView: UIView {

    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var regitrationDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static func initFromNib(owner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> Self {
        
        let nib = UINib(nibName: String(describing: self), bundle: Bundle(for: self))
        return nib.instantiate(withOwner: owner, options: options).first as! Self
    }
}
