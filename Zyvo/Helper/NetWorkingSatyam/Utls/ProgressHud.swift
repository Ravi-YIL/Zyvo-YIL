
//
// Copyright (c) 2021 Related Code - https://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import NVActivityIndicatorView


class LoadingView {
   var loadingView: UIView = UIView()
   var ActivityIndicator : NVActivityIndicatorView? = nil
   
   func showActivityLoading(uiView: UIView,type:NVActivityIndicatorType = .orbit,color : UIColor = #colorLiteral(red: 0, green: 0, blue: 255, alpha: 1)) {
   
       ActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: type, color: color, padding: nil)
       
       ActivityIndicator?.center = uiView.center
       ActivityIndicator?.tag = 1
       ActivityIndicator?.type = .ballRotateChase
       uiView.addSubview(ActivityIndicator!)
      ActivityIndicator?.startAnimating()
   }
   func ActivityShow() -> Bool {
       if ActivityIndicator?.tag == 1 {
           return false
       }
       return true
   }
   func hideActivityLoading(uiView: UIView?) {
       ActivityIndicator?.stopAnimating()
       ActivityIndicator?.tag = 2
       ActivityIndicator?.removeFromSuperview()
   }
   func loadErrorS(view:UIViewController,yPoition:CGFloat = 20, ViewC:UIView,image:UIImage = #imageLiteral(resourceName: "no_data_found") ,tintColor:UIColor = .white, Show:Bool,tag: Int = -1) {
       for ii in ViewC.subviews {
           if let d = ii as? UIImageView,d.tag == tag {
               ii.removeFromSuperview()
           }
       }
       if Show {
           let img = UIImageView()
           img.image = image
           img.frame.size = CGSize(width: 150, height: 150)
           img.tag = tag
//            img = view.p_loadErrorMessage()
           img.center = ViewC.center
           img.frame.origin.y = yPoition
           img.image = img.image?.withRenderingMode(.alwaysTemplate)
           img.tintColor = tintColor
           ViewC.addSubview(img)
       }
   }
}
