import Foundation

public protocol MatrixProtocol: Sequence, Equatable, CustomStringConvertible, Hashable {
    associatedtype Element: Numeric
    var rows: Int { get }
    var cols: Int { get }
    var elements: [Element] { get set }
    var count: Int { get }
    
    static var zero: Self { get }

    subscript(row: Int, col: Int) -> Element { get set }

    func clone() -> Self
}

public struct MatrixSizeError: Error {
    public init() {}
}

public extension MatrixProtocol {
    @inlinable var description: String {
        "MatrixProtocol r:\(rows) x c:\(cols) \(elements)"
    }

    @inlinable var count: Int {
        rows * cols
    }

    @inlinable subscript(row: Int, col: Int) -> Element {
        get {
            elements[row * self.cols + col]
        }

        set {
            elements[row * self.cols + col] = newValue
        }
    }

    @inlinable func makeIterator() -> Array<Element>.Iterator {
        return elements.makeIterator()
    }

    // TODO: there might be a more efficient way to transpose
    @inlinable public var transposed: Self {
        var matrix = clone() // TODO: maybe have some clone function that does not clone elements
       
        for rIndex in 0..<self.rows {
            for cIndex in 0..<self.cols {
                matrix[cIndex, rIndex] = self[rIndex, cIndex]
            }
        }
        
        return matrix
    }

    @inlinable func firstIndex(of element: Element) -> (Int, Int)? {
        for row in 0..<rows {
            for col in 0..<cols {
                if self[row, col] == element {
                    return (row, col)
                }
            }
        }
        
        return nil
    }

    @inlinable mutating func add_<T: MatrixProtocol>(_ matrix2: T) throws where T.Element == Self.Element {
        if !(matrix2.rows == rows && matrix2.cols == cols) {
            throw MatrixSizeError()
        }

        for rIndex in 0..<self.rows {
            for cIndex in 0..<self.cols {
                self[rIndex, cIndex] += matrix2[rIndex, cIndex]
            }
        }
    }

    @inlinable func matmul<T: MatrixProtocol>(_ other: T) -> Matrix<Element> where T.Element == Element {
        if (self.cols != other.rows) {
            fatalError("Cannot perform matrix multiplication on two matrices where columns of matrix 1 do not match rows of matrix 2.")
        }
        
        var result = Matrix<Element>(rows: self.rows, cols: other.cols)
        
        for rIndex in 0..<self.rows {
            for cIndex in 0..<other.cols {
                var element = Self.Element.init(exactly: 0)!
                
                for iIndex in 0..<self.cols {
                    element += self[rIndex, iIndex] * other[iIndex, cIndex]
                }
                
                result[rIndex, cIndex] = element
            }
        }
        
        return result
    }

    // TODO: need to add throws if dimensions don't match
    @inlinable static func + (lhs: Self, rhs: Element) -> Self {
        var result = lhs.clone()
        
        for i in 0..<lhs.count {
            result.elements[i] += rhs
        }
        
        return result
    }

    @inlinable static func * (lhs: Self, rhs: Element) -> Self {
        var result = lhs

        for i in 0..<lhs.elements.count {
            result.elements[i] *= rhs
        }

        return result
    }

    @inlinable static func * (lhs: Element, rhs: Self) -> Self {
        rhs * lhs
    }
}

public extension MatrixProtocol where Element: FloatingPoint {
    @inlinable static func /= (lhs: inout Self, rhs: Element) {
        for i in 0..<lhs.count {
            lhs.elements[i] /= rhs
        }
    }

    /// element wise division
    // TODO: divide only the overlapping elements
    @inlinable static func / (lhs: Self, rhs: Self) -> Self {
        var result = lhs.clone()
        
        for i in 0..<lhs.count {
            result.elements[i] /= rhs.elements[i]
        }
        
        return result
    }

    /// element wise multiplication
    // TODO: multiply only the overlapping elements
    @inlinable static func * <Other: MatrixProtocol> (lhs: Self, rhs: Other) -> Self where Other.Element == Element {
        var result = lhs.clone()
        
        for i in 0..<result.count {
            result.elements[i] *= rhs.elements[i]
        }
        
        return result
    }

    @inlinable static prefix func - (mat: Self) -> Self {
        var result = mat.clone()
        
        for i in 0..<mat.count {
            result.elements[i] = -result.elements[i]
        }
        
        return result
    }
}

public extension MatrixProtocol where Element: Comparable {
    @inlinable func max() -> Element {
        return elements.max()!
    }
}

public extension MatrixProtocol where Element: Comparable, Element: SignedNumeric {
    @inlinable func abs() -> Self {
        var result = self
        
        for i in 0..<count {
            result.elements[i] = Swift.abs(self.elements[i])
        }
        
        return result
    }
}

public struct MatrixMultiplicationError: Error {}

// TODO: maybe add more matrix math

/*public func * <T1: MatrixProtocol, T2: MatrixProtocol>(lhs: T1, rhs: T2) throws -> Matrix<T1.Element> where T1.Element == T2.Element {
    return try lhs.matmul(rhs)
}*/



/*
THIS IMPLEMENTATION IS LIKELY NOT CORRECT / does not do what *= is expected to do
public func *= <T: MatrixProtocol>(lhs: inout T, rhs: T) throws -> Matrix {
    return try lhs * rhs
}*/

public struct Matrix<E: Numeric & Hashable>: MatrixProtocol {
    public typealias Element = E
    public var rows: Int
    public var cols: Int
    public var elements: [E]

    public init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.elements = [Element](repeating: Element.zero, count: rows * cols)
    }

    public init(rows: Int, cols: Int, elements: [Element]) {
        self.rows = rows
        self.cols = cols
        self.elements = elements
    }
    
    @inlinable public static var zero: Self {
        fatalError("unavailable, need to specify size")
    }

    @inlinable public func clone() -> Self {
        Self(rows: rows, cols: cols, elements: elements)
    }
}

public protocol Matrix3Protocol: MatrixProtocol {
    init(_ elements: [Element])
}

extension Matrix3Protocol {
    public typealias Dimension = Dim_3x3

    public static var zero: Self {
        Self(Array(repeating: 0, count: 9))
    }

    public func clone() -> Self {
        Self(elements)
    }
}

public struct Matrix3<E: Numeric & Hashable>: Matrix3Protocol {
    public typealias Element = E
    public let rows: Int = 3
    public let cols: Int = 3
    public var elements: [E]

    public init(_ elements: [Element]) {
        self.elements = elements
    }
}

public protocol Matrix4Protocol: MatrixProtocol {
    init(_ elements: [Element])
}

public extension Matrix4Protocol {

    public init<M3: Matrix3Protocol>(topLeft: M3, rest: Self = .identity) where M3.Element == Element {
        self.init([
            topLeft[0, 0], topLeft[0, 1], topLeft[0, 2], rest[0, 3],
            topLeft[1, 0], topLeft[1, 1], topLeft[1, 2], rest[1, 3],
            topLeft[2, 0], topLeft[2, 1], topLeft[2, 2], rest[2, 3],
            rest[3, 0], rest[3, 1], rest[3, 2], rest[3, 3],
        ])
    }

    @inlinable static var identity: Self {
        Self([
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        ])
    }

    @inlinable static var zero: Self {
        Self(Array(repeating: 0, count: 16))
    }

    @inlinable func clone() -> Self {
        Self(elements)
    }

    @inlinable func matmul(_ other: Self) -> Self {
        if (self.cols != other.rows) {
            fatalError("Cannot perform matrix multiplication on two matrices where columns of matrix 1 do not match rows of matrix 2.")
        }
        
        var result = self
        
        for rIndex in 0..<self.rows {
            for cIndex in 0..<other.cols {
                var element = Self.Element.init(exactly: 0)!
                
                for iIndex in 0..<self.cols {
                    element += self[rIndex, iIndex] * other[iIndex, cIndex]
                }
                
                result[rIndex, cIndex] = element
            }
        }
        
        return result
    }
}

public extension Matrix4Protocol where Element: FloatingPointGenericMath {
   @inlinable static func transformation(translation: Vector3<Element>, scaling: Vector3<Element>, rotationAxis: Vector3<Element>, rotationAngle: Element) -> Self {
        let ar = rotationAngle / Element(180) * Element.pi
        let rc = cos(ar)
        let rc1 = 1 - rc
        let rs = sin(ar)
        let ra = rotationAxis
        let r1c1 = scaling[0] * (rc + pow(ra[0], 2) * rc1)
        let r1c2 = ra[0] * ra[1] * rc1
        let r1c3 = ra[0] * ra[2] * rc1 + ra[1] * rs
        let r1c4 = translation[0]
        let r2c1 = ra[1] * ra[0] * rc1 + ra[2] * rs
        let r2c2 = scaling[1] * (rc + pow(ra[1], 2) * rc1)
        let r2c3 = ra[1] * ra[2] * rc1 - ra[0] * rs
        let r2c4 = translation[1]
        let r3c1 = ra[2] * ra[0] * rc1 - ra[1] * rs
        let r3c2 = ra[2] * ra[1] * rc1 + ra[0] * rs
        let r3c3 = scaling[2] * (rc + pow(ra[2], 2) * rc1)
        let r3c4 = translation[2]
    
        return Self([
            r1c1, r1c2, r1c3, r1c4,
            r2c1, r2c2, r2c3, r2c4,
            r3c1, r3c2, r3c3, r3c4,
            0, 0, 0, 1
        ])
    }

    /// - Returns: a scaling matrix
    @inlinable static func scale(_ scale: Vector3<Element>) -> Self {
        Self([
            scale.x, 0, 0, 0,
            0, scale.y, 0, 0,
            0, 0, scale.z, 0,
            0, 0, 0, 1
        ])
    }

    /// - Returns: a translation matrix with the given translation as the last column
    @inlinable static func translation(_ translation: Vector3<Element>) -> Self {
        Self([
            1, 0, 0, translation.x,
            0, 1, 0, translation.y,
            0, 0, 1, translation.z,
            0, 0, 0, 1
        ])
    }

    /// - Returns: rotation matrix with given axes as columns, these are the axes of the rotated coordinate system
    @inlinable static func rotation(x xAxis: Vector3<Element>, y yAxis: Vector3<Element>, z zAxis: Vector3<Element>) -> Self {
        Self([
            xAxis.x, yAxis.x, zAxis.x, 0,
            xAxis.y, yAxis.y, zAxis.y, 0,
            xAxis.z, yAxis.z, zAxis.z, 0,
            0, 0, 0, 1
        ])
    }

    /// - Returns: a full transformation matrix, orientation: translation is encoded in the last column before applying rotation
    @inlinable static func transformation(scale: Vector3<Element>, rotationX: Vector3<Element>, rotationY: Vector3<Element>, rotationZ: Vector3<Element>, translation: Vector3<Element>) -> Self {
        self.translation(translation).matmul(self.rotation(x: rotationX, y: rotationY, z: rotationZ).matmul(self.scale(scale)))
    }

    // TODO: the following functions might be specific to openGL, maybe put those in the GLGraphicsMath package
    @inlinable static func viewTransformation<V: Vector3Protocol>(up: V, right: V, front: V, translation: V) -> Self where V.Element == Self.Element {
        return try! Self([
            right.x, right.y, right.z, 0,
            up.x, up.y, up.z, 0,
            front.x, front.y, front.z, 0,
            0, 0, 0, 1
        ]).matmul(Self([
            1, 0, 0, translation.x,
            0, 1, 0, translation.y,
            0 , 0, 1, translation.z,
            0, 0, 0, 1
        ]))
    }

    /// - Parameter fov: field of view angle in degrees
    @inlinable static func perspectiveProjection(aspectRatio: Element, near: Element, far: Element, fov: Element) -> Self {
        let fovRad = fov / Element(180) * Element.pi
        let r1c1 = 1 / (aspectRatio * tan(fovRad / 2))
        let r2c2 = Element(1) / tan(fovRad / Element(2))
        let r3c3 = -(far + near) / (far - near) 
        let r3c4 = -(Element(2) * far * near) / (far - near)
        
        return Self([
            r1c1, Element.zero, Element.zero, Element.zero,
            Element.zero, r2c2, Element.zero, Element.zero,
            Element.zero, Element.zero, r3c3, r3c4,
            Element.zero, Element.zero, Element(-1), Element.zero
        ])
    }

    @inlinable static func orthographicProjection(top: Element, right: Element, bottom: Element, left: Element, near: Element, far: Element) -> Self {
        let r1c1 = Element(2) / (right - left)
        let r1c4 = -(right + left) / (right - left)
        let r2c2 = Element(2) / (top - bottom)
        let r2c4 = -(top + bottom) / (top - bottom)
        let r3c3 = Element(-2) / (far - near)
        let r3c4 = -(far + near) / (far - near)
    
        return Self([
            r1c1, 0, 0, r1c4,
            0, r2c2, 0, r2c4,
            0, 0, r3c3, r3c4,
            0, 0, 0, 1
        ])
    }
}

public struct Matrix4<E: Numeric & Hashable>: Matrix4Protocol {
    public typealias Element = E
    public let rows: Int = 4
    public let cols: Int = 4
    public var elements: [E]

    public init(_ elements: [Element]) {
        self.elements = elements
    }
}

// TODO: might replace this or remove this / current function of this is to simply remove throws
@inlinable public func * <E: Numeric>(lhs: Matrix4<E>, rhs: Matrix4<E>) -> Matrix4<E> {
    return try! lhs.matmul(rhs)
}

public typealias FMat4 = Matrix4<Float>