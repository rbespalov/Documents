

import UIKit

class NextFolderViewController: UITableViewController {
        
    var content: [Content] = []

    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    @IBOutlet weak var folderLabel: UILabel!
    
    @IBAction func tapNewFolder(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create new folder", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Foder name"
        }
        let createAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let newDir = FileManagerService().createDirectory(self.currentDirectory, textField.text ?? "creating error")
            self.content.append(newDir)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func addPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderLabel.text = "   " + currentDirectory.lastPathComponent
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        content = FileManagerService().contentsOfDirectory(currentDirectory) ?? []
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)

        cell.textLabel?.text = content[indexPath.row].name
        if content[indexPath.row].contentType == .folder {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newDoc") as! NextFolderViewController
        
        let indexPath = tableView.indexPathForSelectedRow

        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        for i in content {
            if i.name == currentCell.textLabel?.text && i.contentType != .file {
                vc.currentDirectory = i.URL
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let wiilDelete = content[indexPath.row]
            content.remove(at: indexPath.row)
            FileManagerService().removeContent(item: wiilDelete.URL)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension NextFolderViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            let fileName = UUID().uuidString + ".jpeg"
            let newFile = FileManagerService().createFile(currentDirectory, image, fileName: fileName)
            content.append(newFile)
            tableView.reloadData()

            dismiss(animated: true)
        }
    }
}
