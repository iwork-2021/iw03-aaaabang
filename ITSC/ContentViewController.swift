//
//  ContentViewController.swift
//  ITSC
//
//  Created by aaaabang on 2021/11/15.
//

import UIKit
import SwiftSoup
import WebKit

protocol ContentDelegate{
    //func showContent(item:NewsItem)
}


class ContentViewController: UIViewController {

    
    var contentDelegate:ContentDelegate?
    var url:URL?
    let webView = WKWebView()
    let baseUrl = URL(string: "https://itsc.nju.edu.cn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let queue = DispatchQueue(label: "com.ITSC.aaaabang")
//            queue.sync {
//                self.fetchData()
//                }
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
                                let content = self.loadContent(html: string)//解析content段html
                                self.webView.loadHTMLString(content, baseURL: self.baseUrl)//使用webView加载
                            }
                       
                           
            }
        })
        task.resume()
    }
    
    func loadContent(html:String)->String{
        do{
            var content:String = ""
            //解析出标题日期集合
            let str = "11dadsddabc"
                    // 1. 创建正则表达式规则
                    let pattern = "^[a-z].*[a-z]$"
                    
                    // 2. 创建正则表达式对象
                    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                        return content
                    }
                    
                    // 3. 匹配字符串中内容
                   let results =  regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
                    
                    // 4.遍历数组,获取结果[NSTextCheckingResult]
                    
                    for result in results {
                        print(result.range)
                        let string = (str as NSString).substring(with: result.range)
                        print(string)
                    }
        
            return content
                 
        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }

    }
//
//    //从url解析图片
//    func loadImage(url:URL){
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("\(error.localizedDescription)")
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("server error")
//                return
//            }
//            DispatchQueue.main.async {
//                if(data == nil){
//                    self.image.image = UIImage(named: "default.jpg")
//                }else{
//                    self.image.image = UIImage(data: data!)
//                }
//            }
//        }.resume()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
