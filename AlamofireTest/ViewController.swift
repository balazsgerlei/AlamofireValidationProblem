import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let baseUrl = "https://httpbin.org/"
    
    let url200 = "ip"
    let url422 = "status/422"
    let url418 = "status/418"

    @IBOutlet weak var activtiyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var validateBeforeSwitch: UISwitch!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonFirstTouchUpInside(_ sender: Any) {
        request(url: url200)
    }
    
    @IBAction func buttonSecondTouchUpInside(_ sender: Any) {
        request(url: url422)
    }
    
    @IBAction func buttonThirdTouchUpInside(_ sender: Any) {
        request(url: url418)
    }
    
    fileprivate func request(url: String) {
        activtiyIndicator.isHidden = false
        resultLabel.text = "---"
        resultLabel.textColor = .black
        
        var request = Alamofire.request(baseUrl + url)
        // Only validate here when the Switch is on
        if validateBeforeSwitch.isOn {
            request = request.validate()
        }
        request.responseString { [weak self] response in
            // This response handler is used before calling the closure which is
            // interested in the final result.
            // For example token refresh logic can
            // be implemented in this first response handler
            
            // Always validate here
            request.validate().responseString { [weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.activtiyIndicator.isHidden = true
                switch response.result {
                case .success:
                    strongSelf.resultLabel.text = "SUCCESS"
                    strongSelf.resultLabel.textColor = .green
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                    strongSelf.resultLabel.text = "ERROR"
                    strongSelf.resultLabel.textColor = .red
                }
            }
        }
    }

}
