allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val project = this
    
    // Создаем функцию для настройки namespace
    val configureNamespace = Action<Project> {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        android?.apply {
            if (namespace == null) {
                namespace = project.group.toString()
            }
        }
    }

    // Если проект уже "вычислен" (evaluated), запускаем сразу. 
    // Если нет — ждем завершения вычисления.
    if (project.state.executed) {
        configureNamespace.execute(project)
    } else {
        project.afterEvaluate {
            configureNamespace.execute(project)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
