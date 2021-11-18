//
//  AboutViewController.swift
//  ITSC
//
//  Created by aaaabang on 2021/11/18.
//

import UIKit
import SwiftSoup
class AboutViewController: UIViewController {
    let url: URL = URL(string: "https://itsc.nju.edu.cn/main.htm")!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
    }
    
    func fetchData() {

        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                        let data = data,
                        let string = String(data: data, encoding: .utf8) {
                            
                            DispatchQueue.main.async {
                                self.loadContent(html: string);
                            }
                           
            }
        })
        task.resume()
    }
    
    func loadContent(html:String){
        do{
            //解析出标题日期集合
            let doc: Document = try SwiftSoup.parse(html)
            let aboutInfo: Element = try doc.select("div.foot-center").first()!
            let aboutHtml: String = try aboutInfo.html()
            let aboutParseFile: Document = try SwiftSoup.parse(aboutHtml)
            let aboutItem: Elements = try aboutParseFile.select("div.news_box")
            
            self.label1.text! = try aboutItem.array()[0].text()
            self.label2.text! = try aboutItem.array()[1].text()
            self.label3.text! = try aboutItem.array()[2].text()
            self.label4.text! = try aboutItem.array()[3].text()
            self.label5.text! = try aboutItem.array()[4].text()
            self.label6.text! = try aboutItem.array()[5].text()

        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
