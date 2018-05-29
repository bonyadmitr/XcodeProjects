# Swift-lesson4

##HW: 
И так, у вас есть время 2 недели и 2 темы, которые нужно вам пройти и освоить самостоятельно:
*Map Kit
*HTTPRequest 

Экраны приложения: Экран с картой. 

###Экран с картой: 
Экран содержит карту и search bar. 
Используя GoogleMaps API или любое другое API нужно сначала отобразить все достопримечательсности Казани, по нажатию на любую из них
вывести краткую информацию в дефолтное окно Map Kit. 
А по вводу названия любого города в search bar нужно так же отобразить этот город и если есть, его достопримечательности на карте. 

Все настройки карты, ее обновления новыми данными лучше вынести в отдельный MapManager. 
Все запросы к API для получения данных тоже нужно вынести в отдельный APIManager. 

В итоге должно получится приложения где сначала отображаются достопримечательности Казани, а если ввести новый город, то отображает этот 
город и его достопримечательности. 

**Нельзя использовать никакие SDK или библиотеки для работы с картой или работы с HTTP запросами, все ручками.**
**Не забывайте про MVC и все что проходили, от использования простых структур для решения мелких задач, до протоколов и extensions**

###Дополнительный материал: 
*[Map Kit docs from Developer Apple](https://developer.apple.com/reference/mapkit)  
*[Raywenderlich Map Kit](https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial)
*[MapKit + CoreLocations from Swiftbook](http://swiftbook.ru/tutorials/routing-mapkit-core-location)
*[Google Maps API Geocoding docs](https://developers.google.com/maps/documentation/geocoding/intro?hl=ru)
*[APIs,Network & JSON, Getting Data](https://code.bradymower.com/swift-3-apis-network-requests-json-getting-the-data-4aaae8a5efc0#.goh3p42fq)
*[JSON parsing from Developer Apple](https://developer.apple.com/swift/blog/?id=37)
