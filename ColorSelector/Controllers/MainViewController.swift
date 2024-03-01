//
//  MainViewController.swift
//  ColorSelector
//
//  Created by Wass on 08/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var hexColor: String?
    
    private let showGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPUYEZ POUR AJOUTER UNE IMAGE", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let content: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "TabBarColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus.viewfinder")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .darkGray
        button.image = image
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changeButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "tray.and.arrow.down")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let picture: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "TOUCHEZ L'ÉCRAN"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.tintColor = UIColor(named: "IconColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorDisplayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private let saveButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    private var zoomBubbleView: ZoomBubbleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createConstraints()
        buttonGestures()
        content.isHidden = true
    }
    
    private func createConstraints() {
        view.addSubview(addButton)
        view.addSubview(showGalleryButton)
        view.addSubview(content)
        content.addSubview(backButton)
        content.addSubview(changeButton)
        content.addSubview(colorDisplayer)
        content.addSubview(picture)
        content.addSubview(label)
        content.addSubview(saveButton)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 300),
            addButton.widthAnchor.constraint(equalToConstant: 300),
            
            showGalleryButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            showGalleryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            showGalleryButton.heightAnchor.constraint(equalToConstant: 50),

            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            content.rightAnchor.constraint(equalTo: view.rightAnchor),
            content.leftAnchor.constraint(equalTo: view.leftAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            changeButton.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            changeButton.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            changeButton.heightAnchor.constraint(equalToConstant: 25),
            changeButton.widthAnchor.constraint(equalToConstant: 25),
            
            colorDisplayer.heightAnchor.constraint(equalToConstant: 100),
            colorDisplayer.rightAnchor.constraint(equalTo: content.rightAnchor),
            colorDisplayer.leftAnchor.constraint(equalTo: content.leftAnchor),
            colorDisplayer.bottomAnchor.constraint(equalTo: content.safeAreaLayoutGuide.bottomAnchor),
            
            picture.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 80),
            picture.rightAnchor.constraint(equalTo: content.rightAnchor),
            picture.leftAnchor.constraint(equalTo: content.leftAnchor),
            picture.bottomAnchor.constraint(equalTo: colorDisplayer.topAnchor),
            
            label.centerXAnchor.constraint(equalTo: colorDisplayer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: colorDisplayer.centerYAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.rightAnchor.constraint(equalTo: colorDisplayer.rightAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func buttonGestures() {
        //ADD SHOWGALLERY GESTURE
        let tapShowGalleryButtonGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        showGalleryButton.addGestureRecognizer(tapShowGalleryButtonGesture)

        //ADD BUTTON GESTURE
        let tapAddButtonGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addButton.addGestureRecognizer(tapAddButtonGesture)
        //BACK BUTTON GESTURE
        let tapBackButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(tapBackButtonGesture)
        //CHANGE BUTTON GESTURE
        let tapChangeButtonGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        changeButton.addGestureRecognizer(tapChangeButtonGesture)
        //PICTURE VIEW GESTURE
        let longPressPictureGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let tapPictureGesture = UITapGestureRecognizer(target: self, action: #selector(colorPicker(_:)))
        picture.addGestureRecognizer(longPressPictureGesture)
        picture.addGestureRecognizer(tapPictureGesture)
        //SAVE BUTTON GESTURE
        let tapSaveButtonGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.addGestureRecognizer(tapSaveButtonGesture)
    }
    
    @objc private func backButtonTapped() {
        content.isHidden = true
        picture.image = nil
        label.text = "TOUCHEZ L'ÉCRAN"
        
    }
    
    @objc func buttonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func saveButtonTapped() {
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
    
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
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
                hexColor = zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer, hexColor: hexColor, saveButton: saveButton)
                label.text = hexColor
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
                hexColor = zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer, hexColor: hexColor, saveButton: saveButton)}
                label.text = hexColor

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








