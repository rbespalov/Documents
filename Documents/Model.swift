
import Foundation
import UIKit

enum ContentType {
    case folder
    case file
}

struct Content {
    var contentType: ContentType
    var name: String
    var URL: URL
}

protocol FileMangerServiceProtocol {
    func contentsOfDirectory(_ currentDir: URL) -> [Content]?
    func createDirectory(_ currentFolder: URL, _ newFolderName: String) -> Content
    func createFile(_ currentFolder: URL, _ newFile: UIImage, fileName: String) -> Content
    func removeContent(item: URL)
}

class FileManagerService: FileMangerServiceProtocol {
    
    let fileManager = FileManager.default
    
    let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func contentsOfDirectory(_ currentDir: URL) -> [Content]?{
        var contentArray: [Content] = []
        do {
            let content = try fileManager.contentsOfDirectory(at: currentDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for i in content {
                if i.isDirectory {
                    let folder = Content(contentType: .folder, name: i.lastPathComponent, URL: i)
                    contentArray.append(folder)
                } else {
                    let file = Content(contentType: .file, name: i.lastPathComponent, URL: i)
                    contentArray.append(file)
                }
            }
        } catch {
            print(error)
            return nil
        }
        return contentArray
    }
    
    func createDirectory(_ currentFolder: URL, _ newFolderName: String) -> Content {
        
        let newFolderURL = currentFolder.appendingPathComponent(newFolderName)
        
        do {
            try fileManager.createDirectory(at: newFolderURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        
        return Content(contentType: .folder, name: newFolderName, URL: newFolderURL)
    }
    
    func createFile(_ currentFolder: URL, _ newFile: UIImage, fileName: String) -> Content {

        let path = currentFolder.appendingPathComponent(fileName)
        
        let data = newFile.pngData()
        
        fileManager.createFile(atPath: path.path, contents: data)

        return Content(contentType: .file, name: fileName, URL: path)
    }
    
    func removeContent(item: URL) {
        
        do {
            try fileManager.removeItem(at: item)
        } catch {
            print ("error deleting file")
        }
    }
}

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
