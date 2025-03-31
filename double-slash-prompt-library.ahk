#SingleInstance Force
SetWorkingDir A_ScriptDir

; Define hotkey: / for double press detection, with ~ to type /
Hotkey "~/", SlashHandler

; Handler for / key with double press detection
SlashHandler(*) {
    static lastPressTime := 0
    currentTime := A_TickCount
    if (currentTime - lastPressTime < 500) {  ; Double press within 500ms
        ShowFileMenu()
    }
    lastPressTime := currentTime  ; Update last press time
}

; Function to display a menu of .txt and .md files
ShowFileMenu() {
    fileMenu := Menu()        ; Create a new menu object
    itemsAdded := false       ; Track if any items are added
    
    Loop Files, A_ScriptDir "\*.txt"
    {
        fileMenu.Add(A_LoopFileName, MenuHandler)
        itemsAdded := true
    }
    
    Loop Files, A_ScriptDir "\*.md"
    {
        fileMenu.Add(A_LoopFileName, MenuHandler)
        itemsAdded := true
    }
    
    if (itemsAdded) {         ; Show menu only if items were added
        fileMenu.Show()
    }
}

; Handler for menu item selection
MenuHandler(ItemName, ItemPos, MenuObj) {
    originalClipboard := ClipboardAll()  ; Save all clipboard content (including images, etc.)
    
    FilePath := A_ScriptDir "\" ItemName
    if (FileExist(FilePath)) {
        fileContents := FileRead(FilePath)  ; Read selected file
        Send "{Backspace 2}"                ; Delete the last two characters ("//")
        A_Clipboard := fileContents         ; Set clipboard to file contents
        Send "^v"                           ; Paste the contents
        Sleep 100                           ; Ensure pasting completes
        A_Clipboard := originalClipboard    ; Restore original clipboard with all content types
    }
}
