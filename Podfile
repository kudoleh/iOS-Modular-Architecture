platform :ios, '10.0'

workspace 'App.xcworkspace'
project 'App.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def movies_search_pod
  pod 'MoviesSearch', :path => 'DevPods/MoviesSearch'
end

def development_pods
  networking_pod
  movies_search_pod
end

target 'App' do
  use_frameworks!

  # Pods for App
  development_pods
end

target 'AppUITests' do
  # Pods for testing
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
  
  target 'Networking_Tests' do
    inherit! :search_paths
  end
end

target 'MoviesSearch_Example' do
  use_frameworks!
  project 'DevPods/MoviesSearch/Example/MoviesSearch.xcodeproj'
  
  movies_search_pod
  
  target 'MoviesSearch_Tests' do
    inherit! :search_paths
  end
end
