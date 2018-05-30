//
//  AppDelegate.swift
//  InternHelper
//
//  Created by Yaroslav Bondar on 05.07.16.
//  Copyright © 2016 SMediaLink. All rights reserved.
//

import Cocoa
import PromiseKit
import SocketIOClientSwift
import ObjectMapper

// TODO: По поводу модели (в них ничего не буду писать) и немного по проекту напишу тут.
// TODO: Была переиспользованна модель созданная до этого.
// TODO: В связи с этим надо поудалять префиксы ОС, где это необходимо и удалить не нужные совсем методы
// TODO: (в тему модели, но не приложения) Надо сделать универсальную модель, которую потом можно копировать почти в каждый проект (в свободное время этим буду заниматься)
// TODO: и при необходимости уже изменять, удалять ненужное и дополнять необходимое.
// TODO: Сделать нормальный вывод ошибок

// TODO: Создать класс сокет менеджера.
// TODO: и чтобы подписывалось всегда один раз
// TODO: Сейчас подписывается еще раз при разлогине-логине
// TODO: (пока еще мало знаний и опта с сокетами. надо будет поработать с ними. полезная, нужная и часто используемая вещь)

// TODO: Подправить дизайн:
// TODO: Определить где нужны окна, а где поповеры.
// TODO: Добавть констрейнты для вьюх или запретить растягивание окон

// TODO: Создать отдельные файлы для всех используемых расширеший базовых классов


// TODO: Избавиться от глобальной переменной (было сделано изначально для простоты)
var isLogined = false


// TODO: Создать стартовый класс, в который перенести всю логику из AppDelegate
// TODO: Текущая "грязь" была создана из-за ускоренного обучения создания меню
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSInputServiceProvider {
    
    // MARK: - Properties
    @IBOutlet weak var window: NSWindow!
    
    // TODO: Слова windows перенести в конец подобно контроллерам
    // TODO: Возможно можно не делать на них константы, чтобы они выгружались из памяти (не сильно (пока еще) знаком с разработкой под мак)
    // TODO: но тем самым они создаются один раз и не затрачивается на это время, только на показ.
    // TODO: Наверное лучше чтобы выгружались, но не знаю пока как это сделать правильно и аккуратно
    let windowUsersList = UsersListController(windowNibName: "UsersListController")
    let windowEventsList = EventsListController(windowNibName: "EventsListController")

    // TODO: выяснить почему предлагали именно "-2"
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    // TODO: добавить адрес в константы и
    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.10.102:3333")!, options: [.Log(false)])
    
//    var once: dispatch_once_t = 0
    

    
    // MARK: - Life cycle
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButton")
        }
        
        OCAccountService.login().then { user -> Void in
            OCAccountService.currentUser = user
            isLogined = true
        }.recover { _ in
            isLogined = false
        }.always { 
            self.start()
        }
    }
    
    func start() {
        if isLogined {
            
            guard let user = OCAccountService.currentUser else {return}
            
            // TODO: меньше использовать "!"А а делать нормальные проверки, чтобы приложение вдруг не крашнулось
            let token = OCAccountService.repository.token!.id
            let userId = user.id!
            print(token)
            print(userId)
            
            // TODO: возможно потребуется чтобы один раз подписывался
            // TODO: а может и нет после создания отдельного класса для сокетов
//            dispatch_once(&once, {
//            })
            
            socket.on("connect") {data, ack in
                self.socket.emit("authentication", ["id": token, "userId": userId])
                print("Connected")
            }
            
            
            // TODO: удалить ненужные подписки
            socket.on("disconnect") { (data, ack) in
                print("Disconnected")
            }
            
            socket.on("authenticated") { data, ack in
                print("User Is Authenticated")
            }

            socket.on("/HelpEvent/POST") { (data, ack) in
                
                let eventsArray : Array<Event> = Mapper<Event>().mapArray(data)!
                
                let events = eventsArray.filter( { $0.tutorId == (OCAccountService.currentUser?.id)! } )
                // TODO: это не правильно работает + в контроллер можно будет не передавать, когда будет класс для хранения
                // TODO: это написано в UsersListController
                self.windowEventsList.events = events
                
                NSApp.activateIgnoringOtherApps(true)
                self.windowEventsList.showWindow(nil)
            }
            
            // TODO: удалить если не понадобиться
//            socket.on("/HelpEvent/PUT") { (data, ack) in
//                
//                let eventsArray : Array<Event> = Mapper<Event>().mapArray(data)!
//                
//                for event in eventsArray {
//                    if event.internId == (OCAccountService.currentUser?.id)! {
//                        print(event.id)
//                    }
//                }
//            }
            
            socket.connect()

            // TODO: отдельный метод для создания меню
            // TODO: можно сделать константу на меню и убирать или устанавливать ее когда это необходимо
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: user.fullName, action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Вызвать", action: #selector(AppDelegate.showUsers(_:)), keyEquivalent: "s"))
            menu.addItem(NSMenuItem(title: "Вызвовы", action: #selector(AppDelegate.showUsers(_:)), keyEquivalent: "d"))
            menu.addItem(NSMenuItem.separatorItem())
            // TODO: перевести слово на рус :)
            menu.addItem(NSMenuItem(title: "Logout", action: #selector(AppDelegate.logout(_:)), keyEquivalent: "d"))
            menu.addItem(NSMenuItem(title: "Выйти из приложения", action: #selector(NSApplication.sharedApplication().terminate(_:)), keyEquivalent: "q"))
            statusItem.menu = menu
            
            
        } else {
            // TODO: тоже можно сделать отдельный метод для читабельности
            statusItem.button?.action = #selector(AppDelegate.togglePopover(_:))
            popover.contentViewController =  LoginController(nibName: "LoginController", bundle: nil)
            
            eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
                if self.popover.shown {
                    self.closePopover(event)
                }
            }
            eventMonitor?.start()
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        socket.disconnect()
    }
    

    // MARK: - Methods
    func showUsers(sender: AnyObject) {
        NSApp.activateIgnoringOtherApps(true)
        windowUsersList.showWindow(sender)
    }
    
    func logout(sender: AnyObject) {
        OCAccountService.logout().then { _ -> Void in
            self.statusItem.menu = nil
            isLogined = false
            self.socket.disconnect()
            // TODO: можно создать метод очищения
            OCAccountService.currentUser = nil
            OCAccountService.repository.token = nil
            OCAccountService.credentials = nil
            self.start()
        }
    }

    
    // MARK: - Popover
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            // TODO: ошибка при разлогине-логине и появления заного поповера
            // TODO: не крашится, только показывается, но надо попытаться решить
            //TODO: InternHelper[50230] <Error>: Error: this application, or a library it uses
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
        eventMonitor?.start()
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}







