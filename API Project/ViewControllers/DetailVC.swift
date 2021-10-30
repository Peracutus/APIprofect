//
//  DetailVC.swift
//  API Project
//
//  Created by Roman on 09.10.2021.
//

import UIKit
import EasyPeasy

class DetailVC: UIViewController {
    
    //MARK: - Create views
    private let albumLogo: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let albumNameLabel =  UILabel(text: "Name album label")
    private let artistNameLabel =  UILabel(text: "Name artist name")
    private let releaseDateLabel =  UILabel(text: "0 tracks")
    private let countLabel =  UILabel(text: "0 tracks")
    private var stackView = UIStackView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: "CellView")
        return collectionView
    }()
    
    var album: Album?
    var songs = [Song]()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupDelegate()
        setModel()
        fetchSongs(album: album)
    }
    
    private func setModel() {
        guard let album = album else {return}
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        countLabel.text = "\(album.trackCount) tracks:"
        releaseDateLabel.text = setDateFormat(date: album.releaseDate)
        
        guard let url = album.artworkUrl100 else {return}
        setImage(urlString: url)
    }
    
    private func setDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateFormatter.date(from: date) else {return ""}//get date from URL
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        return date
    }
    
    private func setImage(urlString: String?) {
        if let urlString = urlString {
            NetworkRequest.shared.requestData(urlString: urlString) { result in
                switch result {
                case.success(let data):
                    let image = UIImage(data: data)
                    self.albumLogo.image = image
                case.failure(let error):
                    self.albumLogo.image = nil
                    print("no album icon" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
    
    private func fetchSongs(album: Album?) {
        guard let album = album else {return}
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else {return}
                self?.songs = songModel.results
                self?.collectionView.reloadData()
            } else {
                print( error?.localizedDescription)
                self?.alertForButton(title: "error", message: error!.localizedDescription)
            }
            
        }
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(albumLogo)
        stackView = UIStackView(arrangedSubviews: [albumNameLabel,
                                                   artistNameLabel,
                                                   releaseDateLabel,
                                                   countLabel],
                                axis: .vertical,
                                spacing: 10,
                                distribution: .fillProportionally)
        view.addSubview(stackView)
        view.addSubview(collectionView)
    }
    
    //MARK: - Set Constraints
    
    private func setConstraints() {
        albumLogo.easy.layout(Top(30).to(view.safeAreaLayoutGuide, .top),Left(20),Height(100),Width(100))
        stackView.easy.layout(Top(30).to(view.safeAreaLayoutGuide, .top),Left(20).to(albumLogo, .right),Right(20))
        collectionView.easy.layout(Top(10).to(stackView, .bottom), Left(17).to(albumLogo, .right), Right(10),Bottom(10))
    }
    
    private func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension DetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! SongsCollectionViewCell
        let song = songs[indexPath.row].trackName
        cell.nameSongLabel.text = song
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 20)
    }
    
}

