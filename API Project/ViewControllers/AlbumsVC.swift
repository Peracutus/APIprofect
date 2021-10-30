//
//  LogInVC.swift
//  API Project
//
//  Created by Roman on 08.10.2021.
//

import UIKit
import EasyPeasy

class AlbumsVC: UIViewController {
    
    
    //MARK: - Create views
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var albums = [Album]()
    var timer: Timer?
    
    //MARK: - viewDidLoad
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupDelegate()
        setNavigationBar()
        setupSearchController()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    //MARK: - Set Constraints
    
    private func setConstraints() {
        tableView.easy.layout(Top().to(view.safeAreaLayoutGuide, .top),Left(),Right(),Bottom())
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
    
    private func setNavigationBar() {
        
        navigationItem.title = "Albums"
        navigationItem.searchController = searchController
        let userInfoButton = createCustomButton(selector: #selector(userInfoTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    //MARK: - Button actions
    
    @objc private func userInfoTapped() {
        let userView = UserInfoVC()
        navigationController?.pushViewController(userView, animated: true)
    }
}


extension AlbumsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumTableViewCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumVC = DetailVC()
        let album = albums[indexPath.row]
        detailAlbumVC.album = album
        detailAlbumVC.title = album.artistName
        navigationController?.pushViewController(detailAlbumVC, animated: true)
    }
    //MARK: - fetch request to take info about albums from URL
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            
            if error == nil {
                
                guard let albumModel = albumModel  else {return}
                
                if albumModel.results != [] {
                    
                    // sorting fetched albums by alphabet ascending
                    let sortedAlbums = albumModel.results.sorted { first, second in
                        return first.collectionName.compare(second.collectionName) == ComparisonResult.orderedAscending
                    }
                    self?.albums = sortedAlbums
                    self?.tableView.reloadData()
                } else {
                    self?.alertForButton(title: "Error", message: "Album not founded. Add some words ")
                }
            } else {
                print( error!.localizedDescription)
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension AlbumsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) // allows to search russian albums
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: text!)
            })
        }
    }
}
