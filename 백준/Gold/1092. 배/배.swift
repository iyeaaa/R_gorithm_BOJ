import Foundation

final class IO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {

        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                      || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    @inline(__always) func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @inline(__always) func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }

    @inline(__always) func writeByString(_ output: String) { // wapas
        FileHandle.standardOutput.write(output.data(using: .utf8)!)
    }
}


let io = IO()
let N = io.readInt()
let cranes = crtArray(N)
let M = io.readInt()
let boxes = crtArray(M) // 2 2 4 5 7

var (lf, ryt) = (1, 10000)
while lf <= ryt {
    let mid = (lf + ryt) / 2
    if isPsb(mid) {
        ryt = mid - 1
    } else {
        lf = mid + 1
    }
}
print(lf == 10001 ? -1 : lf)

func isPsb(_ t: Int) -> Bool {
    var count = 0
    for crane in cranes {
        for _ in 0..<t {
            if count < M && crane >= boxes[count] {
                count += 1
            }
        }
    }
    return count == M
}

func crtArray(_ N: Int) -> [Int] {
    var result = [Int]()
    for _ in 0..<N {
        result.append(io.readInt())
    }
    return result.sorted()
}
