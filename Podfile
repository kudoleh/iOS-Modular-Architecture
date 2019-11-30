platform :ios, '10.0'

workspace 'App.xcworkspace'
project 'App.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def development_pods
  networking_pod
end

target 'App' do
  use_frameworks!

  # Pods for App
  networking_pod
end

target 'AppTests' do
  inherit! :search_paths
  # Pods for testing
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
