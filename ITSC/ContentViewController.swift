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
    var urlStr:String?
    var url:URL?
    let webView = WKWebView()
    let baseUrl = URL(string: "https://itsc.nju.edu.cn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmp = (self.urlStr!.dropLast(4)) + "m.htm"
        self.urlStr = "https://itsc.nju.edu.cn" + tmp
        self.url = URL(string: self.urlStr!)
        print(self.urlStr)
        self.view = webView
        self.fetchData()
 
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
                                print(content)
                                self.webView.loadHTMLString(content, baseURL: self.baseUrl)//使用webView加载
                            }
                       
                           
            }
        })
        task.resume()
    }
    
    func loadContent(html:String)->String{
          do{
            var content:String = ""
            // 1. 创建正则表达式规则<!--End||content-->
            let pattern = #"<!--Start\|\|Container-->(.*)<!--End\|\|Container-->"#//"<!\\-\\-Start\\|\\|content\\-\\->(.*)<!\\-\\-End\\|\\|content\\-\\->"

            // 2. 创建正则表达式对象
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else {
                return "failed"
            }

            // 3. 匹配字符串中内容
           let result =  regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count))

            content = (html as NSString).substring(with: result!.range)


              var head:String = ""
              let pattern1 = #".*<!--Start\|\|Header-->"#
              guard let regex1 = try? NSRegularExpression(pattern: pattern1, options:.dotMatchesLineSeparators) else {
                  return "failed"
              }

              // 3. 匹配字符串中内容
              let result1 =  regex1.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count))

              head = (html as NSString).substring(with: result1!.range)

              var tail:String = ""
              let pattern2 = #"<!--Start\|\|Footer-->(.*)"#
              guard let regex2 = try? NSRegularExpression(pattern: pattern2, options: .dotMatchesLineSeparators) else {
                  return "failed"
              }
              let result2 =  regex2.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count))
             tail = (html as NSString).substring(with: result2!.range)
              content = head + content + tail
              return content


        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }
        
        return " "
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
