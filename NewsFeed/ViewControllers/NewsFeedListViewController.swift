//
//  NewsFeedListViewController.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit
import SDWebImage
class NewsFeedListViewController: UIViewController {

    var serviceCall = Services()
    var newsFeedArray = NSMutableArray ()
    @IBOutlet weak var newsfeedTableView: UITableView!
    var news : News?
    var newsList = [NewsFeed]()
    var isFetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "News Feed"
        // Do any additional setup after loading the view.
        serviceCall.apiReponseProtocol = self
        self.registerNib()
        self.getNewsList(urlStr: Constants.mainURL + "/kstream")
    }
    
    func registerNib() {
        newsfeedTableView.register(UINib.init(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        newsfeedTableView.register(UINib.init(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        newsfeedTableView.estimatedRowHeight = newsfeedTableView.rowHeight
        newsfeedTableView.rowHeight = UITableView.automaticDimension
    }
    
    func getNewsList(urlStr:String) {
        var apitoken = "Bearer "
        apitoken += String(UserDefaults.standard.value(forKey: "api_token") as! String)
        serviceCall.newsFeedList(url: urlStr, body: NSDictionary(), requestStr: "GET",autorisation:  apitoken)
    }
}

extension NewsFeedListViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let noOfRows =  (newsList.count > 0) ? newsList.count : 0
            return noOfRows
        }else if section == 1 && isFetchingMore {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedCell else {
                return UITableViewCell()
            }
            let news = newsList[indexPath.row]
          
            cell.titleLbl.text = news.title!
            cell.descLbl.text = news.full_description
            cell.likesLbl.text = "\(String(describing: news.likes!)) Likes"
            cell.shareLbl.text = "\(String(describing: news.shares!)) Share"
            cell.comtLbl.text = "\(String(describing: news.comments!)) Cmts"
            cell.selectionStyle = .none
           
            guard let imgStr =  news.description_image_url else {
                return cell
            }
            let newStr = imgStr.components(separatedBy: "(webp)/")

            if newStr.count > 1 {
                cell.picImgView.sd_setImage(with: URL(string:"https://" + newStr[1]), placeholderImage: UIImage(named: "breakingnews.jpg"))
            }
         
          
            return cell
        } else  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                return UITableViewCell()
            }
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsFeedDetailVC =  self.storyboard?.instantiateViewController(withIdentifier:"NewsFeedDetailsViewController") as! NewsFeedDetailsViewController
        newsFeedDetailVC.news = newsList[indexPath.row]
        self.navigationController?.pushViewController(newsFeedDetailVC, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height

        if offsetY > contentSize - scrollView.frame.height {
            if !isFetchingMore {
                isFetchingMore = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     self.fetchingMoreRecords()
                }
               
            }
        }
    }
    
    func fetchingMoreRecords() {
       // newsfeedTableView.reloadSections(IndexSet(integer : 1), with: .none)
        guard let nextpageURL = news?.kstream.next_page_url else {
            return
        }
        self.getNewsList(urlStr: nextpageURL)
    }
}

extension NewsFeedListViewController: APIResponse{
    func errorResponse(error : NSError) {
        print("=== Error Response ===")
    }
    func successResponse(response: Any) {
        news = response as? News
        newsList += (response as! News).kstream.data
       
        isFetchingMore = false
        DispatchQueue.main.async {
            self.newsfeedTableView.reloadData()
        }
     }
}
