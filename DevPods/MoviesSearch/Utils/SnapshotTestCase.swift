//
//  SnapshotTestCase.swift
//  MoviesSearch
//

import Foundation
import FBSnapshotTestCase

/// Base class for snapshot tests. Verifies the tests are running on the simulator the
/// reference images were recorded on before any snapshot assertion runs, crashing with
/// a clear message instead of producing confusing pixel diffs on the wrong device.
class SnapshotTestCase: FBSnapshotTestCase {
    /// Override in a subclass if its reference images were recorded on a different simulator.
    class var expectedSimulatorDeviceName: String { "iPhone 17e" }

    override func setUp() {
        super.setUp()
        recordMode = false
        verifyRunningOnExpectedSimulator()
    }

    private func verifyRunningOnExpectedSimulator() {
        let expectedDeviceName = Self.expectedSimulatorDeviceName
        let actualDeviceName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"]
        guard actualDeviceName == expectedDeviceName else {
            fatalError("""
                Snapshot tests must run on the "\(expectedDeviceName)" simulator \
                (the device the reference images were recorded on), but the tests are running on \
                "\(actualDeviceName ?? "an unknown destination (not a simulator?)")". \
                Select "\(expectedDeviceName)" as the run destination and try again.
                """)
        }
    }
}
