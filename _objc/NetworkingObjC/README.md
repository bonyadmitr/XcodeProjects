## To start project

Enter project folder in terminal and run

```bash
chmod +x ./install; ./install
```

> `chmod +x` needs to unlock custom scrpits.

> Without it you will get error: "Permission denied".

> `./install` simply runs the script.

## Terminal commands

#### To synchronize folders and groups in project for development

```bash
bundle e synx --no-sort-by-name NetworkingObjC.xcodeproj
```

#### Install Cocoapods dependencies

```bash
bundle e pod install
```

## Commets

Can be:

- added DI framework like Typhoon to remove singletons
- added services for clients and storages
- created simple class from NSObject to abstract from data base objects
- added SDWebImage for work with images