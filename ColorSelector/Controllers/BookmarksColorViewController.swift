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
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedColorTableViewCell.self, forCellReuseIdentifier: "SavedColorTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Vous n'avez pas encore ajouté de couleur !"
        label.textColor = UIColor(named: "IconColor")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var savedColors = [String]()
    var color: colorType = .HEX
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstraintes()
        segmentedControl.addTarget(self, action: #selector(convertValue(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let defaults = UserDefaults.standard
        if let userData = defaults.array(forKey: "SavedColorsArray") as? [String] {
            savedColors = userData
            tableView.reloadData()
        }
        
        if savedColors.isEmpty {
            label.isHidden = false
            tableView.isHidden = true
            segmentedControl.isHidden = true
        } else {
            label.isHidden = true
            tableView.isHidden = false
            segmentedControl.isHidden = false
        }
    }
    
    private func setupConstraintes() {
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
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
        cell.isUserInteractionEnabled = false
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
