//
//  ContentViewController.swift
//  ITSC
//
//  Created by aaaabang on 2021/11/15.
//

import UIKit
import SwiftSoup
protocol ContentDelegate{
    //func showContent(item:NewsItem)
}


class ContentViewController: UIViewController {

    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var text2: UITextView!
    
    var contentDelegate:ContentDelegate?
    var url:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue(label: "com.ITSC.aaaabang")
            queue.sync {
                self.fetchData()
                }
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
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
                                self.loadContent(html: string)
                            }
                       
                           
            }
        })
        task.resume()
    }
    
    func loadContent(html:String){
        do{
            //解析出标题日期集合
        let doc: Document = try SwiftSoup.parse(html)
        let title = try doc.title()
        //let pics: Elements = try doc.select("img[src]")
        let texts:Element = try doc.select("div.read").first()!
        
        self._title.text! = title
        self.text1.text = String(try texts.text())
            
                 
        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }

    }
    
    //从url解析图片
    func loadImage(link:URL){
        
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
