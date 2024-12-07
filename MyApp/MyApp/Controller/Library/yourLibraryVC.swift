//
//  yourLibraryVC.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit

class yourLibraryVC: UIViewController{
    
    @IBOutlet weak var tblLibrary : UITableView!
    @IBOutlet weak var collectionLibrary : UICollectionView!
    @IBOutlet weak var btnListGrid : UIButton!

    var isListGrid = false
    var yourLibraryData = loadLibraryDataFromUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionLibrary.register(UINib(nibName: "gridCell", bundle: nil), forCellWithReuseIdentifier: "gridCell")
        tblLibrary.register(UINib(nibName: "gridListCell", bundle: nil), forCellReuseIdentifier: "gridListCell")

        NotificationCenter.default.addObserver(self, selector: #selector(redirectedToCreateList), name: Notification.Name("navigateToCreatePlaylist"), object: nil)
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        yourLibraryData = loadLibraryDataFromUserDefaults()
        tblLibrary.reloadData()
        collectionLibrary.reloadData()
        
    }
    
    @objc private func redirectedToCreateList(notification: Notification) {
        if let userInfo = notification.userInfo {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePlaylistVC") as! CreatePlaylistVC
            vc.strName = userInfo["playlistName"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Button Action
    @IBAction func showPopUp(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "popView") as! popView
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    } 
    
    @IBAction func lisGridView(_ sender: UIButton){
        if isListGrid{
            btnListGrid.setImage(UIImage(systemName: "rectangle.grid.2x2"), for: .normal)
            tblLibrary.isHidden = false
            collectionLibrary.isHidden = true
        }
        else{
            btnListGrid.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            tblLibrary.isHidden = true
            collectionLibrary.isHidden = false
            
        }
        isListGrid = !isListGrid
    }
}

extension yourLibraryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourLibraryData?.AllLibrary.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gridListCell") as! gridListCell
        cell.lblAlbumName.text = yourLibraryData?.AllLibrary[indexPath.row].name
        cell.lblSubName.text = "Playlist • \( yourLibraryData?.AllLibrary[indexPath.row].allSong?.count ?? 0) songs"
        if let allSongs = yourLibraryData?.AllLibrary[indexPath.row].allSong {
            if allSongs.count > 0, let artworkUrl1 = allSongs[0].artworkUrl100 {
                cell.img1Icon.kf.setImage(with: URL(string: artworkUrl1))
            }

            if allSongs.count > 1, let artworkUrl2 = allSongs[1].artworkUrl100 {
                cell.img2Icon.kf.setImage(with: URL(string: artworkUrl2))
            }

            if allSongs.count > 2, let artworkUrl3 = allSongs[2].artworkUrl100 {
                cell.img3Icon.kf.setImage(with: URL(string: artworkUrl3))
            }

            if allSongs.count > 3, let artworkUrl4 = allSongs[3].artworkUrl100 {
                cell.img4Icon.kf.setImage(with: URL(string: artworkUrl4))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension yourLibraryVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yourLibraryData?.AllLibrary.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! gridCell
        cell.lblAlbumName.text = yourLibraryData?.AllLibrary[indexPath.row].name
        cell.lblSubName.text = "Playlist • \( yourLibraryData?.AllLibrary[indexPath.row].allSong?.count ?? 0) songs"
        if let allSongs = yourLibraryData?.AllLibrary[indexPath.row].allSong {
            if allSongs.count > 0, let artworkUrl1 = allSongs[0].artworkUrl100 {
                cell.img1Icon.kf.setImage(with: URL(string: artworkUrl1))
            }

            if allSongs.count > 1, let artworkUrl2 = allSongs[1].artworkUrl100 {
                cell.img2Icon.kf.setImage(with: URL(string: artworkUrl2))
            }

            if allSongs.count > 2, let artworkUrl3 = allSongs[2].artworkUrl100 {
                cell.img3Icon.kf.setImage(with: URL(string: artworkUrl3))
            }

            if allSongs.count > 3, let artworkUrl4 = allSongs[3].artworkUrl100 {
                cell.img4Icon.kf.setImage(with: URL(string: artworkUrl4))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - 30) / 2
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
