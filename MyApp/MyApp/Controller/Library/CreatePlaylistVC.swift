//
//  CreatePlaylistVC.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit
 
class CreatePlaylistVC: UIViewController {
    
    @IBOutlet weak var lblPlylist : UILabel!
    @IBOutlet weak var lblTotalSong : UILabel!
    @IBOutlet weak var tblList : UITableView!
    @IBOutlet weak var btnAdd : UIButton!
    
    var strName = ""
    var songs = [SongResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPlylist.text = strName
        applyGradientToView()
        tblList.register(UINib(nibName: "songListCell", bundle: nil), forCellReuseIdentifier: "songListCell")
    }
    
    //MARK: - Button Action
    @IBAction func ConfirmClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddClicked(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SeachVC") as! SeachVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSongToLibrary(libraryName: String, song: [SongResult]) {
        var data = loadLibraryDataFromUserDefaults() ?? AllYourLibrary(AllLibrary: [])
        if let libraryIndex = data.AllLibrary.firstIndex(where: { $0.name == libraryName }) {
            data.AllLibrary[libraryIndex].allSong?.append(contentsOf: song)
        } else {
            let newLibrary = NewLibrary(allSong: song, name: libraryName)
            data.AllLibrary.append(newLibrary)
        }
        saveLibraryDataToUserDefaults(libraryData: data)
    }
    
    func searchSongs(term: String, completion: @escaping ([SongResult]?, Error?) -> Void) {
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/lookup?id=\(encodedTerm)&entity=album"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ITunesSearchResponse.self, from: data)
                completion(response.results, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func applyGradientToView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
        ]
        gradientLayer.locations = [0.0, 0.23, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension CreatePlaylistVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songListCell") as! songListCell
        cell.lblAlbumName.text = songs[indexPath.row].collectionName
        cell.lblSubName.text = songs[indexPath.row].artistName
        cell.imgIcon.kf.setImage(with: URL(string: songs[indexPath.row].artworkUrl100 ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
 
extension CreatePlaylistVC: callNewList {
    func callNewSongList(getId: Int) {
        btnAdd.isHidden = true
        searchSongs(term: (String(getId))) { [weak self] results, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self?.songs = results ?? []
                self?.songs = self!.songs.filter {  $0.artistId != 0 && !($0.collectionViewUrl?.isEmpty ?? true)}
                self?.lblTotalSong.text = "\(self!.songs.count) songs"
                self?.tblList.reloadData()
                self?.addSongToLibrary( libraryName: self!.strName, song: self!.songs)
            }
        }
    }
}
