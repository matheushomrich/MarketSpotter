//
//  main.swift
//  TerminalChallenge
//
//  Created by Matheus Homrich and Enzo Degrazia on 16/03/21.
//

import Foundation

var fileVersion: Int = 0
var allLists: [MarketList] = []

func clearTerminal() {
    for _ in 0..<100 {
        print("")
    }
}

func menu() {
    print("\n--- βοΈenu ---\n\nWhat would you like to do?\n1 - Create new MarketList π\n2 - View list(s) π\n3 - Export list(s) to Desktop π\n4 - Open list(s) in Notes π")
    let choice = readLine()
    switch choice {
    case "1":
        createList()
    case "2":
        viewLists()
        clearTerminal()
    case "3":
        exportLists1()
        exportLists2()
        menu()
    case "4":
        openNotes()
    default:
        clearTerminal()
        print("β ERROR: We've detected that you didn't choose either 1 or 2. β")
        menu()
    }
}

func viewLists() {
    if allLists.isEmpty {
        clearTerminal()
        print("β οΈ You have no lists. β οΈ")
        menu()
    } else {
        clearTerminal()
        print("\n")
        print("Which MarketList do you wish to see?\nβοΈ OBS: Choose by list ID or press ENTER if you want to return to the menu βοΈ\n")
        for mktList in allLists {
            print("\(mktList.id) - \(mktList.name)")
        }
        
        print("\nβοΈ OBS: Press minus(-) if you want to delete all lists. βοΈ")
        
        let choice: String = readLine() ?? ""
        
        switch choice {
        case "":
            clearTerminal()
            menu()
        case "-":
            deleteAllLists()
        default:
            clearTerminal()
            showList(id: Int(choice) ?? -1)
        }
    }
}

func listNotFound(listId: Int) -> Bool {
    var result: Bool = true
    
    for i in allLists {
        if i.id == listId {
            return false
        } else {
            result = true
        }
    }
    
    return result
}

func showList(id: Int) {
    var isListEmpty: Bool = false
    if id == -1 || listNotFound(listId: id) {
        clearTerminal()
        print("β ERROR: Your list was not found, you're returning to the menu. β")
        menu()
    }
    clearTerminal()
    print("\nMARKETLIST")
    for mktList in allLists {
        if id == mktList.id {
            if mktList.list.count == 0 {
                isListEmpty = true
                print("\(mktList.name) is empty")
            } else {
                mktList.showList()
                print("π° \nList's final price: π² \(mktList.showFinalPrice()) π°")
            }
        }
    }
    print("-------------------")
    print("What would you like to do?\n1 - Add product β\n2 - Remove product β\n3 - Empty List 0οΈβ£ \n4 - Delete List β‘\n5 - Go back to the Menu βοΈ")
    let choice = readLine()
    
    switch choice {
    case "1":
        addProduct(listId: id)
    case "2":
        if isListEmpty {
            clearTerminal()
            print("β οΈ You can NOT remove products from an empty list. β οΈ")
            viewLists()
        } else {
            removeProduct(listId: id)
        }
    case "3":
        if isListEmpty {
            clearTerminal()
            print("β οΈ You can NOT empty a list if the list is already empty. β οΈ")
            viewLists()
        } else {
            emptyList(listId: id)
        }
    case "4":
        deleteList(listId: id)
    case "5":
        menu()
    default:
        clearTerminal()
        print("β ERROR: An error was detected while trying to select your option, you're headed back to your lists. β")
        viewLists()
    }
}

func deleteAllLists() {
    clearTerminal()
    print("βοΈ Are you sure you want to delete all Lists? βοΈ\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        allLists.removeAll()
        clearTerminal()
        print("β All lists were SUCCESSFULLY deleted. β")
        menu()
    case "2":
        viewLists()
    default:
        clearTerminal()
        print("β ERROR: An error was detected while trying to DELETE all lists, you're headed back to your lists. β")
        viewLists()
    }
}

func deleteList(listId: Int) {
    var listInQuestion: MarketList?
    
    for mktList in allLists {
        if listId == mktList.id {
            listInQuestion = mktList
        }
    }
    
    clearTerminal()
    print("βοΈ Are you sure you want to delete \(listInQuestion!.name)? βοΈ\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        
        for (i, mktList) in allLists.enumerated() {
            if mktList.id == listId {
                allLists.remove(at: i)
            }
        }
        
        clearTerminal()
        print("β \(listInQuestion!.name) was SUCCESSFULLY deleted. β")
        menu()
    case "2":
        showList(id: listInQuestion!.id)
    default:
        clearTerminal()
        print("β ERROR: An error was detected while trying to DELETE your list, you're headed back to your lists. β")
        viewLists()
    }
    
}

func emptyList(listId: Int) {
    var listInQuestion: MarketList?
    
    for mktList in allLists {
        if listId == mktList.id {
            listInQuestion = mktList
        }
    }
    clearTerminal()
    print("βοΈ Are you sure you want to empty \(listInQuestion!.name)? βοΈ\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        listInQuestion!.emptyList()
        clearTerminal()
        print("β \(listInQuestion!.name) was SUCCESSFULLY emptied. β")
        showList(id: listInQuestion!.id)
    case "2":
        clearTerminal()
        showList(id: listInQuestion!.id)
    default:
        clearTerminal()
        print("β ERROR: An error was detected while trying to empty your list, you're headed back to your lists. β")
        viewLists()
    }
}

func removeProduct(listId: Int) {
    var listInQuestion: MarketList?
    
    for mktList in allLists {
        if listId == mktList.id {
            listInQuestion = mktList
        }
    }
    clearTerminal()
    print("Which product would you like to remove?\nβοΈ OBS: Choose by product ID or press ENTER if you want to return to the your lists βοΈ\n")
    for i in listInQuestion!.list {
        print(i.toStringId())
    }
    let choice: String = readLine() ?? ""
    
    if choice == "" {
        viewLists()
    } else {
        let id = Int(choice) ?? -1
        if id == -1 {
            clearTerminal()
            print("β ERROR: An error was detected while trying to remove your product, you're headed back to your lists. β")
            viewLists()
        }
        clearTerminal()
        
        let name: String = listInQuestion!.showProductName(id: id)
        print("βοΈ Are you sure you want to remove \(name)? βοΈ\n1 - Yes\n2 - No")
        let choice = readLine()
        
        switch choice {
        case "1":
            listInQuestion!.removeProduct(id: id)
            clearTerminal()
            print("β \(listInQuestion!.showProductName(id: id)) was SUCCESSFULLY removed from \(listInQuestion!.name). β")
            showList(id: listId)
        case "2":
            clearTerminal()
            showList(id: listId)
        default:
            clearTerminal()
            print("β ERROR: We've detected that you didn't choose either 1 or 2. β")
            showList(id: listId)
        }
        
    }
    
}

var productNameCounter: Int = 0

func createList() {
    productNameCounter += 1
    clearTerminal()
    print("What's the name of your list?")
    var mktListName: String = readLine() ?? ""
    if mktListName == "" {
        mktListName = "Market_List_\(productNameCounter)"
    }
    
    let mktList: MarketList = MarketList(id: productNameCounter, name: mktListName, list: [], date: Date())
    
    allLists.append(mktList)
    
    clearTerminal()
    print("Would you like to add products to \(mktListName)?\n1 - Yes\n2 - No")
    let choice = readLine()
    switch choice {
    case "1":
        addProduct(listId: mktList.id)
    case "2":
        clearTerminal()
        menu()
    default:
        clearTerminal()
        print("β ERROR: We've detected that you didn't choose either 1 or 2. β")
        menu()
    }
    
}

func addProduct(listId: Int) {
    
    var listInQuestion: MarketList?
    
    for mktList in allLists {
        if listId == mktList.id {
            listInQuestion = mktList
        }
    }
    
    let pCounter_: Int = listInQuestion!.list.count
    
    clearTerminal()
    print("What's the name of your product?")
    var pName = readLine()
    
    if pName == "" {
        pName = "Product_\(pCounter_)"
    }
    
    clearTerminal()
    print("What's \(pName!)'s quantity?\nβοΈ OBS: If we're not able to detect your number it will be put as 1. βοΈ")
    let qnt: String = readLine() ?? ""
    var quantity: Int
    
    if qnt == "" {
        quantity = 1
    } else if qnt.contains("-") {
        quantity = 1
    } else {
        quantity = Int(qnt) ?? 1
    }
    
    clearTerminal()
    print("What's \(pName!)'s price?\nβοΈ OBS: Just press ENTER if you don't know. βοΈ")
    let prc: String = readLine() ?? ""
    var price: Double
    
    if prc == "" {
        price = 0
    } else if prc.contains("-")  {
        price = 0
    } else {
        price = Double(prc) ?? 0
    }
    
    let product: Product = Product(id: pCounter_, name: pName!, price: price, quantity: quantity)
    
    listInQuestion!.list.append(product)
    
    clearTerminal()
    print("β Your product has been SUCCESSFULLY added β\n")
    print("Would you like to:\n1 - Add another product β\n2 - Go to the Menu βοΈ")
    let choice = readLine()
    
    switch choice {
    case "1":
        addProduct(listId: listInQuestion!.id)
    case "2":
        clearTerminal()
        menu()
    default:
        clearTerminal()
        print("β ERROR: We've detected that you didn't choose either 1 or 2. β")
        menu()
    }
}

func exportLists1() {
    clearTerminal()
    fileVersion += 1
    
    if allLists.isEmpty {
        clearTerminal()
        print("β οΈ You have NO lists to export yet. β οΈ")
        menu()
    }
    
    let fileName = "MSLists"
    
    var documentDirectoryUrl = try! FileManager.default.url(
        for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true
    )
    
    
    let fileManager = FileManager.default

    let path = fileManager.currentDirectoryPath
   
    let array = path.components(separatedBy: "/Library")

    
    documentDirectoryUrl.appendPathComponent(array[1])
    let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
    
    do {
        try fileName.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
        
    } catch let error as NSError {
        print (error)
    }
    
    var stringData: String = "πππ Market Spotter Lists πππ\n\n"
    
    for i in allLists {
        stringData += "\n\(i.toString())\nπ° List's final price: π² \(i.showFinalPrice()) π°"
    }
    do {
        try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print (error)
    }
}

func exportLists2() {
    clearTerminal()
    fileVersion += 1
    
    if allLists.isEmpty {
        clearTerminal()
        print("β οΈ You have NO lists to export yet. β οΈ")
        menu()
    }
    
    let fileName = "MSLists"
    
    let documentDirectoryUrl = try! FileManager.default.url(
        for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true
    )
    
    let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
    
    do {
        try fileName.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
        
    } catch let error as NSError {
        print (error)
    }
    
    var stringData: String = "πππ Market Spotter Lists πππ\n\n"
    
    for i in allLists {
        stringData += "\n\(i.toString())\nπ° List's final price: π² \(i.showFinalPrice()) π°"
    }
    do {
        try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print (error)
    }
    print("β Your lists have been successfully exported to \(fileUrl.path) β")
    menu()
}


@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}


func openNotes() {
    if allLists.isEmpty {
        print("β οΈ You have NO lists to open at NOTES yet.β οΈ")
    }
    shell("open", "-a", "Notes.app", "MSLists.txt")
    menu()
}

func main() {
    clearTerminal()
    print("\nπππ MarketSpotter πππ\n")
    print("Welcome to our terminal MarketSpotter, let`s start your MarketList today!")
    print("Would you like to:\n1 - Create a new MarketList π\n2 - Go to menu βοΈ\n3 - Export list(s) to Desktop π\n4 - Open list(s) in Notes π")
    let choice = readLine()
    switch choice {
    case "1":
        createList()
    case "2":
        clearTerminal()
        menu()
    case "3":
        exportLists1()
        exportLists2()
        menu()
    case "4":
        openNotes()
        clearTerminal()
        print("β Your file has been opened at NOTES β")
        menu()
    default:
        clearTerminal()
        print("β ERROR: We've detected that you didn't choose either 1 or 2. β")
        main()
    }
    
}

main()
