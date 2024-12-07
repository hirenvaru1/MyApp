//
//  SeachVC.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit
import Kingfisher

protocol callNewList {
    func callNewSongList(getId: Int)
}

class SeachVC: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var tblSearch : UITableView!
    
    var songs = [SongResult]()
    var delegate : callNewList?

    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self

        tblSearch.register(UINib(nibName: "songListCell", bundle: nil), forCellReuseIdentifier: "songListCell")

        txtSearch.placeholder = "Search"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        txtSearch.attributedPlaceholder = NSAttributedString(string: txtSearch.placeholder ?? "", attributes: attributes)

        txtSearch.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - API Call
    func searchSongs(term: String, completion: @escaping ([SongResult]?, Error?) -> Void) {
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedTerm)&media=music&entity=song&limit=10"
        
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

    @objc func textDidChange() {
        if let text = txtSearch.text {
            searchSongs(term: (text)) { [weak self] results, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self?.songs = results ?? []
                    self?.tblSearch.reloadData()
                }
            }
        }
    }

    //MARK: - Button Action
    @IBAction func cancelClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
 
extension SeachVC: UITableViewDelegate, UITableViewDataSource{
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
        cell.imgIcon.Round = true
        cell.imgIcon.kf.setImage(with: URL(string: songs[indexPath.row].artworkUrl100 ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.callNewSongList(getId: songs[indexPath.row].artistId ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
}
