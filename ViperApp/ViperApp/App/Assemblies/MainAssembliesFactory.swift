//
//  MainAssembliesFactory.swift
//  ViperApp
//
//  Created by Bondar Yaroslav on 29/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import DipApplication

final class MainAssembliesFactory: AssembliesFactory {
    
    /// Предназначен для регистрации сборщиков слоя делегатов
    override func registerLaunchLayer(root: RootLaunchAssembly) {
        container.register(.eagerSingleton) { AppDelegatesAssembly(root: $0, storyboards: $1) }
    }
    
    /// Предназначен для регистрации сборщиков presentation слоя
    override func registerPresentationLayer(root: RootViperAssembly) {
        container.register(.eagerSingleton) { ListModuleAssembly(withCollaborator: $0) }
        container.register(.eagerSingleton) { DetailModuleAssembly(withCollaborator: $0) }
    }
    
    /// Предназначен для регистрации сборщиков слоя сервисов
    override func registerServicesLayer(root: RootServicesAssembly) {
        container.register(.eagerSingleton) { ServicesAssembly(withCollaborator: $0) }
    }
    
    /// Предназначен для регистрации сборщиков core слоя
    override func registerCoreLayer(root: RootCoreAssembly) {
        container.register(.eagerSingleton) { StoryboardsAssembly(withRoot: $0, systemInfrastructure: $1) }
        container.register(.eagerSingleton) { SystemInfrastructureAssembly(withRoot: $0) }
        
        container.register(.eagerSingleton) { ClientsAssembly(withRoot: $0) }
        container.register(.eagerSingleton) { StoragesAssembly(withRoot: $0) }
    }
}
