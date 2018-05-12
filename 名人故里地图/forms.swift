import UIKit
import Eureka
import CoreLocation
import Parse
import CoreFoundation

//MARK: HomeViewController


typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"





class submitted : FormViewController {
    
    
    var savepeople = PFObject(className:"people")
    var state = 0

    var heropinyin = ""
    var heroname = ""
    var heronewplace = ""
    var herooldplace = ""
    var heroword = ""
    var heroloc = CLLocation(latitude: 1, longitude: 1)
    var heroclass = ""
    //var heroimage:PFFile
    
    var baike = ""
    var comment = ""
    var email = ""
    var qqnum = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "名人资料提交"

        URLRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .blueColor() }
        LabelRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orangeColor()  }
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .orangeColor() }
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() }
        
        form =
            
            Section("必填信息")
            
            <<< TextRow() {
                $0.title = "姓名"
                $0.placeholder = "赵云"
                }.onChange{row in
                    if row.value != nil{
                    self.heroname = "\(row.value)"
                    self.savepeople["name"] = row.value! as String}
                    if self.state == 1{
                        self.state = 0}
            }
            
            <<< TextRow() {
                $0.title = "头衔"
                $0.placeholder = "字子龙，蜀国五虎将"
                }.onChange{row in
                    if row.value != nil{

                    self.savepeople["word"] = row.value! as String}
            }
            
            <<< AlertRow<String>() {
                $0.title = "所属类别"
                $0.selectorTitle = "该名人属于什么类别？"
                $0.options = ["古代英杰", "三国", "当代政坛", "科学家", "娱乐人物", "体坛人物"]
                $0.value = "古代英杰"
                }.onChange { row in
                    self.savepeople["class"] = row.value! as String
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purpleColor()
            }

            <<< LocationRow(){
                $0.title = "家乡准确位置"
                $0.value = CLLocation(latitude: 39.9137, longitude: 116.3914)
                }.onChange {row in
                    
                    self.savepeople["geopoint"] = PFGeoPoint(latitude:row.value!.coordinate.latitude, longitude:row.value!.coordinate.longitude)
                }
            
            
            <<< TextRow() {
                $0.title = "家乡现在的名称"
                $0.placeholder = "江苏省盐城市盐都区"
                }.onChange{row in
                    if row.value != nil{

                    self.savepeople["newlocname"] = row.value! as String}
            }
            <<< ImageRow(){
                $0.title = "名人肖像"
                }.onChange{row in
                    var str = NSMutableString(string: "\(self.heroname)") as CFMutableString
                    
                    if CFStringTransform(str, nil, kCFStringTransformToLatin, false) == true {
                        if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) == true{
                            self.heropinyin = "\(str)"
                            var token = self.heropinyin.componentsSeparatedByString("\"")
                            print(token[1])
                            self.heropinyin = token[1].stringByReplacingOccurrencesOfString(" ", withString: "-")

                            print(self.heropinyin)
                        }
                    }
                    
                    
                    
                    let imageData = UIImageJPEGRepresentation(row.value!,0.5)
                    let imageFile = PFFile(name:"\(self.heropinyin).jpg", data:imageData!)
                    self.savepeople["portrait"] = imageFile
            }

            +++ Section("选填信息，丰富信息增大进入数据库的几率")
            <<< TextRow() {
                $0.title = "人物介绍百科页面(百度百科最佳)"
                $0.placeholder = "http://baike.baidu.com/"
        }.onChange{row in
            if row.value != nil{

            self.savepeople["baike"] = row.value! as String}
            }
            
            <<< TextRow() {
                $0.title = "人物故乡古代名称"
                $0.placeholder = "例吴郡吴中"
                }.onChange{row in
                    if row.value != nil{

                    self.savepeople["oldlocname"] = row.value! as String}
            }
            
            <<< TextAreaRow("英雄生平") {
                $0.placeholder = "人物生平论述，展现您的文采"
                }.onChange{row in
                    if row.value != nil{

                    self.savepeople["comment"] = row.value! as String}
            }
            
            
            +++ Section("选填信息：您的个人信息，便于请教查证")
            <<< EmailRow() {
                $0.title = "您的email地址"
                $0.value = "@"
                }.onChange{row in
                    if row.value != nil {
                    self.savepeople["email"] = row.value! as String}
            }
            <<< PhoneRow() {
                $0.title = "QQ号码"
                $0.value = ""
                $0.disabled = false
                }.onChange{row in
                    if row.value != nil{
                    self.savepeople["qq"] = row.value! as String}
        }
    }
    
      
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    @IBAction func submitform(sender: AnyObject) {
        
        if state == 0{
        if savepeople["name"] == nil || savepeople["word"] == nil || savepeople["class"] == nil || savepeople["newlocname"] == nil || savepeople["geopoint"] == nil || savepeople["portrait"] == nil{
            self.displayAlert("提交失败", message: "信息不完整，完成必填信息，谢谢")
        }else{
            
        
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        savepeople["config"] = 3
        savepeople["like"] = 0
        savepeople.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            // Handle success or failure here ...
            if error == nil{
            self.displayAlert("提交成功", message: "感谢您为本软件做出的贡献！")
            self.navigationController?.popToRootViewControllerAnimated(true)
                self.state = 1
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            }else{
            self.displayAlert("提交失败", message: "网络异常")
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            }
            
            }/*, progressBlock: {
                (percentDone: Int32) -> Void in
                // Update your progress spinner here. percentDone will be between 0 and 100.
                var percent = Float(amountDone)
                self.progress.progress = CGFloat(percent)/100
                self.progress.reveal()
        }*/)
    }
        }else{
            displayAlert("错误", message: "请勿重复提交，谢谢！")
           
        }
    }
    
    
    
    
    
    
    func multipleSelectorDone(item:UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
