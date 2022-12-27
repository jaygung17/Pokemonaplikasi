//
//  CardCollectionViewCell.swift
//  Pokemon App
//
//  Created by Novan Agung Waskito on 15/11/22.
//

import UIKit
enum CardImageResult {
    case success(UIImage)
    case failure(String)
    
}

class CardCollectionViewCell: UICollectionViewCell {

    private var downloadTask: URLSessionDataTask?
    
    
    @IBOutlet weak var pokemonCardImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func downloadPokemonCardImage(for url: URL) {
        pokemonCardImageView.isShimmering = true
        downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let image = UIImage (data: data!) {
                DispatchQueue.main.sync {
                    self.pokemonCardImageView.image = image
                    self.pokemonCardImageView.isShimmering = false
                }
            } else {
                print("Something went wrong.")
            }
        }
        downloadTask?.resume()
    }
    func cancelDownloadImage() {
        downloadTask?.suspend()
        downloadTask = nil
    }
  
}
