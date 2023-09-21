//
//  MainViewController.swift
//  ColorSelector
//
//  Created by Wass on 08/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var hexColor: String?
    
    let showGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPUYEZ POUR AJOUTER UNE IMAGE", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    let content = UIView()
    
    let addButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus.viewfinder")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .darkGray
        button.image = image
        return button
    }()
    
    let backButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        return button
    }()
    let changeButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "tray.and.arrow.down")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        return button
    }()
    
    let picture = UIImageView()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "TOUCHEZ L'ÉCRAN"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.tintColor = UIColor(named: "IconColor")
        return label
    }()
    
    let colorDisplayer = UIView()

    
    let saveButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        return button
    }()
    
    
    
    var zoomBubbleView: ZoomBubbleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addButtonView()
        showGalleryButtonView()
        contentView()
        backButtonView()
        changeButtonView()
        colorDisplayerView()
        pictureView()
        rgbLabelView()
        saveButtonView()
    }
    
    private func addButtonView() {
        view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 300).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 300).isActive = true

        
        addButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addButton.addGestureRecognizer(tapGesture)
    }
    
    private func showGalleryButtonView() {

        showGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showGalleryButton)
        showGalleryButton.topAnchor.constraint(equalTo: addButton.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        showGalleryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        showGalleryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func contentView() {
        self.view.addSubview(content)
        content.backgroundColor = UIColor(named: "TabBarColor")
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        content.isHidden = true
        
    }
    
    private func backButtonView() {
        content.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

        
        backButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(tapGesture)
    }
    
    
    private func changeButtonView() {
        content.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        changeButton.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        changeButton.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -20).isActive = true
        changeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        changeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

        
        changeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        changeButton.addGestureRecognizer(tapGesture)
    }
    
    private func pictureView() {
        content.addSubview(picture)
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        picture.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        picture.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        picture.bottomAnchor.constraint(equalTo: colorDisplayer.topAnchor).isActive = true
        picture.clipsToBounds = true
        picture.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorPicker(_:)))
        picture.addGestureRecognizer(longPressGesture)
        picture.addGestureRecognizer(tapGesture)
    }
    
    private func rgbLabelView() {
        content.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func colorDisplayerView() {
        content.addSubview(colorDisplayer)
        colorDisplayer.translatesAutoresizingMaskIntoConstraints = false
        colorDisplayer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        colorDisplayer.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        colorDisplayer.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        colorDisplayer.bottomAnchor.constraint(equalTo: content.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func saveButtonView() {
        content.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.rightAnchor.constraint(equalTo: colorDisplayer.rightAnchor, constant: -20).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor).isActive = true

        saveButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func backButtonTapped() {
        content.isHidden = true
        picture.image = nil
        label.text = "TOUCHEZ L'ÉCRAN"
        
    }
    
    @objc func buttonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func saveButtonTapped() {
        guard hexColor != nil else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.saveButton.tintColor = .green
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                self.saveButton.transform = CGAffineTransform.identity
            })
        }

        var savedColorsArray = UserDefaults.standard.array(forKey: "SavedColorsArray") as? [String] ?? []
        savedColorsArray.append(hexColor!)
        UserDefaults.standard.set(savedColorsArray, forKey: "SavedColorsArray")
        UserDefaults.standard.synchronize()
    }
    
    @objc private func colorPicker(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: picture)
        print("Tap location: \(location)")
        
        let color = picture.image?.getPixelColorAtPoint(point: location, sourceView: picture)
        hexColor = picture.image?.getHexaValue(point: location, sourceView: picture)
        
        let luminance = color?.luminance
        
        
        label.textColor = luminance! < 0.5 ? .white : .black
        saveButton.tintColor = luminance! < 0.5 ? .white : .black
        label.text = hexColor
        colorDisplayer.backgroundColor = color
    }
    
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: picture)
        let zoomSize = CGSize(width: 150, height: 150)

        switch gesture.state {
        case .began:
            let zoomedRect = CGRect(x: touchPoint.x - zoomSize.width / 2, y: touchPoint.y - zoomSize.height / 2, width: zoomSize.width, height: zoomSize.height)
            
            if let sourceImage = picture.image,
               let cgImage = sourceImage.cgImage,
               let croppedCGImage = cgImage.cropping(to: CGRect(x: touchPoint.x / picture.bounds.width * CGFloat(cgImage.width), y: touchPoint.y / picture.bounds.height * CGFloat(cgImage.height) - zoomSize.height, width: zoomSize.width, height: zoomSize.height)) {
                
                let zoomedImage = UIImage(cgImage: croppedCGImage)
                zoomBubbleView = ZoomBubbleView(frame: zoomedRect, image: zoomedImage)
                zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer, hexColor: hexColor)
                view.addSubview(zoomBubbleView!)
            }
        case .changed:
            let zoomedRect = CGRect(x: touchPoint.x - zoomSize.width / 2, y: touchPoint.y - zoomSize.height / 2, width: zoomSize.width, height: zoomSize.height)
            zoomBubbleView?.frame = zoomedRect
            
            if let sourceImage = picture.image,
               let cgImage = sourceImage.cgImage,
               let croppedCGImage = cgImage.cropping(to: CGRect(x: touchPoint.x / picture.bounds.width * CGFloat(cgImage.width), y: touchPoint.y / picture.bounds.height * CGFloat(cgImage.height) - zoomSize.height, width: zoomSize.width, height: zoomSize.height)) {
                
                let zoomedImage = UIImage(cgImage: croppedCGImage)
                zoomBubbleView?.updateImage(image: zoomedImage)
                zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer, hexColor: hexColor)            }
        case .ended:
            zoomBubbleView?.removeFromSuperview()
            zoomBubbleView = nil
        default:
            break
        }
    }



}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            let compressedImage = UIImage(data: jpegData)
            picture.image = compressedImage
        }
        content.isHidden = (picture.image == nil) ? true : false

        dismiss(animated: true)
    }
    

    
}








