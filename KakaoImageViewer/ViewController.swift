//
//  ViewController.swift
//  KakaoImageViewer
//
//  Created by Doyeong Yeom on 19/12/2018.
//  Copyright © 2018 Doyeong Yeom. All rights reserved.
//

import Kingfisher

class ViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String?
    var page: Int = 0
    var imageList: ImageListModel?
    var isNextLoading = false
    var updateTimeStamp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 9.1, *) {
            self.searchController.obscuresBackgroundDuringPresentation = false
        } else {
            self.searchController.dimsBackgroundDuringPresentation = false
        }
        self.searchController.searchBar.placeholder = "Search Images"
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.search), userInfo: nil, repeats: true)
        
        self.setTableViewBackground()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignFirstResponderFromSearchBar)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    func setTableViewBackground() {
        let messageLabel = UILabel()
        messageLabel.text = "검색결과가 없습니다"
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.tableView.backgroundView = messageLabel
    }

    func loadSections() {
        guard let searchText = self.searchController.searchBar.text else { self.refreshControl?.endRefreshing(); return }
        APIService.searchImage(searchText: searchText, page: 1).responseJSON { r in
            let jsonDecoder = JSONDecoder()
            debugPrint(r)
            if let jsonData = r.data {
                do {
                    let imageList = try jsonDecoder.decode(ImageListModel.self, from: jsonData)
                    self.imageList = imageList
                    self.page = 1
                    self.tableView.reloadData()
                } catch let error{
                    let alert = UIAlertController(title: "이미지 가져오기 에러", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func loadNextSections() {
        self.isNextLoading = true
        guard let searchText = self.searchController.searchBar.text else { self.refreshControl?.endRefreshing(); return }
        APIService.searchImage(searchText: searchText, page: self.page + 1).responseJSON { r in
            let jsonDecoder = JSONDecoder()
            debugPrint(r)
            if let jsonData = r.data {
                do {
                    let imageList = try jsonDecoder.decode(ImageListModel.self, from: jsonData)
                    if let documents = imageList.documents {
                        self.imageList?.documents?.append(contentsOf: documents)
                        self.page += 1
                        self.tableView.reloadData()
                    }
                } catch let error{
                    let alert = UIAlertController(title: "이미지 가져오기 에러", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
            self.isNextLoading = false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageList?.documents?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell {
            if let urlString = self.imageList?.documents?[indexPath.row].imageUrl {
                cell.contentImageView.kf.setImage(with: URL(string: urlString))
            }
            if let count = self.imageList?.documents?.count, indexPath.row == count - 1 {
                self.loadNextSections()
            }
            return cell
        } else {
            return ImageTableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let imageInfo = self.imageList?.documents?[indexPath.row] {
            return CGFloat(imageInfo.height ?? 0) * (tableView.frame.size.width / CGFloat(imageInfo.width ?? 0))
        }
        
        return 0
    }
    
    @objc func search() {
        if self.searchText != self.searchController.searchBar.text {
            self.searchText = self.searchController.searchBar.text
            self.loadSections()
        }
    }
    
    @objc func resignFirstResponderFromSearchBar(){
        self.searchController.searchBar.resignFirstResponder()
    }
}
