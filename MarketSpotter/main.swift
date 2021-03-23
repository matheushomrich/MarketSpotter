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
    print("\n--- Ⓜ️enu ---\n\nWhat would you like to do?\n1 - Create new MarketList 📝\n2 - View list(s) 📑\n3 - Export list(s) to Desktop 📂\n4 - Open list(s) in Notes 📒")
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
        print("❌ ERROR: We've detected that you didn't choose either 1 or 2. ❌")
        menu()
    }
}

func viewLists() {
    if allLists.isEmpty {
        clearTerminal()
        print("⚠️ You have no lists. ⚠️")
        menu()
    } else {
        clearTerminal()
        print("\n")
        print("Which MarketList do you wish to see?\n❗️ OBS: Choose by list ID or press ENTER if you want to return to the menu ❗️\n")
        for mktList in allLists {
            print("\(mktList.id) - \(mktList.name)")
        }
        
        print("\n❗️ OBS: Press minus(-) if you want to delete all lists. ❗️")
        
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
        print("❌ ERROR: Your list was not found, you're returning to the menu. ❌")
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
                print("💰 \nList's final price: 💲 \(mktList.showFinalPrice()) 💰")
            }
        }
    }
    print("-------------------")
    print("What would you like to do?\n1 - Add product ➕\n2 - Remove product ➖\n3 - Empty List 0️⃣ \n4 - Delete List ␡\n5 - Go back to the Menu Ⓜ️")
    let choice = readLine()
    
    switch choice {
    case "1":
        addProduct(listId: id)
    case "2":
        if isListEmpty {
            clearTerminal()
            print("⚠️ You can NOT remove products from an empty list. ⚠️")
            viewLists()
        } else {
            removeProduct(listId: id)
        }
    case "3":
        if isListEmpty {
            clearTerminal()
            print("⚠️ You can NOT empty a list if the list is already empty. ⚠️")
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
        print("❌ ERROR: An error was detected while trying to select your option, you're headed back to your lists. ❌")
        viewLists()
    }
}

func deleteAllLists() {
    clearTerminal()
    print("⁉️ Are you sure you want to delete all Lists? ⁉️\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        allLists.removeAll()
        clearTerminal()
        print("✅ All lists were SUCCESSFULLY deleted. ✅")
        menu()
    case "2":
        viewLists()
    default:
        clearTerminal()
        print("❌ ERROR: An error was detected while trying to DELETE all lists, you're headed back to your lists. ❌")
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
    print("⁉️ Are you sure you want to delete \(listInQuestion!.name)? ⁉️\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        
        for (i, mktList) in allLists.enumerated() {
            if mktList.id == listId {
                allLists.remove(at: i)
            }
        }
        
        clearTerminal()
        print("✅ \(listInQuestion!.name) was SUCCESSFULLY deleted. ✅")
        menu()
    case "2":
        showList(id: listInQuestion!.id)
    default:
        clearTerminal()
        print("❌ ERROR: An error was detected while trying to DELETE your list, you're headed back to your lists. ❌")
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
    print("⁉️ Are you sure you want to empty \(listInQuestion!.name)? ⁉️\n1 - Yes\n2 - No")
    let choice = readLine()
    
    switch choice {
    case "1":
        listInQuestion!.emptyList()
        clearTerminal()
        print("✅ \(listInQuestion!.name) was SUCCESSFULLY emptied. ✅")
        showList(id: listInQuestion!.id)
    case "2":
        clearTerminal()
        showList(id: listInQuestion!.id)
    default:
        clearTerminal()
        print("❌ ERROR: An error was detected while trying to empty your list, you're headed back to your lists. ❌")
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
    print("Which product would you like to remove?\n❗️ OBS: Choose by product ID or press ENTER if you want to return to the your lists ❗️\n")
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
            print("❌ ERROR: An error was detected while trying to remove your product, you're headed back to your lists. ❌")
            viewLists()
        }
        clearTerminal()
        
        let name: String = listInQuestion!.showProductName(id: id)
        print("⁉️ Are you sure you want to remove \(name)? ⁉️\n1 - Yes\n2 - No")
        let choice = readLine()
        
        switch choice {
        case "1":
            listInQuestion!.removeProduct(id: id)
            clearTerminal()
            print("✅ \(listInQuestion!.showProductName(id: id)) was SUCCESSFULLY removed from \(listInQuestion!.name). ✅")
            showList(id: listId)
        case "2":
            clearTerminal()
            showList(id: listId)
        default:
            clearTerminal()
            print("❌ ERROR: We've detected that you didn't choose either 1 or 2. ❌")
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
        print("❌ ERROR: We've detected that you didn't choose either 1 or 2. ❌")
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
    print("What's \(pName!)'s quantity?\n❗️ OBS: If we're not able to detect your number it will be put as 1. ❗️")
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
    print("What's \(pName!)'s price?\n❗️ OBS: Just press ENTER if you don't know. ❗️")
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
    print("✅ Your product has been SUCCESSFULLY added ✅\n")
    print("Would you like to:\n1 - Add another product ➕\n2 - Go to the Menu Ⓜ️")
    let choice = readLine()
    
    switch choice {
    case "1":
        addProduct(listId: listInQuestion!.id)
    case "2":
        clearTerminal()
        menu()
    default:
        clearTerminal()
        print("❌ ERROR: We've detected that you didn't choose either 1 or 2. ❌")
        menu()
    }
}

func exportLists1() {
    clearTerminal()
    fileVersion += 1
    
    if allLists.isEmpty {
        clearTerminal()
        print("⚠️ You have NO lists to export yet. ⚠️")
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
    
    var stringData: String = "🛒🛒🛒 Market Spotter Lists 🛒🛒🛒\n\n"
    
    for i in allLists {
        stringData += "\n\(i.toString())\n💰 List's final price: 💲 \(i.showFinalPrice()) 💰"
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
        print("⚠️ You have NO lists to export yet. ⚠️")
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
    
    var stringData: String = "🛒🛒🛒 Market Spotter Lists 🛒🛒🛒\n\n"
    
    for i in allLists {
        stringData += "\n\(i.toString())\n💰 List's final price: 💲 \(i.showFinalPrice()) 💰"
    }
    do {
        try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print (error)
    }
    print("✅ Your lists have been successfully exported to \(fileUrl.path) ✅")
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
        print("⚠️ You have NO lists to open at NOTES yet.⚠️")
    }
    shell("open", "-a", "Notes.app", "MSLists.txt")
    menu()
}

func main() {
    clearTerminal()
    print("\n🛒🛒🛒 MarketSpotter 🛒🛒🛒\n")
    print("Welcome to our terminal MarketSpotter, let`s start your MarketList today!")
    print("Would you like to:\n1 - Create a new MarketList 📝\n2 - Go to menu Ⓜ️\n3 - Export list(s) to Desktop 📂\n4 - Open list(s) in Notes 📒")
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
        print("✅ Your file has been opened at NOTES ✅")
        menu()
    default:
        clearTerminal()
        print("❌ ERROR: We've detected that you didn't choose either 1 or 2. ❌")
        main()
    }
    
}

main()
