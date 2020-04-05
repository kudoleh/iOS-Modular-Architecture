platform :ios, '10.0'

workspace 'App.xcworkspace'
project 'App.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking', :testspecs => ['Tests'] 
end

def authentication_pod
  pod 'Authentication', :path => 'DevPods/Authentication'
end

def movies_search_pod
  pod 'MoviesSearch', :path => 'DevPods/MoviesSearch', :testspecs => ['Tests']
end

def development_pods
  networking_pod
  authentication_pod
  movies_search_pod
end

target 'App' do
  use_frameworks!
  # Pods for App
  development_pods
end

target 'AppUITests' do
  use_frameworks!
  
  # Pods for testing
  development_pods
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
end

target 'Authentication_Example' do
  use_frameworks!
  project 'DevPods/Authentication/Example/Authentication.xcodeproj'
  
  authentication_pod
end

target 'MoviesSearch_Example' do
  use_frameworks!
  project 'DevPods/MoviesSearch/Example/MoviesSearch.xcodeproj'
  
  movies_search_pod
end
