//
//  MenuTableViewDataSource.swift
//  SideDish
//
//  Created by TTOzzi on 2020/04/23.
//  Copyright © 2020 TTOzzi. All rights reserved.
//

import UIKit

class MenuTableViewDataSource: NSObject, UITableViewDataSource {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier) as? MenuTableViewCell else { return UITableViewCell() }
        let sideDish = dataManager[indexPath.section][indexPath.row]
        guard cell.hashCode != sideDish.hash else { return cell }
        cell.updateCell(data: sideDish)
        
        if let image = ImageFileManager.shared.getSavedImage(name: sideDish.hash) {
            DispatchQueue.main.async {
                cell.menuImage.image = image
            }
        } else {
            SideDishUseCase.loadImage(url: sideDish.image) { data in
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    cell.menuImage.image = image
                }
                ImageFileManager.shared.saveImage(image: image, name: sideDish.hash)
            }
        }
        return cell
    }
}
