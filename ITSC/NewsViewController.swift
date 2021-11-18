//
//  NewsViewController.swift
//  ITSC
//
//  Created by aaaabang on 2021/11/14.
//

import UIKit
import SwiftSoup
class NewsViewController: UITableViewController, ContentDelegate{
    
    var newsList:[NewsItem] = []
    var page = 1
    var index:Int = 0//新闻列表下标


    func fetchData() {
        
        var url:URL
        if page == 1{
            url = URL(string: "https://itsc.nju.edu.cn/xwdt/list.htm")!
        }else{
            url = URL(string: "https://itsc.nju.edu.cn/xwdt/list\(page).htm")!
        }
            
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
                                self.tableView.reloadData()
                            }
                        self.page = self.page + 1;
                        if self.page > 18{
                            print("End page")
                            self.page = 18
                            return
                        }else{
                            self.fetchData()
                        }
                           
            }
        })
        task.resume()
    }
    
    func loadContent(html:String){
        do{
            //解析出标题日期集合
            let doc: Document = try SwiftSoup.parse(html)
            let titles: Elements = try doc.select("span.news_title")
            let dates:Elements = try doc.select("span.news_meta")
            
            //设置标题和链接
            for item:Element in titles.array(){
                let title = try item.text()
                let temp = try item.getElementsByTag("a").first()!
                let link = try temp.attr("href")
                
                newsList.append(NewsItem(title: title, date: "", link: link))
            }
            //设置日期
            
            for item:Element in dates.array(){
                let date = try item.text()
                newsList[self.index].date = date
                self.index = self.index+1
            }
                
        }catch Exception.Error(let type, let message){
            print(message)
        }catch{
            print("error")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.fetchData()
    
            
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsViewCell

        if(indexPath.row >= newsList.count){
            cell.title.text! = ""
            cell.date.text! = ""
            return cell
        }
        
        // Configure the cell...
        
        let news = newsList[indexPath.row]
        print(news.title)
        cell.title.text! = news.title
        cell.date.text! = news.date
  
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let contentViewController = segue.destination as! ContentViewController
        let cell = sender as! NewsViewCell
        let item = newsList[tableView.indexPath(for: cell)!.row]
        print(item.title)
        contentViewController.urlStr = item.link
        contentViewController.contentDelegate = self
        
       
    }
    

}
