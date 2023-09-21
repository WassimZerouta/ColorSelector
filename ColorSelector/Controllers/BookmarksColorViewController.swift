//
//  BookmarksColorViewController.swift
//  ColorSelector
//
//  Created by Wass on 14/09/2023.
//

import UIKit

class BookmarksColorViewController: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let items = ["HEX", "RGB"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(convertValue(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedColorTableViewCell.self, forCellReuseIdentifier: "SavedColorTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    var savedColors = [String]()
    var color: colorType = .HEX
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        createConstrainte()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func createConstrainte()	{
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let defaults = UserDefaults.standard
        if let userData = defaults.array(forKey: "SavedColorsArray") as? [String] {
            savedColors = userData
            tableView.reloadData()
            print(savedColors)
        }
    }
    

    @objc func convertValue(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            color = .HEX
            tableView.reloadData()
        case 1:
            color = .RGB
            tableView.reloadData()
        default:
            color = .HEX
            tableView.reloadData()
        }
    }
}

extension BookmarksColorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedColorTableViewCell", for: indexPath) as! SavedColorTableViewCell
        
        let color = UIColor(hex: savedColors[indexPath.row])
        let hexLabel = self.color == .HEX ? savedColors[indexPath.row] : color?.stringRepresentation
        cell.configure(hexLabelText: hexLabel!, color: color ?? .white)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedColors.remove(at: indexPath.row)
            UserDefaults.standard.set(savedColors, forKey: "SavedColorsArray")
            UserDefaults.standard.synchronize()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
}
