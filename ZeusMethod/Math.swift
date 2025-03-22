import Foundation
import simd

// 球の構造体
struct Sphere {
    let center: SIMD3<Float>
    let radius: Float
}

// 直線の構造体（点と方向ベクトル）
struct Line {
    let point: SIMD3<Float>
    let direction: SIMD3<Float>
}

// 直線と球の交点を計算する関数
func calculateIntersection(line: Line, sphere: Sphere) -> [SIMD3<Float>] {
    // 球の中心から直線上の点へのベクトル
    let oc = line.point - sphere.center
    
    // 方向ベクトルの正規化
    let normalizedDir = normalize(line.direction)
    
    // 二次方程式の係数
    let a = dot(normalizedDir, normalizedDir) // 常に1（正規化済み）
    let b = 2.0 * dot(oc, normalizedDir)
    let c = dot(oc, oc) - sphere.radius * sphere.radius
    
    // 判別式
    let discriminant = b * b - 4 * a * c
    
    // 交点なし
    if discriminant < 0 {
        return []
    }
    
    // 交点計算
    let sqrtDiscriminant = sqrt(discriminant)
    
    // 1つの交点（接している場合）
    if abs(discriminant) < 1e-10 {
        let t = -b / (2 * a)
        let intersection = line.point + normalizedDir * t
        return [intersection]
    }
    
    // 2つの交点
    let t1 = (-b - sqrtDiscriminant) / (2 * a)
    let t2 = (-b + sqrtDiscriminant) / (2 * a)
    
    let intersection1 = line.point + normalizedDir * t1
    let intersection2 = line.point + normalizedDir * t2
    
    return [intersection1, intersection2]
}

// 2点から直線と球の交点を求める便利な関数
func findLineAndSphereIntersection(
    point1: SIMD3<Float>,
    point2: SIMD3<Float>,
    sphereCenter: SIMD3<Float>,
    radius: Float
) -> [SIMD3<Float>] {
    // 方向ベクトルの計算
    let direction = point2 - point1
    
    // 直線の定義
    let line = Line(point: point1, direction: direction)
    
    // 球の定義
    let sphere = Sphere(center: sphereCenter, radius: radius)
    
    // 交点計算
    return calculateIntersection(line: line, sphere: sphere)
}

