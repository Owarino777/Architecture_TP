workspace "Ability Browser" "C4 model for the Ability Browser desktop application." {

    !identifiers hierarchical

    model {
        user = person "End User" "A user who browses the web with accessibility-oriented interaction features."

        websites = softwareSystem "Websites and Web Services" "External websites and web services loaded inside the browser." {
            tags "External System"
        }

        operatingSystem = softwareSystem "Operating System and Device APIs" "Provides windowing, input injection, camera access, local file access and platform services." {
            tags "External System"
        }

        updateSource = softwareSystem "Update Metadata Source" "External source used to retrieve application update metadata and display update notifications." {
            tags "External System"
        }

        partnerContentApi = softwareSystem "Partner Content API" "External API owned by another application and used to provide partner page data." {
            tags "External System"
        }

        abilityBrowser = softwareSystem "Ability Browser" "Accessible desktop web browser built with Qt, QML, C++, Qt WebEngine, HeadPilot, OpenCV and native Extlib dependencies." {
            tags "Internal Software System"

            desktopApplication = container "Desktop Application" "Main installed desktop application used by the end user. It hosts the QML interface, browser shell, accessibility features, HeadPilot controls, virtual keyboard, partner page and local application services." "Qt 6.8.3, C++, QML, Qt Quick, Qt Quick Controls, Extlib native dependencies" {

                group "User Interface Layer" {
                    applicationShell = component "Application Shell" "Owns the main window, global layout, navigation zones and application startup lifecycle." "QML, Qt Quick, Qt Quick Controls, C++" {
                        tags "UI Component"
                    }

                    browserPage = component "Browser Page" "Displays the web browsing area, address bar, navigation controls and page actions." "QML, Qt Quick, Qt WebEngine" {
                        tags "UI Component"
                    }

                    partnerPage = component "Partner Page" "Displays partner content and provides access from the home page." "QML, Qt Quick" {
                        tags "UI Component"
                    }

                    overlayController = component "Overlay Controller" "Manages floating overlays such as auto-click controls, accessibility tools and movable UI helpers." "QML, Qt Quick, C++" {
                        tags "UI Component"
                    }

                    accessibilityThemeManager = component "Accessibility Theme Manager" "Manages focus visibility, contrast, palettes and accessibility-related visual options." "QML, Qt Quick, C++" {
                        tags "UI Component"
                    }
                }

                group "Browser Services Layer" {
                    webEngineBridge = component "WebEngine Bridge" "Connects QML browser controls to Qt WebEngine and injects JavaScript when needed." "C++, QML, Qt WebEngine, JavaScript" {
                        tags "Service Component"
                    }

                    favoritesManager = component "Favorites Manager" "Manages default favorites, user favorites, favorite ordering and favorite page state." "C++, QML, Qt Core" {
                        tags "Service Component"
                    }

                    faviconResolver = component "Favicon Resolver" "Resolves stable favicons using local assets, WebEngine favicons and fallback icons." "QML, JavaScript, Qt Resource System, Qt WebEngine" {
                        tags "Service Component"
                    }
                }

                group "Accessibility Services Layer" {
                    headPilotController = component "HeadPilot Controller" "Coordinates camera-based pointer interaction, auto-click behavior, cursor visibility and device lifecycle." "C++, Qt Core, Qt GUI, Qt Multimedia, Extlib native dependencies" {
                        tags "Accessibility Component"
                    }

                    computerVisionEngine = component "Computer Vision Engine" "Processes camera frames and computes tracking data used by HeadPilot features." "C++, OpenCV, Extlib native dependencies" {
                        tags "Native Component"
                    }

                    magnifierController = component "Magnifier Controller" "Provides the magnifier feature and related display behavior." "QML, Qt Quick, C++" {
                        tags "Accessibility Component"
                    }

                    virtualKeyboardController = component "Virtual Keyboard Controller" "Controls the custom virtual keyboard visibility, input context integration and text injection." "C++, QML, Qt Input Context, Qt Quick" {
                        tags "Accessibility Component"
                    }

                    suggestionEngine = component "Suggestion Engine" "Provides spellchecking and word suggestions for the custom virtual keyboard when dictionary-based suggestions are enabled." "C++, Hunspell, Extlib dictionaries" {
                        tags "Native Component"
                    }
                }

                group "Application Services Layer" {
                    configurationManager = component "Configuration Manager" "Stores and exposes runtime configuration such as keyboard visibility, HeadPilot settings and UI preferences." "C++, Qt Core, Qt Properties" {
                        tags "Service Component"
                    }

                    updateNotificationService = component "Update Notification Service" "Checks update metadata and exposes notification state to the UI." "C++, QML, Qt Network" {
                        tags "Integration Component"
                    }

                    partnerApiClient = component "Partner API Client" "Retrieves partner data from the external partner content API and exposes it to the Partner Page." "C++, Qt Network" {
                        tags "Integration Component"
                    }
                }
            }

            webRenderingEngine = container "Web Rendering Engine" "Loads, executes and renders web pages inside the desktop application." "Qt WebEngine, Chromium" {
                tags "Runtime Container"
            }

            localStore = container "Local Settings and Favorites Store" "Stores user preferences, favorites, browser-related local state and application settings." "Qt local persistence, local persistent storage" {
                tags "Database"
            }

            applicationAssets = container "Application Assets" "Contains bundled icons, logos, favicons, QML resources, dictionaries and static assets." "Qt Resource System, bundled assets, Extlib resources" {
                tags "Storage"
            }
        }

        user -> abilityBrowser "Uses"

        abilityBrowser -> websites "Loads and displays web content from"
        abilityBrowser -> operatingSystem "Uses platform and device capabilities from"
        abilityBrowser -> updateSource "Checks update metadata from"
        abilityBrowser -> partnerContentApi "Consumes partner data from"

        user -> abilityBrowser.desktopApplication "Interacts with"

        abilityBrowser.desktopApplication -> abilityBrowser.webRenderingEngine "Controls page loading and rendering"
        abilityBrowser.desktopApplication -> abilityBrowser.localStore "Reads from and writes to"
        abilityBrowser.desktopApplication -> abilityBrowser.applicationAssets "Loads bundled resources from"
        abilityBrowser.desktopApplication -> operatingSystem "Uses platform APIs from"
        abilityBrowser.desktopApplication -> updateSource "Checks update metadata from"
        abilityBrowser.desktopApplication -> partnerContentApi "Fetches partner data from"

        abilityBrowser.webRenderingEngine -> websites "Loads web pages from"

        user -> abilityBrowser.desktopApplication.applicationShell "Uses"

        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.browserPage "Displays browsing interface"
        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.partnerPage "Displays partner interface"
        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.overlayController "Displays accessibility overlays"
        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.configurationManager "Reads application state from"
        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.accessibilityThemeManager "Applies visual accessibility settings from"
        abilityBrowser.desktopApplication.applicationShell -> abilityBrowser.desktopApplication.updateNotificationService "Displays update status from"

        abilityBrowser.desktopApplication.browserPage -> abilityBrowser.desktopApplication.webEngineBridge "Delegates browser actions to"
        abilityBrowser.desktopApplication.browserPage -> abilityBrowser.desktopApplication.favoritesManager "Uses favorites from"
        abilityBrowser.desktopApplication.browserPage -> abilityBrowser.desktopApplication.faviconResolver "Requests favicon candidates from"
        abilityBrowser.desktopApplication.browserPage -> abilityBrowser.desktopApplication.virtualKeyboardController "Uses text input features from"
        abilityBrowser.desktopApplication.browserPage -> abilityBrowser.desktopApplication.magnifierController "Can be enhanced by"

        abilityBrowser.desktopApplication.webEngineBridge -> abilityBrowser.webRenderingEngine "Controls"
        abilityBrowser.webRenderingEngine -> websites "Loads web content from"

        abilityBrowser.desktopApplication.favoritesManager -> abilityBrowser.localStore "Persists favorites in"
        abilityBrowser.desktopApplication.favoritesManager -> abilityBrowser.applicationAssets "Loads default favorite icons from"

        abilityBrowser.desktopApplication.faviconResolver -> abilityBrowser.applicationAssets "Loads fallback icons from"
        abilityBrowser.desktopApplication.faviconResolver -> abilityBrowser.webRenderingEngine "Reads page favicon data from"

        abilityBrowser.desktopApplication.overlayController -> abilityBrowser.desktopApplication.headPilotController "Exposes HeadPilot controls for"
        abilityBrowser.desktopApplication.overlayController -> abilityBrowser.desktopApplication.magnifierController "Exposes magnifier controls for"
        abilityBrowser.desktopApplication.overlayController -> abilityBrowser.desktopApplication.virtualKeyboardController "Exposes keyboard controls for"

        abilityBrowser.desktopApplication.headPilotController -> abilityBrowser.desktopApplication.computerVisionEngine "Uses tracking data computed by"
        abilityBrowser.desktopApplication.headPilotController -> operatingSystem "Uses cursor and input APIs from"

        abilityBrowser.desktopApplication.computerVisionEngine -> operatingSystem "Receives camera frames through"

        abilityBrowser.desktopApplication.magnifierController -> operatingSystem "Uses screen and windowing APIs from"

        abilityBrowser.desktopApplication.virtualKeyboardController -> abilityBrowser.desktopApplication.suggestionEngine "Requests spellchecking and suggestions from"
        abilityBrowser.desktopApplication.virtualKeyboardController -> operatingSystem "Uses input APIs from"

        abilityBrowser.desktopApplication.suggestionEngine -> abilityBrowser.applicationAssets "Loads dictionaries and language resources from"

        abilityBrowser.desktopApplication.configurationManager -> abilityBrowser.localStore "Persists configuration in"

        abilityBrowser.desktopApplication.updateNotificationService -> updateSource "Reads update metadata from"

        abilityBrowser.desktopApplication.partnerPage -> abilityBrowser.desktopApplication.partnerApiClient "Requests partner data from"
        abilityBrowser.desktopApplication.partnerPage -> abilityBrowser.applicationAssets "Loads partner assets from"
        abilityBrowser.desktopApplication.partnerApiClient -> partnerContentApi "Fetches partner data from"
    }

    views {
        systemLandscape "SystemLandscape" {
            include user
            include abilityBrowser
            include websites
            include operatingSystem
            include updateSource
            include partnerContentApi
            autolayout lr 450 250
        }

        systemContext abilityBrowser "SystemContext" {
            include user
            include abilityBrowser
            include websites
            include operatingSystem
            include updateSource
            include partnerContentApi
            autolayout lr 450 250
        }

        container abilityBrowser "Containers" {
            include user
            include abilityBrowser.desktopApplication
            include abilityBrowser.webRenderingEngine
            include abilityBrowser.localStore
            include abilityBrowser.applicationAssets
            include websites
            include operatingSystem
            include updateSource
            include partnerContentApi
            autolayout lr 450 250
        }

        component abilityBrowser.desktopApplication "DesktopApplicationComponents" {
            include user

            include abilityBrowser.desktopApplication.applicationShell
            include abilityBrowser.desktopApplication.browserPage
            include abilityBrowser.desktopApplication.partnerPage
            include abilityBrowser.desktopApplication.overlayController
            include abilityBrowser.desktopApplication.accessibilityThemeManager

            include abilityBrowser.desktopApplication.webEngineBridge
            include abilityBrowser.desktopApplication.favoritesManager
            include abilityBrowser.desktopApplication.faviconResolver

            include abilityBrowser.desktopApplication.headPilotController
            include abilityBrowser.desktopApplication.computerVisionEngine
            include abilityBrowser.desktopApplication.magnifierController
            include abilityBrowser.desktopApplication.virtualKeyboardController
            include abilityBrowser.desktopApplication.suggestionEngine

            include abilityBrowser.desktopApplication.configurationManager
            include abilityBrowser.desktopApplication.updateNotificationService
            include abilityBrowser.desktopApplication.partnerApiClient

            include abilityBrowser.webRenderingEngine
            include abilityBrowser.localStore
            include abilityBrowser.applicationAssets

            include websites
            include operatingSystem
            include updateSource
            include partnerContentApi

            autolayout lr 520 260
        }

        styles {
            element "Element" {
                background #101820
                color #ffffff
                stroke #0077cc
                strokeWidth 2
                shape roundedbox
            }

            element "Person" {
                background #123b14
                color #ffffff
                stroke #39a845
                strokeWidth 3
                shape person
            }

            element "Internal Software System" {
                background #101820
                color #ffffff
                stroke #0077cc
                strokeWidth 4
                shape roundedbox
            }

            element "External System" {
                background #1b1111
                color #ffffff
                stroke #d92332
                strokeWidth 3
                shape roundedbox
            }

            element "Container" {
                background #101820
                color #ffffff
                stroke #0077cc
                strokeWidth 3
                shape roundedbox
            }

            element "Runtime Container" {
                background #0f172a
                color #ffffff
                stroke #60a5fa
                strokeWidth 3
                shape roundedbox
            }

            element "Component" {
                background #101820
                color #ffffff
                stroke #2d8cff
                strokeWidth 2
                shape component
            }

            element "UI Component" {
                background #102033
                color #ffffff
                stroke #60a5fa
            }

            element "Service Component" {
                background #111827
                color #ffffff
                stroke #38bdf8
            }

            element "Accessibility Component" {
                background #132216
                color #ffffff
                stroke #22c55e
            }

            element "Native Component" {
                background #231a10
                color #ffffff
                stroke #f59e0b
            }

            element "Integration Component" {
                background #221733
                color #ffffff
                stroke #a855f7
            }

            element "Database" {
                background #101820
                color #ffffff
                stroke #f59f27
                strokeWidth 3
                shape cylinder
            }

            element "Storage" {
                background #101820
                color #ffffff
                stroke #f59f27
                strokeWidth 3
                shape folder
            }

            element "Boundary" {
                stroke #0077cc
                strokeWidth 2
            }

            relationship "Relationship" {
                color #d8d8d8
                thickness 1
                dashed false
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}